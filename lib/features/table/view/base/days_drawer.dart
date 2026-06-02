import 'package:adary/features/table/view/screen/dashboard/widget/diagonal_box.dart';
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
          itemCount: calednerController.workDaysList.length + 1,
          controller: controller,
          itemBuilder: (_, index) {
            return index == 0
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3, vertical: 2.3),
                    child: DiagonalBox(
                      topText: "الحصة",
                      bottomText: "اليوم",
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3, vertical: 2.3),
                    child: Container(
                      width: 120,
                      height: 95,
                      decoration: BoxDecoration(
                          color: Get.find<CalednerController>().todayIndex ==
                                  index - 1
                              ? AppColors.SECONDERYCOLOR
                              : null,
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(color: AppColors.SECONDERYCOLOR)),
                      child: Center(
                          child: Text(
                        calednerController.workDaysList[index - 1].day
                            .toString(),
                        style: AlMaraiaBold.copyWith(
                            fontSize: 18,
                            color: Get.find<CalednerController>().todayIndex ==
                                    index - 1
                                ? AppColors.MAINCOLOR
                                : AppColors.SECONDERYCOLOR),
                      )),
                    ));
          },
        ),
      );
    }); // end of days
  }
}
