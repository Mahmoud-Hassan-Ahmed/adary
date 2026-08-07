import 'dart:math' as math;

import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/conts/text.dart';
import 'package:adary/core/theme/theme_app.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/domain/usecases/get_hijri_date.dart';
import 'package:adary/features/adary/presentation/pages/login_screen.dart';
import 'package:adary/features/adary/presentation/pages/start_page.dart';
import 'package:adary/features/table/helper/route_helper.dart';
import 'package:adary/features/table/view/screen/dashboard/dashboardScreen.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:adary/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:adary/features/table/helper/get_di.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await findSystemLocale();
  await EasyLocalization.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await init();
  await di.init();
  final locale = AppUtils.instance.getLocale();

  AppUtils.sl<GetHijriDate>().call();
  runApp(EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'), // English
        Locale('ar', 'SA'), // A
      ],
      path: ConstsApp.pathTranslate,
      startLocale: locale,
      saveLocale: true,
      fallbackLocale: locale,
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    configLoading();
    AppUtils.contextApp = context;
    AppUtils.appUser = AppUtils.instance.getUser();
    AppUtils.permissions = AppUtils.instance.getLogin()?.permissions ?? [];
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
