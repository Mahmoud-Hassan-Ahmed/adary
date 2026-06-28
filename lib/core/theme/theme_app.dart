import 'package:adary/core/conts/app_colors.dart';
import 'package:flutter/material.dart';

class ThemeApp {
  static final lightTheme = ThemeData(
    fontFamily: 'BahijTheSansArabic',
    primaryColor: const Color(0xFFEF7822),
    secondaryHeaderColor: const Color(0xFF000743),
    disabledColor: const Color(0xFFA0A4A8),
    brightness: Brightness.light,
    hintColor: const Color(0xFF9F9F9F),
    cardColor: Colors.white,
    colorScheme: const ColorScheme.light(
        primary: Color(0xFFEF7822), secondary: Color(0xFFEF7822)),
    scaffoldBackgroundColor: Colors.white,
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      backgroundColor: Colors.orange,
      textStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15,          // buttonText → 15sp
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    )),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
          textStyle: const TextStyle(
        fontSize: 14,           // secondary → 14sp
        fontWeight: FontWeight.w600,
        color: Colors.grey,
      )),
    ),
    cardTheme: CardThemeData(
      color: Colors.grey.shade100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Colors.grey, width: 2),
      ),
      elevation: 4,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: InputBorder.none,
      contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
    ),
    textTheme: const TextTheme(
      // ── Display / Hero ───────────────────────────────────────────────────
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, height: 1.3),
      displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, height: 1.3),
      displaySmall: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, height: 1.3),

      // ── Headlines ────────────────────────────────────────────────────────
      headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, height: 1.3),
      headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, height: 1.4),
      headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, height: 1.4),

      // ── Titles ───────────────────────────────────────────────────────────
      titleLarge: TextStyle(                 // section / card title
        color: AppColors.BACKGROUNDGREYCOLOR,
        fontSize: 18,
        fontWeight: FontWeight.w700,
        height: 1.4,
      ),
      titleMedium: TextStyle(               // body text
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: Colors.black,
        height: 1.5,
      ),
      titleSmall: TextStyle(                // secondary text
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Colors.grey,
        height: 1.5,
      ),

      // ── Body ─────────────────────────────────────────────────────────────
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, height: 1.6),
      bodyMedium: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, height: 1.6),
      bodySmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 1.5),

      // ── Labels ───────────────────────────────────────────────────────────
      labelLarge: TextStyle(                // list item primary
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.w500,
        height: 1.4,
      ),
      labelMedium: TextStyle(              // list item body
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.4,
      ),
      labelSmall: TextStyle(               // captions / secondary labels
        color: Colors.grey,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.3,
      ),
    ),
  );

  static final darkTheme = ThemeData();
}
