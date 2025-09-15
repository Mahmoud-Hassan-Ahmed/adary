class AdministrativeCircular {
  final int? id;
  final String title;
  final DateTime date;
  final DateTime createdAt;
  final String dateHijri;
  final String issuer;
  final bool sendNotification;
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
      selectAll: json['select_all'] ?? false,
      fileUrl: json['file'] ?? '',
    );
  }
}
