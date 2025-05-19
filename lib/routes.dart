import 'package:client_service/view/registro/register_cliente.dart';
import 'package:client_service/view/registro/register_empleado.dart';
import 'package:client_service/view/servicio/registro_instalacion.dart';
import 'package:flutter/cupertino.dart';

final Map<String, WidgetBuilder> routes = {
  'Nuevos Empleados': (context) => const RegistroEmpleadoPage(),
  'Nuevos Clientes': (context) => const RegistroClientePage(),
  'Registro de instalación': (context) => const RegistroInstalacion()
};
