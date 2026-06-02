class AttendanceStatisticsModel {
  final Summary summary;
  final List<ClassStatistics> classes;

  AttendanceStatisticsModel({
    required this.summary,
    required this.classes,
  });

  factory AttendanceStatisticsModel.fromJson(Map<String, dynamic> json) {
    return AttendanceStatisticsModel(
      summary: Summary.fromJson(json['summary']),
      classes: (json['classes'] as List)
          .map((e) => ClassStatistics.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'summary': summary.toJson(),
      'classes': classes.map((e) => e.toJson()).toList(),
    };
  }
}

class Summary {
  final AttendanceItem present;
  final AttendanceItem absent;
  final AttendanceItem late;

  Summary({
    required this.present,
    required this.absent,
    required this.late,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      present: AttendanceItem.fromJson(json['present']),
      absent: AttendanceItem.fromJson(json['absent']),
      late: AttendanceItem.fromJson(json['late']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'present': present.toJson(),
      'absent': absent.toJson(),
      'late': late.toJson(),
    };
  }
}

class ClassStatistics {
  final int classId;
  final String className;

  final AttendanceItem present;
  final AttendanceItem absent;
  final AttendanceItem late;

  ClassStatistics({
    required this.classId,
    required this.className,
    required this.present,
    required this.absent,
    required this.late,
  });

  factory ClassStatistics.fromJson(Map<String, dynamic> json) {
    return ClassStatistics(
      classId: json['class_id'],
      className: json['class_name'],
      present: AttendanceItem.fromJson(json['present']),
      absent: AttendanceItem.fromJson(json['absent']),
      late: AttendanceItem.fromJson(json['late']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'class_id': classId,
      'class_name': className,
      'present': present.toJson(),
      'absent': absent.toJson(),
      'late': late.toJson(),
    };
  }
}

class AttendanceItem {
  final int count;
  final int percent;

  AttendanceItem({
    required this.count,
    required this.percent,
  });

  factory AttendanceItem.fromJson(Map<String, dynamic> json) {
    return AttendanceItem(
      count: json['count'],
      percent: json['percent'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'percent': percent,
    };
  }
}
