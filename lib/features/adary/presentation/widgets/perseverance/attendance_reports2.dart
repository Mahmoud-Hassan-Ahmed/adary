import 'package:adary/features/adary/data/models/behavior_statistics_model.dart';
import 'package:adary/features/adary/presentation/bloc/behavoir_notes/behavoir_notes_bloc.dart';
import 'package:adary/features/adary/presentation/widgets/perseverance/ClassProgressCard.dart';
import 'package:adary/features/adary/presentation/widgets/perseverance/ClassProgressCard2.dart';
import 'package:adary/features/adary/presentation/widgets/perseverance/PercentCard.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/bloc/base_bloc.dart';

class AttendanceStatsPage2 extends StatelessWidget {
  const AttendanceStatsPage2({super.key});

  @override
  Widget build(BuildContext context) {
    List<BehaviorStatisticsModel>? behaviorStatisticsModel;
    return BlocProvider(
      create: (context) => sl<BehavoirNotesBloc>(),
      child: BlocBuilder<BehavoirNotesBloc, BehavoirNotesState>(
        builder: (context, state) {
          if (state is BehavoirNotesInitial) {
            BaseBloc.get<BehavoirNotesBloc>(context)
                .add(GetBehaviorStatisticsEvent());
          } else if (state is DoneGetBehaviorStatistics) {
            behaviorStatisticsModel = state.statistics;
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

                    /// Section Title
                    const Text(
                      "نسب السلوك حسب الفصل ",
                      style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// Class Cards
                    ...List.generate(
                      behaviorStatisticsModel?.length ?? 0,
                      (index) => ClassProgressCard2(
                        classStatistics: behaviorStatisticsModel![index],
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
