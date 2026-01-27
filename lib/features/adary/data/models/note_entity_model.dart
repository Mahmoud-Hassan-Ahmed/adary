import 'package:adary/core/model/select_model.dart';

class NoteModel implements SelectModel {
  final int id;
  final String description;
  final String typeNote;
  final bool howSession;
  final bool activeWhatsapp;
  final bool activeSms;
  final bool activeNotification;
  final int numToSend;
  final int? arranging;
  final String templateMessage;
  final String typeNoteDisplay;

  NoteModel(
      {required this.id,
      required this.description,
      required this.typeNote,
      required this.howSession,
      required this.activeWhatsapp,
      required this.activeSms,
      required this.activeNotification,
      required this.numToSend,
      required this.arranging,
      required this.typeNoteDisplay,
      required this.templateMessage});

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'],
      typeNoteDisplay: json['type_note_display'],
      description: json['description'],
      typeNote: json['type_note'],
      howSession: json['how_session'] ?? false,
      activeWhatsapp: json['active_whatsapp'] ?? false,
      activeSms: json['active_sms'] ?? false,
      activeNotification: json['active_notification'] ?? false,
      numToSend: json['num_to_send'] ?? 1,
      arranging: json['arranging'],
      templateMessage: json['template_message'] ??
          'Hello {name}, a note has been recorded {num} times, which is: {note}. We hope you pay more attention to this.',
    );
  }

  @override
  // TODO: implement name
  String get name => description;
}
