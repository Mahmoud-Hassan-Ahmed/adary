import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/conts/icons.dart';
import 'package:adary/core/share/widgets/btn_icon.dart';
import 'package:adary/core/share/widgets/btn_with_icon.dart';
import 'package:adary/core/share/widgets/container_btns.dart';
import 'package:adary/core/share/widgets/expansion_widget.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/model_20.dart';
import 'package:adary/features/adary/domain/entities/delay_entity.dart';
import 'package:adary/features/adary/domain/entities/delete_entity.dart';
import 'package:adary/features/adary/domain/entities/file_download_entity.dart';
import 'package:adary/features/adary/domain/usecases/send_model20_decision_use_case.dart';
import 'package:adary/features/adary/presentation/bloc/model20/model20_bloc.dart';
import 'package:adary/features/adary/presentation/pages/manager_decision_page.dart';
import 'package:adary/features/adary/presentation/widgets/admin_prepation/add_model20.dart';
import 'package:adary/features/adary/presentation/widgets/admin_prepation/procedure_status_chip.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:path_provider/path_provider.dart';

class ItemModel20 extends StatelessWidget {
  const ItemModel20(
      {super.key, required this.item, required this.pagingController});
  final Model20Model item;
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
          ProcedureStatusChip(cycle: item.cycle),
          ExpansionWidget(
            title: [
              SvgPicture.asset("assets/icons/person.svg"),
              const SizedBox(
                width: 10,
              ),
              Text(
                item.teacher?.name ?? '',
                style: Theme.of(context).textTheme.labelMedium,
              )
            ],
            body: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset("assets/icons/icon-date.svg"),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    item.atDayDate.toString(),
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              ContainerBtns(
                content: Wrap(
                  alignment: WrapAlignment.spaceAround,
                  spacing: 16,
                  runSpacing: 12,
                  children: [
                    if (AppUtils.permissions.isNotEmpty &&
                            AppUtils.permissions.any((p) =>
                                p.contains('api/notes/model20/delete/')) ||
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
                                  BaseBloc.get<Model20Bloc>(context).add(
                                      DeleteModel20Event(
                                          entity: DeleteEntity(id: item.id)));
                                }).show();
                          }),
                    if (AppUtils.permissions.isNotEmpty &&
                            AppUtils.permissions.any((p) =>
                                p.contains('api/notes/model20/download/')) ||
                        AppUtils.permissions.isEmpty)
                      BtnIcon(
                          label: 'download'.tr(),
                          icon: AppIcon.download,
                          onTap: () async {
                            final tempDir = await getTemporaryDirectory();

                            // Define a file path for the downloaded file
                            final filePath =
                                '${tempDir.path}/${item.teacher?.name ?? ''}.pdf';
                            BaseBloc.get<Model20Bloc>(context).add(
                                DownloadFileEvent(
                                    baseEnity: FileDownloadEneity(
                                        id: item.id, pathDownload: filePath)));
                          }),
                    if (AppUtils.permissions.isNotEmpty &&
                            AppUtils.permissions.any((p) =>
                                p.contains('api/notes/model20/download/')) ||
                        AppUtils.permissions.isEmpty)
                      BtnIcon(
                          label: 'print'.tr(),
                          icon: AppIcon.print,
                          onTap: () async {
                            final tempDir = await getTemporaryDirectory();
                            final filePath =
                                '${tempDir.path}/${item.teacher?.name}.pdf';
                            BaseBloc.get<Model20Bloc>(context).add(
                                DownloadFileEvent(
                                    baseEnity: FileDownloadEneity(
                                        id: item.id,
                                        pathDownload: filePath,
                                        print: true)));
                          }),
                    if (AppUtils.permissions.isNotEmpty &&
                            AppUtils.permissions.any((p) =>
                                p.contains('api/notes/model20/update/')) ||
                        AppUtils.permissions.isEmpty)
                      BtnIcon(
                          label: 'edit'.tr(),
                          icon: AppIcon.edit,
                          onTap: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                return AddModel20(
                                  pagingController: pagingController,
                                  model20model: item,
                                );
                              },
                            );
                          }),
                    if (AppUtils.permissions.isNotEmpty &&
                            AppUtils.permissions.any((p) =>
                                p.contains('api/notes/model20/update/')) ||
                        AppUtils.permissions.isEmpty)
                      BtnIcon(
                          label: 'take_decision'.tr(),
                          icon: AppIcon.takeDecision,
                          onTap: () async {
                            final saved = await Navigator.push<bool>(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ManagerDecisionPage(
                                  procedureId: item.id,
                                  cycle: item.cycle,
                                  onSubmit:
                                      sl<SendModel20DecisionUseCase>().call,
                                ),
                              ),
                            );
                            // القرار يغيّر حالة البطاقة، فتُعاد القائمة لتعكسه.
                            if (saved == true) pagingController.refresh();
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
