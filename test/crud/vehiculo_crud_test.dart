import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../mocks.mocks.dart';
import 'package:client_service/models/vehiculo.dart';

void main() {
  group('Casos de Prueba - Alquiler de Vehículos', () {
    late MockVehiculoRepository repository;

    setUp(() {
      repository = MockVehiculoRepository();
    });

    group('CP-VHL-001: Registrar alquiler de vehículo', () {
      test('Debería registrar un alquiler de vehículo exitosamente', () async {
        // Arrange - Datos del caso de prueba CP-VHL-001
        final alquiler = Alquiler(
          nombreComercial: 'Logística Express S.A.',
          direccion: 'Av. Principal y Calle F',
          telefono: '0981122334',
          correo: 'contacto@logex.com',
          tipoVehiculo: 'Camión grúa',
          fechaReserva: DateTime(2025, 6, 10),
          fechaTrabajo: DateTime(2025, 6, 11),
          montoAlquiler: 250.00,
          personalAsistio: 'Hugo Jaramillo',
        );

        when(repository.create(any)).thenAnswer((_) async => 'vhl-001');

        // Act
        final result = await repository.create(alquiler);

        // Assert
        expect(result, 'vhl-001');
        verify(repository.create(alquiler)).called(1);
      });
    });

    group('CP-VHL-002: Actualizar alquiler de vehículo', () {
      test('Debería actualizar un alquiler existente', () async {
        // Arrange - Datos del caso de prueba CP-VHL-002
        final alquilerOriginal = Alquiler(
          id: 'vhl-001',
          nombreComercial: 'Logística Express S.A.',
          direccion: 'Av. Principal y Calle F',
          telefono: '0981122334',
          correo: 'contacto@logex.com',
          tipoVehiculo: 'Camión grúa',
          fechaReserva: DateTime(2025, 6, 10),
          fechaTrabajo: DateTime(2025, 6, 11),
          montoAlquiler: 250.00,
          personalAsistio: 'Hugo Jaramillo',
        );

        final alquilerActualizado = Alquiler(
          id: 'vhl-001',
          nombreComercial: 'Logística Express S.A.',
          direccion: 'Av. Principal y Calle F',
          telefono: '0981122334',
          correo: 'contacto@logex.com',
          tipoVehiculo: 'Camión grúa',
          fechaReserva: DateTime(2025, 6, 10),
          fechaTrabajo: DateTime(2025, 6, 12),
          montoAlquiler: 270.00,
          personalAsistio: 'Hugo Jaramillo',
        );

        when(repository.update(any, any)).thenAnswer((_) async {});

        // Act
        await repository.update('vhl-001', alquilerActualizado);

        // Assert
        verify(repository.update('vhl-001', alquilerActualizado)).called(1);
      });
    });

    group('CP-VHL-003: Cancelar alquiler de vehículo', () {
      test('Debería cancelar un alquiler correctamente', () async {
        // Arrange
        final alquiler = Alquiler(
          id: 'vhl-001',
          nombreComercial: 'Logística Express S.A.',
          direccion: 'Av. Principal y Calle F',
          telefono: '0981122334',
          correo: 'contacto@logex.com',
          tipoVehiculo: 'Camión grúa',
          fechaReserva: DateTime(2025, 6, 10),
          fechaTrabajo: DateTime(2025, 6, 11),
          montoAlquiler: 250.00,
          personalAsistio: 'Hugo Jaramillo',
        );

        final alquilerCancelado =
            alquiler.cancelar('Cliente canceló la reserva');

        when(repository.update(any, any)).thenAnswer((_) async {});

        // Act
        await repository.update('vhl-001', alquilerCancelado);

        // Assert
        verify(repository.update('vhl-001', alquilerCancelado)).called(1);
        expect(alquilerCancelado.estado, EstadoAlquiler.cancelado);
        expect(
            alquilerCancelado.motivoCancelacion, 'Cliente canceló la reserva');
      });
    });

    group('Operaciones CRUD básicas', () {
      test('Debería listar todos los alquileres', () async {
        // Arrange
        final alquileres = [
          Alquiler(
            nombreComercial: 'Logística Express S.A.',
            direccion: 'Av. Principal y Calle F',
            telefono: '0981122334',
            correo: 'contacto@logex.com',
            tipoVehiculo: 'Camión grúa',
            fechaReserva: DateTime(2025, 6, 10),
            fechaTrabajo: DateTime(2025, 6, 11),
            montoAlquiler: 250.00,
            personalAsistio: 'Hugo Jaramillo',
          ),
        ];

        when(repository.getAll()).thenAnswer((_) async => alquileres);

        // Act
        final result = await repository.getAll();

        // Assert
        expect(result, isA<List<Alquiler>>());
        expect(result.length, 1);
        expect(result.first.nombreComercial, 'Logística Express S.A.');
      });

      test('Debería eliminar un alquiler', () async {
        // Arrange
        when(repository.delete(any)).thenAnswer((_) async {});

        // Act
        await repository.delete('vhl-001');

        // Assert
        verify(repository.delete('vhl-001')).called(1);
      });
    });
  });
}
