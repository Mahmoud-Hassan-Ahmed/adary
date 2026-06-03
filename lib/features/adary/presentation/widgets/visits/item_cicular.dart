import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/conts/app_colors.dart';
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
import 'package:flutter_svg/svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:open_filex/open_filex.dart';

class ItemCicular extends StatelessWidget {
  const ItemCicular(
      {super.key, required this.visitModel, required this.pagingController});
  final AdministrativeCircular visitModel;
  final PagingController pagingController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.APP_COLOR, width: 1),
      ),
      child: Column(
        children: [
          ExpansionWidget(
            body: [
              Wrap(
                children: [
                  SvgPicture.asset("assets/icons/iconoir_send-mail.svg"),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    visitModel.issuer,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Wrap(
                children: [
                  SvgPicture.asset("assets/icons/icon-date.svg"),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    '${'date'.tr()}  : ${visitModel.dateHijri}',
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(color: AppColors.APP_COLOR),
                  ),
                ],
              ),
              // Text(
              //   visitModel.dateHijri,
              //   style: Theme.of(context).textTheme.labelMedium,
              // ),

              const SizedBox(
                height: 20,
              ),
              ContainerBtns(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if (AppUtils.permissions.isNotEmpty &&
                            AppUtils.permissions
                                .contains('/circular/delete-circular/') ||
                        AppUtils.permissions.isEmpty)
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
                    BtnIcon(
                        label: 'download'.tr(),
                        icon: "assets/icons/material-symbols_download.svg",
                        onTap: () async {
                          final pdf = await AppUtils.downloadFile(
                              visitModel.fileUrl, '${visitModel.title}.pdf');
                          if (pdf != null) {
                            OpenFilex.open(pdf);
                          }
                        }),
                    if (AppUtils.checkPermission(['/circular/edit-circular/']))
                      BtnIcon(
                          label: 'edit'.tr(),
                          icon: "assets/icons/edit-contained.svg",
                          onTap: () {
                            AppUtils.go(AddCircale(
                              administrativeCircular: visitModel,
                              pagingController: pagingController,
                            ));
                          }),
                    if (AppUtils.checkPermission(['/circular/api/circular/']))
                      BtnIcon(
                          label: 'list_teachers'.tr(),
                          icon: 'assets/icons/pepicons-pencil_persons.svg',
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
              SvgPicture.asset("assets/icons/bi_file-pdf.svg"),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  visitModel.title,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
