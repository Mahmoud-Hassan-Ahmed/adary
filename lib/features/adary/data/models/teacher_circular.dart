import 'package:adary/features/adary/data/models/teacher_model.dart';

class TeacherCircular {
  final int? id;
  final Teacher teacherId;
  final int administrativeCircularId;
  final bool isSignature;

  TeacherCircular({
    this.id,
    required this.teacherId,
    required this.administrativeCircularId,
    this.isSignature = false,
  });

  // Factory method to create an instance from JSON
  factory TeacherCircular.fromJson(Map<String, dynamic> json) {
    return TeacherCircular(
      id: json['id'],
      teacherId: Teacher.fromJson(json['teacher']),
      administrativeCircularId: json['administrative_circulars'],
      isSignature: json['is_signature'] ?? false,
    );
  }
}
