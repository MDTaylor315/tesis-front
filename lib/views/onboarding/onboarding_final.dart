import 'package:flutter/material.dart';
import 'package:adipix/theme/app_theme.dart'; // Asegúrate de tener tu AppTheme definido
import 'dart:async'; // Para Future.delayed

class OnboardingCompletionScreen extends StatefulWidget {
  final VoidCallback
      onCompletion; // Callback para cuando la pantalla termine su trabajo

  const OnboardingCompletionScreen({super.key, required this.onCompletion});

  @override
  State<OnboardingCompletionScreen> createState() =>
      _OnboardingCompletionScreenState();
}

class _OnboardingCompletionScreenState
    extends State<OnboardingCompletionScreen> {
  @override
  void initState() {
    super.initState();
    _startRedirectionTimer();
  }

  void _startRedirectionTimer() {
    // Simula un proceso de guardado o una espera
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        widget
            .onCompletion(); // Llama al callback para notificar que la tarea está hecha
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo de AdiPix
            Image.asset(
              'assets/img/logo_letras.png', // Reemplaza con la ruta correcta de tu logo
              width: MediaQuery.of(context).size.width * 0.4,
            ),
            const SizedBox(height: 50),

            // Título
            const Text(
              'Datos guardados',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor, // O el color que desees
              ),
            ),
            const SizedBox(height: 10),

            // Subtítulo
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                'En un momento se redirigirá a la vista principal de la aplicación',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 50),

            // Indicador de progreso circular
            const CircularProgressIndicator(
              color: AppTheme.secondaryColor, // Color del indicador
              strokeWidth: 4,
            ),
          ],
        ),
      ),
    );
  }
}
