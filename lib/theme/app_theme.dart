import 'package:flutter/material.dart';

class AppTheme {
  // Paleta Cyber-Vibrant
  static const Color bgDark = Color(0xFF0F0C20);
  static const Color cardDark = Color(0xFF1E193B);
  static const Color neonPink = Color(0xFFFF2A85);
  static const Color neonCyan = Color(0xFF00F0FF);
  static const Color neonPurple = Color(0xFF7B2CBF);
  static const Color electricYellow = Color(0xFFFFBE0B);

  static const LinearGradient mainGradient = LinearGradient(
    colors: [neonPink, neonPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cyanGradient = LinearGradient(
    colors: [neonCyan, Color(0xFF0077FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData get vibrantTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bgDark,
      primaryColor: neonPink,
      fontFamily: 'Roboto',
      colorScheme: const ColorScheme.dark(
        primary: neonPink,
        secondary: neonCyan,
        surface: cardDark,
      ),
      useMaterial3: true,
    );
  }
}