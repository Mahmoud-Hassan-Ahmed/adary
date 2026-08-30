import 'package:adary/features/adary/data/models/procedure_cycle.dart';
import 'package:adary/features/adary/data/models/teacher_model.dart';

/// مساءلة ملاحظة: النموذج الرابع بجانب ١٨ و١٩ و٢٠.
///
/// لا يُنشئها المدير بإدخال يدوي بل بالضغط على «إرسال مساءلة» أمام ملاحظة
/// مسجّلة على المعلّم، فينسخ الخادم نصّ الملاحظة وتاريخها. النصّ هنا نسخة
/// وقت الإرسال ولا يتغيّر بتعديل الملاحظة لاحقًا.
class NoteAccountabilityModel {
  final int id;
  final Teacher teacher;
  final int? notesTeacherId;
  final String noteText;
  final String? noteComment;
  final String? noteDateHijri;
  final String? noteSessionDisplay;

  /// ملاحظة المدير على إفادة المعلّم، يكتبها مع اعتماد رأيه.
  final String? managerNote;

  /// إفادة المعلّم ورأي المدير وقنوات إشعاره به.
  final ProcedureCycle cycle;

  NoteAccountabilityModel({
    required this.id,
    required this.teacher,
    required this.noteText,
    this.notesTeacherId,
    this.noteComment,
    this.noteDateHijri,
    this.noteSessionDisplay,
    this.managerNote,
    this.cycle = const ProcedureCycle(),
  });

  factory NoteAccountabilityModel.fromJson(Map<String, dynamic> json) {
    return NoteAccountabilityModel(
      id: json['id'],
      teacher: Teacher.fromJson(json['teacher']),
      notesTeacherId: json['notes_teacher'] as int?,
      noteText: json['note_text']?.toString() ?? '',
      noteComment: json['note_comment']?.toString(),
      noteDateHijri: json['note_date_hijri']?.toString(),
      noteSessionDisplay: json['note_session_display']?.toString(),
      managerNote: json['manager_note']?.toString(),
      cycle: ProcedureCycle.fromJson(json),
    );
  }
}
