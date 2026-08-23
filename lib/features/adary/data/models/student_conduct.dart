import 'package:adary/features/adary/data/models/attendance_statistics_model.dart';
import 'package:adary/features/adary/data/models/student_per.dart';

/// نماذج قسم «المواظبة والسلوك» — الشاشات التي تُفتح من قائمة النقاط الثلاث:
/// سجل حضور الطالب، سجل سلوكه، والإجراءات المتخذة بحقّه.

/// بطاقة الطالب أعلى شاشات السجل.
class StudentCard {
  final int id;
  final String name;
  final String? numberStudent;
  final String? className;

  StudentCard({
    required this.id,
    required this.name,
    this.numberStudent,
    this.className,
  });

  factory StudentCard.fromJson(Map<String, dynamic> json) => StudentCard(
        id: json['id'],
        name: json['name'] ?? '',
        numberStudent: json['number_student'],
        className: json['class_name'],
      );
}

/// حصة واحدة داخل يوم في «سجل حضور الطالب».
class AttendanceSession {
  final int id;
  final String? session, sessionDisplay, startTime, endTime;
  final String attendance, attendanceDisplay;
  final String? className, note;

  AttendanceSession({
    required this.id,
    required this.attendance,
    required this.attendanceDisplay,
    this.session,
    this.sessionDisplay,
    this.startTime,
    this.endTime,
    this.className,
    this.note,
  });

  /// «8:00 ص - 8:45 ص» كما يظهر أسفل اسم الحصة، وفارغ إن لم يُضبط التوقيت.
  String get timeRange =>
      (startTime == null || endTime == null) ? '' : '$startTime - $endTime';

  bool get isPresent => attendance == 's';
  bool get isAbsent => attendance == 'a';
  bool get isLate => attendance == 'l';
  bool get isPermission => attendance == 'p';

  factory AttendanceSession.fromJson(Map<String, dynamic> json) =>
      AttendanceSession(
        id: json['id'],
        session: json['session'],
        sessionDisplay: json['session_display'],
        startTime: json['start_time'],
        endTime: json['end_time'],
        attendance: json['attendance'] ?? '',
        attendanceDisplay: json['attendance_display'] ?? '',
        className: json['class_name'],
        note: json['note'],
      );
}

/// يوم مطويّ في «سجل حضور الطالب»، عنوانه «الخميس 15 أغسطس 2026».
class AttendanceDay {
  final String? date, dateHijri, dateDisplay;
  final List<AttendanceSession> sessions;

  AttendanceDay({
    this.date,
    this.dateHijri,
    this.dateDisplay,
    required this.sessions,
  });

  factory AttendanceDay.fromJson(Map<String, dynamic> json) => AttendanceDay(
        date: json['date']?.toString(),
        dateHijri: json['date_hijri'],
        dateDisplay: json['date_display'],
        sessions: ((json['sessions'] ?? []) as List)
            .map((e) => AttendanceSession.fromJson(e))
            .toList(),
      );
}

/// ملخّص البطاقات الأربع أعلى «سجل حضور الطالب».
class StudentAttendanceSummary {
  final AttendanceItem present, absent, late, permission;

  StudentAttendanceSummary({
    required this.present,
    required this.absent,
    required this.late,
    required this.permission,
  });

  static AttendanceItem _item(dynamic json) => json == null
      ? AttendanceItem(count: 0, percent: 0)
      : AttendanceItem.fromJson(json);

  factory StudentAttendanceSummary.fromJson(Map<String, dynamic> json) =>
      StudentAttendanceSummary(
        present: _item(json['present']),
        absent: _item(json['absent']),
        late: _item(json['late']),
        permission: _item(json['permission']),
      );
}

class StudentAttendanceRecord {
  final StudentCard student;
  final StudentAttendanceSummary summary;
  final int totalRecords;
  final List<AttendanceDay> days;

  StudentAttendanceRecord({
    required this.student,
    required this.summary,
    required this.totalRecords,
    required this.days,
  });

  factory StudentAttendanceRecord.fromJson(Map<String, dynamic> json) =>
      StudentAttendanceRecord(
        student: StudentCard.fromJson(json['student']),
        summary: StudentAttendanceSummary.fromJson(json['summary'] ?? {}),
        totalRecords: json['total_records'] ?? 0,
        days: ((json['days'] ?? []) as List)
            .map((e) => AttendanceDay.fromJson(e))
            .toList(),
      );
}

/// سجل سلوك واحد داخل يوم.
class BehaviorDayRecord {
  final int id;
  final String? period, periodDisplay, startTime, endTime, className;
  final List<BehaviorNote> notes;
  final String? additionalNotes;
  final int totalPoints;

  BehaviorDayRecord({
    required this.id,
    required this.notes,
    required this.totalPoints,
    this.period,
    this.periodDisplay,
    this.startTime,
    this.endTime,
    this.className,
    this.additionalNotes,
  });

  String get timeRange =>
      (startTime == null || endTime == null) ? '' : '$startTime - $endTime';

  factory BehaviorDayRecord.fromJson(Map<String, dynamic> json) =>
      BehaviorDayRecord(
        id: json['id'],
        period: json['period'],
        periodDisplay: json['period_display'],
        startTime: json['start_time'],
        endTime: json['end_time'],
        className: json['class_name'],
        notes: ((json['notes'] ?? []) as List)
            .map((e) => BehaviorNote.fromJson(e))
            .toList(),
        additionalNotes: json['additional_notes'],
        totalPoints: json['total_points'] ?? 0,
      );
}

class BehaviorDay {
  final String? date, dateHijri, dateDisplay;
  final List<BehaviorDayRecord> records;

  BehaviorDay({
    this.date,
    this.dateHijri,
    this.dateDisplay,
    required this.records,
  });

  factory BehaviorDay.fromJson(Map<String, dynamic> json) => BehaviorDay(
        date: json['date']?.toString(),
        dateHijri: json['date_hijri'],
        dateDisplay: json['date_display'],
        records: ((json['records'] ?? []) as List)
            .map((e) => BehaviorDayRecord.fromJson(e))
            .toList(),
      );
}

class StudentBehaviorSummary {
  final int totalPoints, positiveNotes, negativeNotes, recordsCount;

  StudentBehaviorSummary({
    required this.totalPoints,
    required this.positiveNotes,
    required this.negativeNotes,
    required this.recordsCount,
  });

  factory StudentBehaviorSummary.fromJson(Map<String, dynamic> json) =>
      StudentBehaviorSummary(
        totalPoints: json['total_points'] ?? 0,
        positiveNotes: json['positive_notes'] ?? 0,
        negativeNotes: json['negative_notes'] ?? 0,
        recordsCount: json['records_count'] ?? 0,
      );
}

class StudentBehaviorRecord {
  final StudentCard student;
  final StudentBehaviorSummary summary;
  final List<BehaviorDay> days;

  StudentBehaviorRecord({
    required this.student,
    required this.summary,
    required this.days,
  });

  factory StudentBehaviorRecord.fromJson(Map<String, dynamic> json) =>
      StudentBehaviorRecord(
        student: StudentCard.fromJson(json['student']),
        summary: StudentBehaviorSummary.fromJson(json['summary'] ?? {}),
        days: ((json['days'] ?? []) as List)
            .map((e) => BehaviorDay.fromJson(e))
            .toList(),
      );
}

/// أنواع الإجراء الأربعة في شاشة «إتخاذ إجراء».
class ProcedureType {
  static const verbalWarning = 'verbal_warning';
  static const gradeDeduction = 'grade_deduction';
  static const referToAgent = 'refer_to_agent';
  static const referToCounselor = 'refer_to_counselor';

  /// بالترتيب الذي تعرضه الشاشة، ونصوصها كما في التصميم.
  static const List<MapEntry<String, String>> all = [
    MapEntry(verbalWarning, 'إنذار شفهي'),
    MapEntry(gradeDeduction, 'حسم درجة'),
    MapEntry(referToAgent, 'إحالة إلي الوكيل'),
    MapEntry(referToCounselor, 'إحالة إلي المرشد'),
  ];
}

/// بطاقة إجراء في شاشة «الإجراءات المتخذة».
class StudentProcedure {
  final int id;
  final StudentCard? student;
  final int? studentClass, attendanceRecord, behaviorRecord;
  final String? className, reason, date, dateHijri, session, source;
  final String procedureType, procedureTypeDisplay;

  StudentProcedure({
    required this.id,
    required this.procedureType,
    required this.procedureTypeDisplay,
    this.student,
    this.studentClass,
    this.attendanceRecord,
    this.behaviorRecord,
    this.className,
    this.reason,
    this.date,
    this.dateHijri,
    this.session,
    this.source,
  });

  factory StudentProcedure.fromJson(Map<String, dynamic> json) =>
      StudentProcedure(
        id: json['id'],
        student: json['student'] == null
            ? null
            : StudentCard.fromJson(json['student']),
        studentClass: json['student_class'],
        attendanceRecord: json['attendance_record'],
        behaviorRecord: json['behavior_record'],
        className: json['class_name'],
        procedureType: json['procedure_type'] ?? '',
        procedureTypeDisplay: json['procedure_type_display'] ?? '',
        source: json['source'],
        reason: json['reason'],
        date: json['date']?.toString(),
        dateHijri: json['date_hijri'],
        session: json['session'],
      );

  /// حمولة الإنشاء من شاشة «إتخاذ إجراء» — تُرسل كقائمة عند تحديد أكثر من نوع.
  static Map<String, dynamic> createPayload({
    required int studentId,
    required String procedureType,
    int? studentClass,
    String? source,
    String? reason,
    String? date,
    String? dateHijri,
    String? session,
    int? attendanceRecord,
    int? behaviorRecord,
  }) =>
      {
        'student_id': studentId,
        'procedure_type': procedureType,
        if (studentClass != null) 'student_class': studentClass,
        if (source != null) 'source': source,
        if (reason != null) 'reason': reason,
        if (date != null) 'date': date,
        if (dateHijri != null) 'date_hijri': dateHijri,
        if (session != null) 'session': session,
        if (attendanceRecord != null) 'attendance_record': attendanceRecord,
        if (behaviorRecord != null) 'behavior_record': behaviorRecord,
      };
}
