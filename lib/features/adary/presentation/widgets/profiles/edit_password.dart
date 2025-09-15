import 'package:adary/core/conts/images.dart';
import 'package:adary/core/conts/style.dart';
import 'package:adary/core/share/widgets/custom_text_field.dart';
import 'package:adary/core/share/widgets/navBar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditPassword extends StatelessWidget {
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
              child: CustomTextField(
                hintText: "write_here".tr(),
              ))
        ],
      ),
    );
  }

  Widget _hintTxt({required String txt}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.black)),
          SizedBox(
            width: 10,
          ),
          Text(txt.tr())
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
                  imagePath: Images.ARROW_BACK,
                  headerTxt: "edit_password".tr()),
              SizedBox(
                height: 30,
              ),
              _customBox(txt: "old_password".tr()),
              SizedBox(
                height: 20,
              ),
              _customBox(txt: "new_password".tr()),
              SizedBox(
                height: 20,
              ),
              _hintTxt(
                  txt:
                      "لا يمكن لكلمة المرور أن تكون مشابهة للمعلومات الشخصية الأخرى"),
              SizedBox(
                height: 10,
              ),
              _hintTxt(
                  txt: "كلمة المرور الخاصة بك يجب أن تتضمن 8 حروف على الأقل."),
              _hintTxt(txt: "لا يمكن أن تكون كلمة المرور شائعة الاستخدام."),
              SizedBox(
                height: 10,
              ),
              _hintTxt(
                  txt: "لا يمكن أن تكون كلمة المرور مكونة من أرقام فقط.".tr()),
              SizedBox(
                height: 20,
              ),
              _customBox(txt: "confirm_new_password".tr()),
              SizedBox(
                height: 220,
              ),
              Divider(
                color: Colors.grey.withOpacity(0.2),
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
            ],
          ),
        ),
      ),
    );
  }
}
