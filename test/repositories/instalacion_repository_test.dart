import 'package:flutter_test/flutter_test.dart';
import 'package:client_service/models/instalacion.dart';

void main() {
  group('InstalacionRepository', () {
    test('valida estructura de datos de instalación', () {
      final instalacion = Instalacion(
        fechaInstalacion: DateTime.now(),
        cedula: '1234567890',
        nombreComercial: 'Test Company',
        direccion: 'Test Address',
        item: 'Test Item',
        descripcion: 'Test Description',
        horaInicio: '09:00',
        horaFin: '17:00',
        tipoTrabajo: 'Test Work',
        cargoPuesto: 'Test Position',
        telefono: '1234567890',
        numeroTarea: '1',
      );

      expect(instalacion.cedula, '1234567890');
      expect(instalacion.nombreComercial, 'Test Company');
      expect(instalacion.direccion, 'Test Address');
      expect(instalacion.item, 'Test Item');
      expect(instalacion.descripcion, 'Test Description');
      expect(instalacion.horaInicio, '09:00');
      expect(instalacion.horaFin, '17:00');
      expect(instalacion.tipoTrabajo, 'Test Work');
      expect(instalacion.cargoPuesto, 'Test Position');
      expect(instalacion.telefono, '1234567890');
      expect(instalacion.numeroTarea, '1');
    });

    test('valida métodos de Instalacion', () {
      final instalacion = Instalacion(
        fechaInstalacion: DateTime.now(),
        cedula: '1234567890',
        nombreComercial: 'Test Company',
        direccion: 'Test Address',
        item: 'Test Item',
        descripcion: 'Test Description',
        horaInicio: '09:00',
        horaFin: '17:00',
        tipoTrabajo: 'Test Work',
        cargoPuesto: 'Test Position',
        telefono: '1234567890',
        numeroTarea: '1',
      );

      // Verificar que se puede cancelar
      final instalacionCancelada = instalacion.cancelar('Test reason');
      expect(instalacionCancelada.estado, EstadoInstalacion.cancelado);
      expect(instalacionCancelada.motivoCancelacion, 'Test reason');
    });

    test('valida estados de instalación', () {
      expect(EstadoInstalacion.pendiente, isNotNull);
      expect(EstadoInstalacion.enProceso, isNotNull);
      expect(EstadoInstalacion.completado, isNotNull);
      expect(EstadoInstalacion.cancelado, isNotNull);
    });
  });
}
