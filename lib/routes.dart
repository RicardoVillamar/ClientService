import 'package:client_service/view/registers/client/register_client.dart';
import 'package:client_service/view/registers/employet/register_employet.dart';
import 'package:client_service/view/reports/camara.dart';
import 'package:client_service/view/reports/cliente.dart';
import 'package:client_service/view/reports/empleado.dart';
import 'package:client_service/view/reports/instalacion.dart';
import 'package:client_service/view/reports/vehiculo.dart';
import 'package:client_service/view/service/vehicle_rental/register_vehicle.dart';
import 'package:client_service/view/service/camara/register_camara.dart';
import 'package:client_service/view/service/installation/register_installation.dart';
import 'package:flutter/cupertino.dart';

final Map<String, WidgetBuilder> routes = {
  'Nuevos Empleados': (context) => const RegistroEmpleadoPage(),
  'Nuevos Clientes': (context) => const RegistroClientePage(),
  'Registro de instalación': (context) => const RegistroInstalacion(),
  'Mantenimiento de cámaras': (context) => const RegistroCamara(),
  'Alquiler vehículos': (context) => const RegistroAlquiler(),
  'Empleados': (context) => const ReportEmpleado(),
  'Clientes': (context) => const ReportCliente(),
  'Reporte de instalaciones': (context) => const ReportInstalacion(),
  'Reporte de cámaras': (context) => const ReportCamara(),
  'Reporte vehículos': (context) => const ReportVehiculo(),
};
