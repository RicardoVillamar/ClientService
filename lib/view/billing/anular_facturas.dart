import 'package:client_service/models/factura.dart';
import 'package:client_service/utils/colors.dart';
import 'package:client_service/utils/font.dart';
import 'package:client_service/view/widgets/shared/apptitle.dart';
import 'package:client_service/view/widgets/flash_messages.dart';
import 'package:client_service/viewmodel/factura_viewmodel.dart';
import 'package:client_service/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AnularFacturas extends StatefulWidget {
  const AnularFacturas({super.key});

  @override
  State<AnularFacturas> createState() => _AnularFacturasState();
}

class _AnularFacturasState extends State<AnularFacturas> {
  final FacturaViewModel _facturaViewModel = sl<FacturaViewModel>();
  List<Factura> _facturas = [];
  List<Factura> _facturasFiltradas = [];

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
        _facturas = _facturaViewModel.facturas
            .where((f) => f.estado != EstadoFactura.cancelada)
            .toList();
        _aplicarFiltros();
      });
    }
  }

  void _loadFacturas() async {
    await _facturaViewModel.fetchFacturas();
  }

  void _aplicarFiltros() {
    _facturasFiltradas = _facturas.where((factura) {
      bool matchSearch = _searchController.text.isEmpty ||
          factura.numeroFactura
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()) ||
          factura.nombreCliente
              .toLowerCase()
              .contains(_searchController.text.toLowerCase());

      return matchSearch;
    }).toList();
  }

  void _confirmarAnulacion(Factura factura) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Anulación'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('¿Está seguro de anular la factura ${factura.numeroFactura}?'),
            const SizedBox(height: 8),
            Text('Cliente: ${factura.nombreCliente}'),
            Text('Monto: \$${factura.total.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            const Text(
              'Esta acción no se puede deshacer.',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _anularFactura(factura);
            },
            child: const Text('Anular', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _anularFactura(Factura factura) async {
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
            const Apptitle(title: 'Anular Facturas'),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    // Barra de búsqueda
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
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.orange[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.orange[200]!),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.warning, color: Colors.orange[700]),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Solo se muestran facturas que pueden ser anuladas (pendientes, pagadas o vencidas)',
                                    style: TextStyle(
                                      color: Colors.orange[700],
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
                                        Icons.cancel_outlined,
                                        size: 64,
                                        color: Colors.grey[400],
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'No hay facturas disponibles para anular',
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
                                            _confirmarAnulacion(factura),
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
