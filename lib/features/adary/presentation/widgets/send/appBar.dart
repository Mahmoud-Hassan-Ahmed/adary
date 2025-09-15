import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/conts/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart' as easy;

class Appbar extends StatelessWidget {
  final String title;
  const Appbar({required this.title}) : super();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: Get.back,
      child: Container(
        width: context.width,
        height: 50,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Icon(Icons.arrow_back),
                  SizedBox(
                    width: 16,
                  ),
                  Text(easy.tr(title),
                      style: AbhayaLibreExtraBold.copyWith(
                          color: AppColors.SECONDERYCOLOR, fontSize: 28))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
