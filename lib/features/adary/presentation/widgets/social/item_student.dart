import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/conts/icons.dart';
import 'package:adary/core/share/widgets/btn_icon.dart';
import 'package:adary/core/share/widgets/container_btns.dart';
import 'package:adary/core/share/widgets/expansion_widget.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/student_model.dart';
import 'package:adary/features/adary/domain/entities/delete_entity.dart';
import 'package:adary/features/adary/presentation/bloc/class_visit/class_visit_bloc.dart';

import 'package:adary/features/adary/presentation/pages/add_social.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ItemsStudent extends StatelessWidget {
  const ItemsStudent(
      {super.key, required this.studentModel, required this.pagingController});
  final StudentModel studentModel;
  final PagingController pagingController;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromRGBO(196, 248, 248, 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExpansionWidget(
            color: const Color.fromRGBO(196, 248, 248, 0.5),
            title: [
              Text(
                studentModel.name,
                style: Theme.of(context).textTheme.labelMedium,
              )
            ],
            body: [
              Wrap(
                children: [
                  Text(
                    "class".tr(),
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.APP_COLOR),
                  ),
                  const Text(
                    ' : ',
                    style: TextStyle(color: AppColors.APP_COLOR),
                  ),
                  Text(
                    studentModel.className.name,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Row(
                    children: [
                      Text(
                        "father_on_live".tr(),
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: AppColors.APP_COLOR),
                      ),
                      const Text(
                        ' : ',
                        style: TextStyle(color: AppColors.APP_COLOR),
                      ),
                      Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            studentModel.fatherIsAlive ? 'yes'.tr() : 'no'.tr(),
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(fontSize: 13),
                          )),
                    ],
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        "mother_on_live".tr(),
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: AppColors.APP_COLOR),
                      ),
                      const Text(
                        ' : ',
                        style: TextStyle(color: AppColors.APP_COLOR),
                      ),
                      Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          studentModel.motherIsAlive ? 'yes'.tr() : 'no'.tr(),
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        "صلة القرابة".tr(),
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: AppColors.APP_COLOR),
                      ),
                      const Text(
                        ' : ',
                        style: TextStyle(color: AppColors.APP_COLOR),
                      ),
                      Text(
                        studentModel.kinshipWithStudent,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        "مع من يعيش".tr(),
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: AppColors.APP_COLOR),
                      ),
                      const Text(
                        ' : ',
                        style: TextStyle(color: AppColors.APP_COLOR),
                      ),
                      Text(
                        studentModel.kinshipWithStudent,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    "parents_student".tr(),
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.APP_COLOR),
                  ),
                  const Text(
                    ' : ',
                    style: TextStyle(color: AppColors.APP_COLOR),
                  ),
                  Text(
                    studentModel.studentGuardian,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    "الإجراءات".tr(),
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.orange),
                  ),
                  const Text(
                    ' : ',
                    style: TextStyle(color: AppColors.APP_COLOR),
                  ),
                  Text(
                    studentModel.withLive,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ContainerBtns(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if (AppUtils.permissions.isNotEmpty &&
                            AppUtils.permissions.any((p) =>
                                p.contains("api/notes/social/delete/")) ||
                        AppUtils.permissions.isEmpty)
                      BtnIcon(
                          label: 'delete'.tr(),
                          icon: AppIcon.rash,
                          onTap: () {
                            AwesomeDialog(
                                context: context,
                                dialogType: DialogType.warning,
                                titleTextStyle: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                                title: 'delete_student'.tr(),
                                desc: 'delete_student_des'.tr(),
                                btnCancelText: 'no'.tr(),
                                btnOkText: 'delete'.tr(),
                                btnCancelOnPress: () {},
                                btnOkOnPress: () {
                                  BaseBloc.get<ClassVisitBloc>(context).add(
                                      DeleteStudentEvent(
                                          entity: DeleteEntity(
                                              id: studentModel.id)));
                                }).show();
                          }),
                    if (AppUtils.permissions.isNotEmpty &&
                            AppUtils.permissions.any((p) =>
                                p.contains("api/notes/social/update/")) ||
                        AppUtils.permissions.isEmpty)
                      BtnIcon(
                          label: 'edit'.tr(),
                          icon: AppIcon.edit,
                          onTap: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                return AddSocial(
                                  student: studentModel,
                                  pagingController: pagingController,
                                );
                              },
                            );
                          })
                  ],
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
