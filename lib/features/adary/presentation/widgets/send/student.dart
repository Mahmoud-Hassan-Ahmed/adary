import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/conts/style.dart';
import 'package:adary/features/adary/presentation/widgets/send/appBar.dart';
import 'package:adary/features/adary/presentation/widgets/send/custom_Box.dart';
import 'package:adary/features/adary/presentation/widgets/send/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart' as easy;

class Student extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Scaffold(
              body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 15,
          ),
          Appbar(
            title: easy.tr("send_to_students"),
          ),
          SizedBox(
            height: 45,
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                easy.tr("send_to"),
                style: AbhayaLibreBold.copyWith(
                  color: AppColors.FONTCOLOR,
                  fontSize: 17,
                ),
              )),
          const Divider(),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
              onTap: () => Get.to(() => Message(title: "أ. محمد العتيبي"),
                  transition: Transition.cupertino),
              child: CustomBox(
                title: "أ. محمد العتيبي",
              )),
          SizedBox(
            height: 10,
          ),
          const Divider()
        ],
      ))),
    );
  }
}
