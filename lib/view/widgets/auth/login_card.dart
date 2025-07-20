import 'package:flutter/material.dart';
import 'package:client_service/utils/colors.dart';
import 'package:client_service/utils/font.dart';

class LoginCard extends StatefulWidget {
  final String userType;
  final Function(String email, String password) onLogin;
  final bool isLoading;
  final bool showHeaderOnly; // Nuevo parámetro para mostrar solo el header
  final bool showFormOnly; // Nuevo parámetro para mostrar solo el formulario

  const LoginCard({
    super.key,
    required this.userType,
    required this.onLogin,
    this.isLoading = false,
    this.showHeaderOnly = false,
    this.showFormOnly = false,
  });

  @override
  State<LoginCard> createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      widget.onLogin(_emailController.text, _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = widget.userType == 'Administrador';

    // Si solo queremos mostrar el formulario
    if (widget.showFormOnly) {
      return _buildForm(isAdmin);
    }

    // Si solo queremos mostrar el header
    if (widget.showHeaderOnly) {
      return _buildHeader(isAdmin);
    }

    // Diseño completo original
    return Column(
      children: [
        _buildHeader(isAdmin),
        const SizedBox(height: 30),
        _buildForm(isAdmin),
      ],
    );
  }

  Widget _buildHeader(bool isAdmin) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          // Logo circular como en el mockup
          // Container(
          //   width: 120,
          //   height: 120,
          //   decoration: BoxDecoration(
          //     color: Colors.white,
          //     shape: BoxShape.circle,
          //     boxShadow: [
          //       BoxShadow(
          //         color: Colors.black.withOpacity(0.2),
          //         blurRadius: 15,
          //         offset: const Offset(0, 8),
          //       ),
          //     ],
          //   ),
          //   child: Icon(
          //     isAdmin ? Icons.admin_panel_settings : Icons.person,
          //     size: 60,
          //     color: isAdmin ? AppColors.btnColor : AppColors.primaryColor,
          //   ),
          // ),

          const SizedBox(height: 30),

          // Text(
          //   'SIMEVEC',
          //   style: AppFonts.titleBold.copyWith(
          //     fontSize: 32,
          //     color: Colors.white,
          //     letterSpacing: 2,
          //     fontWeight: FontWeight.w900,
          //     shadows: [
          //       Shadow(
          //         color: Colors.black.withOpacity(0.5),
          //         offset: const Offset(2, 2),
          //         blurRadius: 4,
          //       ),
          //     ],
          //   ),
          // ),

          const SizedBox(height: 15),

          // Tipo de usuario
          Text(
            widget.userType,
            style: AppFonts.subtitleBold.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 20,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.5),
                  offset: const Offset(1, 1),
                  blurRadius: 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(bool isAdmin) {
    return Container(
      margin: widget.showFormOnly
          ? EdgeInsets.zero
          : const EdgeInsets.symmetric(horizontal: 25),
      padding: const EdgeInsets.all(40),
      decoration: widget.showFormOnly
          ? null
          : BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Texto Bienvenido usuario
            Text(
              'Iniciar Sesión',
              style: AppFonts.titleBold.copyWith(
                color: Colors.black87,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 45),

            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(fontSize: 16),
              decoration: InputDecoration(
                labelText: 'Correo',
                labelStyle: AppFonts.inputtext.copyWith(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color:
                        isAdmin ? AppColors.btnColor : AppColors.primaryColor,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu correo';
                }
                final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                if (!emailRegex.hasMatch(value)) {
                  return 'Correo inválido';
                }
                return null;
              },
            ),

            const SizedBox(height: 35), // Aumenté el espaciado

            // Campo de contraseña
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              style: const TextStyle(
                  fontSize: 16), // Aumenté el tamaño de la fuente
              decoration: InputDecoration(
                labelText: 'Contraseña',
                labelStyle: AppFonts.inputtext.copyWith(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color:
                        isAdmin ? AppColors.btnColor : AppColors.primaryColor,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15), // Más altura en los campos
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu contraseña';
                }
                if (value.length < 6) {
                  return 'La contraseña debe tener al menos 6 caracteres';
                }
                return null;
              },
            ),

            const SizedBox(height: 55), // Aumenté el espaciado antes del botón

            // Botón de ingresar - grande y redondeado como en el mockup
            SizedBox(
              width: double.infinity,
              height: 55, // Aumenté la altura del botón
              child: ElevatedButton(
                onPressed: widget.isLoading ? null : _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isAdmin ? AppColors.btnColor : AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  elevation: 3,
                ),
                child: widget.isLoading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        'Ingresar',
                        style: AppFonts.buttonBold.copyWith(
                          fontSize:
                              18, // Aumenté el tamaño de la fuente del botón
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 30), // Aumenté el espaciado

            if (isAdmin) ...[
              const SizedBox(height: 25),
              // Mensaje de seguridad para admin más discreto
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.orange.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.security,
                      color: Colors.orange[700],
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Acceso restringido',
                        style: AppFonts.text.copyWith(
                          color: Colors.orange[700],
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
