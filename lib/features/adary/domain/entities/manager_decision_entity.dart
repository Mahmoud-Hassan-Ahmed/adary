import 'package:adary/features/adary/domain/entities/base_enity.dart';

/// ما ترسله شاشة "رأي مدير المدرسة" عند الضغط على "حفظ البيانات":
/// الخيار الذي اعتمده المدير، وقنوات إشعار المعلّم به إن اختار إشعاره.
class ManagerDecisionEntity extends BaseEnity {
  final int id;
  final String decision;
  final bool notifyTeacher;
  final bool notifyApp;
  final bool notifyWhatsapp;
  final bool notifySms;

  ManagerDecisionEntity({
    required this.id,
    required this.decision,
    this.notifyTeacher = false,
    this.notifyApp = false,
    this.notifyWhatsapp = false,
    this.notifySms = false,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'manager_decision': decision,
      'notify_teacher': notifyTeacher,
      // القنوات لا معنى لها بغير تفعيل إشعار المعلّم، فتُصفَّر معه.
      'notify_app': notifyTeacher && notifyApp,
      'notify_whatsapp': notifyTeacher && notifyWhatsapp,
      'notify_sms': notifyTeacher && notifySms,
    };
  }
}
