import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  fontFamily: 'PingARLT',
  primaryColor: const Color(0xFFEF7822),
  secondaryHeaderColor: const Color(0xFF000743),
  disabledColor: const Color(0xFFA0A4A8),
  brightness: Brightness.light,
  hintColor: const Color(0xFF9F9F9F),
  cardColor: Colors.white,
  colorScheme: const ColorScheme.light(
      primary: Color(0xFFEF7822), secondary: Color(0xFFEF7822)),
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: const Color(0xFFEF7822))),
);
