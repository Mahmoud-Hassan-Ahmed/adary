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
              child: Column(
                children: [
                  // SizedBox(
                  //   height: 137,
                  // ),
                  const Calendar(),
                  //end of calender
                  // SizedBox(
                  //   height: 56,
                  // ),
                  GetBuilder<WaitingController>(builder: (waitingController) {
                    return waitingController.isLoading
                        ? _addInstructorLoader()
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                            child: Center(
                              child: GestureDetector(
                                // onTap: () => Get.toNamed(
                                //     RouteHelper.getAwaitingRoute(
                                //         dayNum: Get.find<CalednerController>()
                                //             .selectedDayIndex
                                //             .toString())),
                                onTap: () {
                                  AppUtils.go(AddWaititng(
                                    day: Get.find<CalednerController>()
                                        .selectedDayIndex
                                        .toString(),
                                  ));
                                },
                                child: Container(
                                  width: 327,
                                  height: 56,
                                  decoration: BoxDecoration(
                                      color: AppColors.SECONDERYCOLOR,
                                      borderRadius: BorderRadius.circular(25)),
                                  child: Center(
                                    child: Text(
                                      easy.tr("add_to_upsent_teacher"),
                                      style: AlMaraiaBold.copyWith(
                                          fontSize: 21,
                                          color: AppColors.MAINCOLOR),
                                    ),
                                  ),
                                ),
                              ),
                            ));
                  }),
                  //end of add absent btn
                  const SizedBox(
                    height: 34,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                    child: Row(
                      children: [
                        Text(
                          easy.tr("upsent_teacher_classes"),
                          style: AlMaraiaBold.copyWith(
                              fontSize: 18, color: AppColors.SECONDERYCOLOR),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                    child: Row(
                      children: [
                        Text(
                          easy.tr("add_to_waiting_teacher"),
                          style: AlMaraia.copyWith(
                              fontSize: 17,
                              color: AppColors.GREYFONTCOLOR,
                              fontWeight: FontWeight.normal),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GetBuilder<WaitingController>(builder: (waitingController) {
                    return waitingController.isLoading
                        ? _tableLoader(orientation)
                        : _absentTable(orientation,
                            waitingList: waitingController.filterdWaitingList);
                  }),
                  const SizedBox(
                    height: 20,
                  )
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
                    _tableCell(width: 102, txt: "", isBtn: false),
                    _tableCell(width: 65, txt: "", isBtn: false),
                    _tableCell(width: 102, txt: "", isBtn: true),
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
                    _tableCell(width: 102, txt: "", isBtn: false),
                    _tableCell(width: 65, txt: "", isBtn: false),
                    _tableCell(width: 102, txt: "", isBtn: true),
                  ],
                ),
                // end of table content
              ],
            )));
  }

  Widget _absentTable(orientation,
      {required List<waitingListModel> waitingList}) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _tableHeader(orientation),
            // end of header
            waitingList.isEmpty
                ? Center(
                    child: Text(
                      easy.tr("no_session_for_today_txt"),
                      style: AlMaraiaBold.copyWith(
                          fontSize: 21, color: AppColors.SECONDERYCOLOR),
                    ),
                  )
                : const SizedBox.shrink(),
            ...List.generate(waitingList.length, (index) {
              return Row(
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
                        "${index + 1}",
                        style: AlMaraiaBold.copyWith(
                            color: AppColors.MAINCOLOR, fontSize: 24),
                      ),
                    ),
                  ),
                  _tableCell(
                      width:
                          orientation == Orientation.portrait ? 102 : 102 * 2,
                      txt:
                          "${waitingList[index].cell!.classroomName!}\n${StringHanler.cutString(txt: waitingList[index].cell!.cellText.toString(), isName: false, pattern: "\n")}",
                      isBtn: false),
                  _tableCell(
                      width: orientation == Orientation.portrait ? 85 : 85 * 2,
                      txt: waitingList[index].class_number_text.toString(),
                      isBtn: false),
                  _tableCell(
                      width:
                          orientation == Orientation.portrait ? 102 : 102 * 3,
                      txt: waitingList[index]
                          .waitingTeacher!
                          .teacherName
                          .toString(),
                      isBtn: true,
                      cellId: waitingList[index].cell!.cellId.toString(),
                      waiting_class_id: waitingList[index].waitingClassId,
                      materialName:
                          "${StringHanler.cutString(txt: waitingList[index].cell!.cellText.toString(), isName: false, pattern: "\n")}",
                      className: "${waitingList[index].cell!.classroomName!}"),
                ],
              );
            })
            // end of table content
          ],
        ));
  }

  Widget _tableHeader(orientation) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
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

  Widget _tableCell(
      {required double width,
      required String txt,
      required bool isBtn,
      String? cellId,
      String? materialName,
      int? waiting_class_id,
      String? className}) {
    return Container(
        width: width,
        height: 93,
        child: DottedBorder(
            borderType: BorderType.RRect,
            dashPattern: [7, 6],
            color: Colors.black,
            strokeWidth: 1,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    txt,
                    style: AlMaraia.copyWith(
                        fontSize: 17, overflow: TextOverflow.ellipsis),
                  ),
                  isBtn
                      ? const SizedBox(
                          height: 10,
                        )
                      : const SizedBox.shrink(),
                  isBtn
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () => Get.toNamed(
                                  RouteHelper.getUpUseRoute(
                                      cellId: cellId.toString(),
                                      teacherNAme: txt,
                                      materialName: materialName.toString(),
                                      className: className.toString())),
                              child: SizedBox(
                                height: 24,
                                width: 24,
                                child: SvgPicture.asset(Images.EDIT_BTN_ICON),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            GetBuilder<WaitingController>(
                                builder: (waitingController) {
                              return GestureDetector(
                                  onTap: () {
                                    _showMyDialog(
                                        waiting_class_id: waiting_class_id!);
                                  },
                                  child: waitingController.isDeleteing &&
                                          waitingController
                                                  .selectedWaitingClassID ==
                                              waiting_class_id
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 3,
                                            color: AppColors.SECONDERYCOLOR,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ));
                            })
                          ],
                        )
                      : const SizedBox.shrink()
                ],
              ),
            )));
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
