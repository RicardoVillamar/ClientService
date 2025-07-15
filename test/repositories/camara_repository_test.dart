import 'package:flutter_test/flutter_test.dart';
import 'package:client_service/models/camara.dart';

void main() {
  group('CamaraRepository', () {
    test('valida estructura de datos de cámara', () {
      final camara = Camara(
        nombreComercial: 'Test Company',
        fechaMantenimiento: DateTime.now(),
        direccion: 'Test Address',
        tecnico: 'Test Technician',
        tipo: 'Test Type',
        descripcion: 'Test Description',
        costo: 100.0,
      );

      expect(camara.nombreComercial, 'Test Company');
      expect(camara.direccion, 'Test Address');
      expect(camara.tecnico, 'Test Technician');
      expect(camara.tipo, 'Test Type');
      expect(camara.descripcion, 'Test Description');
      expect(camara.costo, 100.0);
    });

    test('valida métodos de Camara', () {
      final camara = Camara(
        nombreComercial: 'Test Company',
        fechaMantenimiento: DateTime.now(),
        direccion: 'Test Address',
        tecnico: 'Test Technician',
        tipo: 'Test Type',
        descripcion: 'Test Description',
        costo: 100.0,
      );

      // Verificar que se puede cancelar
      final camaraCancelada = camara.cancelar('Test reason');
      expect(camaraCancelada.estado, EstadoCamara.cancelado);
      expect(camaraCancelada.motivoCancelacion, 'Test reason');
    });

    test('valida estados de cámara', () {
      expect(EstadoCamara.pendiente, isNotNull);
      expect(EstadoCamara.enProceso, isNotNull);
      expect(EstadoCamara.completado, isNotNull);
      expect(EstadoCamara.cancelado, isNotNull);
    });
  });
}
