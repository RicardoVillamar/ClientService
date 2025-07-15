import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:client_service/models/empleado.dart';

class InitialUserSetup {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> crearEmpleadosIniciales() async {
    try {
      // Verificar si ya existen empleados
      final existing = await _firestore.collection('empleados').get();
      if (existing.docs.isNotEmpty) {
        print('Ya existen empleados en el sistema');
        return;
      }

      // Crear empleado administrador
      final admin = Empleado(
        nombre: 'Administrador',
        apellido: 'Sistema',
        cedula: 'admin',
        direccion: 'Oficina',
        telefono: '0000000000',
        correo: 'admin@lightviate.com',
        cargo: CargoEmpleado.administrador,
        fechaContratacion: DateTime.now(),
        fotoUrl: '',
      );
      await _firestore.collection('empleados').add(admin.toMap());
      print('Empleado administrador creado: admin@lightviate.com');

      // Crear empleados de ejemplo
      final empleados = [
        Empleado(
          nombre: 'Juan',
          apellido: 'Pérez',
          cedula: '123',
          direccion: 'Calle 1',
          telefono: '1111111111',
          correo: 'juan@lightviate.com',
          cargo: CargoEmpleado.tecnico,
          fechaContratacion: DateTime.now(),
        ),
        Empleado(
          nombre: 'María',
          apellido: 'González',
          cedula: '456',
          direccion: 'Calle 2',
          telefono: '2222222222',
          correo: 'maria@lightviate.com',
          cargo: CargoEmpleado.ayudante,
          fechaContratacion: DateTime.now(),
        ),
      ];
      for (final emp in empleados) {
        await _firestore.collection('empleados').add(emp.toMap());
        print('Empleado creado: ${emp.correo}');
      }
      print('Empleados iniciales creados exitosamente');
    } catch (e) {
      print('Error al crear empleados iniciales: $e');
    }
  }

  // Método para mostrar todos los empleados (solo para debug)
  static Future<void> mostrarEmpleados() async {
    try {
      final empleados = await _firestore.collection('empleados').get();
      print('\n=== EMPLEADOS EN EL SISTEMA ===');
      for (final doc in empleados.docs) {
        final empleado = Empleado.fromMap(doc.data(), doc.id);
        print('ID: ${empleado.id}');
        print('Nombre: ${empleado.nombreCompleto}');
        print('Cargo: ${empleado.cargoDisplayName}');
        print('Correo: ${empleado.correo}');
        print('---');
      }
    } catch (e) {
      print('Error al obtener empleados: $e');
    }
  }
}
