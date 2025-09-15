import 'package:adary/features/adary/domain/entities/base_enity.dart';
import 'package:easy_localization/easy_localization.dart';

class VisitEntity extends BaseEnity {
  final int? id;
  final int teacher;
  final String visitorName;
  final DateTime date;
  final String dateHijri;
  final int? className;
  final String? session;
  final bool sendNotif;
  final bool isVisible;
  final bool notifyTeacher;

  VisitEntity({
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

  Map<String, dynamic> toJson() {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    return {
      'id': id,
      'teacher_id': teacher,
      'visitor_name': visitorName,
      'date': formattedDate,
      'date_hijri': dateHijri,
      'class_name_id': className,
      'session': session,
      'send_notif': sendNotif,
      'is_visible': isVisible,
      'notify_teacher': notifyTeacher,
    };
  }
}
