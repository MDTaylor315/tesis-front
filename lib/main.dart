import 'package:adipix/routes/routes.dart';
import 'package:adipix/theme/app_theme.dart';
import 'package:adipix/views/main/app_shell.dart';
import 'package:adipix/views/main/home_screen.dart';
import 'package:adipix/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adipix App',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // Soporte para inglés (default)
        Locale(
            'es', 'ES'), // Soporte para español (requerido por showDatePicker)
      ],

      theme: AppTheme.lightTheme,
      //initialRoute: '/home',
      home: AppShell(),
      // 2. Conecta tu función de gestión de rutas personalizada
      onGenerateRoute: generateRoute,
      // ⭐ Establece tu SplashScreen como la vista inicial
    );
  }
}
