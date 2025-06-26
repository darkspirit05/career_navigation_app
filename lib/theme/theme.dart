import 'package:flutter/material.dart';

final ThemeData lightMode = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF5F7FA), // Soft bluish-white
    colorScheme: const ColorScheme.light(
        background: Color(0xFFF5F7FA),
        primary: Color(0xFF3B82F6),       // Calmer blue
        secondary: Color(0xFF7B8794),     // Neutral slate
        inversePrimary: Color(0xFF1F2937),// Deep text
        surface: Colors.white,
        surfaceVariant: Color(0xFFE4E9F0), // For card glass tint
        outlineVariant: Color(0xFFCAD5E0),
    ),
    appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Color(0xFFF5F7FA),
        foregroundColor: Color(0xFF1F2937),
        centerTitle: true,
        titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
        ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3B82F6),
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            elevation: 6,
        ),
    ),
    cardTheme: CardTheme(
        color: Colors.white.withOpacity(0.72),
        surfaceTintColor: Colors.transparent,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.all(12),
    ),
    textTheme: const TextTheme(
        bodyMedium: TextStyle(fontSize: 16, color: Color(0xFF1F2937)),
        bodyLarge: TextStyle(fontSize: 18, color: Color(0xFF111827)),
        titleMedium: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        labelSmall: TextStyle(fontSize: 13, color: Colors.grey),
        labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
    ),
    chipTheme: ChipThemeData(
        backgroundColor: Colors.white.withOpacity(0.2),
        selectedColor: const Color(0xFF3B82F6).withOpacity(0.2),
        disabledColor: Colors.grey.withOpacity(0.15),
        labelStyle: const TextStyle(fontSize: 14, color: Color(0xFF1F2937)),
        secondaryLabelStyle: const TextStyle(fontSize: 14, color: Colors.white),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: Color(0xFFCAD5E0)),
        ),
    ),
);

final ThemeData darkMode = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF101317),
    colorScheme: const ColorScheme.dark(
        background: Color(0xFF101317),
        surface: Color(0xFF1A1E23),
        surfaceVariant: Color(0xFF2A2F36),
        outlineVariant: Color(0xFF3C434D),
        primary: Color(0xFF3B82F6),
        secondary: Color(0xFF9CA3AF),
        inversePrimary: Color(0xFFF9FAFB),
    ),
    appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Color(0xFF101317),
        foregroundColor: Color(0xFFF9FAFB),
        centerTitle: true,
        titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFFF9FAFB),
        ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3B82F6),
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            elevation: 6,
        ),
    ),
    cardTheme: CardTheme(
        color: const Color(0xFF1A1E23).withOpacity(0.7),
        surfaceTintColor: Colors.transparent,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.all(12),
    ),
    textTheme: const TextTheme(
        bodyMedium: TextStyle(fontSize: 16, color: Color(0xFFF9FAFB)),
        bodyLarge: TextStyle(fontSize: 18, color: Color(0xFFF3F4F6)),
        titleMedium: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        labelSmall: TextStyle(fontSize: 13, color: Colors.grey),
        labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
    ),
    chipTheme: ChipThemeData(
        backgroundColor: Colors.white.withOpacity(0.05),
        selectedColor: const Color(0xFF3B82F6).withOpacity(0.2),
        disabledColor: Colors.grey.withOpacity(0.15),
        labelStyle: const TextStyle(fontSize: 14, color: Colors.white),
        secondaryLabelStyle: const TextStyle(fontSize: 14, color: Colors.white),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: Color(0xFF3C434D)),
        ),
    ),
);
