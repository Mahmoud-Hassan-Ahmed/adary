import 'package:adary/core/conts/images.dart';
import 'package:adary/core/conts/style.dart';
import 'package:adary/core/share/widgets/custom_text_field.dart';
import 'package:adary/core/share/widgets/navBar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContactUs extends StatelessWidget {
  Widget _customBox({required String txt, int maxLines = 1}) {
    return Container(
      child: Column(
        children: [
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: CustomTextField(
                hintText: txt.tr(),
                maxLines: maxLines,
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              const AppNavBar(
                  imagePath: Images.ARROW_BACK, headerTxt: "contact_us"),
              SizedBox(
                height: 30,
              ),
              _customBox(txt: "الأسم"),
              SizedBox(
                height: 15,
              ),
              _customBox(txt: "رقم الهاتف"),
              SizedBox(
                height: 15,
              ),
              _customBox(txt: "البريد الألكتروني"),
              SizedBox(
                height: 15,
              ),
              _customBox(txt: "نوع الرسالة"),
              SizedBox(
                height: 15,
              ),
              _customBox(txt: "اكتب هنا", maxLines: 7),
              SizedBox(
                height: 15,
              ),
              Center(
                child: Container(
                  width: 250,
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xff060606)),
                  child: Center(
                    child: Text(
                      "save".tr(),
                      style: AbhayaLibreMedium.copyWith(
                          color: Colors.white, fontSize: 22),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 60,
              )
            ],
          ),
        ),
      ),
    );
  }
}
