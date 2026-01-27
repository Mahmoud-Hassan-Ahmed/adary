import 'package:adary/features/adary/domain/entities/base_enity.dart';

class StudentEntity extends BaseEnity {
  final int? id;
  final int className;
  final String name;
  final bool fatherIsAlive;
  final bool motherIsAlive;
  final String kinshipWithStudent;
  final String studentGuardian;
  final String withLive;
  final bool? notifyTeacher;
  final bool? sendSms;

  StudentEntity(
      {required this.className,
      this.id,
      required this.name,
      required this.fatherIsAlive,
      required this.motherIsAlive,
      required this.kinshipWithStudent,
      required this.studentGuardian,
      required this.notifyTeacher,
      required this.sendSms,
      required this.withLive});
  @override
  Map<String, dynamic> toJson() => {
        'class_name_id': className,
        'father_is_alive': fatherIsAlive,
        'mother_is_alive': fatherIsAlive,
        'student_guardian': studentGuardian,
        'kinship_with_student': kinshipWithStudent,
        'with_live': withLive,
        'name': name,
        'notify_teacher': notifyTeacher,
        'send_sms': sendSms,
      };
}
