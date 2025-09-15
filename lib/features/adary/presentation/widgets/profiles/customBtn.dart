import 'package:adary/core/conts/style.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class btn extends StatelessWidget {
  final String btnTitle;

  btn({required this.btnTitle});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 60,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xff060606)),
      child: Center(
        child: Text(
          btnTitle.tr(),
          style: AbhayaLibreMedium.copyWith(color: Colors.white, fontSize: 22),
        ),
      ),
    );
  }
}
