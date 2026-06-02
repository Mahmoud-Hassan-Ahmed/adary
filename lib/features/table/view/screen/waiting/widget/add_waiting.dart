import 'package:adary/core/share/widgets/btn_app.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/presentation/pages/done_added_page.dart';
import 'package:adary/features/adary/presentation/widgets/text/label_main_text.dart';
import 'package:adary/features/table/controller/calender_controller.dart';
import 'package:adary/features/table/controller/teatcher_controller.dart';
import 'package:adary/features/table/utils/app_colors.dart';
import 'package:adary/features/table/utils/dimensions.dart';
import 'package:adary/features/table/utils/images.dart';
import 'package:adary/features/table/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart' as easy;

import '../../../base/app_main_loader.dart';
import '../../../base/back_btn.dart';

class AddWaititng extends StatefulWidget {
  String day;

  AddWaititng({required this.day});
  @override
  State<AddWaititng> createState() => _AddWaititngState();
}

class _AddWaititngState extends State<AddWaititng> {
  @override
  void initState() {
    super.initState();
    Get.find<TeacherController>().successmessages.clear();
    Get.find<TeacherController>().failedmessages.clear();
    Get.find<TeacherController>()
        .getAllTeachers(reload: false, dayNum: widget.day);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(14),
        child: GetBuilder<TeacherController>(builder: (teacherController) {
          return teacherController.isLoading
              ? _addLoader()
              : BtnApp(
                  label: 'حسناً ',
                  onTap: () async {
                    await teacherController
                        .setAbsentTeachers(
                            dayNum:
                                Get.find<CalednerController>().selectedDayIndex)
                        .then((value) {
                      if (Get.find<TeacherController>()
                          .failedmessages
                          .isNotEmpty) {
                        _showMyDialog();
                      } else {
                        AppUtils.go(const DoneAddedPage(
                            label: 'تم إضافة المعلمين المتغيبين بنجاح',
                            title: 'حصص الانتظار   '));
                      }
                    });
                  },
                );
        }),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LabelMainText(
                  text: easy.tr("upsent_teacher"),
                  fontSize: 15,
                  color: Colors.blue,
                ),
                BackBtn(),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),

          Expanded(
            child: GetBuilder<TeacherController>(builder: (teacherController) {
              return teacherController.isLoading
                  ? _loader()
                  : _content(teacherController: teacherController);
            }),
          ),
          SizedBox(
            height: 17,
          ),

          // end of instructor list

          // end of add btn
        ],
      ),
    );
  }

  Widget _loader() {
    return AppLoader(
        loaderView: Padding(
            padding: EdgeInsets.symmetric(horizontal: 52),
            child: SizedBox(
              height: 400,
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: 10,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1,
                  mainAxisExtent: context.height / 15,
                ),
                itemBuilder: (_, index) => Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Container(
                        width: 264,
                        height: 8,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(5)),
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }

  Widget _content({required TeacherController teacherController}) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: GridView.builder(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: teacherController.teacherList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            crossAxisSpacing: 1,
            mainAxisSpacing: 1,
            mainAxisExtent: context.height / 15,
          ),
          itemBuilder: (_, index) => Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    teacherController.toggleAbsent(
                        instructorID: teacherController.teacherList[index].id!);
                  },
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      color:
                          teacherController.teacherList[index].hasAbsentToday!
                              ? AppColors.SECONDERYCOLOR
                              : AppColors.MAINCOLOR,
                      border: Border.all(
                          color: teacherController
                                  .teacherList[index].hasAbsentToday!
                              ? AppColors.SECONDERYCOLOR
                              : AppColors.FONTCOLOR,
                          width: 2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                        child:
                            teacherController.teacherList[index].hasAbsentToday!
                                ? Icon(
                                    Icons.done,
                                    color: AppColors.MAINCOLOR,
                                    size: 20,
                                  )
                                : const SizedBox.shrink()),
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                SizedBox(
                  width: 200,
                  child: Text(
                    teacherController.teacherList[index].name.toString(),
                    style: AlMaraiaBold.copyWith(
                        fontSize: 16, overflow: TextOverflow.ellipsis),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _addLoader() {
    return AppLoader(
        loaderView: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.PADDING_SIZE_DEFAULT),
              child: Center(
                child: Container(
                  width: 327,
                  height: 56,
                  decoration: BoxDecoration(
                      color: AppColors.SECONDERYCOLOR,
                      borderRadius: BorderRadius.circular(25)),
                  child: Center(
                    child: Text(
                      "اضافة  ",
                      style: AlMaraiaBold.copyWith(
                          fontSize: 18, color: AppColors.MAINCOLOR),
                    ),
                  ),
                ),
              ),
            )));
  }

  void _showMyDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(content:
            StatefulBuilder(// You need this, notice the parameters below:
                builder: (BuildContext context, StateSetter setState) {
          return Container(
            width: context.width,
            height: context.height / 2,
            child: Column(
              children: [
                // GestureDetector(
                //   onTap: () => Get.back(),
                //   child: Padding(
                //       padding: const EdgeInsets.only(
                //           left: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.end,
                //         children: [
                //           SvgPicture.asset(
                //             Images.CLOSE_ICON,
                //           ),
                //         ],
                //       )),
                // ),
                SizedBox(
                  height: 20,
                ),
                Center(child: Image.asset(Images.CHECK_ICON)),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: context.width - 20,
                  height: 200,
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(children: [
                      ...Get.find<TeacherController>()
                          .failedmessages
                          .map((e) => Column(children: [
                                Center(
                                    child: Text(
                                  e["title"].toString(),
                                  style: AlMaraiaBold.copyWith(
                                      fontSize: 16, color: Colors.red),
                                )),
                                Wrap(children: [
                                  Text(
                                    e["note"].toString(),
                                    style: AlMaraiaBold.copyWith(fontSize: 16),
                                  )
                                ]),
                                const SizedBox(
                                  height: 10,
                                )
                              ])),

                      // Get.find<TeacherController>()
                      //             .failedmessages
                      //             .map((e) => e["note"].toString() + "\n")
                      //             .toString()
                      // Center(
                      //   child: Wrap(
                      //     children: [
                      //       Text(
                      //         Get.find<TeacherController>()
                      //             .failedmessages
                      //             .map((e) => e["note"].toString() + "\n")
                      //             .toString(),
                      //         style: AlMaraiaBold.copyWith(fontSize: 16),
                      //       )
                      //     ],
                      //   ),
                      // ),
                    ]),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () {
                    Get
                      ..back()
                      ..back();
                  },
                  child: Container(
                    width: 327,
                    height: 56,
                    decoration: BoxDecoration(
                        color: AppColors.SECONDERYCOLOR,
                        borderRadius:
                            BorderRadius.circular(Dimensions.RADIUS_DEFAULT)),
                    child: Center(
                      child: Text(
                        "اغلاق",
                        style: AlMaraiaBold.copyWith(
                            fontSize: 18, color: AppColors.MAINCOLOR),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }));
      },
    );
  }
}
