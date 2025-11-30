import 'package:adary/features/table/view/base/days_drawer.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/calender_controller.dart';
import '../../controller/teacher_page_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/style.dart';

class AppTable extends StatelessWidget {
  Map<String, dynamic> table;
  bool isInstructor;
  AppTable({super.key, required this.table, required this.isInstructor});

  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    print(table);
    var orientation = MediaQuery.of(context).orientation;
    return SizedBox(
        height: orientation == Orientation.portrait
            ? context.height / 1.2
            : context.height * 2,
        width: context.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                height: orientation == Orientation.portrait
                    ? context.height / 1.39
                    : context.height * 2,
                width: 140,
                child: Column(
                  children: [
                    SizedBox(
                      height: orientation == Orientation.portrait ? 0 : 40,
                    ),
                    Expanded(child: Days(controller: controller)),
                  ],
                )),
            // end of days
            SizedBox(
                width: context.width - 140,
                height: orientation == Orientation.portrait
                    ? context.height / 1.1
                    : context.height * 2 + 50,
                child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: Get.find<TeacherPageController>()
                        .classesNamesAndNumbers
                        .length,
                    controller: controller,
                    separatorBuilder: (_, __) => const SizedBox(width: 0.1),
                    itemBuilder: (context, day) {
                      return Row(
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height: 50,
                                width: 100,
                                child: Center(
                                  child: Text(
                                    Get.find<TeacherPageController>()
                                        .classesNamesAndNumbers[day]
                                        .toString(),
                                    style: AlMaraia.copyWith(
                                        fontSize: 18,
                                        color: AppColors.FONTCOLOR
                                            .withOpacity(0.7)),
                                  ),
                                ),
                              ),
                              // end of session name
                              SizedBox(
                                width: 180,
                                height: orientation == Orientation.portrait
                                    ? context.height / 1.33
                                    : context.height * 2,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    controller: controller,
                                    scrollDirection: Axis.vertical,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: Get.find<CalednerController>()
                                        .workDaysList
                                        .length,
                                    itemBuilder: ((context, index) {
                                      return Container(
                                          width: 120,
                                          height: 100,
                                          color: Get.find<CalednerController>()
                                                      .todayIndex ==
                                                  index
                                              ? AppColors.TABLEBACKGROUNDCOLOR
                                              : null,
                                          child: DottedBorder(
                                              borderType: BorderType.RRect,
                                              dashPattern: const [7, 6],
                                              color: Colors.black,
                                              strokeWidth: 1,
                                              padding: const EdgeInsets.all(6),
                                              child: Center(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      isInstructor
                                                          ? table["table"]["$index"]
                                                                          [
                                                                          "${day + 1}"]
                                                                      [
                                                                      "cell_text"]
                                                                  [0]
                                                              .toString()
                                                          : table["table"][
                                                                          "$index"]
                                                                      [
                                                                      "${day + 1}"]
                                                                  ["cell_text"]
                                                              .toString(),
                                                      style: AlMaraia.copyWith(
                                                          fontSize: 17),
                                                    ),
                                                    if (table["table"]["$index"]
                                                                    [
                                                                    "${day + 1}"]
                                                                ["cell_ids"] ==
                                                            null ||
                                                        table["table"]["$index"]
                                                                        [
                                                                        "${day + 1}"]
                                                                    ["cell_ids"]
                                                                .length >
                                                            0)
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            table["table"]["$index"]
                                                                        [
                                                                        "${day + 1}"]
                                                                    [
                                                                    "start_time"]
                                                                .toString(),
                                                          ),
                                                          const SizedBox(
                                                              width:
                                                                  8), // space between times
                                                          const Text('-'),
                                                          const SizedBox(
                                                              width: 8),
                                                          Text(
                                                            table["table"]["$index"]
                                                                        [
                                                                        "${day + 1}"]
                                                                    ["end_time"]
                                                                .toString(),
                                                          ),
                                                        ],
                                                      )
                                                  ],
                                                ),
                                              )));
                                    })),
                              )
                            ],
                          )
                        ],
                      );
                    }))

            // end of table sessions
          ],
        ));
  }
}
