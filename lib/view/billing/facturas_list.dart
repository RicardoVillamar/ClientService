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

class FacturasList extends StatefulWidget {
  const FacturasList({super.key});

  @override
  State<FacturasList> createState() => _FacturasListState();
}

class _FacturasListState extends State<FacturasList> {
  final FacturaViewModel _facturaViewModel = sl<FacturaViewModel>();
  List<Factura> _facturas = [];
  List<Factura> _facturasFiltradas = [];

  String _filtroEstado = 'todos';
  String _filtroTipoServicio = 'todos';
  final TextEditingController _searchController = TextEditingController();

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
    super.dispose();
  }

  void _onFacturaViewModelChanged() {
    if (mounted) {
      setState(() {
        _facturas = _facturaViewModel.facturas;
        _aplicarFiltros();
      });
    }
  }

  void _loadFacturas() async {
    await _facturaViewModel.fetchFacturas();
  }

  void _aplicarFiltros() {
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

      return matchEstado && matchTipoServicio && matchSearch;
    }).toList();
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
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Eliminar Factura'),
              onTap: () {
                Navigator.pop(context);
                _confirmarEliminacion(factura);
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

  void _confirmarEliminacion(Factura factura) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Eliminación'),
        content: Text(
            '¿Está seguro de eliminar la factura ${factura.numeroFactura}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success =
                  await _facturaViewModel.eliminarFactura(factura.id!);

              if (success) {
                FlashMessages.showSuccess(
                  context: context,
                  message: 'Factura eliminada exitosamente',
                );
              } else {
                FlashMessages.showError(
                  context: context,
                  message: 'Error al eliminar la factura',
                );
              }
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
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
            const Apptitle(title: 'Facturación'),
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
                          ElevatedButton.icon(
                            onPressed: () async {
                              await _facturaViewModel.exportarFacturas();
                              FlashMessages.showSuccess(
                                context: context,
                                message: 'Facturas exportadas exitosamente',
                              );
                            },
                            icon: const Icon(Icons.download),
                            label: const Text('Exportar'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accentColor,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Filtros y búsqueda
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Barra de búsqueda
                          TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              hintText:
                                  'Buscar por número de factura o cliente...',
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _aplicarFiltros();
                              });
                            },
                          ),
                          const SizedBox(height: 16),

                          // Filtros
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: _filtroEstado,
                                  decoration: const InputDecoration(
                                    labelText: 'Estado',
                                    border: OutlineInputBorder(),
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                        value: 'todos', child: Text('Todos')),
                                    DropdownMenuItem(
                                        value: 'pendiente',
                                        child: Text('Pendiente')),
                                    DropdownMenuItem(
                                        value: 'pagada', child: Text('Pagada')),
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
                                      _aplicarFiltros();
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
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                        value: 'todos', child: Text('Todos')),
                                    DropdownMenuItem(
                                        value: 'camara', child: Text('Cámara')),
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
                                      _aplicarFiltros();
                                    });
                                  },
                                ),
                              ),
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
                                        'No hay facturas disponibles',
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
