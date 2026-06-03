import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/conts/app_colors.dart';
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
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class HealthItem extends StatelessWidget {
  const HealthItem(
      {super.key, required this.visitModel, required this.pagingController});
  final HealthCondition visitModel;
  final PagingController pagingController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.APP_COLOR, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          ExpansionWidget(
            ispadding: F,
            body: [
              const Divider(
                height: 20,
                indent: 0,
                endIndent: 0,
                color: AppColors.APP_COLOR,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "name_health".tr(),
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.APP_COLOR),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        visitModel.name,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 20,
                indent: 0,
                endIndent: 0,
                color: AppColors.APP_COLOR,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "class".tr(),
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.APP_COLOR),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        visitModel.classNameId.name,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 20,
                color: AppColors.APP_COLOR,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "name".tr(),
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.APP_COLOR),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        visitModel.nameStudent,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 20,
                color: AppColors.APP_COLOR,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "dealing".tr(),
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: AppColors.APP_COLOR),
                      ),
                    ),
                    // const Text(' : '),
                    Expanded(
                      child: Text(
                        visitModel.dealingWithSituation,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 20,
                color: AppColors.APP_COLOR,
              ),
              const SizedBox(
                height: 10,
              ),
              ContainerBtns(
                content: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      if (AppUtils.checkPermission(['/health/delete-health/']))
                        BtnIcon(
                            label: 'delete'.tr(),
                            icon: 'assets/icons/delete.svg',
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
                      const SizedBox(
                        width: 40,
                      ),
                      if (AppUtils.checkPermission(['/health/edit-health/']))
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
      ),
    );
  }
}
