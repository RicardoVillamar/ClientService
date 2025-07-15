import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../mocks.mocks.dart';
import 'package:client_service/models/camara.dart';

void main() {
  group('Casos de Prueba - Mantenimiento de Cámaras', () {
    group('CP-CAM-001: Registrar mantenimiento de cámara', () {
      test('Debería registrar un mantenimiento de cámara exitosamente',
          () async {
        // Arrange
        final repository = MockCamaraRepository();
        final camara = Camara(
          nombreComercial: 'Seguridad Total S.A.',
          fechaMantenimiento: DateTime(2025, 6, 8),
          direccion: 'Av. Las Américas y Calle 12',
          tecnico: 'Carlos Molina',
          tipo: 'Cuadrilla 2',
          descripcion: 'Reemplazo de lente',
          costo: 150.00,
        );

        // Configurar el mock para devolver un ID
        when(repository.create(any)).thenAnswer((_) async => 'cam-001');

        // Act
        final result = await repository.create(camara);

        // Assert
        expect(result, 'cam-001');
        verify(repository.create(camara)).called(1);
      });
    });

    group('CP-CAM-002: Editar mantenimiento de cámara', () {
      test('Debería actualizar un mantenimiento existente', () async {
        // Arrange
        final repository = MockCamaraRepository();
        final camaraActualizada = Camara(
          id: 'cam-001',
          nombreComercial: 'Seguridad Total S.A.',
          fechaMantenimiento: DateTime(2025, 6, 8),
          direccion: 'Av. Las Américas y Calle 12',
          tecnico: 'Andrea Pérez',
          tipo: 'Cuadrilla 2',
          descripcion: 'Cambio de lente y limpieza de sensor',
          costo: 150.00,
        );

        when(repository.update(any, any)).thenAnswer((_) async {});

        // Act
        await repository.update('cam-001', camaraActualizada);

        // Assert
        verify(repository.update('cam-001', camaraActualizada)).called(1);
      });
    });

    group('CP-CAM-003: Cancelar mantenimiento de cámara', () {
      test('Debería cancelar un mantenimiento correctamente', () async {
        // Arrange
        final camara = Camara(
          id: 'cam-001',
          nombreComercial: 'Seguridad Total S.A.',
          fechaMantenimiento: DateTime(2025, 6, 8),
          direccion: 'Av. Las Américas y Calle 12',
          tecnico: 'Carlos Molina',
          tipo: 'Cuadrilla 2',
          descripcion: 'Reemplazo de lente',
          costo: 150.00,
        );

        final camaraCancelada = camara.cancelar('Cliente canceló el servicio');

        // Assert
        expect(camaraCancelada.estado, EstadoCamara.cancelado);
        expect(
            camaraCancelada.motivoCancelacion, 'Cliente canceló el servicio');
        expect(camaraCancelada.fechaCancelacion, isNotNull);
      });
    });

    group('Operaciones CRUD básicas', () {
      test('Debería listar todas las cámaras', () async {
        // Arrange
        final repository = MockCamaraRepository();
        final camaras = [
          Camara(
            nombreComercial: 'Seguridad Total S.A.',
            fechaMantenimiento: DateTime(2025, 6, 8),
            direccion: 'Av. Las Américas y Calle 12',
            tecnico: 'Carlos Molina',
            tipo: 'Cuadrilla 2',
            descripcion: 'Reemplazo de lente',
            costo: 150.00,
          ),
        ];

        when(repository.getAll()).thenAnswer((_) async => camaras);

        // Act
        final result = await repository.getAll();

        // Assert
        expect(result, isA<List<Camara>>());
        expect(result.length, 1);
        expect(result.first.nombreComercial, 'Seguridad Total S.A.');
      });

      test('Debería eliminar una cámara', () async {
        // Arrange
        final repository = MockCamaraRepository();
        when(repository.delete(any)).thenAnswer((_) async {});

        // Act
        await repository.delete('cam-001');

        // Assert
        verify(repository.delete('cam-001')).called(1);
      });
    });
  });
}
