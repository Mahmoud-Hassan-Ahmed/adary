import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/share/widgets/expansion_widget.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/week_group.dart';
import 'package:adary/features/adary/presentation/bloc/week_plan/week_plan_bloc.dart';
import 'package:adary/features/adary/presentation/widgets/week_plans/add_week.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WeekInputIem extends StatelessWidget {
  const WeekInputIem({super.key, required this.weekGroupModel});
  final WeekGroupModel weekGroupModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromRGBO(196, 248, 248, 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExpansionWidget(
              color: const Color.fromRGBO(196, 248, 248, 0.5),
              title: [
                Text(
                  weekGroupModel.name,
                  style: Theme.of(context).textTheme.labelMedium,
                )
              ],
              body: [
                WeekCard(
                  weekGroupModel: weekGroupModel,
                ),
              ]),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

class WeekCard extends StatelessWidget {
  final WeekGroupModel weekGroupModel;

  const WeekCard({super.key, required this.weekGroupModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('weeks_count'.tr(namedArgs: {'count': weekGroupModel.weeksCount.toString()}),
                        style: const TextStyle(color: Colors.red)),
                    StatusBadge(active: weekGroupModel.isActive),
                  ],
                ),
                const SizedBox(height: 6),
                Text('weekly_plans_count'.tr(namedArgs: {'count': weekGroupModel.plansNumber.toString()}),
                    style: const TextStyle(color: Colors.blue)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.warning,
                      animType: AnimType.bottomSlide,
                      title: 'are_you_sure'.tr(),
                      desc: 'delete_group_warning'.tr(),
                      btnCancelOnPress: () {},
                      btnOkOnPress: () {
                        BaseBloc.get<WeekPlanBloc>(context)
                            .add(DeleteWeekGroupEvent(id: weekGroupModel.id));
                      },
                    ).show();
                  },
                  icon: SvgPicture.asset("assets/icons/delete.svg")),
              const SizedBox(width: 12),
              IconButton(
                  onPressed: () {
                    AppUtils.go(AddWeek(
                      weekGroupModel: weekGroupModel,
                    ));
                  },
                  icon: SvgPicture.asset('assets/icons/edit.svg'))
            ],
          )
        ],
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  final bool active;

  const StatusBadge({super.key, required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: active ? Colors.teal[100] : Colors.orange[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        active ? 'activated'.tr() : 'not_activated'.tr(),
        style: TextStyle(
          color: active ? Colors.teal : Colors.orange,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
