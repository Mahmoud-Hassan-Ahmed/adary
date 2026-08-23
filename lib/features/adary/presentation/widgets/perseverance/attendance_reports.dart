import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/features/adary/data/models/attendance_statistics_model.dart';
import 'package:adary/features/adary/presentation/bloc/behavoir_notes/behavoir_notes_bloc.dart';
import 'package:adary/features/adary/presentation/widgets/perseverance/ClassProgressCard.dart';
import 'package:adary/features/adary/presentation/widgets/perseverance/conduct_widgets.dart';
import 'package:adary/features/adary/presentation/widgets/perseverance/report_bar.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/bloc/base_bloc.dart';

/// «تقارير الحضور» — حلقات النسب لكل الفصول، ثم توزيع كل فصل على حدة.
class AttendanceStatsPage extends StatelessWidget {
  const AttendanceStatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<BehavoirNotesBloc>(),
      child: BlocBuilder<BehavoirNotesBloc, BehavoirNotesState>(
        builder: (context, state) {
          AttendanceStatisticsModel? statistics;

          if (state is BehavoirNotesInitial) {
            BaseBloc.get<BehavoirNotesBloc>(context)
                .add(GetAttendanceStatisticsEvent());
          } else if (state is DoneGetAttendanceStatistics) {
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
                  : _content(statistics),
            ),
          );
        },
      ),
    );
  }

  Widget _content(AttendanceStatisticsModel statistics) {
    final summary = statistics.summary;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ReportSectionTitle(text: 'نسبة الحضور لكل الفصول'),
          const SizedBox(height: 12),

          /// الحلقات الثلاث — من اليمين: حاضر، غائب، متأخر.
          Row(
            children: [
              Expanded(
                child: ReportPercentCard(
                  percent: summary.late.percent,
                  color: const Color(0xFFF5B301),
                  label: 'متأخر',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ReportPercentCard(
                  percent: summary.absent.percent,
                  color: const Color(0xFFE94B4B),
                  label: 'غائب',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ReportPercentCard(
                  percent: summary.present.percent,
                  color: const Color(0xFF3FBF5F),
                  label: 'حاضر',
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),
          const ReportSectionTitle(
            text: 'نسب الحضور حسب الفصل',
            teal: true,
          ),
          const SizedBox(height: 12),

          if (statistics.classes.isEmpty)
            const ConductEmpty(text: 'لا يوجد بيانات للعرض')
          else
            ...statistics.classes.map(
              (item) => ClassProgressCard(classStatistics: item),
            ),
        ],
      ),
    );
  }
}
