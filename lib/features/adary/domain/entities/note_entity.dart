import 'package:adary/features/adary/domain/entities/base_enity.dart';

class NoteEntity extends BaseEnity {
  final int? id;
  final int? schoolId; // Corresponding to the ForeignKey `school`
  final String description;
  final String typeNote; // Use 'p' for Positive, 'n' for Needs improvement
  final bool howSession;
  final bool activeWhatsapp;
  final bool activeSms;
  final bool activeNotification;
  final int numToSend;
  final int? arranging;
  final String templateMessage;

  NoteEntity({
    this.id,
    this.schoolId,
    required this.description,
    required this.typeNote,
    this.howSession = false,
    this.activeWhatsapp = false,
    this.activeSms = false,
    this.activeNotification = false,
    this.numToSend = 1,
    this.arranging,
    this.templateMessage =
        'Hello {name}, a note has been recorded {num} times, which is: {note}. We hope you pay more attention to this.',
  });

  // // Factory method to create a Note from a JSON object
  // factory Note.fromJson(Map<String, dynamic> json) {
  //   return Note(
  //     id: json['id'],
  //     schoolId: json['school_id'],
  //     description: json['description'],
  //     typeNote: json['type_note'],
  //     howSession: json['how_session'] ?? false,
  //     activeWhatsapp: json['active_whatsapp'] ?? false,
  //     activeNotification: json['active_notification'] ?? false,
  //     numToSend: json['num_to_send'] ?? 1,
  //     arranging: json['arranging'],
  //     templateMessage: json['template_message'] ??
  //         'Hello {name}, a note has been recorded {num} times, which is: {note}. We hope you pay more attention to this.',
  //   );
  // }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'type_note': typeNote,
      'how_session': howSession,
      'active_whatsapp': activeWhatsapp,
      'active_sms': activeSms,
      'active_notification': activeNotification,
      'num_to_send': numToSend,
      'arranging': arranging,
      'template_message': templateMessage,
    };
  }
}
