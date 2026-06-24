import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/conts/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class BottomNavItem extends StatelessWidget {
  final String? iconPath;
  final Function onTap;
  final bool isSelected;
  final String pageName;
  const BottomNavItem(
      {super.key,
      required this.iconPath,
      required this.onTap,
      this.isSelected = false,
      required this.pageName});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 4,
            width: isSelected ? 40 : 0,
            decoration: BoxDecoration(
              color: AppColors.APP_COLOR,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          if (iconPath != null)
            IconButton(
              icon: SvgPicture.asset(
                iconPath!,
                color:
                    isSelected ? AppColors.FONTCOLOR : AppColors.SECONDERYCOLOR,
                width: 25,
                height: 25,
              ),
              onPressed: () => onTap(),
            ),
          Text(
            pageName,
            overflow: TextOverflow.ellipsis,
            style: AbhayaLibre.copyWith(
                color:
                    isSelected ? AppColors.FONTCOLOR : AppColors.SECONDERYCOLOR,
                fontSize: 11.sp),
          ),
        ],
      ),
      onPressed: () => onTap(),
    );
  }
}
