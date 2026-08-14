/// دورة الإجراء الإداري المشتركة بين نموذج ١٨ (تنبيه تأخير/انصراف)
/// ونموذج ٢٠ (مساءلة غياب): المدير ينشئ النموذج، فيكتب المعلّم أسبابه من
/// تطبيقه، ثم يعتمد المدير رأيه ويختار قنوات إشعار المعلّم به.
library;

/// خيار من خيارات رأي المدير — تختلف نصوصه بين نموذج وآخر فيرسلها الخادم.
class DecisionOption {
  final String value;
  final String label;

  const DecisionOption({required this.value, required this.label});

  factory DecisionOption.fromJson(Map<String, dynamic> json) => DecisionOption(
        value: json['value']?.toString() ?? '',
        label: json['label']?.toString() ?? '',
      );

  /// الخيار الذي يترتب عليه حسم — يُعرض بلون تحذيري في شاشة رأي المدير.
  bool get isDeduction => value.contains('deduct');
}

class ProcedureCycle {
  static const String statusPendingTeacher = 'pending_teacher';
  static const String statusPendingDecision = 'pending_decision';
  static const String statusDecided = 'decided';

  final String status;
  final String statusDisplay;

  /// ما كتبه المعلّم في خانة الأسباب، و`null` ما دام لم يُرسل إفادته بعد.
  final String? teacherReason;
  final String? teacherRepliedAtHijri;

  final String? managerDecision;
  final String managerDecisionDisplay;
  final String? managerDecidedAtHijri;

  final bool notifyTeacher;
  final bool notifyApp;
  final bool notifyWhatsapp;
  final bool notifySms;

  final List<DecisionOption> decisionOptions;

  const ProcedureCycle({
    this.status = statusPendingTeacher,
    this.statusDisplay = '',
    this.teacherReason,
    this.teacherRepliedAtHijri,
    this.managerDecision,
    this.managerDecisionDisplay = '',
    this.managerDecidedAtHijri,
    this.notifyTeacher = false,
    this.notifyApp = false,
    this.notifyWhatsapp = false,
    this.notifySms = false,
    this.decisionOptions = const [],
  });

  factory ProcedureCycle.fromJson(Map<String, dynamic> json) => ProcedureCycle(
        status: json['status']?.toString() ?? statusPendingTeacher,
        statusDisplay: json['status_display']?.toString() ?? '',
        teacherReason: json['teacher_reason'] as String?,
        teacherRepliedAtHijri: json['teacher_replied_at_hijri'] as String?,
        managerDecision: json['manager_decision'] as String?,
        managerDecisionDisplay:
            json['manager_decision_display']?.toString() ?? '',
        managerDecidedAtHijri: json['manager_decided_at_hijri'] as String?,
        notifyTeacher: json['notify_teacher'] == true,
        notifyApp: json['notify_app'] == true,
        notifyWhatsapp: json['notify_whatsapp'] == true,
        notifySms: json['notify_sms'] == true,
        decisionOptions: (json['decision_options'] as List?)
                ?.map((e) => DecisionOption.fromJson(
                    Map<String, dynamic>.from(e as Map)))
                .toList() ??
            const [],
      );

  bool get isPendingTeacher => status == statusPendingTeacher;
  bool get isPendingDecision => status == statusPendingDecision;
  bool get isDecided => status == statusDecided;
}
