import 'package:flutter/material.dart';

ThemeData buildAppTheme() {
  const seed = Colors.deepOrange;
  return ThemeData(
    colorSchemeSeed: seed,
    useMaterial3: true,
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
      backgroundColor: seed,
      foregroundColor: Colors.white,
      elevation: 4,
      centerTitle: true,
    ),
    scaffoldBackgroundColor: const Color(0xFFF6F8FB),
    // Perubahan: gunakan CardThemeData sesuai API Flutter 3.35.5
    cardTheme: const CardThemeData(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
      ),
      margin: EdgeInsets.zero,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
      bodyLarge: TextStyle(fontSize: 16),
      bodyMedium: TextStyle(fontSize: 14),
    ),
  );
}
