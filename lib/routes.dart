import 'package:client_service/view/registers/client/register_client.dart';
import 'package:client_service/view/registers/employet/register_employet.dart';
import 'package:client_service/view/reports/empleado.dart';
import 'package:client_service/view/reports/cliente.dart';
import 'package:client_service/view/reports/camara.dart';
import 'package:client_service/view/reports/instalacion.dart';
import 'package:client_service/view/reports/vehiculo.dart';
import 'package:client_service/view/service/vehicle_rental/register_vehicle.dart';
import 'package:client_service/view/service/camara/register_camara.dart';
import 'package:client_service/view/service/installation/register_installation.dart';
import 'package:client_service/view/billing/create_factura.dart';
import 'package:client_service/view/billing/facturas_list_avanzada.dart';
import 'package:client_service/view/billing/anular_facturas.dart';
import 'package:client_service/view/billing/dashboard_facturacion.dart';
import 'package:client_service/view/calendar/calendario_screen.dart';
import 'package:client_service/view/notifications/notificaciones_screen.dart';
import 'package:client_service/view/settings/configuracion_screen.dart';
import 'package:client_service/view/auth/splash_screen.dart';
import 'package:client_service/view/auth/login_selection_screen.dart';
import 'package:client_service/view/auth/login_empleado_screen.dart';
import 'package:client_service/view/auth/login_admin_screen.dart';
import 'package:flutter/cupertino.dart';

final Map<String, WidgetBuilder> routes = {
  // Auth
  '/splash': (context) => const SplashScreen(),
  '/login': (context) => const LoginSelectionScreen(),
  '/login-empleado': (context) => const LoginEmpleadoScreen(),
  '/login-admin': (context) => const LoginAdminScreen(),
  // Registros
  'Nuevos Empleados': (context) => const RegistroEmpleadoPage(),
  'Nuevos Clientes': (context) => const RegistroClientePage(),

  // Servicios
  'Registro de instalación': (context) => const RegistroInstalacion(),
  'Mantenimiento de cámaras': (context) => const RegistroCamara(),
  'Alquiler vehículos': (context) => const RegistroAlquiler(),

  // Facturación
  'Dashboard Facturación': (context) => const DashboardFacturacion(),
  'Nuevas Facturas': (context) => const CreateFactura(),
  'Reporte de Facturas': (context) => const FacturasListAvanzada(),
  'Anular Factura': (context) => const AnularFacturas(),

  // Reportes
  'Empleados': (context) => const AsistenciasAdminScreen(),
  'Clientes': (context) => const ReportCliente(),
  'Reporte de instalaciones': (context) => const ReportInstalacion(),
  'Reporte de cámaras': (context) => const ReportCamara(),
  'Reporte vehículos': (context) => const ReportVehiculo(),

  // Nuevas funcionalidades
  'calendario': (context) => const CalendarioScreen(),
  'notificaciones': (context) => const NotificacionesScreen(),
  'configuracion': (context) => const ConfiguracionScreen(),
};
