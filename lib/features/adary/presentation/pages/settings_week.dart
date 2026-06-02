import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/week_group.dart';
import 'package:adary/features/adary/presentation/bloc/week_plan/week_plan_bloc.dart';
import 'package:adary/features/adary/presentation/widgets/week_plans/week_input_iem.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/snack_bar_type_enum.dart' show SnackType;

class SettingsWeek extends StatefulWidget {
  const SettingsWeek({super.key});

  @override
  State<SettingsWeek> createState() => _ClassesListState();
}

class _ClassesListState extends State<SettingsWeek> {
  @override
  void initState() {
    super.initState();
  }

  List<WeekGroupModel> items = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<WeekPlanBloc>(),
      child: BlocBuilder<WeekPlanBloc, WeekPlanState>(
        builder: (context, state) {
          if (state is WeekPlanInitial) {
            BlocProvider.of<WeekPlanBloc>(context).add(GetWeeksGroupEvent());
          } else if (state is DoneGetWeeksGroup) {
            items = state.list;
          } else if (state is DoneDeletePlanState) {
            AppUtils.showCustomSnackbar('تم حذف العنصر', SnackType.SUCESS);
            BlocProvider.of<WeekPlanBloc>(context).add(GetWeeksGroupEvent());
          } else if (state is DoneAddWeekGroupState ||
              state is DoneUpdateWeekGroupState) {
            BlocProvider.of<WeekPlanBloc>(context).add(GetWeeksGroupEvent());
          }
          return RefreshIndicator(
            onRefresh: () async {
              BlocProvider.of<WeekPlanBloc>(context).add(GetWeeksGroupEvent());
            },
            child: SafeArea(
                child: Scaffold(
                    body: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) => WeekInputIem(
                weekGroupModel: items[index],
              ),
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
            ))),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
