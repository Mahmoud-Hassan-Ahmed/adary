import 'package:adary/features/adary/domain/entities/base_enity.dart';

class RegisterStudentEntity extends BaseEnity {
  final int studentId;
  final DateTime date;
  final String dateHijri;
  final int className;
  String? attendance;
  final int session;
  String? note;

  RegisterStudentEntity(
      {required this.studentId,
      required this.date,
      required this.dateHijri,
      required this.className,
      this.attendance,
      required this.session,
      this.note});

  @override
  Map<String, dynamic> toJson() => {
        "student_id": studentId,
        "date": date.toIso8601String().split('T').first,
        "date_hijri": dateHijri,
        "class_name": className,
        "attendance": attendance ?? 's',
        "session": session,
        "note": note ?? ''
      };
}

class BehavoirRecordEntity extends BaseEnity {
  final int studentId;
  final DateTime gregorian_date;
  final String date_hijri;
  final int student_class;
  List<int>? notes_ids;
  final int period;
  String? additional_notes;
  bool submit;

  BehavoirRecordEntity(
      {required this.studentId,
      required this.gregorian_date,
      required this.date_hijri,
      required this.student_class,
      this.submit = false,
      required this.period});

  @override
  Map<String, dynamic> toJson() => {
        "student_id": studentId,
        "gregorian_date": gregorian_date.toIso8601String().split('T').first,
        "date_hijri": date_hijri,
        "student_class": student_class,
        "notes_ids": notes_ids ?? [],
        "period": period,
        "additional_notes": additional_notes ?? ''
      };
}
