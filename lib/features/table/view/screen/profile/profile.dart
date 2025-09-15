import 'package:adary/features/table/controller/authintication_controller.dart';
import 'package:adary/features/table/controller/notification_controller.dart';
import 'package:adary/features/table/helper/route_helper.dart';
import 'package:adary/features/table/utils/images.dart';
import 'package:adary/features/table/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart' as easy;

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    Get.find<NotificationController>().getNotificationCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          SizedBox(
            height: 139,
          ),
          GestureDetector(
            onTap: () => Get.toNamed(RouteHelper.gePrivacyRoute()),
            child: _listItem(
                title: easy.tr("privacy_policy2"),
                iconPath: Images.PRIVACY_ICON,
                extreaText: false),
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              Get.find<NotificationController>().getNotification();
              Get.toNamed(RouteHelper.geNotificationRoute());
            },
            child: _listItem(
                title: easy.tr("notification"),
                iconPath: Images.NOTIFICATION_ICON,
                extreaText: true),
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () => Get.toNamed(RouteHelper.geCallUsRoute()),
            child: _listItem(
                title: easy.tr("contact_us"),
                iconPath: "null",
                icon: Icons.message_outlined,
                extreaText: false),
          ),
          // SizedBox(
          //   height: 10,
          // ),
          // GestureDetector(
          //   onTap: () => _launchInWebView(),
          //   child: _listItem(
          //       title: "whoe_we".tr(),
          //       iconPath: Images.WHO_WE_ICON,
          //       extreaText: false),
          // ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () => Get.toNamed(RouteHelper.getSettingRoute()),
            child: _listItem(
                title: easy.tr("setting"),
                iconPath: Images.SHARE_APP_ICON,
                icon: Icons.settings_outlined,
                extreaText: false),
          ),
          SizedBox(
            height: 10,
          ),
          GetBuilder<AuthenticationController>(
              builder: (authenticationController) {
            return GestureDetector(
              onTap: () {
                authenticationController.LogOut();

                Get.offAllNamed(RouteHelper.getLogOutRoute());
              },
              child: _listItem(
                  title: easy.tr("logout"),
                  iconPath: Images.SHARE_APP_ICON,
                  icon: Icons.logout,
                  extreaText: false),
            );
          })
        ],
      )),
    );
  }

  Widget _listItem(
      {required String title,
      required String iconPath,
      required extreaText,
      IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          icon == null
              ? SvgPicture.asset(
                  iconPath,
                  width: 30,
                  height: 30,
                )
              : Icon(icon),
          SizedBox(
            width: 16,
          ),
          Text(
            title,
            style: AlMaraia.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: const Color(0xFF4B4949)),
          ),
          extreaText
              ? Row(
                  children: [
                    const Text("("),
                    GetBuilder<NotificationController>(
                        builder: (notificationController) {
                      return notificationController.isLoading
                          ? const SizedBox(
                              width: 10,
                              height: 10,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ))
                          : Text(
                              " لديك ${notificationController.notificationCounter} تنبيهات ",
                              style: AlMaraia.copyWith(
                                  fontSize: 19, color: const Color(0xFFFD0571)),
                            );
                    }),
                    const Text(")"),
                  ],
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}
