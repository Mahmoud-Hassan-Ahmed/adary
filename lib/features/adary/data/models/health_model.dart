import 'package:adary/features/adary/data/models/classes.dart';

class HealthCondition {
  final int? id;
  final String nameStudent;
  final Classes classNameId;
  final String name;
  final String? recommendations;
  final String dealingWithSituation;
  final bool? notifyTeacher;
  final bool? sendSms;

  HealthCondition({
    this.id,
    required this.nameStudent,
    required this.classNameId,
    required this.name,
    this.recommendations,
    required this.dealingWithSituation,
    required this.notifyTeacher,
    required this.sendSms,
  });

  factory HealthCondition.fromJson(Map<String, dynamic> json) {
    return HealthCondition(
      id: json['id'],
      notifyTeacher: json['notify_teacher'],
      sendSms: json['send_sms'],
      nameStudent: json['name_student'] as String,
      classNameId: Classes.fromJson(json['class_name']),
      name: json['name'] as String,
      recommendations: json['recommendations'] as String?,
      dealingWithSituation: json['dealing_with_situation'] as String,
    );
  }
}
