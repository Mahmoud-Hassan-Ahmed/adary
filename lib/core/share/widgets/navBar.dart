import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/conts/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart' as easy;

class AppNavBar extends StatelessWidget {
  final String imagePath;
  final String headerTxt;
  final bool hasImg = false;

  const AppNavBar(
      {super.key,
      required this.imagePath,
      required this.headerTxt,
      bool hasImg = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
                onTap: () => Get.back(),
                child: Image.asset(
                  imagePath,
                  width: 35,
                  height: 35,
                )),
            const SizedBox(
              width: 10,
            ),
            Text(
              easy.tr(headerTxt),
              style: AbhayaLibreExtraBold.copyWith(
                  fontSize: 20, color: AppColors.GREYFONTCOLOR),
            )
          ],
        ),
        const SizedBox(
          height: 17.5,
        ),
        Container(
          width: context.width,
          color: Colors.grey.withOpacity(0.3),
          height: 1.5,
        ),
      ]),
    );
  }
}
