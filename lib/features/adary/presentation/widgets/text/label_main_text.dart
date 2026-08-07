import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/conts/app_text_styles.dart';
import 'package:flutter/material.dart';

class LabelMainText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Color? color;
  final bool bold;
  final bool textunderline;
  final int? maxLines;

  const LabelMainText({
    Key? key,
    required this.text,
    this.fontSize,
    this.bold = false,
    this.textunderline = false,
    this.color,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.right,
      maxLines: maxLines,
      overflow: maxLines == null ? null : TextOverflow.ellipsis,
      style: TextStyle(
        fontFamily: 'BahijTheSansArabic',
        color: color ?? AppColors.APP_COLOR,
        fontSize: fontSize ?? AppTextStyles.subtitle1,  // 16sp default (was 18)
        fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
        fontStyle: FontStyle.normal,
        decoration: textunderline ? TextDecoration.underline : null,
        letterSpacing: 0,
        height: 1.4,
      ),
    );
  }
}
