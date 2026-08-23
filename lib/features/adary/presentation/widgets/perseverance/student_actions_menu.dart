import 'package:adary/features/adary/presentation/pages/student_record_page.dart';
import 'package:adary/features/adary/presentation/pages/take_procedure_page.dart';
import 'package:flutter/material.dart';

/// قائمة النقاط الثلاث على بطاقة الطالب — بخياراتها الثلاثة كما في التصميم:
/// سجل الطالب، إتخاذ إجراء، والإجراءات المتخذة.
class StudentActionsMenu extends StatelessWidget {
  const StudentActionsMenu({
    super.key,
    required this.studentId,
    required this.studentName,
    this.className,
    this.statusLabel,
    this.statusColor,
    this.studentClassId,
    this.source = 'attendance',
    this.reason,
    this.date,
    this.dateHijri,
    this.session,
    this.attendanceRecordId,
    this.behaviorRecordId,
  });

  final int studentId;
  final String studentName;
  final String? className, statusLabel;
  final Color? statusColor;
  final int? studentClassId;

  /// `attendance` أو `behavior` — يحدّد عنوان السجل ونوع الإجراء المسجَّل.
  final String source;
  final String? reason, date, dateHijri, session;
  final int? attendanceRecordId, behaviorRecordId;

  bool get isAttendance => source == 'attendance';

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: Colors.black54),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      position: PopupMenuPosition.under,
      onSelected: (value) => _open(context, value),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'record',
          child: Text(
            isAttendance ? 'سجل  حضور الطالب' : 'سجل  سلوك الطالب',
            style: _itemStyle,
          ),
        ),
        const PopupMenuDivider(height: 1),
        const PopupMenuItem(
          value: 'take',
          child: Text('إتخاذ إجراء', style: _itemStyle),
        ),
        const PopupMenuDivider(height: 1),
        const PopupMenuItem(
          value: 'taken',
          child: Text('الإجراءات المتخذة', style: _itemStyle),
        ),
      ],
    );
  }

  static const _itemStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 15,
    color: Colors.black,
  );

  void _open(BuildContext context, String value) {
    if (value == 'take') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TakeProcedurePage(
            studentId: studentId,
            studentName: studentName,
            className: className,
            statusLabel: statusLabel,
            statusColor: statusColor,
            studentClassId: studentClassId,
            source: source,
            reason: reason,
            date: date,
            dateHijri: dateHijri,
            session: session,
            attendanceRecordId: attendanceRecordId,
            behaviorRecordId: behaviorRecordId,
          ),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StudentRecordPage(
          studentId: studentId,
          studentName: studentName,
          className: className,
          statusLabel: statusLabel,
          source: source,
          startOnProcedures: value == 'taken',
        ),
      ),
    );
  }
}
