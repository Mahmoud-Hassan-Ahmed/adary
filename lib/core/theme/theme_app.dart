import 'package:adary/core/conts/app_colors.dart';
import 'package:flutter/material.dart';

class ThemeApp {
  static final lightTheme = ThemeData(
    fontFamily: 'PingARLT',
    primaryColor: const Color(0xFFEF7822),
    secondaryHeaderColor: const Color(0xFF000743),
    disabledColor: const Color(0xFFA0A4A8),
    brightness: Brightness.light,
    hintColor: const Color(0xFF9F9F9F),
    cardColor: Colors.white,
    colorScheme: const ColorScheme.light(
        primary: Color(0xFFEF7822), secondary: Color(0xFFEF7822)),
    // textButtonTheme: TextButtonThemeData(
    //     style: TextButton.styleFrom(foregroundColor: const Color(0xFFEF7822))),
    scaffoldBackgroundColor: Colors.white,
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      backgroundColor: Colors.orange,
      textStyle: const TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    )),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
          textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.grey,
      )),
    ),
    cardTheme: CardTheme(
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
        titleLarge: TextStyle(
          color: AppColors.BACKGROUNDGREYCOLOR,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        titleSmall: TextStyle(fontSize: 15, color: Colors.grey),
        displayMedium: TextStyle(
            color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 17),
        labelMedium: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        titleMedium: TextStyle(fontSize: 15, color: Colors.black)),
  );
  static final darkTheme = ThemeData();
}
