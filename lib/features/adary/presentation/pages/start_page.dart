import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/conts/images.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/presentation/pages/main_screen.dart';
import 'package:adary/features/adary/presentation/pages/notification.dart';
import 'package:adary/features/adary/presentation/pages/profile_screen.dart';
import 'package:adary/features/adary/presentation/pages/send_page.dart';
import 'package:adary/features/adary/presentation/widgets/dashboard/bottom_nav_bar.dart';
// import 'package:adary/features/table/view/screen/profile/profile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  var startPage = 0;
  @override
  Widget build(BuildContext context) {
    AppUtils.contextApp = context;
    return SafeArea(
      child: Scaffold(
          bottomNavigationBar: Container(
            decoration:
                BoxDecoration(border: Border.all(color: AppColors.GREYCOLOR)),
            height: 90,
            width: double.infinity,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BottomNavItem(
                    iconPath: Images.HOME_SCREEN_ICON,
                    isSelected: startPage == 0,
                    onTap: () {
                      setState(() {
                        startPage = 0;
                      });
                    },
                    pageName: "main".tr(),
                  ),
                  // BottomNavItem(
                  //   iconPath: Images.SEND_ICON,
                  //   isSelected: startPage == 1,
                  //   onTap: () {
                  //     setState(() {
                  //       startPage = 1;
                  //     });
                  //   },
                  //   pageName: "save".tr(),
                  // ),
                  // BottomNavItem(
                  //   iconPath: Images.NOTI_ICON,
                  //   isSelected: startPage == 2,
                  //   onTap: () {
                  //     setState(() {
                  //       startPage = 2;
                  //     });
                  //   },
                  //   pageName: "notification".tr(),
                  // ),
                  BottomNavItem(
                    iconPath: Images.USER_SQUARE,
                    isSelected: startPage == 3,
                    onTap: () {
                      setState(() {
                        startPage = 3;
                      });
                    },
                    pageName: "profile".tr(),
                  ),
                ]),
          ),
          body: startPage == 0
              ? const MainScreen()
              : startPage == 1
                  ? SendScreen()
                  : startPage == 2
                      ? NotificationScreen()
                      : Profile()),
    );
  }
}
