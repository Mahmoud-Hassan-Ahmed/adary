import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/presentation/pages/login_screen.dart';
import 'package:adary/features/adary/presentation/pages/start_page.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart' show Level;

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3)).then((_) => _goNext());
  }

  /// لا تُترك الشاشة على صورة البدء مهما حدث.
  ///
  /// كان الانتقال كلّه داخل `then` بلا حماية: أي استثناء في قراءة المستخدم
  /// المحفوظ يبتلعه الـ Future فلا يُستدعى `goAndReplace` أصلًا، ويبقى الجهاز
  /// على صورة البدء إلى الأبد — وهو ما يراه المستخدم «شاشة بيضاء لا تفتح».
  void _goNext() {
    Widget next = const LoginScreen();
    try {
      AppUtils.appUser = AppUtils.instance.getUser();
      if (AppUtils.appUser != null) next = const DashboardScreen();
    } catch (e, s) {
      AppUtils.log('تعذّرت قراءة المستخدم عند البدء: $e\n$s',
          levelLog: Level.error);
    }
    AppUtils.goAndReplace(next);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
          image:
              DecorationImage(image: AssetImage('assets/images/splash.png'))),
    );
  }
}
