import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/teacher_model.dart';

class Exam {
  final int id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final int numberOfHalls;
  final String? description;
  final int confirmed; // 0 = Inactive, 1 = Active
  final int dateSystem; // 0 = Gregorian, 1 = Hijri

  Exam({
    required this.name,
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.numberOfHalls,
    this.description,
    required this.confirmed,
    required this.dateSystem,
  });

  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam(
      id: json['id'],
      name: json['name'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      numberOfHalls: json['number_of_halls'],
      description: json['description'],
      confirmed: json['confirmed'],
      dateSystem: json['date_system'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'start_date': startDate.toIso8601String().split('T').first,
      'end_date': endDate.toIso8601String().split('T').first,
      'number_of_halls': numberOfHalls,
      'description': description,
      'confirmed': confirmed,
      'date_system': dateSystem,
    };
  }
}

class Period {
  final int id;
  final String name;
  final String startTime;
  final String endTime;
  final bool active;

  Period({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.active,
  });

  factory Period.fromJson(Map<String, dynamic> json) {
    return Period(
      id: json['id'],
      name: json['name'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      active: json['active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'start_time': startTime,
      'end_time': endTime,
      'active': active,
    };
  }
}

class Hall {
  final int id;
  final String name;
  final int order;
  final int maxTeachers;
  final bool active;
  final Period period;
  final List<Teacher> teachers;
  final List<dynamic> teachersToAvoid;
  final List<dynamic> courseNames;

  Hall({
    required this.id,
    required this.name,
    required this.order,
    required this.maxTeachers,
    required this.active,
    required this.period,
    required this.teachers,
    required this.teachersToAvoid,
    required this.courseNames,
  });

  factory Hall.fromJson(Map<String, dynamic> json) {
    return Hall(
      id: json['id'],
      name: json['name'],
      order: json['order'],
      maxTeachers: json['max_teachers'],
      active: json['active'],
      period: Period.fromJson(json['period']),
      teachers: AppUtils.generateList(json['teachers'], Teacher.fromJson) ?? [],
      teachersToAvoid: json['teachers_to_avoid'] ?? [],
      courseNames: json['course_names'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'order': order,
      'max_teachers': maxTeachers,
      'active': active,
      'period': period.toJson(),
      'teachers': teachers,
      'teachers_to_avoid': teachersToAvoid,
      'course_names': courseNames,
    };
  }
}

class ExamDay {
  final int id;
  final DateTime day;
  final bool active;
  final String dateDisplay;
  final String hijriDate;
  final int periodsCount;
  final List<Hall> halls;
  final List<Teacher> teachers;

  ExamDay(
      {required this.id,
      required this.day,
      required this.active,
      required this.dateDisplay,
      required this.hijriDate,
      required this.periodsCount,
      required this.halls,
      required this.teachers});

  factory ExamDay.fromJson(Map<String, dynamic> json) {
    return ExamDay(
      teachers: json['teachers'] != null
          ? AppUtils.generateList(json['teachers'], Teacher.fromJson)
          : [],
      id: json['id'],
      day: DateTime.parse(json['day']),
      active: json['active'],
      dateDisplay: json['date_display'],
      hijriDate: json['hijri_date'],
      periodsCount: json['periods_count'],
      halls: (json['halls'] as List).map((e) => Hall.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'day': day.toIso8601String().split('T').first,
      'active': active,
      'date_display': dateDisplay,
      'hijri_date': hijriDate,
      'periods_count': periodsCount,
      'halls': halls.map((e) => e.toJson()).toList(),
    };
  }
}
