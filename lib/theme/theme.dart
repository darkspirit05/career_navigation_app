import 'package:flutter/material.dart';

final ThemeData lightMode = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF3F6FA), // Slightly cooler soft tone
    colorScheme: const ColorScheme.light(
        background: Color(0xFFF3F6FA),
        primary: Color(0xFF2563EB), // Vibrant deep blue
        secondary: Color(0xFF64748B), // Slate gray
        inversePrimary: Color(0xFF111827), // Deep gray-black
        surface: Colors.white,
        surfaceVariant: Color(0xFFE8EDF3),
        outlineVariant: Color(0xFFC3D0DB), // Softer border
    ),
    appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Color(0xFFF3F6FA),
        foregroundColor: Color(0xFF111827),
        centerTitle: true,
        titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF111827),
        ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2563EB),
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            elevation: 6,
        ),
    ),
    cardTheme: CardThemeData(
        color: Colors.white.withOpacity(0.72),
        surfaceTintColor: Colors.transparent,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.all(12),
    ),
    textTheme: const TextTheme(
        bodyMedium: TextStyle(fontSize: 16, color: Color(0xFF1E293B)),
        bodyLarge: TextStyle(fontSize: 18, color: Color(0xFF0F172A)),
        titleMedium: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        labelSmall: TextStyle(fontSize: 13, color: Colors.grey),
        labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
    ),
    chipTheme: ChipThemeData(
        backgroundColor: Colors.white.withOpacity(0.18),
        selectedColor: const Color(0xFF2563EB).withOpacity(0.22),
        disabledColor: Colors.grey.withOpacity(0.12),
        labelStyle: const TextStyle(fontSize: 14, color: Color(0xFF1E293B)),
        secondaryLabelStyle: const TextStyle(fontSize: 14, color: Colors.white),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: Color(0xFFC3D0DB)),
        ),
    ),
);

final ThemeData darkMode = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0E1116),
    colorScheme: const ColorScheme.dark(
        background: Color(0xFF0E1116),
        surface: Color(0xFF1C1F26),
        surfaceVariant: Color(0xFF2A2F36),
        outlineVariant: Color(0xFF3D4451),
        primary: Color(0xFF2563EB),
        secondary: Color(0xFF94A3B8),
        inversePrimary: Color(0xFFF1F5F9),
    ),
    appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Color(0xFF0E1116),
        foregroundColor: Color(0xFFF1F5F9),
        centerTitle: true,
        titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFFF1F5F9),
        ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2563EB),
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            elevation: 6,
        ),
    ),
    cardTheme: CardThemeData(
        color: const Color(0xFF1F242B).withOpacity(0.72),
        surfaceTintColor: Colors.transparent,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.all(12),
    ),
    textTheme: const TextTheme(
        bodyMedium: TextStyle(fontSize: 16, color: Color(0xFFF1F5F9)),
        bodyLarge: TextStyle(fontSize: 18, color: Color(0xFFE2E8F0)),
        titleMedium: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        labelSmall: TextStyle(fontSize: 13, color: Colors.grey),
        labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
    ),
    chipTheme: ChipThemeData(
        backgroundColor: Colors.white.withOpacity(0.06),
        selectedColor: const Color(0xFF2563EB).withOpacity(0.22),
        disabledColor: Colors.grey.withOpacity(0.12),
        labelStyle: const TextStyle(fontSize: 14, color: Colors.white),
        secondaryLabelStyle: const TextStyle(fontSize: 14, color: Colors.white),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: Color(0xFF3D4451)),
        ),
    ),
);
