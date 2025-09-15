import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/conts/icons.dart';
import 'package:adary/core/share/widgets/btn_icon.dart';
import 'package:adary/core/share/widgets/btn_with_icon.dart';
import 'package:adary/core/share/widgets/container_btns.dart';
import 'package:adary/core/share/widgets/expansion_widget.dart';
import 'package:adary/features/adary/data/models/model18.dart';
import 'package:adary/features/adary/domain/entities/delete_entity.dart';
import 'package:adary/features/adary/domain/entities/file_download_entity.dart';
import 'package:adary/features/adary/presentation/bloc/delay/delay_bloc.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:path_provider/path_provider.dart';

import 'add_delayed_alert.dart';

class ItemDelayAlert extends StatelessWidget {
  const ItemDelayAlert(
      {super.key, required this.item, required this.pagingController});
  final Model18Model item;
  final PagingController pagingController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpansionWidget(
          title: [
            Text(
              item.teacher.name,
              style: Theme.of(context).textTheme.labelMedium,
            )
          ],
          body: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'date'.tr(),
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Text(
                  item.dayDate,
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
                            title: 'delete_note'.tr(),
                            desc: 'sure_delete_note'.tr(),
                            btnCancelText: 'no'.tr(),
                            btnOkText: 'delete'.tr(),
                            btnCancelOnPress: () {},
                            btnOkOnPress: () {
                              BaseBloc.get<DelayBloc>(context).add(
                                  DeleteModel18event(
                                      entity: DeleteEntity(id: item.id)));
                            }).show();
                      }),
                  BtnIcon(
                      label: 'download'.tr(),
                      icon: AppIcon.download,
                      onTap: () async {
                        final tempDir = await getTemporaryDirectory();

                        final filePath =
                            '${tempDir.path}/${item.teacher.name}.pdf';
                        BaseBloc.get<DelayBloc>(context).add(DownloadFileEvent(
                            baseEnity: FileDownloadEneity(
                                id: item.id, pathDownload: filePath)));
                      }),
                  BtnIcon(
                      label: 'طباعة',
                      icon: AppIcon.print,
                      onTap: () async {
                        final tempDir = await getTemporaryDirectory();
                        final filePath =
                            '${tempDir.path}/${item.teacher.name}.pdf';
                        BaseBloc.get<DelayBloc>(context).add(DownloadFileEvent(
                            baseEnity: FileDownloadEneity(
                                id: item.id,
                                pathDownload: filePath,
                                print: true)));
                      }),
                  BtnIcon(
                      label: 'edit'.tr(),
                      icon: AppIcon.edit,
                      onTap: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return AddDelayedAlert(
                              pagingController: pagingController,
                              model18model: item,
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
    );
  }
}
