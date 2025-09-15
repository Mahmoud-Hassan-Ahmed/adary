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
        SizedBox(
          height: 80,
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 42),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SvgPicture.asset(
                        Images.CLOSE_ICON,
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ],
    );
  }
}
