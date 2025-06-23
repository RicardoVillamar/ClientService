import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:client_service/models/usuario.dart';

class InitialUserSetup {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> crearUsuariosIniciales() async {
    try {
      // Verificar si ya existen usuarios
      final existingUsers = await _firestore.collection('usuarios').get();
      if (existingUsers.docs.isNotEmpty) {
        print('Ya existen usuarios en el sistema');
        return;
      }

      // Crear usuario administrador
      final admin = Usuario(
        email: 'admin@lightvitae.com',
        password: 'admin123', // En producción, esto debería estar hasheado
        tipo: TipoUsuario.administrador,
        nombre: 'Administrador',
        apellido: 'Sistema',
        activo: true,
        fechaCreacion: DateTime.now(),
      );

      await _firestore.collection('usuarios').add(admin.toMap());
      print('Usuario administrador creado: admin@lightvitae.com / admin123');

      // Crear usuario empleado de prueba
      final empleado = Usuario(
        email: 'empleado@lightvitae.com',
        password: 'empleado123', // En producción, esto debería estar hasheado
        tipo: TipoUsuario.empleado,
        nombre: 'Juan',
        apellido: 'Pérez',
        activo: true,
        fechaCreacion: DateTime.now(),
      );

      await _firestore.collection('usuarios').add(empleado.toMap());
      print('Usuario empleado creado: empleado@lightvitae.com / empleado123');

      // Crear más usuarios empleados de ejemplo
      final empleados = [
        Usuario(
          email: 'maria.gonzalez@lightvitae.com',
          password: 'maria123',
          tipo: TipoUsuario.empleado,
          nombre: 'María',
          apellido: 'González',
          activo: true,
          fechaCreacion: DateTime.now(),
        ),
        Usuario(
          email: 'carlos.rodriguez@lightvitae.com',
          password: 'carlos123',
          tipo: TipoUsuario.empleado,
          nombre: 'Carlos',
          apellido: 'Rodríguez',
          activo: true,
          fechaCreacion: DateTime.now(),
        ),
      ];

      for (final emp in empleados) {
        await _firestore.collection('usuarios').add(emp.toMap());
        print('Usuario empleado creado: ${emp.email} / ${emp.password}');
      }

      print('Usuarios iniciales creados exitosamente');
    } catch (e) {
      print('Error al crear usuarios iniciales: $e');
    }
  }

  // Método para mostrar todos los usuarios (solo para debug)
  static Future<void> mostrarUsuarios() async {
    try {
      final usuarios = await _firestore.collection('usuarios').get();
      print('\n=== USUARIOS EN EL SISTEMA ===');
      for (final doc in usuarios.docs) {
        final usuario = Usuario.fromMap(doc.data(), doc.id);
        print('ID: ${usuario.id}');
        print('Email: ${usuario.email}');
        print('Nombre: ${usuario.nombreCompleto}');
        print('Tipo: ${usuario.tipo.displayName}');
        print('Activo: ${usuario.activo}');
        print('---');
      }
    } catch (e) {
      print('Error al obtener usuarios: $e');
    }
  }
}
