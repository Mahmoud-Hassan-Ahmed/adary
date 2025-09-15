import 'package:adary/core/conts/images.dart';
import 'package:adary/core/conts/style.dart';
import 'package:adary/core/share/widgets/custom_text_field.dart';
import 'package:adary/core/share/widgets/navBar.dart';
import 'package:adary/features/adary/presentation/widgets/profiles/customBtn.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MarketeingCode extends StatelessWidget {
  Widget _customBox({required String txt}) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    txt.tr(),
                    style: AbhayaLibreMedium.copyWith(fontSize: 17),
                  ))
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: CustomTextField(
                hintText: "اكتب هنا",
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
              const SizedBox(
                height: 15,
              ),
              const AppNavBar(
                  imagePath: Images.ARROW_BACK, headerTxt: "marketing_code"),
              const SizedBox(
                height: 120,
              ),

              Center(
                child: SizedBox(
                  height: 400,
                  width: 400,
                  child: Column(
                    children: [
                      Text(
                        "الكود".tr(),
                        style: AbhayaLibreBold.copyWith(
                            color: Color(0xff000000), fontSize: 18),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        "14040".tr(),
                        style: AbhayaLibreBold.copyWith(
                            color: Color(0xff000000), fontSize: 18),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        "نسبة العموله".tr(),
                        style: AbhayaLibreBold.copyWith(
                            color: Color(0xff000000), fontSize: 18),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        "15%".tr(),
                        style: AbhayaLibreBold.copyWith(
                            color: Color(0xff000000), fontSize: 18),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        "نشط".tr(),
                        style: AbhayaLibreBold.copyWith(
                            color: Color(0xff000000), fontSize: 18),
                      ),
                      Text(
                        "نعم".tr(),
                        style: AbhayaLibreBold.copyWith(
                            color: Color(0xff000000), fontSize: 18),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              //copy_marketing_code_link
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height: 90,
          child: Column(
            children: [
              Divider(
                color: Colors.grey.withOpacity(0.2),
              ),
              Center(child: btn(btnTitle: "save".tr())),
            ],
          ),
        ),
      ),
    );
  }
}
