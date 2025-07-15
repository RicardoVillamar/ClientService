import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../mocks.mocks.dart';
import 'package:client_service/models/empleado.dart';

void main() {
  group('Casos de Prueba - Gestión de Empleados', () {
    test('Registrar empleado', () async {
      final repository = MockEmpleadoRepository();
      final empleado = Empleado(
        nombre: 'Luis Enrique',
        apellido: 'García Martínez',
        cedula: '0912345678',
        direccion: 'Cdla. Bellavista Mz. 14',
        telefono: '0983344556',
        correo: 'lgarcia@empresa.com',
        cargo: CargoEmpleado.tecnico,
        fechaContratacion: DateTime(2025, 6, 1),
        fotoUrl: 'user_foto.jpg',
      );
      when(repository.create(any)).thenAnswer((_) async => 'emp-001');
      final result = await repository.create(empleado);
      expect(result, 'emp-001');
      verify(repository.create(empleado)).called(1);
    });

    test('Editar empleado', () async {
      final repository = MockEmpleadoRepository();
      final empleado = Empleado(
        id: 'emp-001',
        nombre: 'Luis Enrique',
        apellido: 'García Martínez',
        cedula: '0912345678',
        direccion: 'Cdla. Bellavista Mz. 14',
        telefono: '0983344556',
        correo: 'luise.garcia@empresa.com',
        cargo: CargoEmpleado.electricista,
        fechaContratacion: DateTime(2025, 6, 1),
        fotoUrl: 'user_foto.jpg',
      );
      when(repository.update(any, any)).thenAnswer((_) async {});
      await repository.update('emp-001', empleado);
      verify(repository.update('emp-001', empleado)).called(1);
    });

    test('Eliminar empleado', () async {
      final repository = MockEmpleadoRepository();
      when(repository.delete(any)).thenAnswer((_) async {});
      await repository.delete('emp-001');
      verify(repository.delete('emp-001')).called(1);
    });

    test('Listar empleados', () async {
      final repository = MockEmpleadoRepository();
      final empleado = Empleado(
        nombre: 'Luis Enrique',
        apellido: 'García Martínez',
        cedula: '0912345678',
        direccion: 'Cdla. Bellavista Mz. 14',
        telefono: '0983344556',
        correo: 'lgarcia@empresa.com',
        cargo: CargoEmpleado.tecnico,
        fechaContratacion: DateTime(2025, 6, 1),
        fotoUrl: 'user_foto.jpg',
      );
      when(repository.getAll()).thenAnswer((_) async => [empleado]);
      final result = await repository.getAll();
      expect(result, isA<List<Empleado>>());
      expect(result.length, 1);
      expect(result.first.nombreCompleto, 'Luis Enrique García Martínez');
      expect(result.first.cargoDisplayName, 'Técnico');
    });

    test('Verificar si un empleado es administrador', () async {
      final empleadoAdmin = Empleado(
        nombre: 'Admin',
        apellido: 'User',
        cedula: '1234567890',
        direccion: 'Dirección Admin',
        telefono: '0999999999',
        correo: 'admin@empresa.com',
        cargo: CargoEmpleado.administrador,
        fechaContratacion: DateTime(2025, 1, 1),
      );
      expect(empleadoAdmin.esAdministrador, true);
      expect(empleadoAdmin.cargoDisplayName, 'Administrador');
    });
  });
}
