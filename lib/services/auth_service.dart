import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:client_service/models/usuario.dart';

class AuthService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'usuarios';

  // Usuario actual autenticado
  static Usuario? _usuarioActual;
  static Usuario? get usuarioActual => _usuarioActual;

  // Iniciar sesión
  static Future<Map<String, dynamic>> iniciarSesion({
    required String email,
    required String password,
  }) async {
    try {
      // Normalizar email
      email = email.toLowerCase().trim();

      // Buscar usuario por email
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('email', isEqualTo: email)
          .where('activo', isEqualTo: true)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return {
          'success': false,
          'message': 'Usuario no encontrado o inactivo',
        };
      }

      final userDoc = querySnapshot.docs.first;
      final usuario = Usuario.fromMap(userDoc.data(), userDoc.id);

      // Verificar contraseña (en producción debería usar hash)
      if (usuario.password != password) {
        return {
          'success': false,
          'message': 'Contraseña incorrecta',
        };
      }

      // Actualizar último acceso
      await _firestore.collection(_collection).doc(userDoc.id).update({
        'ultimoAcceso': DateTime.now().toIso8601String(),
      });

      // Establecer usuario actual
      _usuarioActual = usuario.copyWith(
        ultimoAcceso: DateTime.now(),
      );

      return {
        'success': true,
        'message': 'Inicio de sesión exitoso',
        'usuario': _usuarioActual,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error al iniciar sesión: $e',
      };
    }
  }

  // Cerrar sesión
  static void cerrarSesion() {
    _usuarioActual = null;
  }

  // Verificar si hay una sesión activa
  static bool get tieneUsuarioActivo => _usuarioActual != null;

  // Verificar si el usuario actual es administrador
  static bool get esAdministrador => _usuarioActual?.esAdministrador ?? false;

  // Verificar si el usuario actual es empleado
  static bool get esEmpleado => _usuarioActual?.esEmpleado ?? false;

  // Crear usuario (solo para administradores)
  static Future<Map<String, dynamic>> crearUsuario(Usuario usuario) async {
    try {
      // Verificar que el usuario actual sea administrador
      if (!esAdministrador) {
        return {
          'success': false,
          'message': 'No tienes permisos para crear usuarios',
        };
      }

      // Verificar que el email no exista
      final existeEmail = await _firestore
          .collection(_collection)
          .where('email', isEqualTo: usuario.email.toLowerCase().trim())
          .get();

      if (existeEmail.docs.isNotEmpty) {
        return {
          'success': false,
          'message': 'Ya existe un usuario con este email',
        };
      }

      // Crear usuario
      final docRef =
          await _firestore.collection(_collection).add(usuario.toMap());

      return {
        'success': true,
        'message': 'Usuario creado exitosamente',
        'usuarioId': docRef.id,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error al crear usuario: $e',
      };
    }
  }

  // Obtener todos los usuarios (solo para administradores)
  static Future<List<Usuario>> obtenerUsuarios() async {
    if (!esAdministrador) return [];

    try {
      final querySnapshot = await _firestore.collection(_collection).get();
      return querySnapshot.docs
          .map((doc) => Usuario.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Cambiar contraseña
  static Future<Map<String, dynamic>> cambiarContrasena({
    required String contrasenaActual,
    required String nuevaContrasena,
  }) async {
    try {
      if (_usuarioActual == null) {
        return {
          'success': false,
          'message': 'No hay usuario autenticado',
        };
      }

      // Verificar contraseña actual
      if (_usuarioActual!.password != contrasenaActual) {
        return {
          'success': false,
          'message': 'Contraseña actual incorrecta',
        };
      }

      // Actualizar contraseña
      await _firestore.collection(_collection).doc(_usuarioActual!.id).update({
        'password': nuevaContrasena,
      });

      // Actualizar usuario actual
      _usuarioActual = _usuarioActual!.copyWith(password: nuevaContrasena);

      return {
        'success': true,
        'message': 'Contraseña actualizada exitosamente',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error al cambiar contraseña: $e',
      };
    }
  }
}
