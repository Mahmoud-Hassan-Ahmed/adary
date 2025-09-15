import 'package:adary/core/share/widgets/my_app_bar.dart';
import 'package:adary/features/table/view/base/app_bar.dart';
import 'package:adary/features/table/view/base/table.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../controller/calender_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/dimensions.dart';
import '../../../../utils/style.dart';
import 'package:easy_localization/easy_localization.dart' as easy;

class AllTable extends StatefulWidget {
  Map<String, dynamic> singleClass;

  AllTable({required this.singleClass});
  @override
  State<AllTable> createState() => _AllTableState();
}

class _AllTableState extends State<AllTable> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {},
      color: AppColors.SECONDERYCOLOR,
      child: SafeArea(
        child: Scaffold(
          appBar: MyAppBar(title: easy.tr('back')),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // const SizedBox(
                //   height: 60,
                // ),
                // const MainAppBar(),
                const SizedBox(
                  height: 20,
                ),

                const SizedBox(
                  height: 20,
                ),

                _header(
                    classTabel: easy.tr("class_table"),
                    grade: widget.singleClass["classroom_name"].toString()),
                const SizedBox(
                  height: 10,
                ),
                AppTable(table: widget.singleClass, isInstructor: false),
                // end of table
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header({required String classTabel, required String grade}) {
    return Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.PADDING_SIZE_DEFAULT),
        child: Row(
          children: [
            Text(
              "$classTabel: ",
              style: AlMaraiaBold.copyWith(
                  fontSize: 20, color: const Color(0xFF9ED3D7)),
            ),
            Text(
              grade,
              style: AlMaraiaBold.copyWith(
                  fontSize: 19, color: AppColors.SECONDERYCOLOR),
            ),
          ],
        ));
  }
}
