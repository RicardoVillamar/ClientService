import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../mocks.mocks.dart';
import 'package:client_service/models/instalacion.dart';

void main() {
  group('Casos de Prueba - Instalación de Postes', () {
    late MockInstalacionRepository repository;

    setUp(() {
      repository = MockInstalacionRepository();
    });

    group('CP-PST-001: Registrar instalación de poste', () {
      test('Debería registrar una instalación de poste exitosamente', () async {
        // Arrange - Datos del caso de prueba CP-PST-001
        final instalacion = Instalacion(
          fechaInstalacion: DateTime(2025, 6, 7),
          cedula: '0923456789',
          nombreComercial: 'Infraestructura Segura S.A.',
          direccion: 'Cdla. Kennedy Norte, Calle 5ta',
          item: 'Poste metálico 10m, grúa hidráulica',
          descripcion: 'Instalación de poste para alumbrado público',
          horaInicio: '09:00',
          horaFin: '13:30',
          tipoTrabajo: 'Instalación',
          cargoPuesto: 'Manuel Rodríguez',
          telefono: '0991234567',
          numeroTarea: '5',
        );

        when(repository.create(any)).thenAnswer((_) async => 'pst-001');

        // Act
        final result = await repository.create(instalacion);

        // Assert
        expect(result, 'pst-001');
        verify(repository.create(instalacion)).called(1);
      });
    });

    group('CP-PST-002: Editar instalación de poste', () {
      test('Debería actualizar una instalación existente', () async {
        // Arrange - Datos del caso de prueba CP-PST-002
        final instalacionOriginal = Instalacion(
          id: 'pst-001',
          fechaInstalacion: DateTime(2025, 6, 7),
          cedula: '0923456789',
          nombreComercial: 'Infraestructura Segura S.A.',
          direccion: 'Cdla. Kennedy Norte, Calle 5ta',
          item: 'Poste metálico 10m, grúa hidráulica',
          descripcion: 'Instalación de poste para alumbrado público',
          horaInicio: '09:00',
          horaFin: '13:30',
          tipoTrabajo: 'Instalación',
          cargoPuesto: 'Manuel Rodríguez',
          telefono: '0991234567',
          numeroTarea: '5',
        );

        final instalacionActualizada = Instalacion(
          id: 'pst-001',
          fechaInstalacion: DateTime(2025, 6, 7),
          cedula: '0923456789',
          nombreComercial: 'Infraestructura Segura S.A.',
          direccion: 'Cdla. Kennedy Norte, Calle 5ta',
          item: 'Poste metálico 10m, grúa hidráulica',
          descripcion: 'Cambio de poste anterior por uno nuevo',
          horaInicio: '09:00',
          horaFin: '14:00',
          tipoTrabajo: 'Instalación',
          cargoPuesto: 'Manuel Rodríguez',
          telefono: '0991234567',
          numeroTarea: '5',
        );

        when(repository.update(any, any)).thenAnswer((_) async {});

        // Act
        await repository.update('pst-001', instalacionActualizada);

        // Assert
        verify(repository.update('pst-001', instalacionActualizada)).called(1);
      });
    });

    group('CP-PST-003: Cancelar instalación de poste', () {
      test('Debería cancelar una instalación correctamente', () async {
        // Arrange
        final instalacion = Instalacion(
          id: 'pst-001',
          fechaInstalacion: DateTime(2025, 6, 7),
          cedula: '0923456789',
          nombreComercial: 'Infraestructura Segura S.A.',
          direccion: 'Cdla. Kennedy Norte, Calle 5ta',
          item: 'Poste metálico 10m, grúa hidráulica',
          descripcion: 'Instalación de poste para alumbrado público',
          horaInicio: '09:00',
          horaFin: '13:30',
          tipoTrabajo: 'Instalación',
          cargoPuesto: 'Manuel Rodríguez',
          telefono: '0991234567',
          numeroTarea: '5',
        );

        final instalacionCancelada =
            instalacion.cancelar('Cliente canceló la instalación');

        when(repository.update(any, any)).thenAnswer((_) async {});

        // Act
        await repository.update('pst-001', instalacionCancelada);

        // Assert
        verify(repository.update('pst-001', instalacionCancelada)).called(1);
        expect(instalacionCancelada.estado, EstadoInstalacion.cancelado);
        expect(instalacionCancelada.motivoCancelacion,
            'Cliente canceló la instalación');
      });
    });

    group('Operaciones CRUD básicas', () {
      test('Debería listar todas las instalaciones', () async {
        // Arrange
        final instalaciones = [
          Instalacion(
            fechaInstalacion: DateTime(2025, 6, 7),
            cedula: '0923456789',
            nombreComercial: 'Infraestructura Segura S.A.',
            direccion: 'Cdla. Kennedy Norte, Calle 5ta',
            item: 'Poste metálico 10m, grúa hidráulica',
            descripcion: 'Instalación de poste para alumbrado público',
            horaInicio: '09:00',
            horaFin: '13:30',
            tipoTrabajo: 'Instalación',
            cargoPuesto: 'Manuel Rodríguez',
            telefono: '0991234567',
            numeroTarea: '5',
          ),
        ];

        when(repository.getAll()).thenAnswer((_) async => instalaciones);

        // Act
        final result = await repository.getAll();

        // Assert
        expect(result, isA<List<Instalacion>>());
        expect(result.length, 1);
        expect(result.first.nombreComercial, 'Infraestructura Segura S.A.');
      });

      test('Debería eliminar una instalación', () async {
        // Arrange
        when(repository.delete(any)).thenAnswer((_) async {});

        // Act
        await repository.delete('pst-001');

        // Assert
        verify(repository.delete('pst-001')).called(1);
      });
    });
  });
}
