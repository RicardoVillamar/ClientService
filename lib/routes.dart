import 'package:client_service/view/registro/register_cliente.dart';
import 'package:client_service/view/registro/register_empleado.dart';
import 'package:flutter/cupertino.dart';

final Map<String, WidgetBuilder> routes = {
  'Nuevos Empleados': (context) => const RegistroEmpleadoPage(),
  'Nuevos Clientes': (context) => const RegistroClientePage(),

  // Añade todas las demás páginas aquí
};
