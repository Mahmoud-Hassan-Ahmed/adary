import 'package:adary/features/adary/presentation/widgets/perseverance/attendance_reports.dart';
import 'package:adary/features/adary/presentation/widgets/perseverance/attendance_reports2.dart';
import 'package:flutter/material.dart';

class ReportsStatistics extends StatelessWidget {
  const ReportsStatistics({super.key, required this.isView});
  final bool isView;

  @override
  Widget build(BuildContext context) {
    return isView ? AttendanceStatsPage() : AttendanceStatsPage2();
  }
}
