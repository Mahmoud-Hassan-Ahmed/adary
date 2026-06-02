import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/conts/app_colors.dart';
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
import 'package:adary/features/adary/presentation/widgets/social/rating_view.dart';
import 'package:adary/features/adary/presentation/widgets/visits/plan_visit.dart';
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
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.APP_COLOR, width: 1),
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          ExpansionWidget(
            ispadding: false,
            body: [
              const Divider(
                height: 20,
                color: AppColors.APP_COLOR,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "name_visitor".tr(),
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
                        visitModel.visitorName,
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
                        visitModel.className!.name,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 10,
                color: AppColors.APP_COLOR,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "session".tr(),
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
                        sessions
                            .firstWhere((test) =>
                                (test as Relations).value ==
                                (visitModel.session ?? '1'))
                            .name,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 10,
                color: AppColors.APP_COLOR,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        "التقيم العام".tr(),
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.APP_COLOR),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              visitModel.rateName,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ),
                          RatingView(
                            rating: visitModel.rate_visit,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const Divider(
                height: 10,
                color: AppColors.APP_COLOR,
              ),
              ContainerBtns(
                hasBorder: false,
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if (AppUtils.permissions.isNotEmpty &&
                            AppUtils.permissions.any((p) =>
                                p.contains("api/notes/Visits/delete/")) ||
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
                    BtnIcon(
                        label: 'download'.tr(),
                        icon: AppIcon.download,
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
                        }),
                    if (AppUtils.permissions.isNotEmpty &&
                            AppUtils.permissions.any((p) =>
                                p.contains("api/notes/Visits/update/")) ||
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
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        BaseBloc.get<ClassVisitBloc>(context)
                            .add(GetEvaluationByVisitEvent(v: visitModel.id!));
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: "edit",
                          child: Text("تقييم زيارة الفصل "),
                        ),
                      ],
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.grey,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "تاريخ  الزيارة : ${visitModel.dateHijri}",
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(color: AppColors.APP_COLOR),
                      ),
                    )
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
