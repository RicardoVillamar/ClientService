import 'package:flutter/material.dart';
import 'package:client_service/viewmodel/auth_viewmodel.dart';
import 'package:client_service/view/home/view.dart';
import 'package:client_service/view/widgets/auth/login_card.dart';
import 'package:client_service/models/empleado.dart';
import 'package:client_service/view/auth/cambiar_password_screen.dart';
import 'package:provider/provider.dart';
import 'package:client_service/providers/empleado_provider.dart';

class LoginAdminScreen extends StatelessWidget {
  const LoginAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthViewModel>(
      create: (_) => AuthViewModel(),
      child: const _LoginAdminScreenBody(),
    );
  }
}

class _LoginAdminScreenBody extends StatefulWidget {
  const _LoginAdminScreenBody();

  @override
  State<_LoginAdminScreenBody> createState() => _LoginAdminScreenBodyState();
}

class _LoginAdminScreenBodyState extends State<_LoginAdminScreenBody> {
  bool _isLoading = false;

  void _mostrarError(String mensaje) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _iniciarSesion(String email, String password) async {
    setState(() {
      _isLoading = true;
    });
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+\u0000*');
    if (!emailRegex.hasMatch(email)) {
      _mostrarError('Ingrese un correo válido.');
      setState(() => _isLoading = false);
      return;
    }
    final viewModel = Provider.of<AuthViewModel>(context, listen: false);
    final resultado =
        await viewModel.loginEmpleado(correo: email, password: password);
    if (resultado['success']) {
      final empleado = resultado['empleado'];
      final primerLogin = resultado['primerLogin'] ?? false;
      if (empleado != null) {
        if (empleado.cargo != CargoEmpleado.administrador) {
          _mostrarError(
              'Solo usuarios con cargo de Administrador pueden acceder aquí.');
          setState(() => _isLoading = false);
          return;
        }
        Provider.of<EmpleadoProvider>(context, listen: false)
            .setEmpleado(empleado);
      }
      if (empleado != null && primerLogin) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => CambiarPasswordScreen(cedula: empleado.cedula),
          ),
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false,
        );
      }
    } else {
      final msg = resultado['message']?.toString().toLowerCase() ?? '';
      if (msg.contains('no encontrado') || msg.contains('not found')) {
        _mostrarError('No se encontró una cuenta con ese correo.');
      } else if (msg.contains('contraseña') || msg.contains('password')) {
        _mostrarError('Credenciales incorrectas.');
      } else {
        _mostrarError('Error al iniciar sesión.');
      }
    }
    setState(() {
      _isLoading = false;
    });
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
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(35),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
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
                const Text(
                  '© 2025 SIMEVEC',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                    shadows: [
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
