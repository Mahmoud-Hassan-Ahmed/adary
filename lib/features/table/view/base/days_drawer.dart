import 'package:adary/features/table/view/screen/dashboard/widget/diagonal_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/calender_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/style.dart';

class Days extends StatelessWidget {
  /// Used only for font-size scaling — layout uses Expanded so no cell can overflow.
  final double cellHeight;

  const Days({
    this.cellHeight = 95.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CalednerController>(builder: (ctrl) {
      return Column(
        children: List.generate(ctrl.workDaysList.length + 1, (index) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
              child: index == 0
                  // ── Diagonal header — scales to whatever Expanded gives ──
                  ? const FittedBox(
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                      child: DiagonalBox(
                          topText: "الحصة", bottomText: "اليوم"),
                    )
                  // ── Day row ─────────────────────────────────────────────
                  : Container(
                      width: 120,
                      decoration: BoxDecoration(
                        color: ctrl.todayIndex == index - 1
                            ? AppColors.SECONDERYCOLOR
                            : null,
                        borderRadius: BorderRadius.circular(13),
                        border:
                            Border.all(color: AppColors.SECONDERYCOLOR),
                      ),
                      child: Center(
                        child: Text(
                          ctrl.workDaysList[index - 1].day.toString(),
                          style: AlMaraiaBold.copyWith(
                            fontSize: (cellHeight * 0.20).clamp(9, 18),
                            color: ctrl.todayIndex == index - 1
                                ? AppColors.MAINCOLOR
                                : AppColors.SECONDERYCOLOR,
                          ),
                        ),
                      ),
                    ),
            ),
          );
        }),
      );
    });
  }
}
