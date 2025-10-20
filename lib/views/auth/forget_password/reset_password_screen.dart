import 'package:adipix/theme/app_theme.dart';
import 'package:adipix/views/auth/forget_password/success_password_screen.dart';
import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Estados para la visibilidad de la contraseña
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Estado para habilitar el botón
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    // Escucha los cambios para habilitar/deshabilitar el botón
    _passwordController.addListener(_validateFields);
    _confirmPasswordController.addListener(_validateFields);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Lógica de habilitación del botón
  void _validateFields() {
    setState(() {
      // Habilitar si ambos campos tienen contenido (Puedes agregar más reglas aquí)
      _isButtonEnabled = _passwordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty;
    });
  }

  // Widget personalizado para el campo de contraseña
  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool isVisible,
    required VoidCallback toggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: !isVisible, // Ocultar si isVisible es false
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Este campo es obligatorio.';
            }
            if (label == 'Confirmar contraseña' &&
                value != _passwordController.text) {
              return 'Las contraseñas no coinciden.';
            }
            // Agrega más validaciones de seguridad de contraseña aquí
            return null;
          },
          decoration: InputDecoration(
            hintText: '• • • • • • • •', // Dots como hint
            suffixIcon: IconButton(
              icon: Icon(
                isVisible
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: Colors.grey[400],
              ),
              onPressed: toggleVisibility,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  const BorderSide(color: AppTheme.secondaryColor, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // Botón de sesión al final (bottomNavigationBar)
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 10,
          left: 24,
          right: 24,
        ),
        color: Colors.white,
        child: TextButton(
          onPressed: () {
            // Regresar a la pantalla de Login (simulación)
            Navigator.of(context).pop();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('¿Recordaste tu contraseña? ',
                  style: TextStyle(color: Colors.black)),
              Text(
                "Inicia sesión",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.secondaryColor,
                ),
              ),
            ],
          ),
        ),
      ),

      // Contenido principal
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top + 20),

                // Header: Botón de regreso y Logo
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.zero, // Padding mínimo
                        side: BorderSide(color: Colors.grey[300]!),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        minimumSize: const Size(44, 44),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new,
                          size: 20, color: Colors.black),
                    ),
                    Image.asset('assets/img/logo_letras.png', height: 40),
                  ],
                ),

                const SizedBox(height: 48),

                // Título y Subtítulo
                const Text(
                  'Restablecer contraseña',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                const Text(
                  'Por favor escribe algo que puedas recordar.',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 32),

                // 1. Campo 'Crear contraseña'
                _buildPasswordField(
                  label: 'Crear contraseña',
                  controller: _passwordController,
                  isVisible: _isPasswordVisible,
                  toggleVisibility: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),

                const SizedBox(height: 24),

                // 2. Campo 'Confirmar contraseña'
                _buildPasswordField(
                  label: 'Confirmar contraseña',
                  controller: _confirmPasswordController,
                  isVisible: _isConfirmPasswordVisible,
                  toggleVisibility: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                ),

                const SizedBox(height: 32),

                // Botón "Restablecer contraseña"
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isButtonEnabled
                        ? () {
                            if (_formKey.currentState!.validate()) {
                              // Lógica para restablecer la contraseña
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PasswordSuccessScreen(), // Envuelve el widget en MaterialPageRoute
                                ),
                              );
                            }
                          }
                        : null, // Deshabilitar el botón si no está habilitado
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.secondaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      // Estilo para botón deshabilitado
                    ),
                    child: const Text(
                      'Restablecer contraseña',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                const SizedBox(height: 20), // Espacio final
              ],
            ),
          ),
        ),
      ),
    );
  }
}
