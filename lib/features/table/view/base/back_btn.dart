import 'package:adary/core/conts/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class BackBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SvgPicture.asset(
                    Images.CLOSE_ICON,
                    height: 25,
                    width: 25,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
