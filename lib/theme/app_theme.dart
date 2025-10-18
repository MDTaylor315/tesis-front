import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF141F17);
  static const Color secondaryColor = Color(0xFF1F2E21);
  static const Color borderButtonColor = Color(0xFF3D5C42);
  static const Color secondaryLabel = Color(0xFF9CBFAB);
  static const Color categoryLabel = Color(0xFF96C4A8);
  static const Color buttonColor = Color(0xFF78D187);
  static const Color inputTextColor = Color(0xFF9EBFA3);
  static const Color red = Color(0xFFFA5438);

  static ThemeData get theme {
    // Definimos un TextStyle base para Manrope para facilitar el .copyWith()
    const TextStyle manropeBase = TextStyle(fontFamily: 'Manrope');
    const TextStyle splineSansBase = TextStyle(fontFamily: 'SplineSans');

    return ThemeData(
      primaryColor: secondaryColor,
      scaffoldBackgroundColor: primaryColor,
      
      // Aplicamos el TextTheme, usando el TextStyle base con el fontFamily.
      // Los pesos de fuente (fontWeight) se mapearán a los archivos .ttf que declaraste.
      textTheme: TextTheme(
        // DISPLAY (Usando SplineSans)
        displayLarge: splineSansBase.copyWith(
            fontWeight: FontWeight.w700, // o FontWeight.bold
            color: Colors.white,
            fontSize: 18), 
        displayMedium: splineSansBase.copyWith(
            fontWeight: FontWeight.w500, // Medium
            color: Colors.white,
            fontSize: 16), 
        displaySmall: manropeBase.copyWith(
            fontWeight: FontWeight.w600, // Semi Bold
            color: Colors.white),

        // HEADLINE (Usando Manrope)
        headlineLarge: manropeBase.copyWith(
            fontWeight: FontWeight.w700, color: Colors.white, fontSize: 18), // Bold
        headlineMedium: manropeBase.copyWith(fontWeight: FontWeight.w600), // Semi Bold
        headlineSmall: manropeBase.copyWith(fontWeight: FontWeight.w500), // Medium

        // TITLE (Usando Manrope)
        titleLarge: manropeBase.copyWith(fontWeight: FontWeight.w700), // Bold
        titleMedium: manropeBase.copyWith(fontWeight: FontWeight.w600), // Semi Bold
        titleSmall: manropeBase.copyWith(fontWeight: FontWeight.w500), // Medium

        // BODY (Usando SplineSans y Manrope)
        bodyLarge: splineSansBase.copyWith(
            fontWeight: FontWeight.w800, color: Colors.white, fontSize: 32), // Extra Bold (Si SplineSans lo tiene)
        bodyMedium:
            splineSansBase.copyWith(fontWeight: FontWeight.w400), // Regular
        bodySmall: manropeBase.copyWith(fontWeight: FontWeight.w300), // Light

        // LABEL (Usando Manrope y SplineSans)
        labelLarge: manropeBase.copyWith(fontWeight: FontWeight.w600), // Semi Bold
        labelMedium: splineSansBase.copyWith(
            fontWeight: FontWeight.w500, color: Colors.white), // Medium
        labelSmall: splineSansBase.copyWith(
            fontWeight: FontWeight.w500, color: AppTheme.secondaryLabel), // Medium
      ),
      
      // --- Resto del Tema ---
      
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: secondaryColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: const Color(0xFF96C4A8),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      colorScheme: ColorScheme.fromSeed(seedColor: inputTextColor),
      useMaterial3: true,
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          backgroundColor: buttonColor, // Fondo de botón
          foregroundColor: primaryColor, // Texto/ícono
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: secondaryColor,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelStyle: TextStyle(
          color: inputTextColor,
          fontSize: 14,
          fontFamily: 'Manrope', // Opcional: para el label del input
        ),
        hintStyle: const TextStyle(
          color: inputTextColor,
          fontSize: 13,
          fontStyle: FontStyle.italic,
          fontFamily: 'Manrope', // Opcional: para el hint del input
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderButtonColor, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderButtonColor, width: 0.5),
        ),
      ),
    );
  }
}