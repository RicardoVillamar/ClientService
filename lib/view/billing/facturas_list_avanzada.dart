import 'package:client_service/models/factura.dart';
import 'package:client_service/utils/colors.dart';
import 'package:client_service/utils/font.dart';
import 'package:client_service/view/widgets/shared/apptitle.dart';
import 'package:client_service/view/widgets/flash_messages.dart';
import 'package:client_service/view/billing/create_factura.dart';
import 'package:client_service/view/billing/edit_factura.dart';
import 'package:client_service/view/billing/view_factura.dart';
import 'package:client_service/viewmodel/factura_viewmodel.dart';
import 'package:client_service/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FacturasListAvanzada extends StatefulWidget {
  const FacturasListAvanzada({super.key});

  @override
  State<FacturasListAvanzada> createState() => _FacturasListAvanzadaState();
}

class _FacturasListAvanzadaState extends State<FacturasListAvanzada> {
  final FacturaViewModel _facturaViewModel = sl<FacturaViewModel>();
  List<Factura> _facturas = [];
  List<Factura> _facturasFiltradas = [];

  String _filtroEstado = 'todos';
  String _filtroTipoServicio = 'todos';
  String _ordenarPor = 'fechaDesc'; // fechaDesc, fechaAsc, clienteAZ, clienteZA

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _fechaDesdeController = TextEditingController();
  final TextEditingController _fechaHastaController = TextEditingController();

  DateTime? _fechaDesde;
  DateTime? _fechaHasta;

  bool _mostrarFiltros = false;

  @override
  void initState() {
    super.initState();
    _loadFacturas();
    _facturaViewModel.addListener(_onFacturaViewModelChanged);
  }

  @override
  void dispose() {
    _facturaViewModel.removeListener(_onFacturaViewModelChanged);
    _searchController.dispose();
    _fechaDesdeController.dispose();
    _fechaHastaController.dispose();
    super.dispose();
  }

  void _onFacturaViewModelChanged() {
    if (mounted) {
      setState(() {
        _facturas = _facturaViewModel.facturas;
        _aplicarFiltrosYOrden();
      });
    }
  }

  void _loadFacturas() async {
    await _facturaViewModel.fetchFacturas();
  }

  void _aplicarFiltrosYOrden() {
    _facturasFiltradas = _facturas.where((factura) {
      bool matchEstado =
          _filtroEstado == 'todos' || factura.estado.name == _filtroEstado;
      bool matchTipoServicio = _filtroTipoServicio == 'todos' ||
          factura.tipoServicio.name == _filtroTipoServicio;
      bool matchSearch = _searchController.text.isEmpty ||
          factura.numeroFactura
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()) ||
          factura.nombreCliente
              .toLowerCase()
              .contains(_searchController.text.toLowerCase());

      bool matchFecha = true;
      if (_fechaDesde != null) {
        matchFecha = factura.fechaEmision.isAfter(_fechaDesde!) ||
            factura.fechaEmision.isAtSameMomentAs(_fechaDesde!);
      }
      if (_fechaHasta != null && matchFecha) {
        matchFecha = factura.fechaEmision
            .isBefore(_fechaHasta!.add(const Duration(days: 1)));
      }

      return matchEstado && matchTipoServicio && matchSearch && matchFecha;
    }).toList();

    // Aplicar ordenamiento
    _facturasFiltradas.sort((a, b) {
      switch (_ordenarPor) {
        case 'fechaDesc':
          return b.fechaEmision.compareTo(a.fechaEmision);
        case 'fechaAsc':
          return a.fechaEmision.compareTo(b.fechaEmision);
        case 'clienteAZ':
          return a.nombreCliente.compareTo(b.nombreCliente);
        case 'clienteZA':
          return b.nombreCliente.compareTo(a.nombreCliente);
        default:
          return b.fechaEmision.compareTo(a.fechaEmision);
      }
    });
  }

  Future<void> _selectDate(
      TextEditingController controller, bool isDateFrom) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      final formattedDate = DateFormat('dd/MM/yyyy').format(picked);
      setState(() {
        controller.text = formattedDate;
        if (isDateFrom) {
          _fechaDesde = picked;
        } else {
          _fechaHasta = picked;
        }
        _aplicarFiltrosYOrden();
      });
    }
  }

  void _limpiarFiltros() {
    setState(() {
      _filtroEstado = 'todos';
      _filtroTipoServicio = 'todos';
      _ordenarPor = 'fechaDesc';
      _searchController.clear();
      _fechaDesdeController.clear();
      _fechaHastaController.clear();
      _fechaDesde = null;
      _fechaHasta = null;
      _aplicarFiltrosYOrden();
    });
  }

  Color _getEstadoColor(EstadoFactura estado) {
    switch (estado) {
      case EstadoFactura.pendiente:
        return Colors.orange;
      case EstadoFactura.pagada:
        return Colors.green;
      case EstadoFactura.vencida:
        return Colors.red;
      case EstadoFactura.cancelada:
        return Colors.grey;
    }
  }

  String _getEstadoText(EstadoFactura estado) {
    switch (estado) {
      case EstadoFactura.pendiente:
        return 'Pendiente';
      case EstadoFactura.pagada:
        return 'Pagada';
      case EstadoFactura.vencida:
        return 'Vencida';
      case EstadoFactura.cancelada:
        return 'Cancelada';
    }
  }

  String _getTipoServicioText(TipoServicio tipo) {
    switch (tipo) {
      case TipoServicio.camara:
        return 'Cámara';
      case TipoServicio.instalacion:
        return 'Instalación';
      case TipoServicio.vehiculo:
        return 'Vehículo';
    }
  }

  Icon _getTipoServicioIcon(TipoServicio tipo) {
    switch (tipo) {
      case TipoServicio.camara:
        return const Icon(Icons.camera_alt, color: AppColors.primaryColor);
      case TipoServicio.instalacion:
        return const Icon(Icons.build, color: AppColors.primaryColor);
      case TipoServicio.vehiculo:
        return const Icon(Icons.directions_car, color: AppColors.primaryColor);
    }
  }

  void _mostrarMenuAcciones(Factura factura) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.visibility),
              title: const Text('Ver Factura'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewFactura(factura: factura),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Editar Factura'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditFactura(factura: factura),
                  ),
                ).then((_) => _loadFacturas());
              },
            ),
            if (factura.estado == EstadoFactura.pendiente) ...[
              ListTile(
                leading: const Icon(Icons.check_circle, color: Colors.green),
                title: const Text('Marcar como Pagada'),
                onTap: () {
                  Navigator.pop(context);
                  _cambiarEstado(factura, EstadoFactura.pagada);
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel, color: Colors.red),
                title: const Text('Marcar como Vencida'),
                onTap: () {
                  Navigator.pop(context);
                  _cambiarEstado(factura, EstadoFactura.vencida);
                },
              ),
            ],
            if (factura.estado != EstadoFactura.cancelada)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Anular Factura'),
                onTap: () {
                  Navigator.pop(context);
                  _confirmarAnulacion(factura);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _cambiarEstado(Factura factura, EstadoFactura nuevoEstado) async {
    final success = await _facturaViewModel.actualizarEstadoFactura(
        factura.id!, nuevoEstado);

    if (success) {
      FlashMessages.showSuccess(
        context: context,
        message: 'Estado actualizado exitosamente',
      );
    } else {
      FlashMessages.showError(
        context: context,
        message: 'Error al actualizar el estado',
      );
    }
  }

  void _confirmarAnulacion(Factura factura) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Anulación'),
        content:
            Text('¿Está seguro de anular la factura ${factura.numeroFactura}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await _facturaViewModel.actualizarEstadoFactura(
                  factura.id!, EstadoFactura.cancelada);

              if (success) {
                FlashMessages.showSuccess(
                  context: context,
                  message: 'Factura anulada exitosamente',
                );
              } else {
                FlashMessages.showError(
                  context: context,
                  message: 'Error al anular la factura',
                );
              }
            },
            child: const Text('Anular', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Container(
        decoration: const BoxDecoration(
          color: AppColors.accentColor,
          gradient: LinearGradient(
            colors: [AppColors.accentColor, AppColors.backgroundColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const Apptitle(title: 'Facturas'),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    // Barra de herramientas
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CreateFactura(),
                                ),
                              ).then((_) => _loadFacturas());
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Nueva Factura'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              foregroundColor: Colors.white,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _mostrarFiltros = !_mostrarFiltros;
                                  });
                                },
                                icon: Icon(
                                  _mostrarFiltros
                                      ? Icons.filter_list_off
                                      : Icons.filter_list,
                                  color: AppColors.primaryColor,
                                ),
                                tooltip: 'Filtros',
                              ),
                              IconButton(
                                onPressed: () async {
                                  await _facturaViewModel.exportarFacturas();
                                  FlashMessages.showSuccess(
                                    context: context,
                                    message: 'Facturas exportadas exitosamente',
                                  );
                                },
                                icon: const Icon(
                                  Icons.download,
                                  color: AppColors.primaryColor,
                                ),
                                tooltip: 'Exportar',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Filtros avanzados
                    if (_mostrarFiltros)
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Filtros',
                                  style: AppFonts.subtitleBold,
                                ),
                                TextButton(
                                  onPressed: _limpiarFiltros,
                                  child: const Text('Limpiar'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Barra de búsqueda
                            TextField(
                              controller: _searchController,
                              decoration: const InputDecoration(
                                hintText:
                                    'Buscar por número de factura o cliente...',
                                prefixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _aplicarFiltrosYOrden();
                                });
                              },
                            ),
                            const SizedBox(height: 16),

                            // Rango de fechas
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _fechaDesdeController,
                                    readOnly: true,
                                    decoration: const InputDecoration(
                                      labelText: 'Fecha desde',
                                      suffixIcon: Icon(Icons.calendar_today),
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                    ),
                                    onTap: () => _selectDate(
                                        _fechaDesdeController, true),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextFormField(
                                    controller: _fechaHastaController,
                                    readOnly: true,
                                    decoration: const InputDecoration(
                                      labelText: 'Fecha hasta',
                                      suffixIcon: Icon(Icons.calendar_today),
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                    ),
                                    onTap: () => _selectDate(
                                        _fechaHastaController, false),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Filtros por estado y servicio
                            Row(
                              children: [
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    value: _filtroEstado,
                                    decoration: const InputDecoration(
                                      labelText: 'Estado',
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                    ),
                                    items: const [
                                      DropdownMenuItem(
                                          value: 'todos', child: Text('Todos')),
                                      DropdownMenuItem(
                                          value: 'pendiente',
                                          child: Text('Pendiente')),
                                      DropdownMenuItem(
                                          value: 'pagada',
                                          child: Text('Pagada')),
                                      DropdownMenuItem(
                                          value: 'vencida',
                                          child: Text('Vencida')),
                                      DropdownMenuItem(
                                          value: 'cancelada',
                                          child: Text('Cancelada')),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        _filtroEstado = value!;
                                        _aplicarFiltrosYOrden();
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    value: _filtroTipoServicio,
                                    decoration: const InputDecoration(
                                      labelText: 'Servicio',
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                    ),
                                    items: const [
                                      DropdownMenuItem(
                                          value: 'todos', child: Text('Todos')),
                                      DropdownMenuItem(
                                          value: 'camara',
                                          child: Text('Cámara')),
                                      DropdownMenuItem(
                                          value: 'instalacion',
                                          child: Text('Instalación')),
                                      DropdownMenuItem(
                                          value: 'vehiculo',
                                          child: Text('Vehículo')),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        _filtroTipoServicio = value!;
                                        _aplicarFiltrosYOrden();
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Ordenamiento
                            Row(
                              children: [
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    value: _ordenarPor,
                                    decoration: const InputDecoration(
                                      labelText: 'Ordenar por',
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                    ),
                                    items: const [
                                      DropdownMenuItem(
                                          value: 'fechaDesc',
                                          child: Text('Fecha (más reciente)')),
                                      DropdownMenuItem(
                                          value: 'fechaAsc',
                                          child: Text('Fecha (más antigua)')),
                                      DropdownMenuItem(
                                          value: 'clienteAZ',
                                          child: Text('Cliente (A-Z)')),
                                      DropdownMenuItem(
                                          value: 'clienteZA',
                                          child: Text('Cliente (Z-A)')),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        _ordenarPor = value!;
                                        _aplicarFiltrosYOrden();
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                    // Estadísticas rápidas
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                '${_facturasFiltradas.length}',
                                style: AppFonts.subtitleBold.copyWith(
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              const Text('Total'),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '${_facturasFiltradas.where((f) => f.estado == EstadoFactura.pendiente).length}',
                                style: AppFonts.subtitleBold.copyWith(
                                  color: Colors.orange,
                                ),
                              ),
                              const Text('Pendientes'),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '${_facturasFiltradas.where((f) => f.estado == EstadoFactura.pagada).length}',
                                style: AppFonts.subtitleBold.copyWith(
                                  color: Colors.green,
                                ),
                              ),
                              const Text('Pagadas'),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '\$${_facturasFiltradas.fold(0.0, (sum, f) => sum + f.total).toStringAsFixed(2)}',
                                style: AppFonts.subtitleBold.copyWith(
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              const Text('Total \$'),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Lista de facturas
                    Expanded(
                      child: _facturaViewModel.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _facturasFiltradas.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.receipt_long,
                                        size: 64,
                                        color: Colors.grey[400],
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'No hay facturas que coincidan con los filtros',
                                        style: AppFonts.bodyNormal.copyWith(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.all(16),
                                  itemCount: _facturasFiltradas.length,
                                  itemBuilder: (context, index) {
                                    final factura = _facturasFiltradas[index];
                                    return Card(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      elevation: 2,
                                      child: ListTile(
                                        leading: _getTipoServicioIcon(
                                            factura.tipoServicio),
                                        title: Text(
                                          factura.numeroFactura,
                                          style: AppFonts.subtitleBold,
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              factura.nombreCliente,
                                              style: AppFonts.bodyNormal,
                                            ),
                                            Text(
                                              'Fecha: ${DateFormat('dd/MM/yyyy').format(factura.fechaEmision)}',
                                              style: AppFonts.text,
                                            ),
                                            Text(
                                              'Servicio: ${_getTipoServicioText(factura.tipoServicio)}',
                                              style: AppFonts.text,
                                            ),
                                          ],
                                        ),
                                        trailing: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: _getEstadoColor(
                                                    factura.estado),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                _getEstadoText(factura.estado),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '\$${factura.total.toStringAsFixed(2)}',
                                              style:
                                                  AppFonts.bodyNormal.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        onTap: () =>
                                            _mostrarMenuAcciones(factura),
                                      ),
                                    );
                                  },
                                ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
