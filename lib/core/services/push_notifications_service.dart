import 'dart:async';
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
import 'package:flutter/services.dart' show MethodChannel;
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

  /// سقفٌ لكل نداء يعبر قناة المنصّة أو الشبكة هنا: هذه الخدمة تعمل بعد ظهور
  /// الشاشة، ولا يصحّ أن يبقى نداءٌ منها معلّقًا يستهلك الجهاز بلا نهاية.
  static const Duration _channelTimeout = Duration(seconds: 15);

  /// يقرأ سبب رفض أبل من `AppDelegate` — لا تكشفه واجهة firebase_messaging.
  static const MethodChannel _apnsChannel = MethodChannel('adary/apns');

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

  /// خلاصة آخر محاولة تسجيل، سطرًا سطرًا.
  ///
  /// «تظهر نافذة الإذن ثم لا يصل شيء» عرَضٌ تشترك فيه أسبابٌ متباينة: رمز
  /// APNs لم يصدر، أو صدر ولم يقبله الخادم، أو قبله ولم يرسل. ولا يفرّق
  /// بينها إلا معرفةُ آخر خطوة نجحت، فتُسجَّل هنا بدل أن تُبتلع.
  final List<String> diagnostics = [];

  void _note(String line, {bool bad = false}) {
    diagnostics.add(line);
    AppUtils.log('[إشعارات] $line',
        levelLog: bad ? Level.error : Level.info);
  }

  /// تُستدعى مرة واحدة عند إقلاع التطبيق. لا ترمي: تطبيق بلا إشعارات أهون من
  /// تطبيق لا يفتح لأن ملف إعدادات Firebase ناقص.
  Future<void> init() async {
    if (_initialized) return;
    try {
      // بمهلة: على جهاز بلا خدمات Google (Honor/Huawei) لا ترمي التهيئة بل
      // تتعلّق، وبلا مهلة يبقى المستدعي معلّقًا معها بلا نهاية.
      await Firebase.initializeApp().timeout(_channelTimeout);
      // الإذن أولًا وعبر Firebase وحده. `flutter_local_notifications` يطلب
      // إذنًا خاصًا به على iOS افتراضيًا، وهو إذن عرضٍ محلي لا يستدعي
      // `registerForRemoteNotifications`. فإن سبق طلبُه طلبَ Firebase، وجد
      // Firebase الإذن ممنوحًا فلم يسجّل الجهاز لدى APNs — فتظهر النافذة،
      // ويضغط المستخدم «سماح»، ولا يصدر رمز APNs، ولا يصل إشعار واحد.
      await _requestPermission().timeout(_channelTimeout);
      await _initLocalNotifications().timeout(_channelTimeout);
      await _initPushHandlers().timeout(_channelTimeout);
      _initialized = true;
      // لا يُنتظر: تسجيل الرمز طلبُ شبكةٍ خلفيٌّ، وانتظاره كان يطيل الإقلاع.
      unawaited(syncToken());
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
      // بلا طلب إذن: Firebase طلبه قبل قليل، وهو وحده من يسجّل لدى APNs.
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
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
    // iOS يعرضه بنفسه بعد setForegroundNotificationPresentationOptions،
    // فبناء إشعار محلي فوقه يُظهره مرتين.
    if (Platform.isIOS) return;

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

  /// سبب الرفض كما ورد من أبل إلى `AppDelegate`، أو null إن لم يرد رفض.
  Future<String?> _apnsFailureReason() async {
    try {
      return await _apnsChannel.invokeMethod<String>('lastFailure');
    } catch (e) {
      return null;
    }
  }

  /// ينتظر رمز APNs بمحاولات قصيرة متتابعة.
  ///
  /// النظام لا يسلّم الرمز فور الإذن: يحتاج ذهابًا وإيابًا مع خوادم أبل قد
  /// يتجاوز الثواني على شبكة بطيئة أو عند أول تشغيل بعد التثبيت. وانتظارٌ
  /// واحد ثابت كان يمرّ قبل وصوله فيعود `getToken` بـ null ولا يُسجَّل الجهاز
  /// أبدًا حتى تُشغَّل النسخة مرة أخرى.
  Future<String?> _awaitApnsToken() async {
    for (var attempt = 0; attempt < 6; attempt++) {
      final token = await FirebaseMessaging.instance
          .getAPNSToken()
          .timeout(_channelTimeout, onTimeout: () => null);
      if (token != null && token.isNotEmpty) return token;
      await Future.delayed(const Duration(seconds: 2));
    }
    return null;
  }

  /// يرسل رمز الجهاز إلى الخادم. تُستدعى بعد تسجيل الدخول وعند كل إقلاع
  /// وعند تجديد الرمز — الرمز يتغيّر بإعادة تثبيت التطبيق أو مسح بياناته.
  Future<void> syncToken() async {
    diagnostics.clear();
    final login = AppUtils.instance.getLogin();
    if (login == null) {
      _note('لا يوجد حساب مسجَّل، فلا يُنسب الجهاز لمدرسة.', bad: true);
      return;
    }

    try {
      if (Platform.isIOS) {
        final apns = await _awaitApnsToken();
        if (apns == null) {
          // أشهر أسبابه: خاصية Push غير مفعّلة على الـ App ID، أو الـ
          // provisioning profile لا يحمل الـ entitlement. ونافذة الإذن تظهر
          // في الحالتين، فظهورها ليس دليلًا على نجاح التسجيل.
          _note('رمز APNs لم يصدر — تسجيل الجهاز لدى أبل فشل.', bad: true);
          final reason = await _apnsFailureReason();
          _note(reason == null
              ? 'أبل لم تردّ بخطأ: التسجيل لم يُطلب أصلًا.'
              : 'نصّ رفض أبل: $reason');
          return;
        }
        _note('رمز APNs صدر.');
      }

      _token ??= await FirebaseMessaging.instance
          .getToken()
          .timeout(_channelTimeout, onTimeout: () => null);
      if (_token == null || _token!.isEmpty) {
        // مع وجود رمز APNs، يعني هذا أن Firebase لم يُصدر رمزًا للجهاز.
        _note('Firebase لم يُصدر رمز FCM.', bad: true);
        return;
      }
      _note('رمز FCM: $_token');

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

      // `package_name` ثابتٌ على معرّف أندرويد بينما معرّف حزمة iOS هو
      // com.smartapleP.in. إن كان الخادم يميّز التطبيقات به فالجهاز يُسجَّل
      // تحت هوية تطبيق آخر — وهذا أول ما يُراجَع في الخادم إن ظهر أدناه أن
      // التسجيل «نجح» ومع ذلك لا يصل شيء.
      _note('يُرسَل إلى ${Api.baseUrl}${Api.fcmTokenUpdate} '
          'بـ package_name=$_packageName');

      final response = await dio.post(Api.fcmTokenUpdate, data: {
        'fcm_token': _token,
        'package_name': _packageName,
        'lang_code': AppUtils.instance.getLocale().languageCode,
      });

      // كان الرد يُهمَل تمامًا: خادمٌ يردّ 200 برسالة رفض كان يبدو نجاحًا.
      final ok = response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300;
      _note('ردّ الخادم ${response.statusCode}: ${response.data}', bad: !ok);
    } catch (e) {
      _note('تعذّر تسجيل رمز الإشعارات: $e', bad: true);
    }
  }
}
