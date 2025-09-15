import 'package:adary/features/table/controller/notification_controller.dart';
import 'package:adary/features/table/utils/app_colors.dart';
import 'package:adary/features/table/utils/dimensions.dart';
import 'package:adary/features/table/utils/images.dart';
import 'package:adary/features/table/view/base/app_main_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart' as easy;

import '../../../../utils/style.dart';

class Notification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Get.find<NotificationController>().getNotificationCount();
        await Get.find<NotificationController>().getNotification();
      },
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  height: 74,
                ),
                Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        child: Row(
                          children: [
                            const Icon(Icons.arrow_back_ios),
                            Text(
                              easy.tr("back"),
                              style: AlMaraiaRegular.copyWith(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    )),
                SizedBox(
                  height: 47,
                ),
                GetBuilder<NotificationController>(
                    builder: (notificationController) {
                  return notificationController.isLoadingNotification
                      ? _loader()
                      : Column(
                          children:
                              notificationController.notification.map((e) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(e.message.toString()),
                                  GestureDetector(
                                      onTap: () {
                                        notificationController
                                            .deleteNotification(
                                                notificationId: e.id!);
                                      },
                                      child: notificationController
                                              .isDeletingNotification
                                          ? notificationController.selectedId ==
                                                  e.id
                                              ? const SizedBox(
                                                  width: 15,
                                                  height: 15,
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: AppColors
                                                        .SECONDERYCOLOR,
                                                    strokeWidth: 3,
                                                  ),
                                                )
                                              : SvgPicture.asset(
                                                  Images.DELETE_ICON)
                                          : SvgPicture.asset(
                                              Images.DELETE_ICON))
                                ],
                              ),
                            );
                          }).toList(),
                        );
                }),
                SizedBox(
                  height: 21,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _loader() {
    return AppLoader(
        loaderView: Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Container(
                width: Get.context!.width - 90,
                height: 8,
                decoration: BoxDecoration(
                    color: AppColors.SECONDERYCOLOR,
                    borderRadius: BorderRadius.circular(10)),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Container(
                width: Get.context!.width - 90,
                height: 8,
                decoration: BoxDecoration(
                    color: AppColors.SECONDERYCOLOR,
                    borderRadius: BorderRadius.circular(10)),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Container(
                width: Get.context!.width - 90,
                height: 8,
                decoration: BoxDecoration(
                    color: AppColors.SECONDERYCOLOR,
                    borderRadius: BorderRadius.circular(10)),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Container(
                width: Get.context!.width - 90,
                height: 8,
                decoration: BoxDecoration(
                    color: AppColors.SECONDERYCOLOR,
                    borderRadius: BorderRadius.circular(10)),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Container(
                width: Get.context!.width - 90,
                height: 8,
                decoration: BoxDecoration(
                    color: AppColors.SECONDERYCOLOR,
                    borderRadius: BorderRadius.circular(10)),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Container(
                width: Get.context!.width - 90,
                height: 8,
                decoration: BoxDecoration(
                    color: AppColors.SECONDERYCOLOR,
                    borderRadius: BorderRadius.circular(10)),
              ),
            ],
          ),
        )
      ],
    ));
  }
}
