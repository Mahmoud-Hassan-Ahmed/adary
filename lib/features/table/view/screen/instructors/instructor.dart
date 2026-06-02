import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/presentation/widgets/text/label_main_text.dart';
import 'package:adary/features/table/controller/calender_controller.dart';
import 'package:adary/features/table/controller/localization_controller.dart';
import 'package:adary/features/table/controller/teacher_page_controller.dart';
import 'package:adary/features/table/view/base/app_main_loader.dart';
import 'package:adary/features/table/view/base/custom_snack_bar.dart';
import 'package:adary/features/table/view/screen/instructors/instructor_full_table.dart';
import 'package:adary/features/table/view/screen/instructors/instructors_tables.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart' show DateFormat;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:lottie/lottie.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/images.dart';
import '../../../utils/string_handler.dart';
import '../../../utils/style.dart';
import '../../base/calendar.dart';
import 'dart:math' as math;

import '../../base/custom_text_field.dart';
import '../../base/table_header.dart';
import 'widget/dropDownBtn.dart';
import 'package:easy_localization/easy_localization.dart' as easy;

class Instructor extends StatefulWidget {
  @override
  State<Instructor> createState() => _InstructorState();
}

class _InstructorState extends State<Instructor> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    Get.find<TeacherPageController>().getTeachersList(reload: false);
    Get.find<TeacherPageController>().getTeachersTable(reload: false);
    Get.find<TeacherPageController>().getClassesNamesAndNumbers(reload: false);
  }

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    return RefreshIndicator(
      onRefresh: () => Get.find<TeacherPageController>().loadData(),
      color: AppColors.SECONDERYCOLOR,
      child: SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const InstructorDropDown(),
                    // end of drop down

                    const Calendar(),

                    // end of calender
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        LabelMainText(
                          fontSize: 14,
                          bold: true,
                          text:
                              '${easy.tr('اليوم:')} ${DateFormat('d MMMM yyyy', 'ar').format(DateTime.now())}',
                        ),
                        TextButton(
                            onPressed: () {
                              Get.to(() => const InstructorsFullTable(),
                                  transition: Transition.cupertino);
                            },
                            child: LabelMainText(
                                textunderline: T,
                                fontSize: 14,
                                text: easy.tr("view_all_teacher_tables"))),
                      ],
                    ),
                    GetBuilder<TeacherPageController>(
                        builder: (teacherPageController) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: const BoxDecoration(
                          color: AppColors.SECONDERYCOLOR,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (teacherPageController
                                        .teachersTableList.length !=
                                    1 &&
                                teacherPageController
                                    .teachersTableList.isNotEmpty)
                              IconButton(
                                  onPressed: () {
                                    AppUtils.log(teacherPageController
                                        .teachersTableList[
                                            teacherPageController.currentIndex]
                                        .toString());
                                  },
                                  icon: SvgPicture.asset(
                                    "assets/icons/previw.svg",
                                    color:
                                        teacherPageController.currentIndex > 0
                                            ? Colors.white
                                            : Colors.grey,
                                  )),

                            if (teacherPageController
                                .teachersTableList.isNotEmpty)
                              LabelMainText(
                                text: teacherPageController
                                                .teachersTableList.length !=
                                            1 &&
                                        teacherPageController
                                            .teachersTableList.isNotEmpty
                                    ? teacherPageController.teachersTableList[
                                            teacherPageController.currentIndex]
                                        ['teacher_name']
                                    : teacherPageController.teachersTableList[0]
                                        ['teacher_name'],
                                color: Colors.white,
                              ),
                            if (teacherPageController
                                        .teachersTableList.length !=
                                    1 &&
                                teacherPageController
                                    .teachersTableList.isNotEmpty)
                              IconButton(
                                  onPressed: () {},
                                  icon: SvgPicture.asset(
                                    "assets/icons/next.svg",
                                    color: teacherPageController.currentIndex <
                                            teacherPageController
                                                    .teachersTableList.length -
                                                1
                                        ? Colors.white
                                        : Colors.grey,
                                  )),

                            // Container(
                            //   width: 60,
                            //   height: 25,
                            //   decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(25),
                            //     color: AppColors.SECONDERYCOLOR,
                            //   ),
                            //   child: Transform.rotate(
                            //     angle: Get.find<LocalizationController>()
                            //             .isLtr
                            //         ? math.pi / 2
                            //         : math.pi / -2,
                            //     child: Center(
                            //         child: Lottie.asset(
                            //       Images.ARROW_RIGHT,
                            //       fit: BoxFit.cover,
                            //     )),
                            //   ),
                            // ),
                            // Text(
                            //   easy.tr("scroll"),
                            //   style: AlMaraiaBold.copyWith(fontSize: 19),
                            // ),
                          ],
                        ),
                      );
                    }),

                    GetBuilder<TeacherPageController>(
                        builder: (teacherPageController) {
                      return teacherPageController.isLoadingTable
                          ? _TableCardLoader(orientation)
                          : _tables(
                              orientation,
                              tables: teacherPageController.teachersTableList,
                            );
                    }),
                    // end of table
                    // SizedBox(
                    //   height: orientation == Orientation.portrait
                    //       ? context.height / 11
                    //       : context.width / 11,
                    // ),
                    // const Padding(
                    //   padding: EdgeInsets.symmetric(
                    //       horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                    //   child: Divider(
                    //     color: AppColors.GREYCOLOR,
                    //   ),
                    // ),
                    // if (AppUtils.permissions.isNotEmpty &&
                    //         AppUtils.permissions.contains(
                    //             '/dashboard-mobile/classes/teachers/') ||
                    //     AppUtils.permissions.isEmpty)
                    //   // end of divider
                    //   GetBuilder<TeacherPageController>(
                    //       builder: (teacherPageController) {
                    //     return teacherPageController
                    //             .teachersTableList.isNotEmpty
                    //         ? GestureDetector(
                    //             onTap: () => Get.to(
                    //                 () => const InstructorsFullTable(),
                    //                 transition: Transition.cupertino),
                    //             child: Align(
                    //               alignment: Alignment.bottomCenter,
                    //               child: Text(
                    //                 easy.tr("view_all_teacher_tables"),
                    //                 style: AlMaraiaBold.copyWith(
                    //                     fontSize: 18,
                    //                     decoration: TextDecoration.underline),
                    //               ),
                    //             ),
                    //           )
                    //         : const SizedBox.shrink();
                    //   }),
                    // end of view all tables btn
                    // const SizedBox(
                    //   height: 60,
                    // ),
                  ],
                ))),
      ),
    );
  }

  // table slider
  Widget _tables(orientation, {required List<dynamic> tables}) {
    return GetBuilder<TeacherPageController>(builder: (teacherPageController) {
      return SizedBox(
          height: orientation == Orientation.portrait
              ? context.height / 1.6
              : context.width / 1.6,
          width: context.width,
          child: PageView.builder(
              controller: teacherPageController.tableController,
              physics: const BouncingScrollPhysics(),
              itemCount: tables.length,
              onPageChanged: (value) {
                teacherPageController.currentIndex = value;
                teacherPageController.update();
              },
              itemBuilder: (context, index) {
                return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: _TableCard(orientation, table: tables[index]));
              }));
    });
  }

  // table container
  Widget _TableCard(orientation, {required Map<String, dynamic> table}) {
    return Column(
      children: [
        // const SizedBox(
        //   height: 34,
        // ),

        // TableHeader(
        //   headerTxt: table["teacher_name"].toString(),
        //   headerTxtColor: AppColors.SECONDERYCOLOR,
        //   headerTxtSized: 18,
        // ),

        // const SizedBox(
        //   height: 15,
        // ),
        Expanded(
          child: GetBuilder<TeacherPageController>(
              builder: (teacherPageController) {
            return GetBuilder<CalednerController>(
                builder: (calednerController) {
              return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount:
                      teacherPageController.classesNamesAndNumbers.length,
                  itemBuilder: (context, index) {
                    return _tableRow(
                        session: teacherPageController.classesNamesAndNumbers[index]
                            .toString(),
                        startTime: table["table"]
                                ["${Get.find<CalednerController>().selectedDayIndex}"]
                            ["${index + 1}"]['start_time'],
                        endTime: table["table"]["${Get.find<CalednerController>().selectedDayIndex}"]
                            ["${index + 1}"]['end_time'],
                        subject: StringHanler.cutString(
                            txt: table["table"]["${Get.find<CalednerController>().selectedDayIndex}"]
                                    ["${index + 1}"]["cell_text"][0]
                                .toString(),
                            isName: true,
                            pattern: "\n"),
                        className: StringHanler.cutString(
                            txt: table["table"]["${Get.find<CalednerController>().selectedDayIndex}"]["${index + 1}"]["cell_text"][0].toString(),
                            isName: false,
                            pattern: "\n"));
                  });
            });
          }),
        ),

        // end of table row

        // const SizedBox(
        //   height: 5,
        // ),
        // const Padding(
        //   padding:
        //       EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
        //   child: Divider(
        //     color: AppColors.GREYCOLOR,
        //   ),
        // ),
        // const SizedBox(
        //   height: 25,
        // ),
        // SizedBox(
        //   width: context.width,
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       GestureDetector(
        //         onTap: () => _showMyDialog(orientation,
        //             instructorName: table["teacher_name"].toString(),
        //             instructorId: table["teacher_id"],
        //             bContext: context),
        //         child: SizedBox(
        //           width: context.width / 4,
        //           child: Center(
        //             child: Text(
        //               easy.tr("notification"),
        //               style: AlMaraiaBold.copyWith(
        //                   fontSize: 19,
        //                   decoration: TextDecoration.underline,
        //                   overflow: TextOverflow.ellipsis),
        //             ),
        //           ),
        //         ),
        //       ),
        //       GestureDetector(
        //           onTap: () => Get.to(
        //               () => InstructorFullTable(
        //                     table: table,
        //                   ),
        //               transition: Transition.cupertino),
        //           child: Padding(
        //             padding: const EdgeInsets.symmetric(
        //                 horizontal: Dimensions.PADDING_SIZE_DEFAULT),
        //             child: SizedBox(
        //               width: context.width / 2,
        //               child: Center(
        //                 child: Text(
        //                   easy.tr("view_instructor_full_table"),
        //                   style: AlMaraiaBold.copyWith(
        //                       overflow: TextOverflow.ellipsis,
        //                       fontSize: 17,
        //                       decoration: TextDecoration.underline),
        //                 ),
        //               ),
        //             ),
        //           ))
        //     ],
        //   ),
        // ),

        // end of display all table btn
      ],
    );
  }

  Widget _tableRow({
    required String session,
    required String startTime,
    required String endTime,
    required String subject,
    required String className,
  }) {
    return Table(
      border: TableBorder.all(
        color: AppColors.SECONDERYCOLOR,
        width: 1,
      ),
      children: [
        TableRow(
          children: [
            /// Session
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        session,
                        textAlign: TextAlign.center,
                        style: AlMaraia.copyWith(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(startTime,
                              style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.SECONDERYCOLOR)),
                          const SizedBox(width: 2),
                          const Text(
                            '-',
                            style: TextStyle(color: AppColors.SECONDERYCOLOR),
                          ),
                          const SizedBox(width: 2),
                          Text(endTime,
                              style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.SECONDERYCOLOR)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /// Subject
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Center(
                child: Text(
                  subject,
                  textAlign: TextAlign.center,
                  style: AlMaraiaBold.copyWith(
                    fontSize: 16,
                    color: AppColors.FONTCOLOR,
                  ),
                ),
              ),
            ),

            /// Class
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Center(
                child: Text(
                  "($className)",
                  textAlign: TextAlign.center,
                  style: AlMaraia.copyWith(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _dropDownLoader(orientation) {
    return AppLoader(
        loaderView: Container(
      width: context.width / 1.1,
      height: orientation == Orientation.portrait
          ? context.height / 15
          : context.width / 15,
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.GREYCOLOR.withOpacity(0.6)),
    ));
  }

  Widget _TableCardLoader(orientation) {
    return AppLoader(
      loaderView: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.RADIUS_DEFAULT + 2),
          child: DottedBorder(
            borderType: BorderType.RRect,
            dashPattern: [10, 10],
            color: Colors.grey,
            strokeWidth: 1,
            radius: Radius.circular(12),
            padding: EdgeInsets.all(6),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                child: Container(
                  height: orientation == Orientation.portrait
                      ? context.height / 2
                      : context.width / 2,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 34,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                        child: Row(
                          children: [
                            Container(
                              width: 200,
                              height: 8,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(25)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: orientation == Orientation.portrait
                            ? context.height / 2.5
                            : context.width / 2.5,
                        child: GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemCount: 7,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 6,
                            mainAxisExtent: context.height / 28,
                          ),
                          itemBuilder: (_, index) => Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 8,
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                      width: 200,
                                      height: 8,
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                      width: 50,
                                      height: 8,
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "عرض الجدول كامل",
                              style: AlMaraiaBold.copyWith(
                                  fontSize: 18,
                                  decoration: TextDecoration.underline),
                            )
                          ],
                        ),
                      )
                      // end of full table btn
                    ],
                  ),
                )),
          )),
    );
  }

  void _showMyDialog(orientation,
      {required String instructorName,
      required int instructorId,
      required BuildContext bContext}) {
    AwesomeDialog(
      context: context,
      body:
          StatefulBuilder(// StatefulBuilder is used for local state management
              builder: (BuildContext context, StateSetter setState) {
        return GetBuilder<TeacherPageController>(
            builder: (teacherPageController) {
          return Column(
            children: [
              Center(
                child: Text(
                  " ارسال اشعار الى الأستاذ $instructorName ",
                  style: AlMaraiaBold.copyWith(fontSize: 16),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: context.width - 60,
                height: 170,
                child: Form(
                  key: teacherPageController.formkey,
                  child: Center(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: CustomTextField(
                        hintText: "ادخل نص الاشعار هنا",
                        maxLines: 5,
                        controller: teacherPageController.msgController,
                        validate: (value) {
                          if (value == null || value.isEmpty) {
                            return easy.tr("required");
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
      }),
      dialogType: DialogType.noHeader,
      btnOkText: 'ارسال',
      btnCancelText: 'الغاء',
      // autoDismiss: false,
      onDismissCallback: (type) {},
      dismissOnBackKeyPress: false,
      dismissOnTouchOutside: false,
      autoDismiss: false,
      btnOkOnPress: () {
        TeacherPageController teacherPageController =
            Get.find<TeacherPageController>();
        FocusManager.instance.primaryFocus?.unfocus();
        if (teacherPageController.formkey.currentState!.validate()) {
          teacherPageController
              .sendNotification(teacherID: instructorId)
              .then((value) {
            if (value.isSuccess) {
              Navigator.pop(bContext);
              _success(orientation, msg: value.message);
            } else {
              showCustomSnackBar("حدث خطأ ما, برجاء المحاولية مرة أخري.");
            }
          });
        }
      },
      btnCancelOnPress: () {
        Navigator.pop(bContext);
      },
    ).show();
  }

  void _success(orientation, {required String msg}) {
    Future.delayed(Duration(seconds: 1), () {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(content:
              StatefulBuilder(// You need this, notice the parameters below:
                  builder: (BuildContext context, StateSetter setState) {
            return Container(
              width: context.width,
              height: orientation == Orientation.portrait
                  ? context.height / 2
                  : context.width / 2,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Padding(
                        padding: const EdgeInsets.only(
                            left: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SvgPicture.asset(
                              Images.CLOSE_ICON,
                            ),
                          ],
                        )),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Center(child: Image.asset(Images.CHECK_ICON)),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: context.width - 60,
                    height: 50,
                    child: Center(
                      child: Wrap(
                        children: [
                          Text(
                            msg.toString(),
                            style: AlMaraiaBold.copyWith(fontSize: 18),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
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
                              fontSize: 24, color: AppColors.MAINCOLOR),
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
    });
  }
}
