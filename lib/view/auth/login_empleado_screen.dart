import 'package:flutter/material.dart';
import 'package:client_service/services/auth_service.dart';
import 'package:client_service/view/calendar/calendario_screen.dart';
import 'package:client_service/view/auth/cambiar_password_screen.dart';
import 'package:client_service/view/asistencia/asistencia_screen.dart';

class LoginEmpleadoScreen extends StatefulWidget {
  const LoginEmpleadoScreen({super.key});

  @override
  State<LoginEmpleadoScreen> createState() => _LoginEmpleadoScreenState();
}

class _LoginEmpleadoScreenState extends State<LoginEmpleadoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cedulaController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _cedulaController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _iniciarSesion() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final cedula = _cedulaController.text.trim();
    final password = _passwordController.text;
    final email = '$cedula@empleado.com';
    final resultado =
        await AuthService.iniciarSesion(email: email, password: password);
    setState(() => _isLoading = false);
    if (resultado['success']) {
      // Si es primer login (password == cedula), forzar cambio de contraseña
      if (password == cedula) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => CambiarPasswordScreen(cedula: cedula)),
        );
      } else {
        // Ir a la pantalla principal de empleado (calendario + asistencia)
        Navigator.pushReplacement(
            context,
          MaterialPageRoute(builder: (_) => const EmpleadoHomeScreen()),
          );
        }
      } else {
        _mostrarError(resultado['message']);
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Login Empleado',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _cedulaController,
                  decoration: const InputDecoration(labelText: 'Cédula'),
                  keyboardType: TextInputType.number,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Ingrese su cédula' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  obscureText: _obscurePassword,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Ingrese su contraseña' : null,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _isLoading ? null : _iniciarSesion,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Ingresar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Pantalla principal de empleado: calendario + asistencia
class EmpleadoHomeScreen extends StatelessWidget {
  const EmpleadoHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Panel Empleado'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.calendar_today), text: 'Servicios'),
              Tab(icon: Icon(Icons.access_time), text: 'Asistencia'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            CalendarioScreen(),
            AsistenciaScreen(),
          ],
        ),
      ),
    );
  }
}
