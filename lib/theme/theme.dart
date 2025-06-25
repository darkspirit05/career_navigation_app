import 'package:flutter/material.dart';

/// Light Mode Theme — Clean, Calm & Professional
final ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
        background: Color(0xFFF7F8FA),     // Soft gray background
        primary: Color(0xFF5B9EFF),        // Gentle blue primary
        secondary: Color(0xFF7D8B97),      // Muted bluish-gray secondary
        inversePrimary: Color(0xFF1E1E1E), // Dark text color
    ),
    scaffoldBackgroundColor: const Color(0xFFF7F8FA),
    appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Color(0xFFF7F8FA),
        foregroundColor: Color(0xFF1E1E1E),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF5B9EFF),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
    ),
);

/// Dark Mode Theme — Modern, Elegant & Eye-Friendly
final ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
        background: Color(0xFF121212),     // True dark background
        primary: Color(0xFF1E88E5),        // Vivid blue primary
        secondary: Color(0xFF9E9E9E),      // Muted gray secondary
        inversePrimary: Color(0xFFE0E0E0), // Light text color
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Color(0xFF121212),
        foregroundColor: Color(0xFFE0E0E0),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF1E88E5),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
    ),
);
