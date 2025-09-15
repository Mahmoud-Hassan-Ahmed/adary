import 'package:adary/features/adary/data/models/classes.dart';
import 'package:adary/features/adary/data/models/teacher_model.dart';

class VisitModel {
  final int? id;
  final Teacher teacher;
  final String visitorName;
  final DateTime date;
  final String dateHijri;
  final Classes? className;
  final String? session;
  final bool sendNotif;
  final bool isVisible;
  final bool? notifyTeacher;

  VisitModel({
    this.id,
    required this.teacher,
    required this.visitorName,
    required this.date,
    required this.dateHijri,
    this.className,
    this.session,
    required this.sendNotif,
    required this.isVisible,
    required this.notifyTeacher,
  });

  factory VisitModel.fromJson(Map<String, dynamic> json) {
    return VisitModel(
        id: json['id'] as int?,
        teacher: Teacher.fromJson(json['teacher']),
        visitorName: json['visitor_name'] as String,
        date: DateTime.parse(json['date'] as String),
        dateHijri: json['date_hijri'] as String,
        className: Classes.fromJson(json['class_name']),
        session: json['session'] as String?,
        sendNotif: json['send_notif'] as bool,
        isVisible: json['is_visible'] as bool,
        notifyTeacher: json['notify_teacher']);
  }
}
