import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/conts/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BtnApp extends StatelessWidget {
  const BtnApp(
      {super.key,
      required this.label,
      required this.onTap,
      this.padding,
      this.radius,
      this.icon});
  final String label;
  final Function() onTap;
  final double? radius;
  final String? icon;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.APP_COLOR,
        padding: padding ?? const EdgeInsets.all(8),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius ?? 40),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null)
            SvgPicture.asset(
              icon!,
              color: Colors.white,
              height: 20,
              width: 20,
            ),
          const SizedBox(
            width: 4,
          ),
          Text(
            label,
            style: AppTextStyles.buttonText.copyWith(color: Colors.white),  // 15sp bold
          ),
        ],
      ),
    );
  }
}
