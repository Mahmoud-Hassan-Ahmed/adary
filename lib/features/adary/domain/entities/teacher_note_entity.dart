import 'package:adary/features/adary/domain/entities/base_enity.dart';

class TeacherNote extends BaseEnity {
  final int? id;
  final int teacher;
  int monitorNote;
  String comment;
  bool isActive = false;

  TeacherNote({
    this.isActive = false,
    this.id,
    required this.teacher,
    required this.monitorNote,
    required this.comment,
  });

  // Method to convert a JSON map to a TeacherNote object
  factory TeacherNote.fromJson(Map<String, dynamic> json) {
    return TeacherNote(
      teacher: json['teacher'],
      monitorNote: json['monitor_note'],
      comment: json['comment'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'teacher_id': teacher,
      'monitor_note_id': monitorNote,
      'comment': comment,
      // 'school': school,
    };
  }
}
