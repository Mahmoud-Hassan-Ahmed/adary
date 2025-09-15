import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/conts/images.dart';
import 'package:adary/core/conts/style.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CustomBox extends StatelessWidget {
  final String title;
  CustomBox({required this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title.tr(),
              style: AbhayaLibre.copyWith(
                  color: AppColors.SECONDERYCOLOR, fontSize: 18)),
          SizedBox(height: 21, child: SvgPicture.asset(Images.FORWARD_ARROW))
        ],
      ),
    );
  }
}
