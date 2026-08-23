import 'package:adary/features/adary/data/models/behavior_statistics_model.dart';
import 'package:adary/features/adary/presentation/widgets/perseverance/report_bar.dart';
import 'package:flutter/material.dart';

/// بطاقة فصل في «تقارير السلوك»: التوزيع على المستويات الخمسة.
class ClassProgressCard2 extends StatelessWidget {
  const ClassProgressCard2({super.key, required this.classStatistics});

  final BehaviorStatisticsModel classStatistics;

  @override
  Widget build(BuildContext context) {
    // من اليمين إلى اليسار كما في التصميم: ممتاز ← ضعيف.
    final segments = [
      ReportSegment(
        value: classStatistics.excellent,
        color: const Color(0xFF1EBE8F),
        label: 'ممتاز',
      ),
      ReportSegment(
        value: classStatistics.veryGood,
        color: const Color(0xFF4CAF50),
        label: 'جيدجدا',
      ),
      ReportSegment(
        value: classStatistics.good,
        color: const Color(0xFFF5B301),
        label: 'جيد',
      ),
      ReportSegment(
        value: classStatistics.acceptable,
        color: const Color(0xFFF07A2B),
        label: 'مقبول',
      ),
      ReportSegment(
        value: classStatistics.weak,
        color: const Color(0xFFE94B4B),
        label: 'ضعيف',
      ),
    ];

    return ReportClassCard(
      className: classStatistics.className,
      segments: segments,
    );
  }
}
