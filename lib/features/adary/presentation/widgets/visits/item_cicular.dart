import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/conts/icons.dart';
import 'package:adary/core/share/widgets/btn_icon.dart';
import 'package:adary/core/share/widgets/container_btns.dart';
import 'package:adary/core/share/widgets/expansion_widget.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/circular_model.dart';
import 'package:adary/features/adary/domain/entities/delete_entity.dart';
import 'package:adary/features/adary/presentation/bloc/circular/circular_bloc.dart';
import 'package:adary/features/adary/presentation/pages/add_circale.dart';
import 'package:adary/features/adary/presentation/widgets/visits/list_teachers_widget.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:open_filex/open_filex.dart';

class ItemCicular extends StatelessWidget {
  const ItemCicular(
      {super.key, required this.visitModel, required this.pagingController});
  final AdministrativeCircular visitModel;
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
                  "${"issuer".tr()} : ",
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                Text(
                  visitModel.issuer,
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
                  "${"date".tr()} : ",
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                Text(
                  visitModel.dateHijri,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
            // Text(
            //   visitModel.dateHijri,
            //   style: Theme.of(context).textTheme.labelMedium,
            // ),
            const Divider(
              height: 10,
            ),
            if (visitModel.sendNotification)
              Text(
                'noti_teacher'.tr(),
                style: Theme.of(context).textTheme.labelMedium,
              ),
            const SizedBox(
              height: 10,
            ),
            ContainerBtns(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (AppUtils.permissions.isNotEmpty &&
                          AppUtils.permissions
                              .contains('api/notes/circular/delete/') ||
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
                              title: 'delete_circular'.tr(),
                              desc: 'delete_circular_des'.tr(),
                              btnCancelText: 'no'.tr(),
                              btnOkText: 'delete'.tr(),
                              btnCancelOnPress: () {},
                              btnOkOnPress: () {
                                BaseBloc.get<CircularBloc>(context).add(
                                    DeleteCircularEvent(
                                        entity: DeleteEntity(
                                            id: visitModel.id ?? 0)));
                              }).show();
                        }),
                  if (AppUtils.permissions.isNotEmpty &&
                          AppUtils.permissions
                              .contains('api/notes/circular/download/') ||
                      AppUtils.permissions.isEmpty)
                    BtnIcon(
                        label: 'download'.tr(),
                        icon: AppIcon.download,
                        onTap: () async {
                          final pdf = await AppUtils.downloadFile(
                              visitModel.fileUrl, '${visitModel.title}.pdf');
                          if (pdf != null) {
                            OpenFilex.open(pdf);
                          }
                        }),
                  if (AppUtils.permissions.isNotEmpty &&
                          AppUtils.permissions
                              .contains('api/notes/circular/update/') ||
                      AppUtils.permissions.isEmpty)
                    BtnIcon(
                        label: 'edit'.tr(),
                        icon: AppIcon.edit,
                        onTap: () {
                          AppUtils.go(AddCircale(
                            administrativeCircular: visitModel,
                            pagingController: pagingController,
                          ));
                        }),
                  if (AppUtils.permissions.isNotEmpty &&
                          AppUtils.permissions
                              .contains('api/notes/circular/download/') ||
                      AppUtils.permissions.isEmpty)
                    BtnIcon(
                        label: 'list_teachers'.tr(),
                        icon: AppIcon.list,
                        onTap: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (context) {
                              return ListTeachersWidget(
                                classId: visitModel,
                              );
                            },
                          );
                        })
                ],
              ),
            ),
          ],
          title: [
            Image.asset(AppIcon.pdf),
            Text(
              visitModel.title,
              style: Theme.of(context).textTheme.labelMedium,
            )
          ],
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
