import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/services/push_notifications_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// يعرض أين توقّفت سلسلة تسجيل الإشعارات، ورمز الجهاز لنسخه.
///
/// «الإشعارات لا تصل» عرَضٌ لا يفرّق بين خطأ في الجهاز وخطأ في الخادم وخطأ في
/// إعداد APNs، ولا سبيل لقراءة السجلّ من نسخة TestFlight. ونسخ الرمز من هنا
/// يحسم الأمر: رسالةٌ تجريبية إليه من Firebase Console تفصل جانب الجهاز عن
/// جانب الخادم فصلًا قاطعًا — إن وصلت فالخلل في الخادم، وإلا ففي APNs.
Future<void> showNotificationsDiagnostics(BuildContext context) {
  final service = PushNotificationsService.instance;
  final lines = service.diagnostics;
  final token = service.token;

  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('حالة الإشعارات',
                  style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              if (lines.isEmpty)
                const Text(
                  'لم تُجرَ محاولة تسجيل بعد. أعد تشغيل التطبيق ثم افتح هذه '
                  'الشاشة مرة أخرى.',
                  style: TextStyle(fontSize: 14, color: Color(0xFF707070)),
                )
              else
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 260),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final line in lines)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text('• $line',
                                style: const TextStyle(fontSize: 13)),
                          ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () async {
                  final reason = await service.retryRegistration();
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(reason == null
                        ? 'أُعيد الطلب ولم ترفض أبل هذه المرة.'
                        : 'رفض أبل: $reason'),
                    duration: const Duration(seconds: 8),
                  ));
                },
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('إعادة طلب التسجيل الآن'),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.APP_COLOR,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: token == null
                    ? null
                    : () {
                        Clipboard.setData(ClipboardData(text: token));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('نُسخ رمز الجهاز')),
                        );
                      },
                icon: const Icon(Icons.copy, size: 18),
                label: Text(token == null
                    ? 'لا يوجد رمز جهاز'
                    : 'نسخ رمز الجهاز (FCM)'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
