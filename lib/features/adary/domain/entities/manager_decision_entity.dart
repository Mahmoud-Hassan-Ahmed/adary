import 'package:adary/features/adary/domain/entities/base_enity.dart';

/// ما ترسله شاشة "رأي مدير المدرسة" عند الضغط على "حفظ البيانات":
/// الخيار الذي اعتمده المدير، وقنوات إشعار المعلّم به إن اختار إشعاره.
class ManagerDecisionEntity extends BaseEnity {
  final int id;
  final String decision;

  /// ملاحظة المدير على إفادة المعلّم — مساءلة الملاحظة وحدها تحفظها،
  /// وبقية النماذج تتجاهلها في الخادم فلا ضرر من إرسالها فارغة.
  final String? managerNote;
  final bool notifyTeacher;
  final bool notifyApp;
  final bool notifyWhatsapp;
  final bool notifySms;

  ManagerDecisionEntity({
    required this.id,
    required this.decision,
    this.managerNote,
    this.notifyTeacher = false,
    this.notifyApp = false,
    this.notifyWhatsapp = false,
    this.notifySms = false,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'manager_decision': decision,
      if (managerNote != null) 'manager_note': managerNote,
      'notify_teacher': notifyTeacher,
      // القنوات لا معنى لها بغير تفعيل إشعار المعلّم، فتُصفَّر معه.
      'notify_app': notifyTeacher && notifyApp,
      'notify_whatsapp': notifyTeacher && notifyWhatsapp,
      'notify_sms': notifyTeacher && notifySms,
    };
  }
}
