import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/conts/icons.dart';
import 'package:adary/core/share/widgets/btn_icon.dart';
import 'package:adary/core/share/widgets/container_btns.dart';
import 'package:adary/core/share/widgets/expansion_widget.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/model_19.dart';
import 'package:adary/features/adary/domain/entities/delete_entity.dart';
import 'package:adary/features/adary/domain/entities/file_download_entity.dart';
import 'package:adary/features/adary/presentation/bloc/model19/model19_bloc.dart';
import 'package:adary/features/adary/presentation/widgets/admin_prepation/add_model19.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:path_provider/path_provider.dart';

class ItemModel19 extends StatelessWidget {
  const ItemModel19(
      {super.key, required this.item, required this.pagingController});
  final Model19Model item;
  final PagingController pagingController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.APP_COLOR, width: 2),
          borderRadius: BorderRadius.circular(25)),
      child: Column(
        children: [
          ExpansionWidget(
            title: [
              SvgPicture.asset("assets/icons/person.svg"),
              const SizedBox(
                width: 10,
              ),
              Text(
                item.teacher.name,
                style: Theme.of(context).textTheme.labelMedium,
              )
            ],
            body: [
              Text(
                'sum_hourse'.tr(),
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                item.exitTime.toString(),
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'sum_days'.tr(),
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                item.numDays.toString(),
                style: Theme.of(context).textTheme.labelMedium,
              ),
              ContainerBtns(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if (AppUtils.permissions.isNotEmpty &&
                            AppUtils.permissions.any((p) =>
                                p.contains('api/notes/model19/delete/')) ||
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
                                title: 'delete_model'.tr(),
                                desc: 'delete_model_des'.tr(),
                                btnCancelText: 'no'.tr(),
                                btnOkText: 'delete'.tr(),
                                btnCancelOnPress: () {},
                                btnOkOnPress: () {
                                  BaseBloc.get<Model19Bloc>(context).add(
                                      DeleteModel19Event(
                                          entity: DeleteEntity(id: item.id)));
                                }).show();
                          }),
                    if (AppUtils.permissions.isNotEmpty &&
                            AppUtils.permissions.any((p) =>
                                p.contains('api/notes/model19/download/')) ||
                        AppUtils.permissions.isEmpty)
                      BtnIcon(
                          label: 'download'.tr(),
                          icon: AppIcon.download,
                          onTap: () async {
                            final tempDir = await getTemporaryDirectory();

                            // Define a file path for the downloaded file
                            final filePath =
                                '${tempDir.path}/${item.teacher.name}.pdf';
                            BaseBloc.get<Model19Bloc>(context).add(
                                DownloadFileEvent(
                                    baseEnity: FileDownloadEneity(
                                        id: item.id, pathDownload: filePath)));
                          }),
                    if (AppUtils.permissions.isNotEmpty &&
                            AppUtils.permissions.any((p) =>
                                p.contains('api/notes/model19/download/')) ||
                        AppUtils.permissions.isEmpty)
                      BtnIcon(
                          label: 'طباعة',
                          icon: AppIcon.print,
                          onTap: () async {
                            final tempDir = await getTemporaryDirectory();
                            final filePath =
                                '${tempDir.path}/${item.teacher.name}.pdf';
                            BaseBloc.get<Model19Bloc>(context).add(
                                DownloadFileEvent(
                                    baseEnity: FileDownloadEneity(
                                        id: item.id,
                                        pathDownload: filePath,
                                        print: true)));
                          }),
                    if (AppUtils.permissions.isNotEmpty &&
                            AppUtils.permissions.any((p) =>
                                p.contains('api/notes/model19/update/')) ||
                        AppUtils.permissions.isEmpty)
                      BtnIcon(
                          label: 'edit'.tr(),
                          icon: AppIcon.edit,
                          onTap: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                return AddModel19(
                                  pagingController: pagingController,
                                  model19model: item,
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
          )
        ],
      ),
    );
  }
}
