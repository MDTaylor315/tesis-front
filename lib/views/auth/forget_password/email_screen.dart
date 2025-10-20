import 'package:adipix/theme/app_theme.dart';
import 'package:adipix/views/auth/auth_shell_screen.dart';
import 'package:adipix/views/auth/forget_password/check_code_screen.dart';
import 'package:adipix/views/auth/login_screen.dart';
import 'package:adipix/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For email regex validation

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateEmail);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    final email = _emailController.text;
    setState(() {
      _isButtonEnabled = _isValidEmail(email);
    });
  }

  bool _isValidEmail(String email) {
    // Basic email regex validation (can be enhanced with a library like email_validator)
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 30,
        ),
        color: Colors.white,
        child: TextButton(
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) =>
                    AuthShell(), // Envuelve el widget en MaterialPageRoute
              ),
              (route) => false, // Elimina todas las rutas anteriores
            );
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('¿Recordaste tu contraseña? '),
              Text(
                "Inicia sesión",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.08),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    child: const Icon(Icons.chevron_left_outlined, size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Image.asset('assets/img/logo_letras.png', height: 40),
                ],
              ),
              const SizedBox(height: 48),
              const Text(
                '¿Olvidaste tu contraseña?',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                '¡No te preocupes! Introduce el correo electrónico asociado a tu cuenta.',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16, height: 1.4),
              ),
              const SizedBox(height: 32),
              CustomTextFormField(
                title: 'Correo electrónico',
                labelText: 'ejemplo@adipix.pe',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu correo electrónico';
                  }
                  if (!_isValidEmail(value)) {
                    return 'Por favor ingresa un correo válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _isButtonEnabled
                      ? () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    VerificationScreen(), // Envuelve el widget en MaterialPageRoute
                              ),
                            );
                          }
                        }
                      : null, // Disables the button
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: _isButtonEnabled
                        ? const BorderSide(
                            color: AppTheme.primaryColor,
                            width: 2) // Enabled: orange border
                        : BorderSide(
                            color: Colors.grey[400]!), // Disabled: gray border
                    backgroundColor: _isButtonEnabled
                        ? AppTheme.primaryColor // Enabled: orange fill
                        : Colors.transparent, // Disabled: transparent
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    foregroundColor: _isButtonEnabled
                        ? Colors.white // Enabled: white text
                        : Colors.grey[600], // Disabled: gray text
                  ),
                  child: const Text(
                    'Enviar código',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
