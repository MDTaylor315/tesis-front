import 'package:adipix/theme/app_theme.dart';
import 'package:adipix/widgets/text_field.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  // Inserta/registro del controller aquí. Alternativamente, registra en Bindings.
  // Registra el controller (puedes cambiar esto por Bindings si prefieres)
  //final LoginController controller = Get.put(LoginController());

  // <-- Form key local al widget (cada instancia tiene su propia key)
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget logo(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.9;
    double height = MediaQuery.of(context).size.width * 0.6;
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE7E8E7),
        borderRadius: BorderRadius.circular(10),
      ),
      width: width,
      height: height,
      alignment: Alignment.center,
      child: Container(
        height: height - 10,
        width: width * 0.6,
        decoration: BoxDecoration(
          color: const Color(0xFFFCFDFD),
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              spreadRadius: 0,
              offset: const Offset(8, 0),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Image.asset(
          'assets/images/logo.png',
          height: height - 50,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget textLabel(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget loginArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textLabel('Usuario'),
        buildTextFormField(
          //controller: controller.emailController,
          labelText: 'Ingrese su nombre de usuario',
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ingrese su nombre de usuario';
            }
            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
              return 'Ingrese un usuario válido';
            }
            return null;
          },
        ),
        const SizedBox(height: 5),
        textLabel("Contraseña"),
        buildTextFormField(
          //controller: controller.passwordController,
          labelText: '***************',
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ingrese su contraseña';
            }
            if (value.length < 6) {
              return 'La contraseña debe tener al menos 6 caracteres';
            }
            return null;
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                logo(context),
                const SizedBox(height: 12),
                const Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 10),
                  child: Text(
                    'Bienvenido',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                loginArea(),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: Obx(
                    () => IconButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () => controller.login(_formKey), // <-- paso la key

                      icon: controller.isLoading.value
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Iniciar sesión',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 36),
                GestureDetector(
                  onTap: () => Get.toNamed('/register'),
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      "¿No tienes cuenta? Regístrate",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppTheme.inputTextColor,
                        fontSize: 14,
                      ),
                    ),
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
