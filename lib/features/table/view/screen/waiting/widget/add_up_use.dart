import 'package:adary/features/table/controller/waitingTeacher_controller.dart';
import 'package:adary/features/table/view/base/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../data/model/response/add_waiting_class_model.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/dimensions.dart';
import '../../../../utils/images.dart';
import '../../../../utils/style.dart';
import '../../../base/app_main_loader.dart';
import '../../../base/back_btn.dart';
import 'package:easy_localization/easy_localization.dart' as easy;

class Upuse extends StatefulWidget {
  String cellId;
  String teacherName;
  String materialName;
  String className;

  Upuse(
      {required this.cellId,
      required this.teacherName,
      required this.materialName,
      required this.className});
  @override
  State<Upuse> createState() => _UpuseState();
}

class _UpuseState extends State<Upuse> {
  @override
  void initState() {
    super.initState();

    Get.find<WaitingTeacherController>()
        .getWaitingTeacher(reload: false, cellId: widget.cellId);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: context.width,
          height: context.height,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                BackBtn(),
                SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: context.width / 1.2,
                  height: 50,
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${widget.className}  ${widget.teacherName}",
                        style: AlMaraia.copyWith(fontSize: 20),
                      ),
                    ],
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                  child: SizedBox(
                      width: context.width / 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              widget.materialName.toString(),
                              style: AlMaraiaBold.copyWith(fontSize: 21),
                            ),
                          ),
                        ],
                      )),
                ),
                SizedBox(
                  height: 26,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.PADDING_SIZE_LARGE),
                  child: Row(
                    children: [
                      Text(
                        easy.tr("assign_to_teacher"),
                        style: AlMaraiaBold.copyWith(fontSize: 22),
                      )
                    ],
                  ),
                ),
                GetBuilder<WaitingTeacherController>(
                    builder: (waitingTeacherController) {
                  return waitingTeacherController.isLoadingWaitingTeacher
                      ? _loader()
                      : _waitingTeachersContent(
                          waitingTeacherController: waitingTeacherController);
                }),
                SizedBox(
                  height: 50,
                ),
                GetBuilder<WaitingTeacherController>(
                    builder: (waitingTeacherController) {
                  return waitingTeacherController.isLoadingWaitingTeacher
                      ? _waitingTeacherLoaderBtnLoader()
                      : waitingTeacherController.isLoadingWaitingTeacherBtn
                          ? _addWaitingTeacherLoader()
                          : _addWaitingTeacherBtn(callBackFunction: () {
                              waitingTeacherController
                                  .addWaitingTeacher()
                                  .then((value) {
                                if (value.isSuccess) {
                                  _showMyDialog(
                                      model: value.newWaitingTeacherModel!);
                                } else {
                                  showCustomSnackBar(
                                      easy.tr("failed_to_proccess"));
                                }
                              });
                            });
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _loader() {
    return AppLoader(
        loaderView: SizedBox(
      height: 400,
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: 4,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1,
          mainAxisExtent: 50,
        ),
        itemBuilder: (_, index) => Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.PADDING_SIZE_LARGE),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 21,
                height: 21,
                decoration: BoxDecoration(
                    color: AppColors.SECONDERYCOLOR,
                    border: Border.all(color: Color(0xFF707070)),
                    borderRadius: BorderRadius.circular(25)),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                width: 230,
                height: 8,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25), color: Colors.red),
              ),
              SizedBox(
                width: 50,
              ),
              Container(
                width: 60,
                height: 8,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25), color: Colors.red),
              )
            ],
          ),
        ),
      ),
    ));
  }

  Widget _addWaitingTeacherBtn({required Function callBackFunction}) {
    return GestureDetector(
      onTap: () {
        callBackFunction();
      },
      child: Container(
        width: 327,
        height: 56,
        decoration: BoxDecoration(
            color: AppColors.SECONDERYCOLOR,
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_DEFAULT)),
        child: Center(
          child: Text(
            easy.tr("assign"),
            style:
                AlMaraiaBold.copyWith(fontSize: 24, color: AppColors.MAINCOLOR),
          ),
        ),
      ),
    );
  }

  Widget _addWaitingTeacherLoader() {
    return Container(
      width: 327,
      height: 56,
      decoration: BoxDecoration(
          color: AppColors.SECONDERYCOLOR,
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_DEFAULT)),
      child: const Center(
          child: CircularProgressIndicator(
        color: AppColors.MAINCOLOR,
      )),
    );
  }

  Widget _waitingTeacherLoaderBtnLoader() {
    return AppLoader(
        loaderView: Container(
      width: 327,
      height: 56,
      decoration: BoxDecoration(
          color: AppColors.SECONDERYCOLOR,
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_DEFAULT)),
    ));
  }

  Widget _waitingTeachersContent(
      {required WaitingTeacherController waitingTeacherController}) {
    return SizedBox(
      height: 300,
      width: context.width,
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: waitingTeacherController.waitingTeacherList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1,
          mainAxisExtent: 50,
        ),
        itemBuilder: (_, index) => Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.PADDING_SIZE_LARGE),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  waitingTeacherController.setSelectedInstructorIndex(
                      index: waitingTeacherController
                          .waitingTeacherList[index].teacherId!,
                      WCTID: waitingTeacherController
                          .waitingTeacherList[index].wctId
                          .toString());
                },
                child: Container(
                  width: 21,
                  height: 21,
                  decoration: BoxDecoration(
                      color: waitingTeacherController
                                  .waitingTeacherList[index].teacherId ==
                              waitingTeacherController.selectedInstructorIndex
                          ? AppColors.SECONDERYCOLOR
                          : null,
                      border: Border.all(color: Color(0xFF707070)),
                      borderRadius: BorderRadius.circular(25)),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              SizedBox(
                width: 140,
                child: Center(
                  child: Text(
                    waitingTeacherController.waitingTeacherList[index].name
                        .toString(),
                    style: AlMaraiaBold.copyWith(
                        fontSize: 22, overflow: TextOverflow.ellipsis),
                  ),
                ),
              ),
              SizedBox(
                width: 2,
              ),
              SizedBox(
                width: 140,
                child: Center(
                  child: Text(
                    waitingTeacherController.waitingTeacherList[index].note
                        .toString(),
                    style: AlMaraia.copyWith(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 18,
                        color: const Color(0xFF4B4949)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showMyDialog({required addWaitingClassTeacherModel model}) {
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
                const SizedBox(
                  height: 26,
                ),
                Center(
                  child: Text(
                    model.data!.cellText!
                        .substring(model.data!.cellText!.indexOf("\n"))
                        .toString(),
                    style: AlMaraiaBold.copyWith(fontSize: 18),
                  ),
                ),
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
                          model.msg.toString(),
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
  }
}
