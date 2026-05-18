import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = true;
  Color _accentColor = const Color(0xFF1DB954); // Spotify Green

  bool get isDarkMode => _isDarkMode;
  Color get accentColor => _accentColor;

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setAccentColor(Color color) {
    _accentColor = color;
    notifyListeners();
  }

  ThemeData getTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: _isDarkMode ? Brightness.dark : Brightness.light,
      primaryColor: _accentColor,
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF121212),
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFFFFFFFF),
        ),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF282828),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF282828),
        hintStyle: const TextStyle(color: Color(0xFF79797D)),
        labelStyle: const TextStyle(color: Color(0xFFB3B3B3)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Color(0xFFFFFFFF),
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Color(0xFFFFFFFF),
        ),
        headlineSmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFFFFFFFF),
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xFFFFFFFF),
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Color(0xFFFFFFFF),
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: Color(0xFFB3B3B3),
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: Color(0xFF79797D),
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: Color(0xFF79797D),
        ),
      ),
      iconTheme: const IconThemeData(
        color: Color(0xFFFFFFFF),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1E1E1E),
        selectedItemColor: Color(0xFF1DB954),
        unselectedItemColor: Color(0xFF79797D),
      ),
    );
  }
}
