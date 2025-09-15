import 'package:adary/features/table/controller/calender_controller.dart';
import 'package:adary/features/table/controller/waiting_controller.dart';
import 'package:adary/features/table/view/base/app_main_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart' as easy;

import '../../utils/app_colors.dart';
import '../../utils/style.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  @override
  void initState() {
    super.initState();
    Get.find<CalednerController>().getWorkDays(reload: false);
  }

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;

    return GetBuilder<CalednerController>(builder: (calednerController) {
      return calednerController.isLoadingWorkDays
          ? _daysLoader(orientation)
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                  width: context.width / 0.5,
                  height: 160,
                  child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 0.0,
                        crossAxisCount: 1,
                        mainAxisExtent: 79,
                      ),
                      itemCount: calednerController.workDaysList.length,
                      itemBuilder: (context, index) {
                        return UnconstrainedBox(
                          child: _calendarBox(
                              daytitle: calednerController
                                  .workDaysList[index].day
                                  .toString(),
                              //TODO: DateChange
                              day: calednerController
                                  .workDaysList[index].dateGregorian!
                                  .substring(8)
                                  .toString(),
                              isToday: calednerController
                                  .workDaysList[index].currentDay!,
                              func: () => calednerController.toggleSelectedDay(
                                  index: calednerController
                                      .workDaysList[index].dayNum!),
                              dayNum: calednerController
                                  .workDaysList[index].dayNum!,
                              isSelected: calednerController.selectedDayIndex ==
                                  calednerController.workDaysList[index].dayNum,
                              orientation: orientation),
                        );
                      })),
            );
    });
  }

  Widget _daysLoader(orientation) {
    return AppLoader(
        loaderView: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _calendarBox(
                daytitle: "",
                dayNum: 25,
                isToday: false,
                isSelected: false,
                day: "",
                func: () =>
                    Get.find<WaitingController>().toggleSelectedDay(index: 25),
                orientation: orientation),
            _calendarBox(
                daytitle: "",
                dayNum: 25,
                isToday: false,
                isSelected: false,
                day: "",
                func: () =>
                    Get.find<WaitingController>().toggleSelectedDay(index: 25),
                orientation: orientation),
            _calendarBox(
                daytitle: "",
                dayNum: 25,
                isToday: false,
                isSelected: false,
                day: "",
                func: () =>
                    Get.find<WaitingController>().toggleSelectedDay(index: 25),
                orientation: orientation),
            _calendarBox(
                daytitle: "",
                dayNum: 25,
                isToday: false,
                isSelected: false,
                day: "",
                func: () =>
                    Get.find<WaitingController>().toggleSelectedDay(index: 25),
                orientation: orientation),
            _calendarBox(
                daytitle: "",
                dayNum: 25,
                isToday: false,
                isSelected: false,
                day: "",
                func: () =>
                    Get.find<WaitingController>().toggleSelectedDay(index: 25),
                orientation: orientation),
          ],
        ),
      ),
    ));
  }

  Widget _calendarBox(
      {required bool isToday,
      required String day,
      required int dayNum,
      required String daytitle,
      required bool isSelected,
      required Function func,
      required Orientation orientation}) {
    return GestureDetector(
      onTap: () => func(),
      child: SizedBox(
        height: 160,
        width: 70,
        child: Stack(
          children: [
            isToday
                ? Positioned(
                    top: 55,
                    left: 1,
                    right: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFCECACA)),
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(18),
                            bottomRight: Radius.circular(18)),
                        color: const Color(0xFFF3056C),
                      ),
                      height: orientation == Orientation.portrait
                          ? MediaQuery.of(Get.context!).size.height / 13
                          : MediaQuery.of(Get.context!).size.height / 6,
                      width: MediaQuery.of(Get.context!).size.width / 6.3,
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            easy.tr("today"),
                            style: AlMaraiaBold.copyWith(
                                fontSize: 18, color: AppColors.MAINCOLOR),
                          ),
                        ],
                      )),
                    ),
                  )
                : const SizedBox.shrink(),
            Positioned(
              top: 1,
              left: 0,
              right: 0,
              child: Container(
                height: 76,
                width: 68,
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFCECACA)),
                    borderRadius: BorderRadius.circular(18),
                    color: isSelected
                        ? AppColors.SECONDERYCOLOR
                        : const Color(0xFFCFE9EB)),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "$day",
                        style: AlMaraiaBold.copyWith(
                            color: isSelected
                                ? AppColors.MAINCOLOR
                                : const Color(0xFF4B4949),
                            fontSize: 24),
                      ),
                      SizedBox(
                        width: 60,
                        child: Center(
                          child: Text(
                            "$daytitle",
                            style: AlMaraia.copyWith(
                                fontSize: 14,
                                overflow: TextOverflow.ellipsis,
                                color: isSelected
                                    ? AppColors.MAINCOLOR
                                    : AppColors.FONTCOLOR),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
