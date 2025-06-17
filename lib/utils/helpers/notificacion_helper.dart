import 'package:client_service/services/notificacion_service.dart';
import 'package:client_service/utils/constants/notificacion_sistema.dart';
import 'package:client_service/services/service_locator.dart';

class NotificacionUtils {
  static NotificacionService get _service => sl<NotificacionService>();

  // Crear notificaciones de prueba para demostrar el sistema
  static Future<void> crearNotificacionesPrueba() async {
    await _service.agregarNotificacion(
      titulo: 'Sistema iniciado',
      mensaje:
          'El sistema de gestión de servicios técnicos se ha iniciado correctamente. ¡Bienvenido!',
      tipo: TipoNotificacion.sistema,
      prioridad: PrioridadNotificacion.media,
    );

    await _service.agregarNotificacion(
      titulo: 'Mantenimiento de cámaras programado',
      mensaje:
          'Recordatorio: Mantenimiento de las cámaras de seguridad programado para el 18 de junio a las 9:00 AM en el edificio principal.',
      tipo: TipoNotificacion.recordatorio,
      prioridad: PrioridadNotificacion.alta,
    );

    await _service.agregarNotificacion(
      titulo: 'Nuevo servicio de instalación',
      mensaje:
          'Se ha registrado un nuevo servicio de instalación de postes para el cliente TechCorp. Fecha programada: 20 de junio.',
      tipo: TipoNotificacion.servicio,
      prioridad: PrioridadNotificacion.media,
    );

    await _service.agregarNotificacion(
      titulo: 'Factura generada exitosamente',
      mensaje:
          'La factura #2025-001 por un monto de \$3,750.00 ha sido generada y enviada al cliente ABC Solutions.',
      tipo: TipoNotificacion.facturacion,
      prioridad: PrioridadNotificacion.media,
    );

    await _service.agregarNotificacion(
      titulo: 'Error en sincronización',
      mensaje:
          'Se ha detectado un error en la sincronización de datos con el servidor. Por favor, revise la conexión.',
      tipo: TipoNotificacion.error,
      prioridad: PrioridadNotificacion.alta,
    );
  }

  // Funciones de utilidad para crear notificaciones específicas desde otras partes de la app
  static Future<void> notificarServicioCreado(
      String tipoServicio, String cliente, DateTime fecha) async {
    print(
        'DEBUG: Creando notificación para servicio: $tipoServicio, cliente: $cliente');
    try {
      await _service.agregarNotificacion(
        titulo: 'Nuevo servicio programado',
        mensaje:
            'Se ha programado un servicio de $tipoServicio para $cliente el ${_formatearFecha(fecha)}.',
        tipo: TipoNotificacion.servicio,
        prioridad: PrioridadNotificacion.media,
      );
      print('DEBUG: Notificación creada exitosamente');
    } catch (e) {
      print('DEBUG: Error al crear notificación: $e');
    }
  }

  static Future<void> notificarMantenimientoPendiente(
      String equipo, DateTime fecha) async {
    await _service.agregarNotificacion(
      titulo: 'Mantenimiento pendiente',
      mensaje:
          'El mantenimiento de $equipo está programado para ${_formatearFecha(fecha)}. No olvides preparar los materiales necesarios.',
      tipo: TipoNotificacion.recordatorio,
      prioridad: PrioridadNotificacion.alta,
    );
  }

  static Future<void> notificarFacturaGenerada(
      String numeroFactura, double monto, String cliente) async {
    await _service.agregarNotificacion(
      titulo: 'Nueva factura generada',
      mensaje:
          'Factura $numeroFactura por \$${monto.toStringAsFixed(2)} ha sido creada para $cliente.',
      tipo: TipoNotificacion.facturacion,
      prioridad: PrioridadNotificacion.media,
    );
  }

  static Future<void> notificarError(
      String descripcion, String? detalles) async {
    await _service.agregarNotificacion(
      titulo: 'Error del sistema',
      mensaje: detalles != null
          ? '$descripcion\n\nDetalles: $detalles'
          : descripcion,
      tipo: TipoNotificacion.error,
      prioridad: PrioridadNotificacion.alta,
    );
  }

  static Future<void> notificarExito(String titulo, String mensaje) async {
    await _service.agregarNotificacion(
      titulo: titulo,
      mensaje: mensaje,
      tipo: TipoNotificacion.exito,
      prioridad: PrioridadNotificacion.media,
    );
  }

  // Crear notificación específica para facturación
  static Future<void> crearNotificacionFactura(
      String titulo, String mensaje) async {
    await _service.agregarNotificacion(
      titulo: titulo,
      mensaje: mensaje,
      tipo: TipoNotificacion.facturacion,
      prioridad: PrioridadNotificacion.media,
    );
  }

  // Crear notificación específica para registros (clientes, empleados)
  static Future<void> crearNotificacionRegistro(
      String titulo, String mensaje) async {
    await _service.agregarNotificacion(
      titulo: titulo,
      mensaje: mensaje,
      tipo: TipoNotificacion.sistema,
      prioridad: PrioridadNotificacion.media,
    );
  }

  static String _formatearFecha(DateTime fecha) {
    final meses = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre'
    ];

    return '${fecha.day} de ${meses[fecha.month - 1]} de ${fecha.year}';
  }
}
