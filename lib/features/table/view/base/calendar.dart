import 'package:adary/features/table/controller/calender_controller.dart';
import 'package:adary/features/table/controller/waiting_controller.dart';
import 'package:adary/features/table/view/base/app_main_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
          : SizedBox(
              width: context.width / 0.5,
              height: 100,
              child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 0.0,
                    crossAxisCount: 1,
                    mainAxisExtent: 79,
                  ),
                  itemCount: calednerController.workDaysList.length,
                  itemBuilder: (context, index) {
                    return UnconstrainedBox(
                      child: _calendarBox(
                          daytitle: calednerController.workDaysList[index].day
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
                          dayNum:
                              calednerController.workDaysList[index].dayNum!,
                          isSelected: calednerController.selectedDayIndex ==
                              calednerController.workDaysList[index].dayNum,
                          orientation: orientation),
                    );
                  }));
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
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 60,
              child: Center(
                child: Text(
                  "$daytitle",
                  style: AlMaraia.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      overflow: TextOverflow.ellipsis,
                      color: isSelected
                          ? AppColors.SECONDERYCOLOR
                          : AppColors.FONTCOLOR),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "$day",
              style: AlMaraiaBold.copyWith(
                  color: isSelected
                      ? AppColors.SECONDERYCOLOR
                      : const Color(0xFF4B4949),
                  fontSize: 16),
            ),
            const SizedBox(
              height: 10,
            ),
            if (isToday)
              Column(
                children: [SvgPicture.asset("assets/icons/Oval.svg")],
              )
          ],
        ),
      ),
    );
  }
}
