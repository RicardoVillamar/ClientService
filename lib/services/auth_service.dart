import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static const String _collection = 'usuarios';

  // Iniciar sesión solo para administradora
  static Future<Map<String, dynamic>> iniciarSesion({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return {
        'success': true,
        'message': 'Inicio de sesión exitoso',
        'user': userCredential.user,
      };
    } on FirebaseAuthException catch (e) {
      return {
        'success': false,
        'message': e.message ?? 'Error desconocido',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error al iniciar sesión: $e',
      };
    }
  }

  // Cerrar sesión
  static Future<void> cerrarSesion() async {
    await _auth.signOut();
  }

  // Verificar si hay una sesión activa
  static bool get tieneUsuarioActivo => _auth.currentUser != null;

  // Obtener usuario actual
  static User? get usuarioActual => _auth.currentUser;
}
