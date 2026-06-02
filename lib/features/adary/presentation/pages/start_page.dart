import 'package:adary/core/conts/images.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/presentation/pages/main_screen.dart';
import 'package:adary/features/adary/presentation/pages/main_screen2.dart';
import 'package:adary/features/adary/presentation/pages/profile_screen.dart';
import 'package:adary/features/adary/presentation/widgets/app_bar/with_carousal.dart';
import 'package:adary/features/adary/presentation/widgets/dashboard/bottom_nav_bar.dart';
import 'package:adary/features/table/view/screen/dashboard/widget/custom_segmented_button.dart';
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
  int profile = 0;
  @override
  Widget build(BuildContext context) {
    AppUtils.contextApp = context;
    return Scaffold(
        bottomNavigationBar: Container(
          height: 90,
          width: double.infinity,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                  iconPath: Images.HOME_SCREEN_ICON,
                  isSelected: profile == 0,
                  onTap: () {
                    setState(() {
                      // startPage = 0;
                      profile = 0;
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

                BottomNavItem(
                  iconPath: Images.USER_SQUARE,
                  isSelected: profile == 1,
                  onTap: () {
                    setState(() {
                      // startPage = 3;
                      profile = 1;
                    });
                  },
                  pageName: "profile".tr(),
                ),
              ]),
        ),
        body: profile == 0
            ? CustomScrollView(
                slivers: [
                  SliverPersistentHeader(
                    pinned: true,
                    floating: false,
                    delegate: WithCarousalBar(),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          CustomSegmentedButton(
                            onChanged: (value) {
                              setState(() {
                                startPage = value;
                              });
                            },
                          ),
                          Expanded(
                            child: startPage == 0
                                ? const MainScreen()
                                : const MainScreen2(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Profile());
  }
}
