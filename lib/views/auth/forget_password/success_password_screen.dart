import 'package:adipix/theme/app_theme.dart';
import 'package:adipix/views/auth/auth_shell_screen.dart';
import 'package:flutter/material.dart';

class PasswordSuccessScreen extends StatelessWidget {
  const PasswordSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos MediaQuery para asegurar que el contenido esté centrado verticalmente
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            // Centramos el contenido en el centro de la pantalla
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. Logo
              Image.asset('assets/img/logo_letras.png', height: 60),

              const SizedBox(height: 56),

              // 2. Título de Confirmación
              const Text(
                'Contraseña cambiada',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold, // Asumiendo Poppins/Inter Bold
                  color: AppTheme
                      .secondaryColor, // Asumiendo que es el color azul oscuro
                ),
              ),
              const SizedBox(height: 12),

              // 3. Subtítulo
              const Text(
                'Su contraseña ha sido cambiada\nexitosamente',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 56),

              // 4. Botón "Regresar"
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Acción: Navegar de vuelta a la pantalla de Login
                    // y eliminar todas las rutas anteriores (si viene de un flujo de restablecimiento)
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => AuthShell()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.secondaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Regresar',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              // Espacio extra para que el contenido se vea centrado sin pegarse al fondo
              SizedBox(height: screenHeight * 0.1),
            ],
          ),
        ),
      ),
    );
  }
}
