import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/conts/icons.dart';
import 'package:adary/core/share/widgets/btn_icon.dart';
import 'package:adary/core/share/widgets/container_btns.dart';
import 'package:adary/core/share/widgets/expansion_widget.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/weekly_pan.dart';
import 'package:adary/features/adary/domain/entities/delete_entity.dart';
import 'package:adary/features/adary/presentation/bloc/week_plan/week_plan_bloc.dart';
import 'package:adary/features/adary/presentation/widgets/visits/plans.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:open_filex/open_filex.dart';

class ItemWeeklyPlan extends StatelessWidget {
  const ItemWeeklyPlan(
      {super.key, required this.visitModel, required this.pagingController});
  final WeeklyPan visitModel;
  final PagingController pagingController;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Plans(
                  weekId: visitModel,
                )));
      },
      child: Column(
        children: [
          ExpansionWidget(
            body: [
              // SizedBox(
              //   height: 300,
              //   child: Plans(
              //     weekId: visitModel.weekNumber,
              //   ),
              // )
              // Text(
              //   "${"date_added".tr()} : ${DateFormat('yyyy-MM-DD').format(visitModel.createdAt)}",
              //   style: Theme.of(context).textTheme.labelMedium,
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              // ContainerBtns(
              //   content: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceAround,
              //     children: [
              //       BtnIcon(
              //           label: 'delete'.tr(),
              //           icon: AppIcon.rash,
              //           onTap: () {
              //             AwesomeDialog(
              //                 context: context,
              //                 dialogType: DialogType.warning,
              //                 titleTextStyle: const TextStyle(
              //                     color: Colors.red,
              //                     fontSize: 20,
              //                     fontWeight: FontWeight.bold),
              //                 title: 'delete_paln'.tr(),
              //                 desc: 'delete_paln_des'.tr(),
              //                 btnCancelText: 'no'.tr(),
              //                 btnOkText: 'delete'.tr(),
              //                 btnCancelOnPress: () {},
              //                 btnOkOnPress: () {
              //                   BaseBloc.get<WeekPlanBloc>(context).add(
              //                       DeleteWeekPlanEvent(
              //                           entity: DeleteEntity(
              //                               id: visitModel.id ?? 0)));
              //                 }).show();
              //           }),
              //       BtnIcon(
              //           label: 'download'.tr(),
              //           icon: AppIcon.download,
              //           onTap: () async {
              //             print(visitModel.file);
              //             final pdf = await AppUtils.downloadFile(
              //                 'https://test.smartble.net${visitModel.file}',
              //                 '${visitModel.teacher.name}.pdf');
              //             if (pdf != null) {
              //               OpenFilex.open(pdf);
              //             }
              //           }),
              //     ],
              //   ),
              // )
            ],
            title: [
              Image.asset(AppIcon.pdf),
              Text(
                visitModel.weekNumberText,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              Expanded(
                child: Text(
                  "${"num_plans".tr()} ${visitModel.weeklyPlansCount}",
                  textAlign: TextAlign.end,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
