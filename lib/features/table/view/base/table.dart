import 'package:adary/features/table/data/model/response/waiting_list.dart';
import 'package:adary/features/table/view/base/days_drawer.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/calender_controller.dart';
import '../../controller/teacher_page_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/style.dart';

const Color _waitingCellBg = Color(0xFFFFF8EE);
const Color _waitingBorderColor = Color(0xFFF57C00);

class AppTable extends StatelessWidget {
  final Map<String, dynamic> table;
  final bool isInstructor;
  final bool showTime;
  final List<waitingListModel>? waitingList;

  AppTable({
    super.key,
    required this.table,
    required this.isInstructor,
    this.showTime = true,
    this.waitingList,
  });

  final ScrollController controller = ScrollController();

  bool _isWaitingCell(int dayListIndex, int sessionNum) {
    if (isInstructor) {
      // Instructor cells embed a flags object — use it directly.
      final flags =
          table["table"]["$dayListIndex"]["$sessionNum"]?["flags"];
      return flags?["is_waiting"] == true;
    }
    // Classroom view: match against the injected waiting list.
    if (waitingList == null || waitingList!.isEmpty) return false;
    final calCtrl = Get.find<CalednerController>();
    if (dayListIndex >= calCtrl.workDaysList.length) return false;
    final dayNum = calCtrl.workDaysList[dayListIndex].dayNum;
    final classroomId = table["classroom_id"];
    return waitingList!.any((w) =>
        w.dayNum == dayNum &&
        w.classNumber == sessionNum &&
        (classroomId == null || w.cell?.classroomId == classroomId));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final bool bounded =
          constraints.maxHeight.isFinite && constraints.maxHeight > 50;

      final double tableH = bounded
          ? constraints.maxHeight
          : (MediaQuery.of(context).orientation == Orientation.portrait
              ? context.height / 1.2
              : context.height * 2);

      final double tableW =
          (constraints.maxWidth.isFinite && constraints.maxWidth > 0)
              ? constraints.maxWidth
              : context.width;

      final int daysCount =
          Get.find<CalednerController>().workDaysList.length;
      final int sessionsCount =
          Get.find<TeacherPageController>().classesNamesAndNumbers.length;

      // cellH is used ONLY for font-size scaling.
      // Cell layout uses Expanded so Flutter distributes space exactly —
      // no floating-point multiplication, no overflow.
      final double cellH = daysCount > 0
          ? (tableH / (daysCount + 1)).clamp(12.0, 100.0)
          : 100.0;

      // DottedBorder inner padding scales with cell size.
      final double dottedPad = (cellH * 0.08).clamp(1.5, 4.0);

      return SizedBox(
        height: tableH,
        width: tableW,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Days column ─────────────────────────────────────────────
            SizedBox(
              height: tableH,
              width: 140,
              child: Days(cellHeight: cellH),
            ),

            // ── Session columns (horizontal scroll) ─────────────────────
            SizedBox(
              width: tableW - 140,
              height: tableH,
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: sessionsCount,
                controller: controller,
                separatorBuilder: (_, __) => const SizedBox(width: 0.1),
                itemBuilder: (context, day) {
                  // Each Column child is Expanded so they share tableH
                  // exactly — no cell heights to multiply/round.
                  return Column(
                    children: [
                      // ── Session header ─────────────────────────────
                      Expanded(
                        child: Container(
                          width: 180,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColors.SECONDERYCOLOR, width: 1),
                            borderRadius: day == 0
                                ? const BorderRadius.only(
                                    topRight: Radius.circular(10))
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              Get.find<TeacherPageController>()
                                  .classesNamesAndNumbers[day]
                                  .toString(),
                              style: AlMaraia.copyWith(
                                fontSize: (cellH * 0.18).clamp(9, 18),
                                color: AppColors.FONTCOLOR
                                    .withValues(alpha: 0.7),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // ── Day-data cells ────────────────────────────
                      ...List.generate(daysCount, (index) {
                        final isWaiting = _isWaitingCell(index, day + 1);
                        final isToday =
                            Get.find<CalednerController>().todayIndex ==
                                index;

                        final Color cellBg = isWaiting
                            ? _waitingCellBg
                            : isToday
                                ? AppColors.TABLEBACKGROUNDCOLOR
                                : Colors.transparent;
                        final Color borderCol = isWaiting
                            ? _waitingBorderColor
                            : AppColors.SECONDERYCOLOR;

                        return Expanded(
                          child: Container(
                            width: 180,
                            color: cellBg,
                            child: DottedBorder(
                              borderType: BorderType.RRect,
                              dashPattern: const [1, 0],
                              color: borderCol,
                              strokeWidth: isWaiting ? 1.5 : 1,
                              padding: EdgeInsets.all(dottedPad),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: [
                                    if (isWaiting)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 2),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.hourglass_top_rounded,
                                              color: _waitingBorderColor,
                                              size: (cellH * 0.12)
                                                  .clamp(7, 12),
                                            ),
                                            const SizedBox(width: 3),
                                            Text(
                                              'انتظار',
                                              style: AlMaraia.copyWith(
                                                fontSize: (cellH * 0.10)
                                                    .clamp(7, 11),
                                                color: _waitingBorderColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    Text(
                                      isInstructor
                                          ? table["table"]["$index"]
                                                      ["${day + 1}"]
                                                  ["cell_text"][0]
                                              .toString()
                                          : table["table"]["$index"]
                                                  ["${day + 1}"]
                                                  ["cell_text"]
                                              .toString(),
                                      style: AlMaraia.copyWith(
                                        fontSize:
                                            (cellH * 0.20).clamp(9, 17),
                                        color: isWaiting
                                            ? _waitingBorderColor
                                            : null,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (showTime &&
                                        (table["table"]["$index"]
                                                    ["${day + 1}"]
                                                ["cell_ids"] ==
                                            null ||
                                            (table["table"]["$index"]
                                                    ["${day + 1}"]
                                                ["cell_ids"] as List)
                                                .isNotEmpty))
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            table["table"]["$index"]
                                                    ["${day + 1}"]
                                                    ["start_time"]
                                                .toString(),
                                            style: AlMaraia.copyWith(
                                              fontSize: (cellH * 0.12)
                                                  .clamp(7, 11),
                                              color: isWaiting
                                                  ? _waitingBorderColor
                                                  : AppColors
                                                      .DARKENGREYFONTCOLOR,
                                            ),
                                          ),
                                          const SizedBox(width: 3),
                                          Text(
                                            '-',
                                            style: AlMaraia.copyWith(
                                                fontSize: (cellH * 0.12)
                                                    .clamp(7, 11)),
                                          ),
                                          const SizedBox(width: 3),
                                          Text(
                                            table["table"]["$index"]
                                                    ["${day + 1}"]
                                                    ["end_time"]
                                                .toString(),
                                            style: AlMaraia.copyWith(
                                              fontSize: (cellH * 0.12)
                                                  .clamp(7, 11),
                                              color: isWaiting
                                                  ? _waitingBorderColor
                                                  : AppColors
                                                      .DARKENGREYFONTCOLOR,
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
