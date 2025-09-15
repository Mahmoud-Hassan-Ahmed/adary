import 'package:adary/features/adary/data/models/note_entity_model.dart';
import 'package:adary/features/adary/data/models/teacher_model.dart';

class NotesTeacher {
  final int? id;
  final Teacher teacherId;
  final String? createdAt;
  final MonitorNote monitorNoteId;
  final String? comment;

  NotesTeacher({
    this.id,
    required this.teacherId,
    this.createdAt,
    required this.monitorNoteId,
    this.comment,
  });

  factory NotesTeacher.fromJson(Map<String, dynamic> json) {
    return NotesTeacher(
      id: json['id'],
      teacherId: Teacher.fromJson(json['teacher']),
      createdAt: json['created_at'],
      monitorNoteId: MonitorNote.fromJson(json['monitor_note']),
      comment: json['comment'],
    );
  }
}

class MonitorNote {
  final int? id;

  final NoteModel noteId; // ID of the Note object (ForeignKey to Note)
  final String date; // Gregorian date (string format)
  final String dateHijri; // Hijri date (string)
  final String? session; // Session (string, can be null or blank)

  MonitorNote({
    this.id,
    required this.noteId,
    required this.date,
    required this.dateHijri,
    this.session,
  });

  // Factory method to create a MonitorNote from a JSON map
  factory MonitorNote.fromJson(Map<String, dynamic> json) {
    return MonitorNote(
      id: json['id'],
      noteId: NoteModel.fromJson(json['note']),
      date: json['date'],
      dateHijri: json['date_hijri'],
      session: json['session'],
    );
  }

  // Method to convert a MonitorNote instance to a JSON map
}
