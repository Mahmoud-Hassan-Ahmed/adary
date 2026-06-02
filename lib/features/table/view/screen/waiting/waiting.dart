import 'package:adary/core/share/widgets/btn_app.dart';
import 'package:adary/core/share/widgets/my_app_bar.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/table/controller/calender_controller.dart';
import 'package:adary/features/table/controller/waiting_controller.dart';
import 'package:adary/features/table/helper/route_helper.dart';
import 'package:adary/features/table/utils/app_colors.dart';
import 'package:adary/features/table/utils/dimensions.dart';
import 'package:adary/features/table/utils/string_handler.dart';
import 'package:adary/features/table/utils/style.dart';
import 'package:adary/features/table/view/base/app_main_loader.dart';
import 'package:adary/features/table/view/base/calendar.dart';
import 'package:adary/features/table/view/base/custom_snack_bar.dart';
import 'package:adary/features/table/view/screen/waiting/widget/add_waiting.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../data/model/response/waiting_list.dart';
import '../../../utils/images.dart';

import 'package:easy_localization/easy_localization.dart' as easy;

class Waiting extends StatefulWidget {
  const Waiting({super.key});

  @override
  State<Waiting> createState() => _WaitingState();
}

class _WaitingState extends State<Waiting> {
  @override
  void initState() {
    super.initState();

    Get.find<WaitingController>().getWaitingList(reload: false);
  }

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;

    return SafeArea(
      child: Scaffold(
          appBar: MyAppBar(title: easy.tr("waitingSessions")),
          body: RefreshIndicator(
            color: AppColors.SECONDERYCOLOR,
            onRefresh: () => Get.find<WaitingController>().loadAllData(),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  // SizedBox(
                  //   height: 137,
                  // ),

                  //end of calender
                  // SizedBox(
                  //   height: 56,
                  // ),

                  // if (AppUtils.permissions.isNotEmpty &&
                  //         AppUtils.permissions.contains(
                  //             '/waiting-classes/add-waiting-classes/') ||
                  //     AppUtils.permissions.isEmpty)
                  if (AppUtils.checkPermission(
                      ['/waiting-classes/add-waiting-class-on-cell/']))
                    GetBuilder<WaitingController>(builder: (waitingController) {
                      return waitingController.isLoading
                          ? _addInstructorLoader()
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: double.infinity,
                                child: BtnApp(
                                    icon: "assets/icons/plus.svg",
                                    radius: 10,
                                    label: easy.tr('add_absent_teachers'),
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: Get.context!,
                                        isScrollControlled:
                                            true, // مهم عشان ياخد ارتفاع كبير
                                        backgroundColor: Colors
                                            .transparent, // عشان تعمل radius
                                        builder: (context) {
                                          return Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.9, // 90% من الشاشة
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                top: Radius.circular(20),
                                              ),
                                            ),
                                            child: AddWaititng(
                                              day:
                                                  Get.find<CalednerController>()
                                                      .selectedDayIndex
                                                      .toString(),
                                            ),
                                          );
                                        },
                                      );
                                    }),
                              ),
                            );
                    }),

                  const Calendar(),
                  //end of add absent btn

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                    child: Row(
                      children: [
                        Text(
                          easy.tr("upsent_teacher_classes"),
                          style: AlMaraiaBold.copyWith(
                              fontSize: 18, color: AppColors.FONTCOLOR),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  GetBuilder<WaitingController>(builder: (waitingController) {
                    return waitingController.isLoading
                        ? _tableLoader(orientation)
                        : _absentTable(orientation,
                            waitingList: waitingController.filterdWaitingList);
                  }),
                ],
              ),
            ),
          )),
    );
  }

  Widget _addInstructorLoader() {
    return AppLoader(
        loaderView: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17),
            child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                child: Center(
                  child: Container(
                    width: 255,
                    height: 56,
                    decoration: BoxDecoration(
                        color: AppColors.SECONDERYCOLOR,
                        borderRadius: BorderRadius.circular(25)),
                    child: Center(
                      child: Text(
                        easy.tr("add_to_upsent_teacher"),
                        style: AlMaraiaBold.copyWith(
                            fontSize: 24, color: AppColors.MAINCOLOR),
                      ),
                    ),
                  ),
                ))));
  }

  Widget _tableLoader(orientation) {
    return AppLoader(
        loaderView: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _tableHeader(orientation),
                // end of header
                Row(
                  children: [
                    Container(
                      width: 31,
                      height: 93,
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.GREYFONTCOLOR),
                          color: AppColors.SECONDERYCOLOR,
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(15),
                              bottomRight: Radius.circular(15))),
                      child: Center(
                        child: Text(
                          "",
                          style: AlMaraiaBold.copyWith(
                              color: AppColors.MAINCOLOR, fontSize: 24),
                        ),
                      ),
                    ),
                    _tableCell(txt: "", isBtn: false),
                    _tableCell(txt: "", isBtn: false),
                    _tableCell(txt: "", isBtn: true),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: 31,
                      height: 93,
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.GREYFONTCOLOR),
                          color: AppColors.SECONDERYCOLOR,
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(15),
                              bottomRight: Radius.circular(15))),
                      child: Center(
                        child: Text(
                          "",
                          style: AlMaraiaBold.copyWith(
                              color: AppColors.MAINCOLOR, fontSize: 24),
                        ),
                      ),
                    ),
                    _tableCell(txt: "", isBtn: false),
                    _tableCell(txt: "", isBtn: false),
                    _tableCell(txt: "", isBtn: true),
                  ],
                ),
                // end of table content
              ],
            )));
  }

  Widget _absentTable(
    Orientation orientation, {
    required List<waitingListModel> waitingList,
  }) {
    return Column(
      children: [
        /// لو مفيش بيانات
        if (waitingList.isEmpty)
          Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                Image.asset("assets/images/note_exists.png"),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  easy.tr("no_session_for_today_txt"),
                  style: AlMaraiaBold.copyWith(
                    fontSize: 14,
                    color: AppColors.FONTCOLOR,
                  ),
                ),
              ],
            ),
          )
        else
          Column(
            children: List.generate(waitingList.length, (index) {
              final item = waitingList[index];

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: AppColors.GREYFONTCOLOR),
                ),
                child: Row(
                  children: [
                    /// 🔹 رقم
                    Container(
                      width: 40,
                      height: 93,
                      decoration: const BoxDecoration(
                        color: AppColors.SECONDERYCOLOR,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "${index + 1}",
                          style: AlMaraiaBold.copyWith(
                            color: AppColors.MAINCOLOR,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),

                    /// 🔹 باقي الأعمدة
                    Expanded(
                      flex: 2,
                      child: _tableCell(
                        txt:
                            "${item.cell!.classroomName!}\n${StringHanler.cutString(
                          txt: item.cell!.cellText.toString(),
                          isName: false,
                          pattern: "\n",
                        )}",
                        isBtn: false,
                      ),
                    ),

                    Expanded(
                      flex: 1,
                      child: _tableCell(
                        txt: item.class_number_text.toString(),
                        isBtn: false,
                      ),
                    ),

                    Expanded(
                      flex: 3,
                      child: _tableCell(
                        txt: item.waitingTeacher!.teacherName.toString(),
                        isBtn: false,
                      ),
                    ),

                    Expanded(
                      flex: 2,
                      child: _tableCell(
                        txt: '',
                        isBtn: true,
                        cellId: item.cell!.cellId.toString(),
                        waiting_class_id: item.waitingClassId,
                        materialName: StringHanler.cutString(
                          txt: item.cell!.cellText.toString(),
                          isName: false,
                          pattern: "\n",
                        ),
                        className: item.cell!.classroomName!,
                      ),
                    ),
                  ],
                ),
              );
            }),
          )
      ],
    );
  }

  Widget _tableHeader(orientation) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          width: 31,
        ),
        SizedBox(
          width: orientation == Orientation.portrait ? 102 : 102 * 2,
          height: 60,
          child: Center(
              child: Text(
            easy.tr("class"),
            style: AlMaraia.copyWith(
                overflow: TextOverflow.ellipsis,
                fontSize: 19,
                color: AppColors.GREYFONTCOLOR),
          )),
        ),
        SizedBox(
          width: orientation == Orientation.portrait ? 85 : 85 * 2,
          height: 60,
          child: Center(
              child: Text(
            easy.tr("session"),
            style: AlMaraia.copyWith(
                overflow: TextOverflow.ellipsis,
                fontSize: 19,
                color: AppColors.GREYFONTCOLOR),
          )),
        ),
        SizedBox(
          width: orientation == Orientation.portrait ? 102 : 102 * 3,
          height: 93,
          child: Center(
              child: Text(
            easy.tr("waiting_teacher"),
            style: AlMaraia.copyWith(
                overflow: TextOverflow.ellipsis,
                fontSize: 19,
                color: AppColors.GREYFONTCOLOR),
          )),
        )
      ],
    );
  }

  Widget _tableCell({
    required String txt,
    required bool isBtn,
    String? cellId,
    String? materialName,
    int? waiting_class_id,
    String? className,
  }) {
    return Container(
      padding: const EdgeInsets.all(6),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// 🔹 النص
            ///
            if (txt.isNotEmpty)
              Text(
                txt,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AlMaraia.copyWith(fontSize: 14),
              ),

            if (isBtn) const SizedBox(height: 10),

            /// 🔹 الأزرار
            if (isBtn)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// edit
                  GestureDetector(
                    onTap: () => Get.toNamed(
                      RouteHelper.getUpUseRoute(
                        cellId: cellId.toString(),
                        teacherNAme: txt,
                        materialName: materialName.toString(),
                        className: className.toString(),
                      ),
                    ),
                    child: SizedBox(
                      height: 24,
                      width: 24,
                      child: SvgPicture.asset(
                        Images.EDIT_BTN_ICON,
                        color: AppColors.SECONDERYCOLOR,
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  /// delete
                  GetBuilder<WaitingController>(
                    builder: (waitingController) {
                      return GestureDetector(
                        onTap: () {
                          _showMyDialog(waiting_class_id: waiting_class_id!);
                        },
                        child: waitingController.isDeleteing &&
                                waitingController.selectedWaitingClassID ==
                                    waiting_class_id
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: AppColors.SECONDERYCOLOR,
                                ),
                              )
                            : SvgPicture.asset("assets/icons/delete.svg"),
                      );
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _showMyDialog({required int waiting_class_id}) {
    AwesomeDialog(
      context: context,
      desc: easy.tr("delete_waiting_class"),
      btnOkOnPress: () {
        Get.find<WaitingController>()
            .deleteWaitingCLass(waiting_class_id: waiting_class_id)
            .then((value) {
          if (value.isSuccess) {
            showCustomSnackBar(value.message, isError: false);
          } else {
            showCustomSnackBar(value.message, isError: true);
          }
        });
      },
      btnOkText: easy.tr("yes"),
      btnCancelText: easy.tr("لا"),
      btnCancelOnPress: () {},
    ).show();
  }
}
