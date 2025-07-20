import 'package:flutter/material.dart';
import 'package:client_service/view/auth/login_admin_screen.dart';
import 'package:client_service/utils/colors.dart';
import 'package:client_service/utils/font.dart';
import 'package:client_service/view/auth/login_empleado_screen.dart';

class LoginSelectionScreen extends StatelessWidget {
  const LoginSelectionScreen({super.key});

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
          child: Column(
            children: [
              // Logo y título principal
              Container(
                padding: const EdgeInsets.all(40),
                margin: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Text(
                          'SIMEVEC',
                          style: AppFonts.titleBold.copyWith(
                            fontSize: 48,
                            color: AppColors.primaryColor,
                            letterSpacing: 3,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Subtítulo
                    Text(
                      'Sistema de servicios de instalación, mantenimiento de postes, Cámaras y préstamos de vehículos',
                      style: AppFonts.text.copyWith(
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                        fontSize: 24,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.2),
                            offset: const Offset(0, 2),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const Spacer(),
              // Mensaje de selección
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                padding: const EdgeInsets.all(10),
                // child: Text(
                //   'Selecciona tu tipo de acceso',
                //   style: AppFonts.subtitleBold.copyWith(
                //     color: AppColors.btnColor,
                //     fontSize: 24,
                //     letterSpacing: 1.2,
                //   ),
                //   textAlign: TextAlign.center,
                // ),
              ),

              const SizedBox(height: 30),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 42, vertical: 20),
                child: Column(
                  children: [
                    // Botón Administrador
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginAdminScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.btnColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 5,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.admin_panel_settings, size: 24),
                            const SizedBox(width: 12),
                            Text(
                              'Administrador',
                              style: AppFonts.buttonBold.copyWith(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginEmpleadoScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 5,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.person, size: 24),
                            const SizedBox(width: 12),
                            Text(
                              'Empleado',
                              style: AppFonts.buttonBold.copyWith(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Footer
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  '© 2025 SIMEVEC - Todos los derechos reservados',
                  style: AppFonts.text.copyWith(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
