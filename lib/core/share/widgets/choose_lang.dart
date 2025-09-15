import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart' as esay;
import 'package:get/get.dart';

chooseLangDialog(BuildContext context, String locals) => AwesomeDialog(
    context: context,
    animType: AnimType.scale,
    dialogType: DialogType.noHeader,
    body: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Text(
            esay.tr('choose_language'),
            style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 16,
                color: AppColors.FONTCOLOR,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          CheckboxListTile(
            tileColor: Colors.white,
            value: true,
            onChanged: (value) async {
              await esay.EasyLocalization.of(AppUtils.contextApp)!
                  .setLocale(const Locale('en', 'US'));
              AppUtils.instance.setLocale('en', 'US');
              Get.updateLocale(const Locale('en', 'US'));
              Navigator.pop(context);
            },
            controlAffinity: ListTileControlAffinity.leading,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            activeColor: Colors.white,
            checkColor: locals == 'en' ? AppColors.GREYFONTCOLOR : Colors.white,
            title: Text(
              esay.tr('English'),
              style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  color: AppColors.FONTCOLOR),
              textAlign: TextAlign.left,
            ),
          ),
          const Divider(
            height: 5,
            indent: 10,
            endIndent: 10,
          ),
          CheckboxListTile(
            value: true,
            onChanged: (value) async {
              await esay.EasyLocalization.of(AppUtils.contextApp)!
                  .setLocale(const Locale('ar', 'SA'));
              AppUtils.instance.setLocale('ar', 'SA');
              Get.updateLocale(const Locale('ar', 'SA'));
              Navigator.pop(context);
            },
            controlAffinity: ListTileControlAffinity.leading,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            activeColor: Colors.white,
            checkColor: locals == 'ar' ? AppColors.FONTCOLOR : Colors.white,
            title: Text(
              esay.tr('arabic'),
              style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 11,
                  color: AppColors.FONTCOLOR),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    ));
