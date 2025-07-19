import 'package:flutter/material.dart';
import 'package:client_service/models/empleado.dart';

class EmpleadoProvider extends ChangeNotifier {
  Empleado? _empleado;

  Empleado? get empleado => _empleado;

  void setEmpleado(Empleado empleado) {
    _empleado = empleado;
    notifyListeners();
  }

  void clearEmpleado() {
    _empleado = null;
    notifyListeners();
  }
}
