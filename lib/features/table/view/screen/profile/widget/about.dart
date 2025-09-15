import 'package:adary/features/table/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart' as easy;

import '../../../../utils/style.dart';

class About extends StatelessWidget {
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
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.PADDING_SIZE_DEFAULT),
              child: Row(
                children: [
                  Text(
                    "من نحن",
                    style: AlMaraiaBold.copyWith(fontSize: 18),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.PADDING_SIZE_DEFAULT),
              child: Wrap(
                children: [
                  Text(
                    "نص الشروط والاحكام هنا نص الشروط والاحكام هنا نص الشروط والاحكام هنا نص الشروط والاحكام هنا نص الشروط والاحكام هنا نص الشروط والاحكام هنا نص الشروط والاحكام هنا ",
                    style: AlMaraiaRegular.copyWith(fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
