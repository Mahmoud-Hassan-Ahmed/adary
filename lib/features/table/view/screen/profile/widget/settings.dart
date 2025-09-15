import 'package:adary/features/table/controller/localization_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../utils/app_constants.dart';
import '../../../../utils/dimensions.dart';
import '../../../../utils/style.dart';
import 'package:easy_localization/easy_localization.dart' as easy;

class AppSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: 74,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(
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
            GetBuilder<LocalizationController>(
                builder: (localizationController) {
              return GestureDetector(
                onTap: () {
                  localizationController.setLanguage(Locale(
                    localizationController.isLtr
                        ? AppConstants.languages[0].languageCode
                        : AppConstants.languages[1].languageCode,
                    localizationController.isLtr
                        ? AppConstants.languages[0].countryCode
                        : AppConstants.languages[1].countryCode,
                  ));
                  localizationController
                      .setSelectIndex(localizationController.isLtr ? 0 : 1);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        easy.tr("changeLang"),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      localizationController.isLtr
                          ? const Text(
                              "عربي",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                              ),
                            )
                          : const Text(
                              "EN",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                              ),
                            )
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
