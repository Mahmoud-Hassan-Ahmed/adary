import 'package:adary/features/adary/data/models/attendance_statistics_model.dart';
import 'package:adary/features/adary/presentation/widgets/perseverance/report_bar.dart';
import 'package:flutter/material.dart';

/// بطاقة فصل في «تقارير الحضور»: شريط مجزّأ ثم عدّاد كل حالة بنقطتها الملوّنة.
class ClassProgressCard extends StatelessWidget {
  const ClassProgressCard({super.key, required this.classStatistics});

  final ClassStatistics classStatistics;

  @override
  Widget build(BuildContext context) {
    // ترتيب الشرائح من اليمين كما في التصميم: حضور، غياب، تأخر.
    // الحضور يلوّن الشريط ولا عدّاد له: يوم العمل أصله أن الطالب حاضر،
    // فالمعروض هو الاستثناء — الغياب والتأخّر.
    final segments = [
      ReportSegment(
        value: classStatistics.present.count,
        color: const Color(0xFF3FBF5F),
        label: 'حضور',
        inLegend: false,
      ),
      ReportSegment(
        value: classStatistics.absent.count,
        color: const Color(0xFFE94B4B),
        label: 'غائب',
      ),
      ReportSegment(
        value: classStatistics.late.count,
        color: const Color(0xFFF5B301),
        label: 'متأخر',
      ),
    ];

    return ReportClassCard(
      className: classStatistics.className,
      segments: segments,
    );
  }
}
