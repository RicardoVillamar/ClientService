import 'package:flutter_test/flutter_test.dart';
import 'package:client_service/services/notificacion_service.dart';
import 'package:client_service/utils/constants/notificacion_sistema.dart';

void main() {
  group('NotificacionService', () {
    test('crea instancia de NotificacionService correctamente', () {
    final service = NotificacionService();
      expect(service, isNotNull);
      expect(service.notificaciones, isA<List>());
    });

    test('valida estructura de TipoNotificacion', () {
      // Verificar que los tipos de notificación están definidos
      expect(TipoNotificacion.servicio, isNotNull);
      expect(TipoNotificacion.sistema, isNotNull);
      expect(TipoNotificacion.recordatorio, isNotNull);
    });

    test('valida estructura de NotificacionSistema', () {
      final notificacion = NotificacionSistema(
        id: 'test-1',
        titulo: 'Test',
        mensaje: 'Mensaje de prueba',
        fechaCreacion: DateTime.now(),
        tipo: TipoNotificacion.servicio,
        prioridad: PrioridadNotificacion.media,
      );

      expect(notificacion.id, 'test-1');
      expect(notificacion.titulo, 'Test');
      expect(notificacion.mensaje, 'Mensaje de prueba');
      expect(notificacion.tipo, TipoNotificacion.servicio);
      expect(notificacion.leida, false);
    });
  });
}
