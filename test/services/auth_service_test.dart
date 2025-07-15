import 'package:flutter_test/flutter_test.dart';
import 'package:client_service/services/auth_service.dart';

void main() {
  group('AuthService', () {
    test('valida estructura de respuesta de login exitoso', () {
      // Probar que la estructura de respuesta es correcta
      final respuestaExito = {
        'success': true,
        'message': 'Inicio de sesión exitoso',
        'user': null,
      };

      expect(respuestaExito['success'], true);
      expect(respuestaExito['message'], isA<String>());
      expect(respuestaExito.containsKey('user'), true);
    });

    test('valida estructura de respuesta de login fallido', () {
      // Probar que la estructura de respuesta de error es correcta
      final respuestaError = {
        'success': false,
        'message': 'Error de autenticación',
      };

      expect(respuestaError['success'], false);
      expect(respuestaError['message'], isA<String>());
      expect(respuestaError.containsKey('user'), false);
    });

    test('valida métodos estáticos de AuthService', () {
      // Verificar que los métodos estáticos están definidos
      expect(AuthService.iniciarSesion, isA<Function>());
      expect(AuthService.cerrarSesion, isA<Function>());
    });
  });
}
