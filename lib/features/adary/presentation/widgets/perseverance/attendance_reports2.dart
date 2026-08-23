import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/features/adary/data/models/behavior_statistics_model.dart';
import 'package:adary/features/adary/presentation/bloc/behavoir_notes/behavoir_notes_bloc.dart';
import 'package:adary/features/adary/presentation/widgets/perseverance/ClassProgressCard2.dart';
import 'package:adary/features/adary/presentation/widgets/perseverance/conduct_widgets.dart';
import 'package:adary/features/adary/presentation/widgets/perseverance/report_bar.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/bloc/base_bloc.dart';

/// «تقارير السلوك» — توزيع طلاب كل فصل على المستويات الخمسة.
class AttendanceStatsPage2 extends StatelessWidget {
  const AttendanceStatsPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<BehavoirNotesBloc>(),
      child: BlocBuilder<BehavoirNotesBloc, BehavoirNotesState>(
        builder: (context, state) {
          List<BehaviorStatisticsModel>? statistics;

          if (state is BehavoirNotesInitial) {
            BaseBloc.get<BehavoirNotesBloc>(context)
                .add(GetBehaviorStatisticsEvent());
          } else if (state is DoneGetBehaviorStatistics) {
            statistics = state.statistics;
          }

          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: statistics == null
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.APP_COLOR,
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(14),
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const ReportSectionTitle(
                            text: 'نسب السلوك حسب الفصل',
                            teal: true,
                          ),
                          const SizedBox(height: 12),
                          if (statistics.isEmpty)
                            const ConductEmpty(text: 'لا يوجد بيانات للعرض')
                          else
                            ...statistics.map(
                              (item) =>
                                  ClassProgressCard2(classStatistics: item),
                            ),
                        ],
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
