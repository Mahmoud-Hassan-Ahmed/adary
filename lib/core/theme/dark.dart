import 'package:adary/core/conts/app_colors.dart';
import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  primaryColor: AppColors.MAINCOLOR,
  disabledColor: const Color(0xFFA0A4A8),
  brightness: Brightness.light,
  hintColor: const Color(0xFF9F9F9F),
  cardColor: AppColors.BACKGROUNDGREYCOLOR.withOpacity(0.2),
);
