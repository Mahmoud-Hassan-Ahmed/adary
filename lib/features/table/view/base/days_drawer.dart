import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/calender_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/style.dart';

class Days extends StatelessWidget {
  final ScrollController controller;
  const Days({
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CalednerController>(builder: (calednerController) {
      return SizedBox(
        width: 120,
        height: 145,
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: calednerController.workDaysList.length,
          controller: controller,
          itemBuilder: (_, index) {
            return Padding(
                padding: EdgeInsets.symmetric(horizontal: 3, vertical: 4),
                child: Container(
                  width: 120,
                  height: 95,
                  decoration: BoxDecoration(
                      color: AppColors.SECONDERYCOLOR,
                      borderRadius: BorderRadius.circular(13)),
                  child: Center(
                      child: Text(
                    calednerController.workDaysList[index].day.toString(),
                    style: AlMaraiaBold.copyWith(
                        fontSize: 18,
                        color:
                            Get.find<CalednerController>().todayIndex == index
                                ? AppColors.MAINCOLOR
                                : AppColors.FONTCOLOR),
                  )),
                ));
          },
        ),
      );
    }); // end of days
  }
}
