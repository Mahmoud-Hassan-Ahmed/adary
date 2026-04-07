import 'package:adary/core/conts/app_colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final double? width; // null = full width, or set specific width
  final double? widthPercentage; // e.g., 0.8 for 80% of screen width
  final double borderRadius;
  final Color backgroundColor;
  final Color textColor;
  final double height;
  final EdgeInsetsGeometry padding;
  final double? fontSize;

  const CustomButton({
    Key? key,
    required this.label,
    this.onPressed,
    this.width,
    this.widthPercentage,
    this.borderRadius = 50,
    this.backgroundColor = AppColors.APP_COLOR,
    this.textColor = Colors.white,
    this.height = 50.0,
    this.fontSize,
    this.padding = const EdgeInsets.symmetric(horizontal: 20.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate final width
    double? finalWidth;
    if (width != null) {
      finalWidth = width;
    } else if (widthPercentage != null) {
      finalWidth = MediaQuery.of(context).size.width * widthPercentage!;
    }
    // If both are null, width will be null (full width)

    return SizedBox(
      width: finalWidth,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: 0, // Remove shadow if needed
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: fontSize ?? 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'BahijTheSansArabic',
          ),
        ),
      ),
    );
  }
}
