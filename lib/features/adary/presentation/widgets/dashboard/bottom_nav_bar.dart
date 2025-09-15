import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/conts/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class BottomNavItem extends StatelessWidget {
  final String? iconPath;
  final Function onTap;
  final bool isSelected;
  final String pageName;
  BottomNavItem(
      {required this.iconPath,
      required this.onTap,
      this.isSelected = false,
      required this.pageName});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: iconPath != null ? 85 : 50,
      width: context.width / 4.2,
      child: IconButton(
        icon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (iconPath != null)
              IconButton(
                icon: SvgPicture.asset(
                  iconPath!,
                  color: isSelected
                      ? AppColors.FONTCOLOR
                      : AppColors.SECONDERYCOLOR,
                  width: 25,
                  height: 25,
                ),
                onPressed: () => onTap(),
              ),
            Text(
              pageName,
              overflow: TextOverflow.ellipsis,
              style: AbhayaLibre.copyWith(
                  color: isSelected
                      ? AppColors.FONTCOLOR
                      : AppColors.SECONDERYCOLOR,
                  fontSize: 15),
            ),
          ],
        ),
        onPressed: () => onTap(),
      ),
    );
  }
}
