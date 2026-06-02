import 'package:adary/core/share/widgets/my_app_bar.dart';
import 'package:adary/features/adary/data/models/exam_model.dart';
import 'package:adary/features/adary/presentation/widgets/exam/CommitteeCard.dart';
import 'package:flutter/material.dart';

class HalsDetails extends StatelessWidget {
  const HalsDetails({super.key, required this.exam, required this.examDay});
  final ExamDay examDay;
  final Exam exam;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: exam.name),
      body: ListView.separated(
          itemBuilder: (context, index) => CommitteeCard(
                exam: exam,
                examDay: examDay,
                hall: examDay.halls[index],
              ),
          separatorBuilder: (context, index) => const SizedBox(
                height: 10,
              ),
          itemCount: examDay.halls.length),
    );
  }
}
