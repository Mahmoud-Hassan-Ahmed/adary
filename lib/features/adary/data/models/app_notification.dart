/// إشعار واحد كما يحفظه الخادم في `NotificationDashboardMobile`.
///
/// الخادم يحفظ صفًّا لكل جهاز عند كل حدث (تأمين حصة، رغبة، إجراء إداري)،
/// ويردّ بها مرتَّبة من الأحدث. و`newMessage` هو ما يبني عليه الشارة.
class AppNotification {
  final int id;
  final String message;
  final bool newMessage;
  final DateTime? createdAt;

  const AppNotification({
    required this.id,
    required this.message,
    required this.newMessage,
    this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] as int,
      message: json['message']?.toString() ?? '',
      newMessage: json['new_message'] == true,
      // الخادم يرسل ISO-8601؛ صفٌّ تالف لا يصحّ أن يُسقط القائمة كلها.
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
    );
  }
}
