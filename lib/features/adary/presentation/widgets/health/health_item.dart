import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/conts/icons.dart';
import 'package:adary/core/share/widgets/btn_icon.dart';
import 'package:adary/core/share/widgets/container_btns.dart';
import 'package:adary/core/share/widgets/expansion_widget.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/health_model.dart';
import 'package:adary/features/adary/domain/entities/delete_entity.dart';
import 'package:adary/features/adary/presentation/bloc/health/health_bloc.dart';
import 'package:adary/features/adary/presentation/pages/add_heath_page.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class HealthItem extends StatelessWidget {
  const HealthItem(
      {super.key, required this.visitModel, required this.pagingController});
  final HealthCondition visitModel;
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
                  "name_health".tr(),
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const Text(' : '),
                Text(
                  visitModel.name,
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
                  visitModel.classNameId.name,
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
                  visitModel.nameStudent,
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
                  "dealing".tr(),
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const Text(' : '),
                Text(
                  visitModel.dealingWithSituation,
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
                              (p) => p.contains("api/notes/health/delete/")) ||
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
                              title: 'delete_health'.tr(),
                              desc: 'delete_health_des'.tr(),
                              btnCancelText: 'no'.tr(),
                              btnOkText: 'delete'.tr(),
                              btnCancelOnPress: () {},
                              btnOkOnPress: () {
                                BaseBloc.get<HealthBloc>(context).add(
                                    DeleteHealthEvent(
                                        baseEnity: DeleteEntity(
                                            id: visitModel.id ?? 0)));
                              }).show();
                        }),
                  if (AppUtils.permissions.isNotEmpty &&
                          AppUtils.permissions.any(
                              (p) => p.contains("api/notes/health/update/")) ||
                      AppUtils.permissions.isEmpty)
                    BtnIcon(
                        label: 'edit'.tr(),
                        icon: AppIcon.edit,
                        onTap: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (context) {
                              return AddHeathPage(
                                healthCondition: visitModel,
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
              visitModel.nameStudent,
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
