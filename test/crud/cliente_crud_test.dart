import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../mocks.mocks.dart';
import 'package:client_service/models/cliente.dart';

void main() {
  group('Casos de Prueba - Gestión de Clientes', () {
    test('Registrar cliente', () async {
      final repository = MockClienteRepository();
      final cliente = Cliente(
        nombreComercial: 'Construcciones Delta',
        ruc: '1790012345001',
        direccion: 'Km 8 Vía a Daule',
        telefono: '0991122334',
        correo: 'admin@delta.com',
        personaContacto: 'Gabriela Salazar',
        cedula: '0912345678',
      );
      when(repository.create(any)).thenAnswer((_) async => 'cli-001');
      final result = await repository.create(cliente);
      expect(result, 'cli-001');
      verify(repository.create(cliente)).called(1);
    });

    test('Editar cliente', () async {
      final repository = MockClienteRepository();
      final cliente = Cliente(
        id: 'cli-001',
        nombreComercial: 'Construcciones Delta',
        ruc: '1790012345001',
        direccion: 'Km 10.5 Vía a Daule',
        telefono: '0995566778',
        correo: 'admin@delta.com',
        personaContacto: 'Gabriela Salazar',
        cedula: '0912345678',
      );
      when(repository.update(any, any)).thenAnswer((_) async {});
      await repository.update('cli-001', cliente);
      verify(repository.update('cli-001', cliente)).called(1);
    });

    test('Eliminar cliente', () async {
      final repository = MockClienteRepository();
      when(repository.delete(any)).thenAnswer((_) async {});
      await repository.delete('cli-001');
      verify(repository.delete('cli-001')).called(1);
    });

    test('Listar clientes', () async {
      final repository = MockClienteRepository();
      final cliente = Cliente(
        nombreComercial: 'Construcciones Delta',
        ruc: '1790012345001',
        direccion: 'Km 8 Vía a Daule',
        telefono: '0991122334',
        correo: 'admin@delta.com',
        personaContacto: 'Gabriela Salazar',
        cedula: '0912345678',
      );
      when(repository.getAll()).thenAnswer((_) async => [cliente]);
      final result = await repository.getAll();
      expect(result, isA<List<Cliente>>());
      expect(result.length, 1);
      expect(result.first.nombreComercial, 'Construcciones Delta');
    });
  });
}
