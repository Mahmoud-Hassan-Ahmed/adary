import 'package:adary/core/share/widgets/my_app_bar.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/table/controller/dashBoard_controller.dart';
import 'package:adary/features/table/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart' as easy;

import 'widget/bottom_nav_bar.dart';

class DashBoardScreen extends GetView<DashBoardController> {
  const DashBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: GetBuilder<DashBoardController>(
            builder: (controller) {
              String title = easy.tr('SchoolTable');

              if (controller.pageIndex == 0) {
                title = easy.tr('instructors');
              } else if (controller.pageIndex == 1) {
                title = easy.tr('laps');
              }

              return MyAppBar(title: title);
            },
          ),
        ),
        bottomNavigationBar:
            GetBuilder<DashBoardController>(builder: (dashBoardController) {
          return Container(
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                border: Border.all(color: AppColors.SECONDERYCOLOR),
                borderRadius: BorderRadius.circular(50)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (AppUtils.checkPermission([
                    '/dashboard/table-by-teachers/',
                  ]))
                    BottomNavItem(
                      iconPath: "assets/icons/icons app2-02 1.svg",
                      isSelected: dashBoardController.pageIndex == 0,
                      onTap: () => dashBoardController.onTapPager(0),
                      pageName: easy.tr("instructors"),
                    ),
                  if (AppUtils.checkPermission(
                      ['/dashboard/table-by-classroom/']))
                    BottomNavItem(
                      iconPath: "assets/icons/laps-icon.svg",
                      isSelected: dashBoardController.pageIndex == 1,
                      onTap: () => dashBoardController.onTapPager(1),
                      pageName: easy.tr("laps"),
                    ),
                  // BottomNavItem(
                  //   iconPath: dashBoardController.pageIndex == 2
                  //       ? Images.FILLED_WAITING_ICON
                  //       : Images.WAITING_ICON,
                  //   isSelected: dashBoardController.pageIndex == 2,
                  //   onTap: () => dashBoardController.onTapPager(2),
                  //   pageName: easy.tr("waiting"),
                  // ),
                  // BottomNavItem(
                  //   iconPath: dashBoardController.pageIndex == 3
                  //       ? Images.FILLED_PROFILE_ICON
                  //       : Images.PROFILE_ICON,
                  //   isSelected: dashBoardController.pageIndex == 3,
                  //   onTap: () => dashBoardController.onTapPager(3),
                  //   pageName: easy.tr("profile"),
                  // ),
                ]),
          );
        }),
        body: GetBuilder<DashBoardController>(
          builder: (homeController) {
            return PageView(
              controller: homeController.pageController,
              onPageChanged: homeController.onPageChanged,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: homeController.children,
            );
          },
        ),
      ),
    );
  }
}
