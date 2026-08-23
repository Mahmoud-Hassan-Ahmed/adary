import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/student_model.dart';
import 'package:flutter/material.dart';

class StudentInfo {
  final int id;
  final String name;

  StudentInfo({required this.id, required this.name});
  factory StudentInfo.fromJson(Map<String, dynamic> json) =>
      StudentInfo(id: json['id'], name: json['name']);
}

class BehaviorNote {
  final int id;
  final String? title, icon, note_type;
  final int points;

  BehaviorNote(
      {required this.id,
      required this.title,
      required this.icon,
      required this.note_type,
      required this.points});
  Color get color => points <= 0 ? Colors.deepOrange : Colors.lightGreen;

  factory BehaviorNote.fromJson(Map<String, dynamic> json) => BehaviorNote(
      icon: json['icon'],
      id: json['id'],
      note_type: json['note_type'],
      points: json['points'],
      title: json['title']);
}

class StudentBehavior {
  final StudentInfo student;
  final int id;
  final List<BehaviorNote> notes;
  final String gregorian_date, date_hijri;
  final int student_class;
  final String period, additional_notes;
  String? className;
  final int total_points;

  StudentBehavior(
      {required this.student,
      required this.id,
      required this.notes,
      required this.gregorian_date,
      required this.date_hijri,
      required this.total_points,
      required this.student_class,
      required this.period,
      required this.additional_notes});

  Color get color => total_points <= 0 ? Colors.deepOrange : Colors.lightGreen;
  factory StudentBehavior.fromJson(Map<String, dynamic> json) =>
      StudentBehavior(
          additional_notes: json['additional_notes'],
          date_hijri: json['hijri_date'],
          total_points: json['total_points'],
          gregorian_date: json['gregorian_date'],
          id: json['id'],
          notes: AppUtils.generateList(json['notes'], BehaviorNote.fromJson),
          period: json['period'],
          student: StudentInfo.fromJson(json['student']),
          student_class: json['student_class']);
}

class StudentPer {
  final StudentInfo student;
  final int id;
  final String date;
  final String dateHijri;
  final int className;
  final String attendance;
  final String session;
  final String? note;

  StudentPer({
    required this.id,
    required this.session,
    required this.date,
    required this.className,
    required this.dateHijri,
    required this.note,
    required this.attendance,
    required this.student,
  });
  factory StudentPer.fromJson(Map<String, dynamic> json) {
    return StudentPer(
        id: json['id'],
        student: StudentInfo.fromJson(json['student']),
        date: json['date'],
        dateHijri: json['date_hijri'],
        attendance: json['attendance'],
        className: json['class_name'],
        note: json['note'],
        session: json['session']);
  }

  String get statusName {
    switch (attendance) {
      case 's':
        return 'حاضر';
      case 'a':
        return 'غائب';
      case 'l':
        return 'متأخر';
      case 'p':
        return 'مستأذن';
      default:
        return '';
    }
  }

  Color get color {
    switch (attendance) {
      case 's':
        return const Color(0xFF43A047);
      case 'a':
        return const Color(0xFFE53935);
      case 'l':
        return const Color(0xFFF5B301);
      case 'p':
        return const Color(0xFF1B2A6B);
      default:
        return Colors.grey;
    }
  }
}
