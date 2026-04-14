import 'package:flutter/material.dart';

class AppTheme {
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFFE50914), // Netflix Red
    scaffoldBackgroundColor: const Color(0xFF000000), // Noir Black
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFE50914),
      secondary: Color(0xFFFFFFFF),
      surface: Color(0xFF141414),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.white70),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      backgroundColor: Colors.transparent,
      selectedItemColor: Color(0xFFE50914),
      unselectedItemColor: Colors.white54,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
      unselectedLabelStyle: TextStyle(fontSize: 10),
      selectedIconTheme: IconThemeData(size: 20),
      unselectedIconTheme: IconThemeData(size: 20),
    ),
  );
}
