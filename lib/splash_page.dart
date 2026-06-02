import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/presentation/pages/login_screen.dart';
import 'package:adary/features/adary/presentation/pages/start_page.dart';
import 'package:adary/features/table/view/screen/dashboard/dashboardScreen.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(const Duration(seconds: 3)).then((onValue) => {
          AppUtils.appUser = AppUtils.instance.getUser(),
          if (AppUtils.appUser != null)
            {AppUtils.go(const DashboardScreen())}
          else
            {AppUtils.go(const LoginScreen())}
        });
    super.initState();
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
