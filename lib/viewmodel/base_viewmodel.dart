import 'package:flutter/material.dart';

abstract class BaseViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isDisposed = false;

  void setLoading(bool loading) {
    if (_isDisposed) return;
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    if (_isDisposed) return;
    _errorMessage = error;
    notifyListeners();
  }

  void clearError() {
    if (_isDisposed) return;
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  /// Maneja operaciones asíncronas con loading y error handling automático
  Future<T?> handleAsyncOperation<T>(Future<T> Function() operation) async {
    try {
      setLoading(true);
      clearError();
      return await operation();
    } catch (e) {
      setError(e.toString());
      return null;
    } finally {
      setLoading(false);
    }
  }

  /// Ejecuta una operación sin cambiar el estado de loading
  Future<T?> executeOperation<T>(Future<T> Function() operation) async {
    try {
      clearError();
      return await operation();
    } catch (e) {
      setError(e.toString());
      return null;
    }
  }
}
