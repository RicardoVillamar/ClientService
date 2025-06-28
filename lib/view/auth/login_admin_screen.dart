import 'package:flutter/material.dart';
import 'package:client_service/services/auth_service.dart';
import 'package:client_service/models/usuario.dart';
import 'package:client_service/view/home/view.dart';
import 'package:client_service/view/widgets/auth/login_card.dart';

class LoginAdminScreen extends StatefulWidget {
  const LoginAdminScreen({super.key});

  @override
  State<LoginAdminScreen> createState() => _LoginAdminScreenState();
}

class _LoginAdminScreenState extends State<LoginAdminScreen> {
  bool _isLoading = false;

  Future<void> _iniciarSesion(String email, String password) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final resultado = await AuthService.iniciarSesion(
        email: email,
        password: password,
      );

      if (resultado['success']) {
        final usuario = resultado['usuario'] as Usuario;

        // Verificar que sea un administrador
        if (usuario.tipo != TipoUsuario.administrador) {
          _mostrarError('Este acceso es solo para administradores');
          return;
        }

        // Navegar a la pantalla principal
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
            (route) => false,
          );
        }
      } else {
        _mostrarError(resultado['message']);
      }
    } catch (e) {
      _mostrarError('Error inesperado: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _mostrarError(String mensaje) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Botón de regreso
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Header con logo y título
                const Column(
                  children: [
                    // Título LIGHT VITAE más grande
                    Text(
                      'LIGHT VITAE',
                      style: TextStyle(
                        fontSize: 48,
                        color: Color(0xFF8962F8),
                        letterSpacing: 3,
                        fontWeight: FontWeight.w900,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            offset: Offset(2, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 10),

                    // Subtítulo SERVICE
                    Text(
                      'SERVICE',
                      style: TextStyle(
                        fontSize: 24,
                        color: Color(0xFF8962F8),
                        letterSpacing: 2,
                        fontWeight: FontWeight.w700,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            offset: Offset(1, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),

                    // Tipo de usuario
                    Text(
                      'Administrador',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        shadows: [
                          Shadow(
                            color: Colors.black54,
                            offset: Offset(1, 1),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 80),

                // Formulario flotante
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(35),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 25,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: LoginCard(
                    userType: 'Administrador',
                    isLoading: _isLoading,
                    onLogin: _iniciarSesion,
                    showFormOnly: true,
                  ),
                ),

                const SizedBox(height: 40),

                // Enlaces adicionales
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Ayuda'),
                        content: const Text(
                          'Si tienes problemas para acceder, contacta al administrador principal del sistema.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Entendido'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Text(
                    '¿Problemas para acceder?',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                      shadows: const [
                        Shadow(
                          color: Colors.black54,
                          offset: Offset(1, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Footer
                Text(
                  '© 2025 Light Vitae',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.8),
                    shadows: const [
                      Shadow(
                        color: Colors.black54,
                        offset: Offset(1, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
