import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' show PlatformDispatcher;

import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/conts/text.dart';
import 'package:adary/core/services/push_notifications_service.dart';
import 'package:adary/core/share/widgets/startup_error_screen.dart';
import 'package:adary/core/theme/theme_app.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/domain/usecases/get_hijri_date.dart';
import 'package:adary/features/table/helper/route_helper.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:adary/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart' show Level;
import 'package:adary/features/table/helper/get_di.dart' as di;

/// كل ما يُنتظر قبل `runApp` يحبس الشاشة بيضاء حتى ينتهي — وإن لم ينتهِ بقيت
/// بيضاء إلى الأبد بلا رسالة. فلا يُنتظر هنا إلا ما يلزم أول إطار، وبمهلة،
/// وما عداه يؤجَّل إلى ما بعد ظهور الشاشة.
const _bootTimeout = Duration(seconds: 20);

void main() => runZonedGuarded(_bootstrap, (error, stack) {
      AppUtils.log('خطأ غير ملتقط: $error\n$stack', levelLog: Level.error);
    });

Future<void> _bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  _installErrorHandlers();

  await EasyLocalization.ensureInitialized();

  // لا يُنتظر: قفل الاتجاهات لا شأن له بأول إطار.
  unawaited(SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]));

  Object? bootError;
  try {
    // `isRegistered` لأن شاشة الخطأ تعيد المحاولة، و get_it يرمي على تسجيل مكرّر.
    if (!AppUtils.sl.isRegistered<AppUtils>()) await init();
    // `init` يسجّل SharedPreferences تسجيلًا غير متزامن ولا ينتظره، بينما
    // `AppUtils.instance` يُبنى منه مباشرة. بلا هذا السطر يصير فتح التطبيق
    // سباقًا مع قناة المنصّة: من يخسره يرى شاشة بيضاء دائمة.
    await AppUtils.sl.allReady(timeout: _bootTimeout);
    await di.init().timeout(_bootTimeout);
  } catch (e, s) {
    bootError = e;
    AppUtils.log('تعذّرت تهيئة التطبيق: $e\n$s', levelLog: Level.error);
  }

  if (bootError != null) {
    runApp(StartupErrorScreen(error: bootError, onRetry: _bootstrap));
    return;
  }

  runApp(EasyLocalization(
    supportedLocales: const [
      Locale('en', 'US'),
      Locale('ar', 'SA'),
    ],
    path: ConstsApp.pathTranslate,
    startLocale: _readLocale(),
    saveLocale: true,
    // لا يصلح أن يكون البديل هو اللغة المحفوظة نفسها: إن كانت هي التالفة
    // بقي التطبيق بلا ترجمة يسقط عليها.
    fallbackLocale: const Locale('ar', 'SA'),
    child: const MyApp(),
  ));

  // بعد أول إطار. الإشعارات تطلب شبكة ورمز APNs وربما نافذة إذن، وانتظارها
  // قبل `runApp` كان يحبس الإقلاع عشرات الثواني على الأجهزة التي تعوزها
  // خدمات Google (Honor/Huawei) أو التي شبكتها بطيئة.
  WidgetsBinding.instance.addPostFrameCallback((_) {
    unawaited(_guard(
        'تهيئة الإشعارات', () => PushNotificationsService.instance.init()));
    unawaited(_guard(
        'جلب التاريخ الهجري', () async => AppUtils.sl<GetHijriDate>().call()));
  });
}

/// عمل جانبي لا يصحّ أن يُسقط التطبيق إن فشل.
Future<void> _guard(String what, Future<dynamic> Function() task) async {
  try {
    await task();
  } catch (e, s) {
    AppUtils.log('تعذّر $what: $e\n$s', levelLog: Level.error);
  }
}

void _installErrorHandlers() {
  final previous = FlutterError.onError;
  FlutterError.onError = (details) {
    previous?.call(details);
    AppUtils.log('خطأ واجهة: ${details.exception}', levelLog: Level.error);
  };
  // خطأ غير متزامن خارج شجرة الودجات: يُسجَّل ولا يُسقط التطبيق.
  PlatformDispatcher.instance.onError = (error, stack) {
    AppUtils.log('خطأ غير متزامن: $error\n$stack', levelLog: Level.error);
    return true;
  };
}

Locale _readLocale() {
  try {
    return AppUtils.instance.getLocale();
  } catch (e) {
    AppUtils.log('تعذّرت قراءة اللغة المحفوظة: $e', levelLog: Level.error);
    return const Locale('ar', 'SA');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    configLoading();
    AppUtils.contextApp = context;
    // مخزَّن تالف أو نموذج تغيّر شكله لا يصحّ أن يمنع التطبيق من الفتح.
    try {
      AppUtils.appUser = AppUtils.instance.getUser();
      AppUtils.permissions = AppUtils.instance.getLogin()?.permissions ?? [];
    } catch (e) {
      AppUtils.log('تعذّرت قراءة بيانات المستخدم المحفوظة: $e',
          levelLog: Level.error);
      AppUtils.appUser = null;
      AppUtils.permissions = [];
    }
    AppUtils.log("permissions: ${AppUtils.permissions}");
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      // ScreenUtilInit defaults this to FontSizeResolvers.width, which silently
      // overrides minTextAdapt and makes every `.sp` scale linearly with the
      // screen width — 2.4x on an iPad, 3x in landscape. Drive it from the
      // smaller of the two axes and clamp it to a narrow band instead, so text
      // keeps the same proportions on every device.
      fontSizeResolver: (fontSize, instance) {
        final scale = math
            .min(instance.scaleWidth, instance.scaleHeight)
            .clamp(0.90, 1.10);
        return fontSize * scale;
      },
      child: GetMaterialApp(
        builder: (context, child) {
          final easyLoadingChild = EasyLoading.init()(context, child);
          // Hard lock: the device's font-size / display-size accessibility
          // setting must never resize the app's text or shift its layout.
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.noScaling,
            ),
            child: easyLoadingChild,
          );
        },
        debugShowCheckedModeBanner: false,
        title: 'Smartble M',
        locale: context.locale,
        theme: ThemeApp.lightTheme,
        getPages: RouteHelper.routes,
        // theme: lightTheme,
        darkTheme: ThemeApp.lightTheme,
        supportedLocales: context.supportedLocales,
        themeMode: ThemeMode.light,
        transitionDuration: const Duration(milliseconds: 250),
        localizationsDelegates: context.localizationDelegates,
        // home: (),
        home: SplashPage(),
        // AppUtils.appUser != null
        //     ? const DashboardScreen()
        //     : const LoginScreen(),
      ),
    );
  }

  void configLoading() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.custom
      ..dismissOnTap = false
      ..indicatorColor = AppColors.DARKENGREYFONTCOLOR
      ..maskColor = AppColors.BORDERGREYCOLOR
      ..backgroundColor = Colors.transparent
      ..boxShadow = <BoxShadow>[]
      ..maskType = EasyLoadingMaskType.clear
      ..indicatorSize = 50
      ..contentPadding = EdgeInsets.zero
      ..textColor = Colors.white
      ..progressColor = Colors.white;
  }
}
