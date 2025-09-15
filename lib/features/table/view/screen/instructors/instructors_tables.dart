import 'package:adary/core/share/widgets/my_app_bar.dart';
import 'package:adary/features/table/controller/calender_controller.dart';
import 'package:adary/features/table/controller/class_room_controller.dart';
import 'package:adary/features/table/controller/teacher_page_controller.dart';
import 'package:adary/features/table/utils/app_colors.dart';
import 'package:adary/features/table/utils/dimensions.dart';
import 'package:adary/features/table/utils/style.dart';
import 'package:adary/features/table/view/base/app_bar.dart';
import 'package:adary/features/table/view/base/table.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../base/days_drawer.dart';
import 'package:easy_localization/easy_localization.dart' as easy;

import 'widget/dropDownBtn.dart';

class InstructorsFullTable extends StatefulWidget {
  const InstructorsFullTable({super.key});

  @override
  State<InstructorsFullTable> createState() => _InstructorsFullTableState();
}

class _InstructorsFullTableState extends State<InstructorsFullTable> {
  @override
  void initState() {
    super.initState();

    //Get.find<TeacherPageController>().convertToList();
  }

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;

    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(title: easy.tr('back')),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // const SizedBox(
              //   height: 40,
              // ),
              // // const MainAppBar(),
              const SizedBox(
                height: 10,
              ),

              const InstructorDropDown(),
              // end of drop down
              const SizedBox(
                height: 20,
              ),

              SizedBox(
                height: orientation == Orientation.portrait
                    ? context.height / 0.9
                    : context.height * 2,
                width: context.width,
                child: GetBuilder<TeacherPageController>(
                    builder: (teacherPageController) {
                  return PageView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: teacherPageController.teachersTableList.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, instructorIndex) {
                        return UnconstrainedBox(
                          child: SizedBox(
                              height: orientation == Orientation.portrait
                                  ? context.height / 0.9
                                  : context.height * 2,
                              width: context.width,
                              child: Column(
                                children: [
                                  _header(
                                      classTabel: easy.tr("teacher_name"),
                                      grade: teacherPageController
                                              .teachersTableList[
                                          instructorIndex]['teacher_name']),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  AppTable(
                                      table: teacherPageController
                                          .teachersTableList[instructorIndex],
                                      isInstructor: true)
                                ],
                              )),
                        );
                      });
                }),
              ),
              // end of table
            ],
          ),
        ),
      ),
    );
  }

  Widget _sessions({required String sessionNumber}) {
    return Container(
      height: 60,
      width: 107,
      child: Center(
        child: Text(
          easy.tr(
              "${Get.find<ClassRoomController>().sessions["$sessionNumber"]}"),
          style: AlMaraia.copyWith(
              fontSize: 20, color: AppColors.FONTCOLOR.withOpacity(0.7)),
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

  Widget _tableRow({required String instructorIndex, required String txt}) {
    return Container(
      width: context.width - 100,
      height: context.height / 1.2,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (context, sessionNumber) {
          return Row(
            children: [
              Column(
                children: [
                  _sessions(sessionNumber: sessionNumber.toString()),
                  // end of session name
                  Container(
                      width: 120,
                      height: context.height * 0.1333,
                      color: Get.find<CalednerController>().todayIndex == 0
                          ? AppColors.TABLEBACKGROUNDCOLOR
                          : null,
                      child: DottedBorder(
                          borderType: BorderType.RRect,
                          dashPattern: [7, 6],
                          color: Colors.black,
                          strokeWidth: 1,
                          padding: EdgeInsets.all(6),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  txt,
                                  style: AlMaraia.copyWith(fontSize: 19),
                                ),
                              ],
                            ),
                          ))),
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
