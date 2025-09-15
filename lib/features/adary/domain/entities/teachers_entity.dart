import 'package:adary/features/adary/domain/entities/base_enity.dart';
import 'package:adary/features/adary/domain/entities/monitor_note.dart';
import 'package:adary/features/adary/domain/entities/teacher_note_entity.dart';

class TeachersEntity extends BaseEnity {
  final List<TeacherNote> list;
  final MonitorNoteEntity monitorNoteEntity;

  TeachersEntity({required this.list, required this.monitorNoteEntity});

  @override
  Map<String, dynamic> toJson() => {};
}
