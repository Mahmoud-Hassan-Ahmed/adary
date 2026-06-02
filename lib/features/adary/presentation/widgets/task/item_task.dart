import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/task_teacher_mdel.dart';
import 'package:adary/features/adary/domain/entities/delete_entity.dart';
import 'package:adary/features/adary/presentation/bloc/delay_task/delay_task_bloc.dart';
import 'package:adary/features/adary/presentation/widgets/task/add_task_teacher.dart';
import 'package:adary/features/adary/presentation/widgets/text/label_main_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ItemTask extends StatelessWidget {
  const ItemTask({
    super.key,
    required this.visitModel,
    required this.pagingController,
    this.canDekete = false,
    this.item,
  });

  final DailyTask visitModel;
  final PagingController pagingController;
  final bool canDekete;
  final DailyTaskModel? item;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// 🔹 المحتوى الأساسي
        Positioned(
          right: MediaQuery.of(context).size.width * 0.25,
          top: 0,
          bottom: 0,
          child: Container(
            width: 2,
            color: visitModel.completed ? Colors.teal.shade200 : Colors.grey,
          ),
        ),

        /// 🟢 الدائرة (النقطة)
        Positioned(
            right: MediaQuery.of(context).size.width * 0.25 - 5,
            // top: 20,
            child: SvgPicture.asset(
              "assets/icons/circular.svg",
              width: 12,
              height: 12,
              color: visitModel.completed ? AppColors.APP_COLOR : Colors.grey,
            )),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🟢 التاريخ
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  LabelMainText(
                    text: item?.date ?? '',
                    fontSize: 13,
                  ),
                  Text(visitModel.date),
                ],
              ),
            ),

            const SizedBox(width: 20), // مساحة للـ line
            // Positioned(
            //   left: MediaQuery.of(context).size.width * 0.25, // عدل حسب التصميم
            //   top: 0,
            //   bottom: -100,
            //   child: SvgPicture.asset(
            //     "assets/icons/line.svg",
            //     fit: BoxFit.fill,
            //   ),
            // ),

            /// 🟢 الكارت
            Expanded(
              flex: 3,
              child: Card(
                color: Colors.white,
                elevation: 6,
                shadowColor: Colors.black.withOpacity(0.7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: const Color(0xFFFEF7EE)),
                              child: Text(
                                visitModel.completed ? 'مكتمل' : 'غير مكتمل',
                                style: TextStyle(
                                  color: visitModel.completed
                                      ? Colors.green
                                      : Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              visitModel.task.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color: const Color(0xFF213693),
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "من ${AppUtils.formatTime(visitModel.startTime)} : "
                              "إلى ${AppUtils.formatTime(visitModel.endTime)}",
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                        "assets/icons/user-profile-03.svg"),
                                    const SizedBox(width: 4),
                                    Text(
                                      visitModel.teacher.name,
                                      style:
                                          TextStyle(color: Color(0xFF213693)),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    if (AppUtils.checkPermission(
                                        ['/daily-supervision/edit/']))
                                      IconButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () {
                                            showModalBottomSheet(
                                              isScrollControlled: true,
                                              context: context,
                                              builder: (context) {
                                                return AddTeacherTask(
                                                  dailyTask: visitModel,
                                                  pagingController:
                                                      pagingController,
                                                );
                                              },
                                            );
                                          },
                                          icon: SvgPicture.asset(
                                              "assets/icons/edit.svg")),
                                    if (canDekete)
                                      if (AppUtils.checkPermission([
                                        '/daily-supervision/delete-daily-task-bulk/'
                                      ]))
                                        IconButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () {
                                              AwesomeDialog(
                                                  context: context,
                                                  dialogType:
                                                      DialogType.warning,
                                                  titleTextStyle:
                                                      const TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                  title: 'delete_mission'.tr(),
                                                  desc:
                                                      'delete_mission_des'.tr(),
                                                  btnCancelText: 'no'.tr(),
                                                  btnOkText: 'delete'.tr(),
                                                  btnCancelOnPress: () {},
                                                  btnOkOnPress: () {
                                                    BaseBloc.get<DelayTaskBloc>(
                                                            context)
                                                        .add(RemoveTakTeaccherEvent(
                                                            enity: DeleteEntity(
                                                                id: visitModel
                                                                    .id)));
                                                  }).show();
                                            },
                                            icon: SvgPicture.asset(
                                                "assets/icons/delete.svg"))
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        /// 🔴 الخط (SVG) - في مكانه الصح داخل Stack
      ],
    );
  }
}
