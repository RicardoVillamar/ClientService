import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:client_service/models/empleado.dart';
import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _empleadoData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get empleadoData => _empleadoData;

  Future<Map<String, dynamic>> loginEmpleado({
    required String correo,
    required String password,
  }) async {
    _setLoading(true);
    // Buscar empleado en Firestore por correo
    final query = await FirebaseFirestore.instance
        .collection('empleados')
        .where('correo', isEqualTo: correo.trim().toLowerCase())
        .limit(1)
        .get();
    _setLoading(false);
    if (query.docs.isEmpty) {
      _errorMessage = 'Empleado no encontrado';
      _empleadoData = null;
      notifyListeners();
      return {'success': false, 'message': 'Empleado no encontrado'};
    }
    final empleado =
        Empleado.fromMap(query.docs.first.data(), query.docs.first.id);
    if (empleado.password == password) {
      final primerLogin = password == empleado.cedula;
      _errorMessage = null;
      _empleadoData = {'empleado': empleado, 'primerLogin': primerLogin};
      notifyListeners();
      return {
        'success': true,
        'empleado': empleado,
        'primerLogin': primerLogin
      };
    } else {
      _errorMessage = 'Contraseña incorrecta';
      _empleadoData = null;
      notifyListeners();
      return {'success': false, 'message': 'Contraseña incorrecta'};
    }
  }

  Future<Map<String, dynamic>> cambiarPassword({
    required String cedula,
    required String nuevaPassword,
  }) async {
    try {
      final query = await FirebaseFirestore.instance
          .collection('empleados')
          .where('cedula', isEqualTo: cedula.trim())
          .limit(1)
          .get();
      if (query.docs.isEmpty) {
        return {'success': false, 'message': 'Empleado no encontrado'};
      }
      await query.docs.first.reference.update({'password': nuevaPassword});
      return {
        'success': true,
        'message': 'Contraseña actualizada correctamente'
      };
    } catch (e) {
      return {'success': false, 'message': 'Error al cambiar contraseña: $e'};
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
