import 'package:adary/features/table/utils/app_colors.dart';
import 'package:adary/features/table/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class BottomNavItem extends StatelessWidget {
  final String iconPath;
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
      height: 90,
      width: context.width / 4.2,
      child: IconButton(
        icon: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              padding: EdgeInsets.all(0),
              icon: SvgPicture.asset(
                iconPath,
                color:
                    isSelected ? AppColors.SECONDERYCOLOR : AppColors.FONTCOLOR,
                width: 25,
                height: 25,
              ),
              onPressed: () => onTap(),
            ),
            Text(
              pageName,
              style: AlMaraiaRegular.copyWith(
                  color: isSelected
                      ? AppColors.SECONDERYCOLOR
                      : AppColors.FONTCOLOR,
                  fontSize: 14),
            ),
          ],
        ),
        onPressed: () => onTap(),
      ),
    );
  }
}
