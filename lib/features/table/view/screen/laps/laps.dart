import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/presentation/widgets/text/label_main_text.dart';
import 'package:adary/features/table/controller/calender_controller.dart';
import 'package:adary/features/table/controller/class_room_controller.dart';
import 'package:adary/features/table/helper/route_helper.dart';
import 'package:adary/features/table/utils/app_colors.dart';
import 'package:adary/features/table/utils/dimensions.dart';
import 'package:adary/features/table/utils/string_handler.dart';
import 'package:adary/features/table/utils/style.dart';
import 'package:adary/features/table/view/base/app_main_loader.dart';
import 'package:adary/features/table/view/base/calendar.dart';
import 'package:adary/features/table/view/screen/laps/widget/laps_drop_down.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'dart:math' as math;

import '../../../controller/localization_controller.dart';
import '../../../controller/teacher_page_controller.dart';
import '../../../utils/images.dart';
import 'widget/full_table.dart';
import 'package:easy_localization/easy_localization.dart' as easy;

class Laps extends StatefulWidget {
  @override
  State<Laps> createState() => _LapsState();
}

class _LapsState extends State<Laps> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    await Get.find<ClassRoomController>().getClassRoomNames(reload: false);
    await Get.find<ClassRoomController>().getClassesTables(reload: false);
  }

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;

    return RefreshIndicator(
      onRefresh: () async {
        Get.find<ClassRoomController>().loadData();
        await Get.find<TeacherPageController>()
            .getClassesNamesAndNumbers(reload: true);
      },
      color: AppColors.SECONDERYCOLOR,
      child: SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    const LapsDropDown(),
                    Calendar(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        LabelMainText(
                          fontSize: 14,
                          bold: true,
                          text:
                              '${easy.tr('اليوم:')} ${easy.DateFormat('d MMMM yyyy', 'ar').format(DateTime.now())}',
                        ),
                        TextButton(
                            onPressed: () {
                              Get.toNamed(
                                  RouteHelper.getAllClassesTAbleRoute());
                            },
                            child: LabelMainText(
                                fontSize: 14,
                                textunderline: true,
                                text: easy.tr("view_full_table"))),
                      ],
                    ),
                    GetBuilder<ClassRoomController>(
                        builder: (classRoomController) {
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
                                if (classRoomController.tablesList.length !=
                                        1 &&
                                    classRoomController.tablesList.isNotEmpty)
                                  IconButton(
                                      onPressed: () {
                                        AppUtils.log(classRoomController
                                            .tablesList[classRoomController
                                                .currentIndex]
                                            .toString());
                                      },
                                      icon: SvgPicture.asset(
                                        "assets/icons/previw.svg",
                                        color:
                                            classRoomController.currentIndex > 0
                                                ? Colors.white
                                                : Colors.grey,
                                      )),
                                if (classRoomController.tablesList.isNotEmpty)
                                  LabelMainText(
                                    text: classRoomController.tablesList[
                                            classRoomController.currentIndex]
                                        ['classroom_name'],
                                    color: Colors.white,
                                  ),
                                if (classRoomController.tablesList.length !=
                                        1 &&
                                    classRoomController.tablesList.isNotEmpty)
                                  IconButton(
                                      onPressed: () {},
                                      icon: SvgPicture.asset(
                                        "assets/icons/next.svg",
                                        color:
                                            classRoomController.currentIndex <
                                                    classRoomController
                                                            .tablesList.length -
                                                        1
                                                ? Colors.white
                                                : Colors.grey,
                                      )),
                              ]));
                      // ? Padding(
                      //     padding:
                      //         const EdgeInsets.symmetric(horizontal: 20),
                      //     child: SizedBox(
                      //         child: Row(
                      //       mainAxisAlignment:
                      //           MainAxisAlignment.spaceBetween,
                      //       children: [
                      //         Container(
                      //           width: 60,
                      //           height: 25,
                      //           decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(25),
                      //             color: AppColors.SECONDERYCOLOR,
                      //           ),
                      //           child: Transform.rotate(
                      //             angle: Get.find<LocalizationController>()
                      //                     .isLtr
                      //                 ? math.pi / 2
                      //                 : math.pi / -2,
                      //             child: Center(
                      //                 child: Lottie.asset(
                      //               Images.ARROW_RIGHT,
                      //               fit: BoxFit.cover,
                      //             )),
                      //           ),
                      //         ),
                      //         Text(
                      //           easy.tr("scroll"),
                      //           style: AlMaraiaBold.copyWith(fontSize: 16),
                      //         ),
                      //       ],
                      //     )),
                      //   )
                    }),
                    GetBuilder<ClassRoomController>(
                        builder: (classRoomController) {
                      return classRoomController.isLoading
                          ? _TableCardLoader(orientation)
                          : classRoomController.isLoadingTables
                              ? _TableCardLoader(orientation)
                              : _Tables(orientation,
                                  classes: classRoomController.tablesList);
                    }),
                    // SizedBox(
                    //   height: orientation == Orientation.portrait
                    //       ? context.height / 19
                    //       : context.width / 19,
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
                    //             '/dashboard-mobile/classes/in-classes/') ||
                    //     AppUtils.permissions.isEmpty)
                    //   GetBuilder<ClassRoomController>(
                    //       builder: (classRoomController) {
                    //     return classRoomController.tablesList.length > 0
                    //         ? GestureDetector(
                    //             onTap: () {
                    //               Get.toNamed(
                    //                   RouteHelper.getAllClassesTAbleRoute());
                    //             },
                    //             child: Align(
                    //               alignment: Alignment.bottomCenter,
                    //               child: Text(
                    //                 easy.tr("view_full_table"),
                    //                 style: AlMaraiaBold.copyWith(
                    //                     fontSize: 16,
                    //                     decoration: TextDecoration.underline),
                    //               ),
                    //             ),
                    //           )
                    //         : const SizedBox.shrink();
                    //   }),
                    // const SizedBox(
                    //   height: 60,
                    // ),
                  ],
                ))),
      ),
    );
  }

  Widget _dayBox(
      {required String dayTitle, required int dayNumber, required isToday}) {
    return Container(
      height: 130,
      width: 67,
      child: Stack(
        children: [
          isToday
              ? Positioned(
                  top: 55,
                  left: 1,
                  right: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFCECACA)),
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25)),
                      color: Color(0xFFF3056C),
                    ),
                    height: 65,
                    width: 65,
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "اليوم",
                          style: AlMaraiaBold.copyWith(
                              fontSize: 14, color: AppColors.MAINCOLOR),
                        ),
                        const SizedBox(
                          height: 18,
                        )
                      ],
                    )),
                  ),
                )
              : const SizedBox.shrink(),
          Positioned(
            top: 5,
            left: 0,
            right: 0,
            child: Container(
              height: 74,
              width: 67,
              decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFCECACA)),
                  borderRadius: BorderRadius.circular(25),
                  color: const Color(0xFFCFE9EB)),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      dayTitle,
                      style: AlMaraiaRegular.copyWith(
                          color: const Color(0xFF4B4949), fontSize: 13),
                    ),
                    Text(
                      "$dayNumber",
                      style: AlMaraiaBold.copyWith(fontSize: 24),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableRow(
      {required String session,
      required String start_time,
      required String end_time,
      required String subject,
      required String instructorName}) {
    return Padding(
      padding: EdgeInsets.zero,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              children: [
                Center(
                  child: Text(
                    " $session ",
                    style: AlMaraia.copyWith(
                        fontSize: 15, color: AppColors.DARKENGREYFONTCOLOR),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      start_time,
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 1), // space between times
                    const Text('-'),
                    const SizedBox(width: 1),
                    Text(
                      end_time,
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                subject,
                style: AlMaraiaBold.copyWith(
                    overflow: TextOverflow.ellipsis,
                    fontSize: 16,
                    color: AppColors.FONTCOLOR),
              ),
            ),
          ),
          Expanded(
            child: Text(
              " ( $instructorName )",
              style: AlMaraia.copyWith(
                  overflow: TextOverflow.ellipsis,
                  fontSize: 15,
                  color: AppColors.DARKENGREYFONTCOLOR),
            ),
          ),
        ],
      ),
    );
  }

  Widget _customBox() {
    return const SizedBox(
      height: 50,
    );
  }

  Widget _Tables(orientation, {required List<dynamic> classes}) {
    return GetBuilder<ClassRoomController>(builder: (classRoomController) {
      return SizedBox(
          height: orientation == Orientation.portrait
              ? context.height / 1.4
              : context.width / 1.4,
          width: context.width,
          child: PageView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: classes.length,
              onPageChanged: classRoomController.onPageChanged,
              controller: classRoomController.tableClassController,
              itemBuilder: (context, index) {
                return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: _table(orientation, singleClass: classes[index]));
              }));
    });
  }

  Widget _table(orientation, {required Map<String, dynamic> singleClass}) {
    return Column(
      children: [
        // const SizedBox(height: 20),

        /// Title
        // Padding(
        //   padding: const EdgeInsets.symmetric(
        //       horizontal: Dimensions.PADDING_SIZE_DEFAULT),
        //   child: Row(
        //     children: [
        //       Text(
        //         singleClass["classroom_name"].toString(),
        //         style: AlMaraiaBold.copyWith(
        //           fontSize: 18,
        //           color: AppColors.SECONDERYCOLOR,
        //         ),
        //       )
        //     ],
        //   ),
        // ),

        /// TABLE
        Expanded(
          child: GetBuilder<TeacherPageController>(
            builder: (teacherPageController) {
              return GetBuilder<CalednerController>(
                builder: (calednerController) {
                  return SingleChildScrollView(
                    child: Table(
                      border: TableBorder.all(
                        color: AppColors.SECONDERYCOLOR,
                        width: 1,
                      ),
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: List.generate(
                        teacherPageController.classesNamesAndNumbers.length,
                        (index) {
                          return TableRow(
                            children: [
                              /// Session
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      teacherPageController
                                          .classesNamesAndNumbers[index]
                                          .toString(),
                                      textAlign: TextAlign.center,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          singleClass["table"][
                                                  "${calednerController.selectedDayIndex}"]
                                              ["${index + 1}"]["start_time"],
                                          style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.SECONDERYCOLOR),
                                        ),
                                        const SizedBox(width: 2),
                                        const Text(
                                          '-',
                                          style: TextStyle(
                                              color: AppColors.SECONDERYCOLOR),
                                        ),
                                        const SizedBox(width: 2),
                                        Text(
                                          singleClass["table"][
                                                  "${calednerController.selectedDayIndex}"]
                                              ["${index + 1}"]["end_time"],
                                          style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.SECONDERYCOLOR),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              /// Subject
                              Center(
                                child: Text(
                                  StringHanler.cutString(
                                    txt: singleClass["table"][
                                                "${calednerController.selectedDayIndex}"]
                                            ["${index + 1}"]["cell_text"]
                                        .toString(),
                                    isName: false,
                                    pattern: "\n",
                                  ),
                                  textAlign: TextAlign.center,
                                  style: AlMaraiaBold.copyWith(
                                    fontSize: 15,
                                    color: AppColors.FONTCOLOR,
                                  ),
                                ),
                              ),

                              /// Instructor
                              Center(
                                child: Text(
                                  StringHanler.cutString(
                                    txt: singleClass["table"][
                                                "${calednerController.selectedDayIndex}"]
                                            ["${index + 1}"]["cell_text"]
                                        .toString(),
                                    isName: true,
                                    pattern: "\n",
                                  ),
                                  textAlign: TextAlign.center,
                                  style: AlMaraia.copyWith(
                                    fontSize: 13,
                                    color: AppColors.FONTCOLOR,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),

        // const SizedBox(height: 20),

        // /// View Table Button
        // Padding(
        //   padding: const EdgeInsets.symmetric(
        //       horizontal: Dimensions.PADDING_SIZE_DEFAULT),
        //   child: GestureDetector(
        //     onTap: () {
        //       Get.to(
        //         () => AllTable(singleClass: singleClass),
        //         transition: Transition.cupertino,
        //       );
        //     },
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.end,
        //       children: [
        //         Text(
        //           easy.tr("view_table"),
        //           style: AlMaraiaBold.copyWith(
        //             fontSize: 16,
        //             decoration: TextDecoration.underline,
        //           ),
        //         )
        //       ],
        //     ),
        //   ),
        // ),

        // const SizedBox(height: 10),
      ],
    );
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
                            mainAxisExtent: orientation == Orientation.portrait
                                ? context.height / 28
                                : context.width / 28,
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
                                  fontSize: 16,
                                  decoration: TextDecoration.underline),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )),
          )),
    );
  }
}
