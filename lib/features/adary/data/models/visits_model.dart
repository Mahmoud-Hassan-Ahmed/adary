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
  final bool? sendSms;
  final double rate_visit;

  VisitModel({
    this.id,
    required this.teacher,
    required this.visitorName,
    required this.date,
    required this.dateHijri,
    this.className,
    this.session,
    required this.rate_visit,
    required this.sendNotif,
    required this.isVisible,
    required this.notifyTeacher,
    required this.sendSms,
  });

  String get rateName {
    final value = rate_visit;

    if (value <= 1) {
      return "Very Bad";
    } else if (value <= 2) {
      return "Bad";
    } else if (value <= 3) {
      return "Good";
    } else if (value <= 4) {
      return "Very Good";
    } else if (value <= 5) {
      return "Excellent";
    } else {
      return "No";
    }
  }

  factory VisitModel.fromJson(Map<String, dynamic> json) {
    return VisitModel(
      id: json['id'] as int?,
      teacher: Teacher.fromJson(json['teacher']),
      visitorName: json['visitor_name'] as String,
      date: DateTime.parse(json['date'] as String),
      dateHijri: json['date_hijri'] as String,
      className: Classes.fromJson(json['class_name']),
      session: json['session'] as String?,
      rate_visit: double.parse(json['rate_visit'].toString()),
      sendNotif: json['send_notif'] as bool,
      isVisible: json['is_visible'] as bool,
      notifyTeacher: json['notify_teacher'],
      sendSms: json['send_sms'],
    );
  }
}
