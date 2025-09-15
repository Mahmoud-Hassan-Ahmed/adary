import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/conts/style.dart';
import 'package:adary/core/share/widgets/custom_text_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Message extends StatelessWidget {
  final String title;
  Message({required this.title});

  final String txt = "غدا تعليق";
  final String txt1 = "مراجعة الإدارة";
  final String txt2 = "الرجاء رفع الغياب";
  final String txt3 = "الرجاء الالتزام بوقت الحصة";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.2,
          scrolledUnderElevation: 0.0,
          title: Text(title.tr(),
              style: AbhayaLibreExtraBold.copyWith(
                  color: AppColors.SECONDERYCOLOR, fontSize: 28)),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 396,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text("اختر رسالة سريعة للأستاذ " + title,
                    style: AbhayaLibreBold.copyWith(
                      fontSize: 20,
                      color: AppColors.triblethree,
                    )),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  direction: Axis.horizontal,
                  children: [
                    Container(
                      margin: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: AppColors.triblethree)),
                      height: 33,
                      child: IntrinsicWidth(
                          child: Center(
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(txt,
                                style: AbhayaLibre.copyWith(
                                  color: AppColors.triblethree,
                                ))),
                      )),
                    ),
                    Container(
                      margin: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: AppColors.triblethree)),
                      height: 33,
                      child: IntrinsicWidth(
                          child: Center(
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(txt1,
                                style: AbhayaLibre.copyWith(
                                  color: AppColors.triblethree,
                                ))),
                      )),
                    ),
                    Container(
                      margin: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: AppColors.triblethree)),
                      height: 33,
                      child: IntrinsicWidth(
                          child: Center(
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(txt2,
                                style: AbhayaLibre.copyWith(
                                  color: AppColors.triblethree,
                                ))),
                      )),
                    ),
                    Container(
                      margin: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: AppColors.triblethree)),
                      height: 33,
                      child: IntrinsicWidth(
                          child: Center(
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(txt3,
                                style: AbhayaLibre.copyWith(
                                  color: AppColors.triblethree,
                                ))),
                      )),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "او قم بكتابة نص الرسالة هنا",
                    style: AbhayaLibreBold.copyWith(fontSize: 19),
                  )),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                    child: CustomTextField(
                  titleText: "اكتب هنا ...",
                  maxLines: 6,
                )),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                  child: Container(
                height: 54,
                width: 280,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(
                    "send".tr(),
                    style: AbhayaLibreMedium.copyWith(
                        color: Colors.white, fontSize: 24),
                  ),
                ),
              )),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    ));
  }
}
