import 'package:flutter/material.dart';
import 'package:tesis/features/auth/screens/login_screen.dart';
import 'package:tesis/features/auth/screens/register_screen.dart';
import 'package:tesis/features/main_app/screens/recommendations/recommendations_screen.dart';
import 'package:tesis/features/main_app/screens/recommendations/result_screen.dart';
import 'package:tesis/features/main_app/screens/template.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  debugPrint('generateRoute -> ${settings.name}'); // Verifica la 1ra vez
  switch (settings.name) {
    case '/login':
      return _slideRoute(LoginScreen(), settings);
    case '/register':
      return _slideRoute(const RegisterScreen(), settings);
    case '/home':
      return _slideRoute(const Template(), settings);
    case '/result':
      return _slideRoute(const ResultScreen(), settings);
    /*case '/recommendations':
      return _slideRoute(const RecommendationScreen(), settings);*/
    default:
      return _slideRoute(LoginScreen(), settings);
  }
}

PageRoute _slideRoute(Widget page, RouteSettings settings) {
  return PageRouteBuilder(
    settings: settings, // importante para que quede registrada la ruta
    transitionDuration: const Duration(milliseconds: 500),
    reverseTransitionDuration: const Duration(milliseconds: 500),
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, animation, __, child) {
      final offsetTween = Tween(begin: const Offset(1, 0), end: Offset.zero)
          .chain(CurveTween(curve: Curves.easeInOut));
      final fadeTween =
          Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeOut));
      return SlideTransition(
        position: animation.drive(offsetTween),
        child:
            FadeTransition(opacity: animation.drive(fadeTween), child: child),
      );
    },
  );
}
