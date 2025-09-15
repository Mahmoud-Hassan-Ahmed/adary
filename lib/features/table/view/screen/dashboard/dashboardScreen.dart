import 'package:adary/core/share/widgets/my_app_bar.dart';
import 'package:adary/features/table/controller/dashBoard_controller.dart';
import 'package:adary/features/table/utils/app_colors.dart';
import 'package:adary/features/table/utils/images.dart';
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
        appBar: MyAppBar(title: easy.tr('SchoolTable')),
        bottomNavigationBar:
            GetBuilder<DashBoardController>(builder: (dashBoardController) {
          return Container(
            decoration:
                BoxDecoration(border: Border.all(color: AppColors.GREYCOLOR)),
            height: 90,
            width: context.width,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    BottomNavItem(
                      iconPath: dashBoardController.pageIndex == 0
                          ? Images.INSTRUCTOR_ICON
                          : Images.INSTRUCTOR_ICON,
                      isSelected: dashBoardController.pageIndex == 0,
                      onTap: () => dashBoardController.onTapPager(0),
                      pageName: easy.tr("instructors"),
                    ),
                    BottomNavItem(
                      iconPath: dashBoardController.pageIndex == 1
                          ? Images.FILLED_LAP_ICON
                          : Images.LAP_ICON,
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
            ),
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
