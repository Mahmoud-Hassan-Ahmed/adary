import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/conts/style.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/presentation/widgets/send/custom_Box.dart';
import 'package:adary/features/adary/presentation/widgets/send/instructor.dart';
import 'package:adary/features/adary/presentation/widgets/send/parent.dart';
import 'package:adary/features/adary/presentation/widgets/send/student.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SendScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Text("ارسال الى",
                    style: AbhayaLibre.copyWith(
                        color: AppColors.FONTCOLOR,
                        fontWeight: FontWeight.bold,
                        fontSize: 18))
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          const Divider(
            height: 1,
          ),
          SizedBox(
            height: 15,
          ),
          GestureDetector(
              onTap: () {
                AppUtils.go(Instructor());
              },
              child: CustomBox(title: "instructors")),
          SizedBox(
            height: 15,
          ),
          const Divider(
            height: 1,
          ),
          SizedBox(
            height: 15,
          ),
          GestureDetector(
              onTap: () => AppUtils.go(Student()),
              child: CustomBox(title: "students")),
          SizedBox(
            height: 15,
          ),
          const Divider(
            height: 1,
          ),
          SizedBox(
            height: 15,
          ),
          GestureDetector(
              onTap: () => AppUtils.go(Parent()),
              child: CustomBox(title: "parents")),
          SizedBox(
            height: 15,
          ),
          const Divider(
            height: 1,
          ),
          SizedBox(
            height: 15,
          ),
        ],
      )),
    );
  }
}
