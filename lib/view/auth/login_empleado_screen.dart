import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:client_service/viewmodel/auth_viewmodel.dart';
import 'package:client_service/providers/empleado_provider.dart';
import 'package:client_service/view/auth/cambiar_password_screen.dart';
import 'package:client_service/view/panel_empleado/panel_empleado_screen.dart';
import 'package:client_service/view/widgets/auth/login_card.dart';

class LoginEmpleadoScreen extends StatefulWidget {
  const LoginEmpleadoScreen({super.key});

  @override
  State<LoginEmpleadoScreen> createState() => _LoginEmpleadoScreenState();
}

class _LoginEmpleadoScreenState extends State<LoginEmpleadoScreen> {
  bool _isLoading = false;

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: Colors.red),
    );
  }

  Future<void> _iniciarSesion(String correo, String cedula) async {
    setState(() => _isLoading = true);
    final viewModel = Provider.of<AuthViewModel>(context, listen: false);
    final resultado =
        await viewModel.loginEmpleado(correo: correo, password: cedula);
    if (resultado['success']) {
      final empleado = resultado['empleado'];
      if (empleado != null) {
        Provider.of<EmpleadoProvider>(context, listen: false)
            .setEmpleado(empleado);
      }
      if (resultado['primerLogin'] == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => CambiarPasswordScreen(cedula: cedula)),
        );
      } else {
        // Navegar al panel de empleado
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => PanelEmpleadoScreen(empleado: empleado)),
        );
      }
    } else {
      final msg = resultado['message']?.toString().toLowerCase() ?? '';
      if (msg.contains('no encontrado') || msg.contains('not found')) {
        _mostrarError('No se encontró una cuenta con ese correo.');
      } else if (msg.contains('contraseña') || msg.contains('password')) {
        _mostrarError('Credenciales incorrectas.');
      } else {
        _mostrarError(resultado['message'] ?? 'Error al iniciar sesión.');
      }
    }
    setState(() => _isLoading = false);
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
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: LoginCard(
                    userType: 'Empleado',
                    isLoading: _isLoading,
                    onLogin: (correo, cedula) => _iniciarSesion(correo, cedula),
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
