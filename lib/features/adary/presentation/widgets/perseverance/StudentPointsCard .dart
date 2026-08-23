import 'package:adary/features/adary/data/models/student_per.dart';
import 'package:adary/features/adary/presentation/widgets/perseverance/student_actions_menu.dart';
import 'package:flutter/material.dart';

/// بطاقة الطالب في «سلوك الطلاب»: الصورة والاسم وملاحظته ملوّنة تحته، ثم
/// أيقونة الحالة، وقائمة النقاط الثلاث على اليسار — كما في التصميم.
class StudentPointsCard extends StatelessWidget {
  const StudentPointsCard({
    super.key,
    required this.studentBehavior,
    required this.className,
    this.classId,
    this.dateHijri,
  });

  final StudentBehavior studentBehavior;
  final String className;
  final int? classId;
  final String? dateHijri;

  /// عنوان أبرز ملاحظة على الطالب، وهو النص الملوّن تحت الاسم.
  String get _noteLabel => studentBehavior.notes.isEmpty
      ? ''
      : studentBehavior.notes.map((n) => n.title ?? '').join('، ');

  Color get _noteColor => studentBehavior.notes.isEmpty
      ? Colors.grey
      : studentBehavior.notes.first.color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          StudentActionsMenu(
            studentId: studentBehavior.student.id,
            studentName: studentBehavior.student.name,
            className: className,
            statusLabel: _noteLabel,
            statusColor: _noteColor,
            studentClassId: classId ?? studentBehavior.student_class,
            source: 'behavior',
            reason: _noteLabel.isEmpty ? null : _noteLabel,
            date: studentBehavior.gregorian_date,
            dateHijri: dateHijri ?? studentBehavior.date_hijri,
            session: studentBehavior.period,
            behaviorRecordId: studentBehavior.id,
          ),
          const SizedBox(width: 4),

          /// أيقونة الحالة
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 6,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              studentBehavior.total_points < 0
                  ? Icons.sentiment_dissatisfied
                  : Icons.sentiment_satisfied,
              color: _noteColor,
              size: 26,
            ),
          ),
          const Spacer(),

          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  studentBehavior.student.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                if (_noteLabel.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    _noteLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: _noteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 10),
          const CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage("assets/images/student.jpg"),
          ),
        ],
      ),
    );
  }
}
