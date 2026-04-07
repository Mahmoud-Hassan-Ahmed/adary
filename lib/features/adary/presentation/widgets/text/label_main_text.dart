import 'package:adary/core/conts/app_colors.dart';
import 'package:flutter/material.dart';

class LabelMainText extends StatelessWidget {
  final String text; // Set text when calling
  final double? fontSize;
  final Color? color;

  const LabelMainText({
    Key? key,
    required this.text, // Required parameter to set text
    this.fontSize,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text, // The text you pass when calling
      textAlign: TextAlign.right,
      style: TextStyle(
        fontFamily: 'BahijTheSansArabic',
        color: this.color ?? AppColors.APP_COLOR,
        fontSize: this.fontSize ?? 25,
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.normal,
        letterSpacing: 0,
        height: 1.0, // 100% line-height
      ),
    );
  }
}
