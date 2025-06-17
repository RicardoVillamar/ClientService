import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:client_service/utils/constants/notificacion_sistema.dart';

class NotificacionService extends ChangeNotifier {
  static const String _storageKey = 'notificaciones_sistema';
  static const int _maxNotificaciones = 100;

  List<NotificacionSistema> _notificaciones = [];
  int _contadorNoLeidas = 0;

  List<NotificacionSistema> get notificaciones =>
      List.unmodifiable(_notificaciones);
  int get contadorNoLeidas => _contadorNoLeidas;

  bool get tieneNotificacionesNoLeidas => _contadorNoLeidas > 0;

  // Inicializar el servicio
  Future<void> inicializar() async {
    await _cargarNotificaciones();
    _actualizarContador();
  }

  // Agregar una nueva notificación
  Future<void> agregarNotificacion({
    required String titulo,
    required String mensaje,
    required TipoNotificacion tipo,
    PrioridadNotificacion prioridad = PrioridadNotificacion.media,
    String? accion,
    Map<String, dynamic>? datos,
    bool mostrarFlash = true,
  }) async {
    print('DEBUG: Agregando notificación - Título: $titulo, Tipo: $tipo');

    final notificacion = NotificacionSistema(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      titulo: titulo,
      mensaje: mensaje,
      fechaCreacion: DateTime.now(),
      tipo: tipo,
      prioridad: prioridad,
      accion: accion,
      datos: datos,
    );

    _notificaciones.insert(0, notificacion);
    print(
        'DEBUG: Notificación agregada a la lista. Total: ${_notificaciones.length}');

    // Limitar el número de notificaciones
    if (_notificaciones.length > _maxNotificaciones) {
      _notificaciones = _notificaciones.take(_maxNotificaciones).toList();
    }

    await _guardarNotificaciones();
    print('DEBUG: Notificaciones guardadas en SharedPreferences');

    _actualizarContador();
    print('DEBUG: Contador actualizado. No leídas: $_contadorNoLeidas');

    // Mostrar notificación flash si está habilitado
    if (mostrarFlash) {
      await _mostrarNotificacionFlash(notificacion);
    }

    notifyListeners();
    print('DEBUG: Listeners notificados');
  }

  // Marcar notificación como leída
  Future<void> marcarComoLeida(String notificacionId) async {
    final index = _notificaciones.indexWhere((n) => n.id == notificacionId);
    if (index != -1 && !_notificaciones[index].leida) {
      _notificaciones[index] = _notificaciones[index].copyWith(leida: true);
      await _guardarNotificaciones();
      _actualizarContador();
      notifyListeners();
    }
  }

  // Marcar todas como leídas
  Future<void> marcarTodasComoLeidas() async {
    bool cambios = false;
    for (int i = 0; i < _notificaciones.length; i++) {
      if (!_notificaciones[i].leida) {
        _notificaciones[i] = _notificaciones[i].copyWith(leida: true);
        cambios = true;
      }
    }

    if (cambios) {
      await _guardarNotificaciones();
      _actualizarContador();
      notifyListeners();
    }
  }

  // Eliminar notificación
  Future<void> eliminarNotificacion(String notificacionId) async {
    final index = _notificaciones.indexWhere((n) => n.id == notificacionId);
    if (index != -1) {
      _notificaciones.removeAt(index);
      await _guardarNotificaciones();
      _actualizarContador();
      notifyListeners();
    }
  }

  // Limpiar notificaciones leídas
  Future<void> limpiarNotificacionesLeidas() async {
    final countAntes = _notificaciones.length;
    _notificaciones.removeWhere((n) => n.leida);

    if (_notificaciones.length != countAntes) {
      await _guardarNotificaciones();
      _actualizarContador();
      notifyListeners();
    }
  }

  // Obtener notificaciones por tipo
  List<NotificacionSistema> obtenerPorTipo(TipoNotificacion tipo) {
    return _notificaciones.where((n) => n.tipo == tipo).toList();
  }

  // Obtener notificaciones no leídas
  List<NotificacionSistema> get notificacionesNoLeidas {
    return _notificaciones.where((n) => !n.leida).toList();
  }

  // Métodos de conveniencia para crear notificaciones específicas
  Future<void> notificarServicioCreado(
      String servicioTipo, String cliente) async {
    await agregarNotificacion(
      titulo: 'Nuevo servicio registrado',
      mensaje:
          'Se ha registrado un nuevo servicio de $servicioTipo para $cliente',
      tipo: TipoNotificacion.servicio,
      prioridad: PrioridadNotificacion.media,
    );
  }

  Future<void> notificarServicioCompletado(
      String servicioTipo, String cliente) async {
    await agregarNotificacion(
      titulo: 'Servicio completado',
      mensaje: 'El servicio de $servicioTipo para $cliente ha sido completado',
      tipo: TipoNotificacion.exito,
      prioridad: PrioridadNotificacion.media,
    );
  }

  Future<void> notificarMantenimientoProgramado(
      String fecha, String equipo) async {
    await agregarNotificacion(
      titulo: 'Mantenimiento programado',
      mensaje: 'Recordatorio: mantenimiento de $equipo programado para $fecha',
      tipo: TipoNotificacion.recordatorio,
      prioridad: PrioridadNotificacion.alta,
    );
  }

  Future<void> notificarError(String mensaje, {String? detalles}) async {
    await agregarNotificacion(
      titulo: 'Error del sistema',
      mensaje: detalles != null ? '$mensaje: $detalles' : mensaje,
      tipo: TipoNotificacion.error,
      prioridad: PrioridadNotificacion.alta,
    );
  }

  Future<void> notificarFacturaCreada(
      String numeroFactura, double monto) async {
    await agregarNotificacion(
      titulo: 'Nueva factura generada',
      mensaje:
          'Factura #$numeroFactura por \$${monto.toStringAsFixed(2)} ha sido creada',
      tipo: TipoNotificacion.facturacion,
      prioridad: PrioridadNotificacion.media,
    );
  }

  // Métodos privados
  Future<void> _cargarNotificaciones() async {
    try {
      print('DEBUG: Cargando notificaciones desde SharedPreferences...');
      final prefs = await SharedPreferences.getInstance();
      final notificacionesJson = prefs.getStringList(_storageKey) ?? [];
      print(
          'DEBUG: Encontradas ${notificacionesJson.length} notificaciones en storage');

      _notificaciones = notificacionesJson
          .map((json) => NotificacionSistema.fromJson(jsonDecode(json)))
          .toList();
      print(
          'DEBUG: ${_notificaciones.length} notificaciones cargadas exitosamente');
    } catch (e) {
      debugPrint('Error al cargar notificaciones: $e');
      _notificaciones = [];
    }
  }

  Future<void> _guardarNotificaciones() async {
    try {
      print(
          'DEBUG: Intentando guardar ${_notificaciones.length} notificaciones...');
      final prefs = await SharedPreferences.getInstance();
      final notificacionesJson =
          _notificaciones.map((n) => jsonEncode(n.toJson())).toList();

      final success =
          await prefs.setStringList(_storageKey, notificacionesJson);
      print('DEBUG: Guardado en SharedPreferences: $success');

      // Verificación inmediata
      final verificacion = prefs.getStringList(_storageKey) ?? [];
      print(
          'DEBUG: Verificación inmediata: ${verificacion.length} elementos guardados');
    } catch (e) {
      debugPrint('Error al guardar notificaciones: $e');
    }
  }

  void _actualizarContador() {
    _contadorNoLeidas = _notificaciones.where((n) => !n.leida).length;
  }

  Future<void> _mostrarNotificacionFlash(
      NotificacionSistema notificacion) async {
    // Aquí se implementaría la lógica para mostrar notificaciones flash
    // Por ahora solo marcamos como mostrada
    final index = _notificaciones.indexWhere((n) => n.id == notificacion.id);
    if (index != -1) {
      _notificaciones[index] = _notificaciones[index].copyWith(mostrada: true);
    }
  }
}
