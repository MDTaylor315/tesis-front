import 'package:flutter/material.dart';

class AppTheme {
  // Existing color definitions (retained as-is)
  static const Color primaryColor =
      Color(0xFF033460); // Dark blue for main elements
  static const Color secondaryColor =
      Color(0xFF033460); // Same as primary, for consistency
  static const Color lightOrange = Color(0xFFF7A83C); // Light orange accent
  static const Color darkOrange =
      Color(0xFFE58226); // Darker orange for highlights
  static const Color lightRed =
      Color(0xFFE01800); // Bright red for errors/warnings
  static const Color darkRed = Color(0xFF592B00); // Muted red variant
  static const Color inputTextColor =
      Color(0xFF033460); // Subtle green-gray for inputs
  static const Color red = Color(0xFFFA5438); // Standard red for accents
  static const Color greyBorder = Color(0xFFD6DEE5);
  static const Color unselected = Color(0xFFF5F7F9);

  // Light theme definition (based on the image's UI: white background, blue buttons, orange logos)
  static ThemeData get lightTheme {
    return ThemeData(
      // Primary and secondary colors
      primaryColor: primaryColor,
      primaryColorLight: secondaryColor,
      fontFamily: 'Inter',
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: lightOrange,
        surface: Colors.white, // White background like the login screen
        error: red,
        onPrimary: Colors.white, // White text on primary blue buttons
        onSecondary: Colors.white, // White text on orange elements
        onSurface: Colors.black87, // Dark text on white surfaces
      ),

      // App bar and navigation
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0, // Flat design like the image
      ),

      // Buttons (e.g., "Ingresar" button in blue)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      // Outlined buttons (e.g., social login buttons)
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: BorderSide(color: greyBorder, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          minimumSize:
              const Size(40, 40), // 40 es una altura estándar para botones
          padding: EdgeInsets.zero,
        ),
      ),

      // Text fields (e.g., email and password inputs with subtle borders)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide:
              BorderSide(color: inputTextColor.withOpacity(0.3), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide:
              BorderSide(color: inputTextColor.withOpacity(0.3), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        labelStyle: TextStyle(color: Colors.grey),
        hintStyle: TextStyle(color: inputTextColor.withOpacity(0.7)),
      ),

      // Text themes (clean, readable fonts like in the image)
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: primaryColor),
        headlineMedium: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
        bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
        bodyMedium: TextStyle(fontSize: 14, color: inputTextColor),
        labelLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white), // For button labels
      ),

      // Card and container styles (for form sections)
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 2,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        margin: const EdgeInsets.all(16),
      ),

      // Icon themes (e.g., for eye icon in password field or social buttons)
      iconTheme: IconThemeData(color: inputTextColor, size: 20),
      splashFactory: InkSplash.splashFactory, // Standard splash effects

      // Use Material 3 design for modern look matching the image

      // Scaffold background (white like the login screen)
      scaffoldBackgroundColor: Colors.white,
    );
  }

  // Optional: Dark theme stub (can be expanded later if needed)
  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      primaryColor: primaryColor,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: darkOrange,
        surface: Color(0xFF121212), // Dark background
      ),
    );
  }
}
