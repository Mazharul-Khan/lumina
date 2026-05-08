import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryLight = Color.fromARGB(255, 9, 23, 219);
  static const Color primaryDark = Color(0xFFBB86FC);
  static const Color backgroundLight = Color.fromARGB(
    255,
    238,
    247,
    255,
  ); // Slightly off-white
  static const Color backgroundDark = Color.fromARGB(255, 22, 17, 38);
  static const Color cardLight = Color.fromARGB(255, 236, 236, 236);
  static const Color cardDark = Color.fromARGB(255, 47, 33, 46);

  // Gradient for AI/Fancy stuff
  static const LinearGradient aiGradient = LinearGradient(
    colors: [Color(0xFF4A148C), Color(0xFF1565C0), Color(0xFFEAF2FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryLight,
      scaffoldBackgroundColor: backgroundLight,
      colorScheme: ColorScheme.light(
        primary: primaryLight,
        secondary: primaryLight,
        surface: backgroundLight,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundLight,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black87),
        titleTextStyle: TextStyle(
          color: Colors.black87,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardLight,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryLight,
        foregroundColor: Colors.white,
      ),
      useMaterial3: true,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryDark,
      scaffoldBackgroundColor: backgroundDark,
      colorScheme: ColorScheme.dark(
        primary: primaryDark,
        secondary: primaryDark,
        surface: backgroundDark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundDark,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardDark,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryDark,
        foregroundColor: Colors.black,
      ),
      useMaterial3: true,
    );
  }
}
