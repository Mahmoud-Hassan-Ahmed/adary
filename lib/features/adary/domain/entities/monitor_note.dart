import 'package:easy_localization/easy_localization.dart';

class MonitorNoteEntity {
  final int? id;
  final int note;
  final DateTime date;
  final String dateHijri;
  final int? session;

  MonitorNoteEntity({
    this.id,
    required this.note,
    required this.date,
    required this.dateHijri,
    required this.session,
  });

  Map<String, dynamic> toJson() {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    return {
      'note_id': note,
      'date': formatter.format(date),
      'date_hijri': dateHijri,
      if (session != null) 'session': session.toString(),
    };
  }
}
