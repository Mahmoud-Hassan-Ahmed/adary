import 'package:adary/core/conts/images.dart';
import 'package:adary/core/conts/style.dart';
import 'package:adary/core/share/widgets/custom_text_field.dart';
import 'package:adary/core/share/widgets/navBar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TermsConditions extends StatelessWidget {
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
          SizedBox(
            height: 10,
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: const CustomTextField(
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
              SizedBox(
                height: 15,
              ),
              const AppNavBar(
                  imagePath: Images.ARROW_BACK, headerTxt: "terms-conditions"),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
