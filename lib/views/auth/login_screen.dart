import 'package:adipix/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  final bool loginMode;
  const LoginScreen({super.key, required this.loginMode});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // Clave para el Form
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final TextEditingController nameController =
      TextEditingController(); // For register (aunque no se usa en el código actual)

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      // Envolver todo en un Form para habilitar validación
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Email Field
          CustomTextFormField(
            title: 'Correo electrónico',
            labelText: 'ejemplo@adipix.pe',
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),

          // Password Field
          CustomTextFormField(
            title: 'Contraseña',
            labelText: '••••••••',
            controller: passwordController,
            isPassword: true,
          ),

          // Confirm Password Field (only in register mode)
          if (!widget.loginMode)
            Column(
              children: [
                const SizedBox(height: 16),
                CustomTextFormField(
                  title: 'Confirmar contraseña',
                  labelText: '••••••••',
                  controller: confirmPasswordController,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor confirma tu contraseña';
                    }
                    if (value != passwordController.text) {
                      return 'Las contraseñas no coinciden';
                    }
                    return null;
                  },
                ),
              ],
            ),

          // Forgot Password Link (only in login mode)
          if (widget.loginMode)
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.zero,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/forget_password');
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text('¿Olvidaste la contraseña?'),
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 50),

          // Login/Register Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Validar el formulario antes de proceder
                  if (widget.loginMode) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/onboarding', (route) => false);
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(widget.loginMode ? 'Ingresar' : 'Registrarme'),
            ),
          ),
          const SizedBox(height: 32),

          // Or Login With (puedes agregar más aquí si es necesario)
        ],
      ),
    );
  }
}
