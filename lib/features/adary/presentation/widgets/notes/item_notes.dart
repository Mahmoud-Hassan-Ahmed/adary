import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/conts/icons.dart';
import 'package:adary/core/share/widgets/btn_icon.dart';
import 'package:adary/core/share/widgets/container_btns.dart';
import 'package:adary/core/share/widgets/expansion_widget.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/note_entity_model.dart';
import 'package:adary/features/adary/domain/entities/delete_entity.dart';

import 'package:adary/features/adary/presentation/bloc/note/note_bloc.dart';
import 'package:adary/features/adary/presentation/pages/add_note_page.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ItemNotes extends StatelessWidget {
  const ItemNotes(
      {super.key, required this.visitModel, required this.pagingController});
  final NoteModel visitModel;
  final PagingController pagingController;

  @override
  Widget build(BuildContext context) {
    //   return Column(
    //     children: [
    //       ExpansionWidget(
    //         body: [
    //           Text(
    //             '${'arraging'.tr()} :${visitModel.arranging ?? 0}',
    //             style: Theme.of(context).textTheme.labelMedium,
    //           ),
    //           const SizedBox(
    //             height: 10,
    //           ),
    //           CheckboxListTile(
    //             activeColor: AppColors.checkbox,
    //             value: visitModel.howSession,
    //             onChanged: (v) {},
    //             title: Text(
    //               'session_active'.tr(),
    //               style: Theme.of(context).textTheme.titleMedium,
    //             ),
    //           ),
    //           const Divider(),
    //           CheckboxListTile(
    //             activeColor: AppColors.checkbox,
    //             value: visitModel.activeWhatsapp,
    //             onChanged: (v) {},
    //             title: Text(
    //               'whatsapp_active'.tr(),
    //               style: Theme.of(context).textTheme.titleMedium,
    //             ),
    //           ),
    //           const Divider(),
    //           CheckboxListTile(
    //             // checkColor: AppColors.checkbox,
    //             activeColor: AppColors.checkbox,
    //             value: visitModel.activeNotification,
    //             onChanged: (v) {},
    //             title: Text(
    //               'notification_active'.tr(),
    //               style: Theme.of(context).textTheme.titleMedium,
    //             ),
    //           ),
    //           ContainerBtns(
    //             content: Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceAround,
    //               children: [
    //                 if (AppUtils.permissions.isNotEmpty &&
    //                         AppUtils.permissions.contains('api/notes/delete/') ||
    //                     AppUtils.permissions.isEmpty)
    //                   BtnIcon(
    //                       label: 'delete'.tr(),
    //                       icon: AppIcon.rash,
    //                       onTap: () {
    //                         AwesomeDialog(
    //                             context: context,
    //                             dialogType: DialogType.warning,
    //                             titleTextStyle: const TextStyle(
    //                                 color: Colors.red,
    //                                 fontSize: 20,
    //                                 fontWeight: FontWeight.bold),
    //                             title: 'delete_note'.tr(),
    //                             desc: 'delete_note_des'.tr(),
    //                             btnCancelText: 'no'.tr(),
    //                             btnOkText: 'delete'.tr(),
    //                             btnCancelOnPress: () {},
    //                             btnOkOnPress: () {
    //                               BaseBloc.get<NoteBloc>(context).add(
    //                                   DeleteNoteEvent(
    //                                       entity: DeleteEntity(
    //                                           id: visitModel.id ?? 0)));
    //                             }).show();
    //                       }),
    //                 if (AppUtils.permissions.isNotEmpty &&
    //                         AppUtils.permissions.contains('api/notes/update/') ||
    //                     AppUtils.permissions.isEmpty)
    //                   BtnIcon(
    //                       label: 'edit'.tr(),
    //                       icon: AppIcon.edit,
    //                       onTap: () {
    //                         showModalBottomSheet(
    //                           isScrollControlled: true,
    //                           context: context,
    //                           builder: (context) {
    //                             return AddNotePage(
    //                               noteModel: visitModel,
    //                               pagingController: pagingController,
    //                             );
    //                           },
    //                         );
    //                       })
    //               ],
    //             ),
    //           )
    //         ],
    //         title: [
    //           Text(
    //             visitModel.description,
    //             style: Theme.of(context).textTheme.labelMedium!.copyWith(
    //                 color:
    //                     visitModel.typeNote == 'n' ? Colors.red : Colors.green),
    //           )
    //         ],
    //       ),
    //       const SizedBox(
    //         height: 10,
    //       )
    //     ],
    //   );
    // }
    return Container(
      margin: const EdgeInsets.all(12),
      child: Stack(
        children: [
          /// CARD
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                  color: Colors.black.withOpacity(0.1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                /// TOP ROW
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        visitModel.description,
                        style: const TextStyle(
                          fontSize: 14,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    /// BADGE
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        color: visitModel.typeNote == 'n'
                            ? const Color(0xffB45309).withOpacity(0.09)
                            : AppColors.APP_COLOR.withOpacity(0.09),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        visitModel.typeNote == 'n'
                            ? 'تحتاج الي تحسين'
                            : 'ملاحظة إيجابية',
                        style: TextStyle(
                          color: visitModel.typeNote == 'n'
                              ? Color(0xffB45309)
                              : AppColors.APP_COLOR,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    /// TITLE
                  ],
                ),

                const SizedBox(height: 12),

                /// BOTTOM ROW
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// ICONS

                    /// ORDER
                    Text(
                      'الترتيب: ${visitModel.arranging ?? 0}',
                      style: const TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (context) {
                                  return AddNotePage(
                                    noteModel: visitModel,
                                    pagingController: pagingController,
                                  );
                                },
                              );
                            },
                            icon: SvgPicture.asset("assets/icons/edit_2.svg")),
                        // const SizedBox(width: 10),
                        IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.warning,
                                  titleTextStyle: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  title: 'delete_note'.tr(),
                                  desc: 'delete_note_des'.tr(),
                                  btnCancelText: 'no'.tr(),
                                  btnOkText: 'delete'.tr(),
                                  btnCancelOnPress: () {},
                                  btnOkOnPress: () {
                                    BaseBloc.get<NoteBloc>(context).add(
                                        DeleteNoteEvent(
                                            entity: DeleteEntity(
                                                id: visitModel.id ?? 0)));
                                  }).show();
                            },
                            icon:
                                SvgPicture.asset("assets/icons/delete_2.svg")),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// RIGHT BORDER
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 5,
              decoration: BoxDecoration(
                color: visitModel.typeNote == 'n'
                    ? const Color(0xffB45309)
                    : AppColors.APP_COLOR,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
