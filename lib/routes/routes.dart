import 'package:adipix/views/auth/auth_shell_screen.dart';
import 'package:adipix/views/auth/forget_password/email_screen.dart';
import 'package:adipix/views/main/app_shell.dart';
import 'package:adipix/views/main/home_screen.dart';
import 'package:adipix/views/onboarding/onboarding_screen.dart';
import 'package:adipix/views/splash_screen.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  debugPrint('generateRoute -> ${settings.name}');
  switch (settings.name) {
    case '/':
      return createFadeRoute(SplashScreen());
    case '/auth':
      return createFadeRoute(AuthShell());
    case '/forget_password':
      return createFadeRoute(ForgotPasswordScreen());
    case '/onboarding':
      return createFadeRoute(OnboardingScreen());
    case '/app_shell':
      return createFadeRoute(AppShell());
    default:
      return createFadeRoute(AuthShell());
  }
}

Route createFadeRoute(Widget page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 500),
    reverseTransitionDuration: const Duration(milliseconds: 800),
    pageBuilder: (context, animation, secondaryAnimation) => FadeIn(
      duration: const Duration(milliseconds: 800),
      child: page, // Quita el Container aquí
    ),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return Container(
        // Agrega Container aquí para fondo blanco en la transición
        color: Colors.white, // Fondo blanco para toda la transición
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      );
    },
  );
}
