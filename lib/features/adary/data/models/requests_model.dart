class LeaveRequestModel {
  final int id;
  final UserModel applicant;
  final UserModel substitute;
  final int cellNumber;
  final String date;
  final String tableNumber;
  final String status;
  final String statusText;
  final String note;
  final String managerNote;
  final LessonModel lesson;
  final DateTime createdAt;
  final DateTime updatedAt;

  LeaveRequestModel({
    required this.id,
    required this.applicant,
    required this.substitute,
    required this.cellNumber,
    required this.date,
    required this.tableNumber,
    required this.status,
    required this.statusText,
    required this.note,
    required this.managerNote,
    required this.lesson,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LeaveRequestModel.fromJson(Map<String, dynamic> json) {
    return LeaveRequestModel(
      id: _asInt(json['id']),
      applicant: UserModel.fromJson(_asMap(json['applicant'])),
      substitute: UserModel.fromJson(_asMap(json['substitute'])),
      cellNumber: _asInt(json['cell_number']),
      date: _asString(json['date']),
      tableNumber: _asString(json['table_number']),
      status: _asString(json['status']),
      statusText: _asString(json['status_text']),
      note: _asString(json['note']),
      managerNote: _asString(json['manager_note']),
      lesson: LessonModel.fromJson(_asMap(json['lesson'])),
      createdAt: _asDate(json['created_at']),
      updatedAt: _asDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'applicant': applicant.toJson(),
      'substitute': substitute.toJson(),
      'cell_number': cellNumber,
      'date': date,
      'table_number': tableNumber,
      'status': status,
      'status_text': statusText,
      'note': note,
      'manager_note': managerNote,
      'lesson': lesson.toJson(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class LessonModel {
  final int cellNumber;
  final String subject;
  final String classroom;
  final String dayName;
  final int classNumber;
  final String endTime;

  LessonModel({
    required this.cellNumber,
    required this.subject,
    required this.classroom,
    required this.dayName,
    required this.classNumber,
    required this.endTime,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      cellNumber: _asInt(json['cell_number']),
      subject: _asString(json['subject']),
      classroom: _asString(json['classroom']),
      dayName: _asString(json['day_name']),
      classNumber: _asInt(json['class_number']),
      endTime: _asString(json['end_time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cell_number': cellNumber,
      'subject': subject,
      'classroom': classroom,
      'day_name': dayName,
      'class_number': classNumber,
      'end_time': endTime,
    };
  }

  /// عرض مختصر للحصة، مثال: "الرياضيات - ١م/٣ - الحصة 3"
  String get title {
    final parts = [
      if (subject.isNotEmpty) subject,
      if (classroom.isNotEmpty) classroom,
      if (classNumber > 0) 'الحصة $classNumber',
    ];
    return parts.join(' - ');
  }
}

class UserModel {
  final int id;
  final String name;

  UserModel({
    required this.id,
    required this.name,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: _asInt(json['id']),
      name: _asString(json['name']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

/// محوّلات آمنة: الـ API يرجّع أحياناً رقم مكان نص (مثل table_number)
/// أو كائن مكان قيمة بسيطة (مثل lesson) أو null.
int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

String _asString(dynamic value) {
  if (value == null) return '';
  if (value is String) return value;
  return value.toString();
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return <String, dynamic>{};
}

DateTime _asDate(dynamic value) {
  if (value is DateTime) return value;
  if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
  return DateTime.now();
}
