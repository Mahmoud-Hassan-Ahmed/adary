import 'package:adary/core/conts/images.dart';
import 'package:adary/core/conts/style.dart';
import 'package:adary/core/share/widgets/custom_text_field.dart';
import 'package:adary/core/share/widgets/navBar.dart';
import 'package:adary/features/adary/presentation/widgets/profiles/customBtn.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditProfile extends StatelessWidget {
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
              AppNavBar(
                  imagePath: Images.ARROW_BACK, headerTxt: "edit_profile".tr()),
              SizedBox(
                height: 30,
              ),
              _customBox(txt: "الاسم الأول*"),
              SizedBox(
                height: 20,
              ),
              _customBox(txt: "الاسم الأخير*"),
              SizedBox(
                height: 20,
              ),
              _customBox(txt: "عنوان بريد إلكتروني*"),
              SizedBox(
                height: 20,
              ),
              _customBox(txt: "رقم الجوال"),
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
