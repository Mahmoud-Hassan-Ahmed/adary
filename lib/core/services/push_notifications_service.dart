import 'dart:io';

import 'package:adary/core/conts/api.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/presentation/pages/delayed_alert.dart';
import 'package:adary/features/adary/presentation/pages/model20.dart';
import 'package:adary/features/adary/presentation/pages/secure_sessions.dart';
import 'package:adary/features/adary/presentation/pages/wishes_page.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart' show Level;

/// إشعارات تطبيق المدير.
///
/// الخادم يرسل الإشعار عند طلب تأمين حصة، وعند تسجيل المعلم رغبة أو تعديلها
/// أو حذفها، وعند إرساله إفادته على نموذج إداري — وكلها تمرّ بقناة واحدة
/// (`teacher_mobile/v2/apis/manager_notify.py::notify_managers`)،
/// وهي تستهدف الأجهزة عبر `fcm_token` المحفوظ في `DashboardMobile` و
/// `DashboardMobileUser`. فما ينقص هنا هو طرف الجهاز: الحصول على الرمز،
/// وإرساله إلى `dashboard-mobile/fcm-token-update/`، وعرض الإشعار.
///
/// بلا هذا التسجيل يبقى `fcm_token` فارغًا في قاعدة البيانات فلا يصل شيء،
/// ولا تظهر قائمة التنبيهات داخل التطبيق لأنها تُقرأ بـ (school, fcm_token).
@pragma('vm:entry-point')
Future<void> _onBackgroundMessage(RemoteMessage message) async {
  // خيط منفصل بلا `sl` ولا واجهة: النظام يعرض الإشعار بنفسه في الخلفية،
  // فلا يُفعل هنا أكثر من التسجيل للتشخيص.
  debugPrint('FCM background: ${message.notification?.title}');
}

class PushNotificationsService {
  PushNotificationsService._();
  static final PushNotificationsService instance = PushNotificationsService._();

  static const String _packageName = 'com.smartable.tables';

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel',
    'إشعارات هامة',
    description: 'طلبات تأمين الحصص وتنبيهات الإدارة',
    importance: Importance.high,
  );

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  String? _token;
  bool _initialized = false;

  String? get token => _token;

  /// تُستدعى مرة واحدة عند إقلاع التطبيق. لا ترمي: تطبيق بلا إشعارات أهون من
  /// تطبيق لا يفتح لأن ملف إعدادات Firebase ناقص.
  Future<void> init() async {
    if (_initialized) return;
    try {
      await Firebase.initializeApp();
      await _initLocalNotifications();
      await _requestPermission();
      await _initPushHandlers();
      _initialized = true;
      await syncToken();
    } catch (e) {
      AppUtils.log('تعذّرت تهيئة الإشعارات: $e', levelLog: Level.error);
    }
  }

  Future<void> _requestPermission() async {
    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    AppUtils.log('إذن الإشعارات: ${settings.authorizationStatus}');
  }

  Future<void> _initLocalNotifications() async {
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) =>
          _openTarget(response.payload),
    );
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
  }

  Future<void> _initPushHandlers() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);
    FirebaseMessaging.onMessage.listen(_showForegroundNotification);
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) => _openTarget(message.data['action_id']?.toString()),
    );

    // التطبيق كان مغلقًا تمامًا وفُتح من الإشعار: الشجرة لم تُبنَ بعد، فيؤجَّل
    // الانتقال إلى ما بعد أول إطار وإلا ضاع `Get.to` في الفراغ.
    final initial = await FirebaseMessaging.instance.getInitialMessage();
    if (initial != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(
          const Duration(seconds: 1),
          () => _openTarget(initial.data['action_id']?.toString()),
        );
      });
    }

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      _token = newToken;
      syncToken();
    });
  }

  /// أندرويد لا يعرض إشعار FCM والتطبيق مفتوح، فيُبنى محليًا.
  void _showForegroundNotification(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: message.data['action_id']?.toString(),
    );
  }

  /// `action_id` يصل من الخادم بالصيغة `<موضوع>_<معرّف>`، ولكلٍّ شاشته:
  ///
  ///   `secure_class_<id>`            → تأمين الحصص
  ///   `wishes_teacher_<teacher_id>`  → قائمة الرغبات
  ///   `procedure_model18_<id>`       → إشعار التأخر/الانصراف
  ///   `procedure_model20_<id>`       → محاسبة الغياب
  ///
  /// الشاشات تُفتح على قوائمها لا على السجل بعينه: المدير يصل إليه منها،
  /// وفتحه مباشرة يحتاج جلبه أولًا وقد يكون حُذف قبل فتح الإشعار.
  void _openTarget(String? actionId) {
    if (actionId == null) return;
    if (actionId.startsWith('secure_class_')) {
      AppUtils.go(const SecureSessions());
    } else if (actionId.startsWith('wishes_teacher_')) {
      AppUtils.go(const WishesPage());
    } else if (actionId.startsWith('procedure_model18_')) {
      AppUtils.go(const DelayedAlert());
    } else if (actionId.startsWith('procedure_model20_')) {
      AppUtils.go(const Model20Page());
    }
  }

  /// يرسل رمز الجهاز إلى الخادم. تُستدعى بعد تسجيل الدخول وعند كل إقلاع
  /// وعند تجديد الرمز — الرمز يتغيّر بإعادة تثبيت التطبيق أو مسح بياناته.
  Future<void> syncToken() async {
    final login = AppUtils.instance.getLogin();
    if (login == null) return; // بلا حساب لا يُعرف لأي مدرسة يُنسب الجهاز

    try {
      if (Platform.isIOS) {
        // بلا رمز APNs يرجع getToken بـ null على iOS.
        final apns = await FirebaseMessaging.instance.getAPNSToken();
        if (apns == null) {
          await Future.delayed(const Duration(seconds: 2));
        }
      }

      _token ??= await FirebaseMessaging.instance.getToken();
      if (_token == null || _token!.isEmpty) return;
      AppUtils.log('FCM token: $_token');

      // Dio مستقل عن `dioConfig`: ذاك يُظهر EasyLoading ورسائل الخطأ لكل طلب
      // غير GET، ولا يصح أن يُغرق المستخدمَ تسجيلٌ صامت يجري في الخلفية.
      final dio = Dio(BaseOptions(
        baseUrl: Api.baseUrl,
        connectTimeout: const Duration(milliseconds: 20000),
        receiveTimeout: const Duration(milliseconds: 20000),
        headers: {
          'app-key': login.password,
          'username': login.username,
          'Accept-Language': 'ar',
        },
      ));

      await dio.post(Api.fcmTokenUpdate, data: {
        'fcm_token': _token,
        'package_name': _packageName,
        'lang_code': AppUtils.instance.getLocale().languageCode,
      });
    } catch (e) {
      AppUtils.log('تعذّر تسجيل رمز الإشعارات: $e', levelLog: Level.error);
    }
  }
}
