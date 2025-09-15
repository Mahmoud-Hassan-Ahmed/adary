import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

ThemeData lightTheme = ThemeData(
  primaryColor: AppColors.MAINCOLOR,
  disabledColor: Color(0xFFA0A4A8),
  brightness: Brightness.light,
  hintColor: Color(0xFF9F9F9F),
  cardColor: AppColors.BACKGROUNDGREYCOLOR.withOpacity(0.2),
);
