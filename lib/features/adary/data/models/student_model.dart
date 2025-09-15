import 'package:adary/features/adary/data/models/classes.dart';

class StudentModel {
  final int id;
  final String name;
  final Classes className;
  final bool fatherIsAlive;
  final bool motherIsAlive;
  final String studentGuardian;
  final String kinshipWithStudent;
  final String withLive;
  final bool? notifyTeacher;
  // Constructor
  StudentModel({
    required this.id,
    required this.name,
    required this.className,
    required this.fatherIsAlive,
    required this.motherIsAlive,
    required this.studentGuardian,
    required this.kinshipWithStudent,
    required this.withLive,
    required this.notifyTeacher,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'],
      name: json['name'] as String,
      className: Classes.fromJson(json['class_name']),
      fatherIsAlive: json['father_is_alive'] as bool,
      motherIsAlive: json['mother_is_alive'] as bool,
      studentGuardian: json['student_guardian'] as String,
      kinshipWithStudent: json['kinship_with_student'] as String,
      withLive: json['with_live'] as String,
      notifyTeacher: json['notify_teacher'],
    );
  }
}
