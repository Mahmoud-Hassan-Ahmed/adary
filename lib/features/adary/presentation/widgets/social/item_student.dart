import 'package:adary/core/bloc/base_bloc.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExpansionWidget(
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
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const Text(' : '),
                Text(
                  studentModel.className.name,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
            const Divider(
              height: 20,
            ),
            Wrap(
              children: [
                Text(
                  "parents_student".tr(),
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const Text(' : '),
                Text(
                  studentModel.studentGuardian,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
            const Divider(
              height: 20,
            ),
            Wrap(
              children: [
                Text(
                  "name".tr(),
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const Text(' : '),
                Text(
                  studentModel.name,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
            const Divider(
              height: 20,
            ),
            Wrap(
              children: [
                Text(
                  "father_on_live".tr(),
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const Text(' : '),
                Text(
                  studentModel.fatherIsAlive ? 'yes'.tr() : 'no'.tr(),
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
            const Divider(
              height: 20,
            ),
            Wrap(
              children: [
                Text(
                  "mother_on_live".tr(),
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const Text(' : '),
                Text(
                  studentModel.motherIsAlive ? 'yes'.tr() : 'no'.tr(),
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
                          AppUtils.permissions.any(
                              (p) => p.contains("api/notes/social/delete/")) ||
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
                                        entity:
                                            DeleteEntity(id: studentModel.id)));
                              }).show();
                        }),
                  if (AppUtils.permissions.isNotEmpty &&
                          AppUtils.permissions.any(
                              (p) => p.contains("api/notes/social/update/")) ||
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
    );
  }
}
