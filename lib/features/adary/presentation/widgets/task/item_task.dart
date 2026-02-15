import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/conts/icons.dart';
import 'package:adary/core/share/widgets/btn_icon.dart';
import 'package:adary/core/share/widgets/container_btns.dart';
import 'package:adary/core/share/widgets/expansion_widget.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/task_teacher_mdel.dart';

import 'package:adary/features/adary/domain/entities/delete_entity.dart';
import 'package:adary/features/adary/presentation/bloc/delay_task/delay_task_bloc.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ItemTask extends StatelessWidget {
  const ItemTask(
      {super.key,
      required this.visitModel,
      required this.pagingController,
      this.canDekete = false});
  final DailyTask visitModel;
  final PagingController pagingController;
  final bool canDekete;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ExpansionWidget(
          body: [
            Wrap(
              children: [
                Text("${'mission'.tr()} : ",
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(fontWeight: FontWeight.bold)),
                Text(
                  visitModel.task.name,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
            const Divider(
              height: 12,
            ),
            Wrap(
              children: [
                Text("${'date'.tr()} : ",
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(fontWeight: FontWeight.bold)),
                Text(
                  visitModel.date,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
            const Divider(
              height: 12,
            ),
            Wrap(
              children: [
                Text("${'from_houre'.tr()} : ",
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(fontWeight: FontWeight.bold)),
                Text(
                  AppUtils.formatTime(visitModel.startTime),
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
            const Divider(
              height: 10,
            ),
            Wrap(
              children: [
                Text("${'to_houre'.tr()} : ",
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(fontWeight: FontWeight.bold)),
                Text(
                  AppUtils.formatTime(visitModel.endTime),
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
            if (canDekete)
              const SizedBox(
                height: 10,
              ),
            if (canDekete)
              ContainerBtns(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if (AppUtils.permissions.isNotEmpty &&
                            AppUtils.permissions.any((p) => p.contains(
                                "/daily-supervision/delete-daily-task-bulk/")) ||
                        AppUtils.permissions.isEmpty)
                      BtnIcon(
                          label: 'delete'.tr(),
                          icon: AppIcon.rash,
                          onTap: () {
                            AwesomeDialog(
                                context: context,
                                dialogType: DialogType.warning,
                                titleTextStyle: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                                title: 'delete_mission'.tr(),
                                desc: 'delete_mission_des'.tr(),
                                btnCancelText: 'no'.tr(),
                                btnOkText: 'delete'.tr(),
                                btnCancelOnPress: () {},
                                btnOkOnPress: () {
                                  BaseBloc.get<DelayTaskBloc>(context).add(
                                      RemoveTakTeaccherEvent(
                                          enity:
                                              DeleteEntity(id: visitModel.id)));
                                }).show();
                          }),
                    // BtnIcon(
                    //     label: 'edit'.tr(),
                    //     icon: AppIcon.edit,
                    //     onTap: () {
                    //       showModalBottomSheet(
                    //         isScrollControlled: true,
                    //         context: context,
                    //         builder: (context) {
                    //           return AddTeacherTask(
                    //             dailyTask: visitModel,
                    //             pagingController: pagingController,
                    //           );
                    //         },
                    //       );
                    //     })
                  ],
                ),
              )
          ],
          title: [
            Text(
              visitModel.teacher.name,
              style: Theme.of(context).textTheme.labelMedium,
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
