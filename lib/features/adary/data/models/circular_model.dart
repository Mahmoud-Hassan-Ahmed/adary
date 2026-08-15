class AdministrativeCircular {
  final int? id;
  final String title;
  final DateTime date;
  final DateTime createdAt;
  final String dateHijri;
  final String issuer;
  /// إشعار المعلمين عن طريق التطبيق
  final bool sendNotification;

  /// إشعار المعلمين عن طريق الواتس اب
  final bool sendWhatsapp;
  final bool sendSms;
  final bool selectAll;
  final String fileUrl;

  AdministrativeCircular({
    this.id,
    required this.title,
    required this.date,
    required this.createdAt,
    required this.dateHijri,
    required this.issuer,
    required this.sendNotification,
    this.sendWhatsapp = false,
    required this.sendSms,
    required this.selectAll,
    required this.fileUrl,
  });

  factory AdministrativeCircular.fromJson(Map<String, dynamic> json) {
    return AdministrativeCircular(
      id: json['id'],
      title: json['title'] ?? '',
      date: DateTime.parse(json['date']),
      createdAt: DateTime.parse(json['created_at']),
      dateHijri: json['date_hijri'] ?? '',
      issuer: json['issuer'] ?? '',
      sendNotification: json['send_notif'] ?? false,
      sendWhatsapp: json['whatsapp_notif'] ?? false,
      selectAll: json['select_all'] ?? false,
      fileUrl: json['file'] ?? '',
      sendSms: json['send_sms'] ?? false,
    );
  }
}
