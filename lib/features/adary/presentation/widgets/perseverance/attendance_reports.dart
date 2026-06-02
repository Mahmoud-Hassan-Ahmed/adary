import 'package:adary/features/adary/data/models/attendance_statistics_model.dart';
import 'package:adary/features/adary/presentation/bloc/behavoir_notes/behavoir_notes_bloc.dart';
import 'package:adary/features/adary/presentation/widgets/perseverance/ClassProgressCard.dart';
import 'package:adary/features/adary/presentation/widgets/perseverance/PercentCard.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/bloc/base_bloc.dart';

class AttendanceStatsPage extends StatelessWidget {
  const AttendanceStatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    AttendanceStatisticsModel? attendanceStatisticsModel;
    return BlocProvider(
      create: (context) => sl<BehavoirNotesBloc>(),
      child: BlocBuilder<BehavoirNotesBloc, BehavoirNotesState>(
        builder: (context, state) {
          if (state is BehavoirNotesInitial) {
            BaseBloc.get<BehavoirNotesBloc>(context)
                .add(GetAttendanceStatisticsEvent());
          } else if (state is DoneGetAttendanceStatistics) {
            attendanceStatisticsModel = state.statistics;
          }
          return Scaffold(
            backgroundColor: const Color(0xfff5f5f5),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Top Title
                    const Text(
                      "نسبة الحضور لكل الفصول",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 10),

                    /// Top Cards
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PercentCard(
                          percent: attendanceStatisticsModel
                                  ?.summary.present.percent ??
                              0,
                          color: Colors.green,
                          label: "حاضر",
                        ),
                        PercentCard(
                          percent: attendanceStatisticsModel
                                  ?.summary.absent.percent ??
                              0,
                          color: Colors.red,
                          label: "غائب",
                        ),
                        PercentCard(
                          percent:
                              attendanceStatisticsModel?.summary.late.percent ??
                                  0,
                          color: Colors.orange,
                          label: "متأخر",
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// Section Title
                    const Text(
                      "نسبة الحضور حسب الفصل",
                      style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// Class Cards
                    ...List.generate(
                      attendanceStatisticsModel?.classes.length ?? 0,
                      (index) => ClassProgressCard(
                        classStatistics:
                            attendanceStatisticsModel!.classes[index],
                      ),
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
