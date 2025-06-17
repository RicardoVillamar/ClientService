import 'package:client_service/models/factura.dart';
import 'package:client_service/utils/colors.dart';
import 'package:client_service/utils/font.dart';
import 'package:client_service/view/widgets/shared/apptitle.dart';
import 'package:client_service/view/billing/create_factura.dart';
import 'package:client_service/view/billing/facturas_list_avanzada.dart';
import 'package:client_service/view/billing/anular_facturas.dart';
import 'package:client_service/view/billing/crear_factura_desde_servicio.dart';
import 'package:client_service/viewmodel/factura_viewmodel.dart';
import 'package:client_service/services/service_locator.dart';
import 'package:flutter/material.dart';

class DashboardFacturacion extends StatefulWidget {
  const DashboardFacturacion({super.key});

  @override
  State<DashboardFacturacion> createState() => _DashboardFacturacionState();
}

class _DashboardFacturacionState extends State<DashboardFacturacion> {
  final FacturaViewModel _facturaViewModel = sl<FacturaViewModel>();
  List<Factura> _facturas = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    await _facturaViewModel.fetchFacturas();
    await _facturaViewModel.cargarEstadisticas();
    setState(() {
      _facturas = _facturaViewModel.facturas;
    });
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
            const Apptitle(title: 'Dashboard de Facturación'),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Estadísticas generales
                      _buildEstadisticasGenerales(),

                      const SizedBox(height: 20),

                      // Acciones rápidas
                      _buildAccionesRapidas(),

                      const SizedBox(height: 20),

                      // Facturas recientes
                      _buildFacturasRecientes(),

                      const SizedBox(height: 20),

                      // Resumen por tipo de servicio
                      _buildResumenTipoServicio(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEstadisticasGenerales() {
    final totalFacturas = _facturas.length;
    final pendientes =
        _facturas.where((f) => f.estado == EstadoFactura.pendiente).length;
    final pagadas =
        _facturas.where((f) => f.estado == EstadoFactura.pagada).length;
    final vencidas =
        _facturas.where((f) => f.estado == EstadoFactura.vencida).length;
    final totalMonto = _facturas.fold(0.0, (sum, f) => sum + f.total);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Estadísticas Generales',
            style: AppFonts.subtitleBold.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Facturas',
                  totalFacturas.toString(),
                  Icons.receipt_long,
                  AppColors.primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Monto Total',
                  '\$${totalMonto.toStringAsFixed(2)}',
                  Icons.attach_money,
                  Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Pendientes',
                  pendientes.toString(),
                  Icons.schedule,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Pagadas',
                  pagadas.toString(),
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Vencidas',
                  vencidas.toString(),
                  Icons.warning,
                  Colors.red,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(), // Espacio vacío para mantener el layout
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppFonts.subtitleBold.copyWith(
              color: color,
              fontSize: 20,
            ),
          ),
          Text(
            title,
            style: AppFonts.text.copyWith(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAccionesRapidas() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Acciones Rápidas',
            style: AppFonts.subtitleBold.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.5,
            children: [
              _buildActionCard(
                'Nueva Factura',
                Icons.add_circle,
                AppColors.primaryColor,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CreateFactura()),
                ),
              ),
              _buildActionCard(
                'Facturar Servicio',
                Icons.build_circle,
                Colors.blue,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CrearFacturaDesdeServicio()),
                ),
              ),
              _buildActionCard(
                'Ver Facturas',
                Icons.list_alt,
                Colors.green,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FacturasListAvanzada()),
                ),
              ),
              _buildActionCard(
                'Anular Facturas',
                Icons.cancel,
                Colors.red,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AnularFacturas()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: AppFonts.bodyNormal.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFacturasRecientes() {
    final facturasRecientes = _facturas.take(5).toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Facturas Recientes',
                style: AppFonts.subtitleBold.copyWith(fontSize: 18),
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FacturasListAvanzada()),
                ),
                child: const Text('Ver todas'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (facturasRecientes.isEmpty)
            Center(
              child: Column(
                children: [
                  Icon(Icons.receipt_long, size: 48, color: Colors.grey[400]),
                  const SizedBox(height: 8),
                  Text(
                    'No hay facturas registradas',
                    style: AppFonts.text.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          else
            ...facturasRecientes
                .map((factura) => _buildFacturaRecenteItem(factura)),
        ],
      ),
    );
  }

  Widget _buildFacturaRecenteItem(Factura factura) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            _getTipoServicioIcon(factura.tipoServicio),
            color: AppColors.primaryColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  factura.numeroFactura,
                  style:
                      AppFonts.bodyNormal.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  factura.nombreCliente,
                  style: AppFonts.text.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${factura.total.toStringAsFixed(2)}',
                style:
                    AppFonts.bodyNormal.copyWith(fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _getEstadoColor(factura.estado),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _getEstadoText(factura.estado),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResumenTipoServicio() {
    final camaras =
        _facturas.where((f) => f.tipoServicio == TipoServicio.camara).length;
    final instalaciones = _facturas
        .where((f) => f.tipoServicio == TipoServicio.instalacion)
        .length;
    final vehiculos =
        _facturas.where((f) => f.tipoServicio == TipoServicio.vehiculo).length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumen por Tipo de Servicio',
            style: AppFonts.subtitleBold.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildServiceTypeCard(
                  'Cámaras',
                  camaras.toString(),
                  Icons.camera_alt,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildServiceTypeCard(
                  'Instalaciones',
                  instalaciones.toString(),
                  Icons.build,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildServiceTypeCard(
                  'Vehículos',
                  vehiculos.toString(),
                  Icons.directions_car,
                  Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceTypeCard(
      String title, String count, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            count,
            style: AppFonts.subtitleBold.copyWith(
              color: color,
              fontSize: 18,
            ),
          ),
          Text(
            title,
            style: AppFonts.text.copyWith(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  IconData _getTipoServicioIcon(TipoServicio tipo) {
    switch (tipo) {
      case TipoServicio.camara:
        return Icons.camera_alt;
      case TipoServicio.instalacion:
        return Icons.build;
      case TipoServicio.vehiculo:
        return Icons.directions_car;
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
}
