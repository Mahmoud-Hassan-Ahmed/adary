import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/conts/icons.dart';
import 'package:adary/core/enums/relations.dart';
import 'package:adary/core/share/widgets/btn_icon.dart';
import 'package:adary/core/share/widgets/container_btns.dart';
import 'package:adary/core/share/widgets/expansion_widget.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/visits_model.dart';
import 'package:adary/features/adary/domain/entities/delete_entity.dart';
import 'package:adary/features/adary/presentation/bloc/class_visit/class_visit_bloc.dart';
import 'package:adary/features/adary/presentation/pages/class_visit.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ItemVisit extends StatelessWidget {
  const ItemVisit(
      {super.key, required this.visitModel, required this.pagingController});
  final VisitModel visitModel;
  final PagingController pagingController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpansionWidget(
          body: [
            Wrap(
              children: [
                Text(
                  "name_visitor".tr(),
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const Text(' : '),
                Text(
                  visitModel.visitorName,
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
                  "class".tr(),
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const Text(' : '),
                Text(
                  visitModel.className!.name,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
            const Divider(
              height: 10,
            ),
            Wrap(
              children: [
                Text(
                  "choose_date".tr(),
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const Text(' : '),
                Text(
                  visitModel.dateHijri,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
            const Divider(
              height: 10,
            ),
            Wrap(
              children: [
                Text(
                  "session".tr(),
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const Text(' : '),
                Text(
                  sessions
                      .firstWhere((test) =>
                          (test as Relations).value ==
                          (visitModel.session ?? '1'))
                      .name,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            ContainerBtns(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (AppUtils.permissions.isNotEmpty &&
                          AppUtils.permissions.any(
                              (p) => p.contains("api/notes/Visits/delete/")) ||
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
                              title: 'delete_visit'.tr(),
                              desc: 'delete_visit_des'.tr(),
                              btnCancelText: 'no'.tr(),
                              btnOkText: 'delete'.tr(),
                              btnCancelOnPress: () {},
                              btnOkOnPress: () {
                                BaseBloc.get<ClassVisitBloc>(context).add(
                                    DeletVisitEvent(
                                        enity: DeleteEntity(
                                            id: visitModel.id ?? 0)));
                              }).show();
                        }),
                  if (AppUtils.permissions.isNotEmpty &&
                          AppUtils.permissions.any(
                              (p) => p.contains("api/notes/Visits/update/")) ||
                      AppUtils.permissions.isEmpty)
                    BtnIcon(
                        label: 'edit'.tr(),
                        icon: AppIcon.edit,
                        onTap: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (context) {
                              return AddClassVisit(
                                visitModel: visitModel,
                                pagingController: pagingController,
                              );
                            },
                          );
                        })
                ],
              ),
            )
          ],
          title: [
            Text(
              visitModel.teacher.name,
              style: Theme.of(context).textTheme.labelMedium,
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
