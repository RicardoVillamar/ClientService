import 'package:flutter/material.dart';
import 'package:client_service/utils/colors.dart';
import 'package:client_service/utils/font.dart';
import 'package:provider/provider.dart';
import 'package:client_service/providers/empleado_provider.dart';
import 'package:client_service/view/auth/cambiar_password_screen.dart';

class ProfileAdminView extends StatelessWidget {
  const ProfileAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    final empleado = Provider.of<EmpleadoProvider>(context).empleado;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil del Administrador',
            style: TextStyle(color: Colors.black)),
        backgroundColor: AppColors.backgroundColor,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: empleado == null
            ? const Center(child: Text('No hay información del administrador.'))
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 24),
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.deepPurple,
                      backgroundImage: empleado.fotoUrl.isNotEmpty
                          ? NetworkImage(empleado.fotoUrl)
                          : null,
                      child: empleado.fotoUrl.isEmpty
                          ? const Icon(Icons.person,
                              size: 60, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      empleado.nombreCompleto,
                      style: AppFonts.titleBold,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      empleado.cargo.displayName,
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 0),
                      child: ListTile(
                        leading: const Icon(Icons.email),
                        title: Text(
                          empleado.correo,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: const Text('Correo'),
                      ),
                    ),
                    Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 0),
                      child: ListTile(
                        leading: const Icon(Icons.badge),
                        title: Text(
                          empleado.cedula,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: const Text('Cédula'),
                      ),
                    ),
                    Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 0),
                      child: ListTile(
                        leading: const Icon(Icons.phone),
                        title: Text(
                          empleado.telefono,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: const Text('Teléfono'),
                      ),
                    ),
                    const SizedBox(height: 32),
                    ListTile(
                      leading: const Icon(Icons.lock_reset),
                      title: const Text('Cambiar contraseña'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                CambiarPasswordScreen(cedula: empleado.cedula),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: const Text('Cerrar sesión'),
                      onTap: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/login', (route) => false);
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
