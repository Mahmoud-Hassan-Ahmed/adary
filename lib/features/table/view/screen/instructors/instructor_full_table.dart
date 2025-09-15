import 'package:adary/core/share/widgets/my_app_bar.dart';
import 'package:adary/features/table/utils/app_colors.dart';
import 'package:adary/features/table/utils/dimensions.dart';
import 'package:adary/features/table/utils/style.dart';
import 'package:adary/features/table/view/base/app_bar.dart';
import 'package:adary/features/table/view/base/table.dart';
import 'package:dotted_border/dotted_border.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart' as easy;

class InstructorFullTable extends StatefulWidget {
  Map<String, dynamic> table;
  InstructorFullTable({super.key, required this.table});
  @override
  State<InstructorFullTable> createState() => _InstructorFullTableState();
}

class _InstructorFullTableState extends State<InstructorFullTable> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(title: easy.tr('back')),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              _header(
                  classTabel: easy.tr("teacher_name"),
                  grade: widget.table["teacher_name"]),
              const SizedBox(
                height: 30,
              ),
              AppTable(
                table: widget.table,
                isInstructor: true,
              ),
              // end of table
              const SizedBox(
                height: 20,
              ),
            ],
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
              style:
                  AlMaraiaBold.copyWith(fontSize: 20, color: Color(0xFF9ED3D7)),
            ),
            Text(
              "$grade",
              style: AlMaraiaBold.copyWith(
                  fontSize: 19, color: AppColors.SECONDERYCOLOR),
            ),
          ],
        ));
  }
}
