import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/conts/app_colors.dart' show AppColors;
import 'package:adary/core/conts/icons.dart';
import 'package:adary/core/enums/snack_bar_type_enum.dart';
import 'package:adary/core/share/widgets/btn_icon.dart';
import 'package:adary/core/share/widgets/container_btns.dart';
import 'package:adary/core/share/widgets/expansion_widget.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/note_teacher.dart';
import 'package:adary/features/adary/domain/entities/delete_entity.dart';
import 'package:adary/features/adary/presentation/bloc/teacher_note/teacher_notes_bloc.dart';
import 'package:adary/features/adary/domain/usecases/create_note_accountability_use_case.dart';
import 'package:adary/features/adary/presentation/widgets/note_teacher/send_note_teacher.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ItemTeacherWidget extends StatelessWidget {
  const ItemTeacherWidget(
      {super.key, required this.visitModel, required this.pagingController});
  final NotesTeacher visitModel;
  final PagingController pagingController;

  /// إسناد مساءلة على هذه الملاحظة — نظير زرّ «إرسال مساءلة» في الموقع.
  /// الخادم ينسخ نصّ الملاحظة وتاريخها من السجلّ، فلا يُرسل إلا معرّفها،
  /// ثم تظهر المساءلة في «مساءلات الملاحظات» بانتظار إفادة المعلّم.
  void _assignAccountability(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      title: 'send_accountability'.tr(),
      desc: 'sure_send_accountability'.tr(),
      btnCancelText: 'no'.tr(),
      btnOkText: 'yes'.tr(),
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        final result =
            await sl<CreateNoteAccountabilityUseCase>()(visitModel.id ?? 0);
        result.fold(
          (failure) =>
              AppUtils.showCustomSnackbar(failure.message, SnackType.FAILURE),
          (_) => AppUtils.showCustomSnackbar(
              'accountability_sent'.tr(), SnackType.SUCESS),
        );
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    // return Column(
    //   children: [
    //     ExpansionWidget(
    //       body: [
    //         Text(
    //           visitModel.comment ?? '',
    //           style: Theme.of(context).textTheme.labelMedium,
    //         ),
    //         const SizedBox(
    //           height: 10,
    //         ),
    //         ContainerBtns(
    //           content: Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceAround,
    //             children: [
    //               if (AppUtils.permissions.isNotEmpty &&
    //                       AppUtils.permissions
    //                           .contains('api/notes/teacher/delete/') ||
    //                   AppUtils.permissions.isEmpty)
    //                 BtnIcon(
    //                     label: 'delete'.tr(),
    //                     icon: AppIcon.rash,
    //                     onTap: () {
    //                       AwesomeDialog(
    //                           context: context,
    //                           dialogType: DialogType.warning,
    //                           titleTextStyle: const TextStyle(
    //                               color: Colors.red,
    //                               fontSize: 20,
    //                               fontWeight: FontWeight.bold),
    //                           title: 'delete_note'.tr(),
    //                           desc: 'sure_delete_note'.tr(),
    //                           btnCancelText: 'no'.tr(),
    //                           btnOkText: 'delete'.tr(),
    //                           btnCancelOnPress: () {},
    //                           btnOkOnPress: () {
    //                             BaseBloc.get<TeacherNotesBloc>(context).add(
    //                                 DeleteTeacherNoteEvent(
    //                                     entity: DeleteEntity(
    //                                         id: visitModel.id ?? 0)));
    //                           }).show();
    //                     }),
    //               if (AppUtils.permissions.isNotEmpty &&
    //                       AppUtils.permissions
    //                           .contains('api/notes/teachers-update/') ||
    //                   AppUtils.permissions.isEmpty)
    //                 BtnIcon(
    //                     label: 'edit'.tr(),
    //                     icon: AppIcon.edit,
    //                     onTap: () {
    //                       showModalBottomSheet(
    //                         isScrollControlled: true,
    //                         context: context,
    //                         builder: (context) {
    //                           return SendNoteContent(
    //                             isTeacher: true,
    //                             teachern: visitModel,
    //                             edit: true,
    //                             add: false,
    //                             pagingController: pagingController,
    //                           );
    //                         },
    //                       );
    //                     }),
    //               if (AppUtils.permissions.isNotEmpty &&
    //                       AppUtils.permissions
    //                           .contains('/api/notes/teachers-notes/') ||
    //                   AppUtils.permissions.isEmpty)
    //                 BtnIcon(
    //                     label: 'assign_note'.tr(),
    //                     icon: AppIcon.edit,
    //                     onTap: () {
    //                       showModalBottomSheet(
    //                         isScrollControlled: true,
    //                         context: context,
    //                         builder: (context) {
    //                           return SendNoteContent(
    //                             isTeacher: true,
    //                             edit: false,
    //                             teachern: visitModel,
    //                             add: true,
    //                             pagingController: pagingController,
    //                           );
    //                         },
    //                       );
    //                     })
    //             ],
    //           ),
    //         )
    //       ],
    //       title: [
    //         Expanded(
    //           child: Text(
    //             visitModel.teacherId.name,
    //             overflow: TextOverflow.ellipsis,
    //             style: Theme.of(context).textTheme.labelMedium,
    //           ),
    //         ),
    //         const SizedBox(
    //           width: 10,
    //         ),
    //         Expanded(
    //           child: Text(
    //             visitModel.monitorNoteId.noteId.description,
    //             overflow: TextOverflow.ellipsis,
    //             style: Theme.of(context).textTheme.labelMedium!.copyWith(
    //                 color: visitModel.monitorNoteId.noteId.typeNote == 'n'
    //                     ? Colors.red
    //                     : Colors.green),
    //           ),
    //         )
    //       ],
    //     ),
    //     const SizedBox(
    //       height: 10,
    //     )
    //   ],
    // );
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Top row (actions + name)
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                  "assets/icons/user-profile-03.svg"),
                              const SizedBox(width: 6),
                              Text(
                                visitModel.teacherId.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            visitModel.monitorNoteId.noteId.description,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: visitModel.monitorNoteId.noteId.typeNote ==
                                      'p'
                                  ? Colors.green
                                  : const Color(0xFFBD5126),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// Actions (left side in image)
                    Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                                tooltip: 'send_accountability'.tr(),
                                onPressed: () => _assignAccountability(context),
                                icon: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFEF7EE),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.assignment_late_outlined,
                                    size: 18,
                                    color: Color(0xFFBD5126),
                                  ),
                                )),
                            IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (context) {
                                      return SendNoteContent(
                                        isTeacher: true,
                                        teachern: visitModel,
                                        edit: true,
                                        add: false,
                                        pagingController: pagingController,
                                      );
                                    },
                                  );
                                },
                                icon: SvgPicture.asset(
                                    "assets/icons/edit_2.svg")),
                            // const SizedBox(width: 10),
                            IconButton(
                                onPressed: () {
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
                                        BaseBloc.get<TeacherNotesBloc>(context)
                                            .add(DeleteTeacherNoteEvent(
                                                entity: DeleteEntity(
                                                    id: visitModel.id ?? 0)));
                                      }).show();
                                },
                                icon: SvgPicture.asset(
                                    "assets/icons/delete_2.svg")),
                          ],
                        ),

                        /// Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color:
                                visitModel.monitorNoteId.noteId.typeNote == 'p'
                                    ? Colors.teal.shade100
                                    : const Color(0xFFFEF7EE),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            visitModel.monitorNoteId.noteId.typeNote == 'p'
                                ? 'إيجابية'
                                : 'بحاجة إلي تحسين ',
                            style: TextStyle(
                              color: visitModel.monitorNoteId.noteId.typeNote ==
                                      'p'
                                  ? Colors.green
                                  : const Color(0xFFBD5126),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    /// Name + avatar
                  ],
                ),

                // const SizedBox(height: 8),

                /// Role,

                /// Date
                Row(
                  children: [
                    SvgPicture.asset("assets/icons/calender2.svg"),
                    const SizedBox(width: 6),
                    Text(
                      DateFormat('dd/MM/yyyy')
                          .format(DateTime.parse(visitModel.createdAt!)),
                      style: const TextStyle(
                          color: AppColors.APP_COLOR,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                if (visitModel.comment != null &&
                    visitModel.comment!.isNotEmpty)
                  const SizedBox(height: 10),

                /// Note text
                ///
                if (visitModel.comment != null &&
                    visitModel.comment!.isNotEmpty)

                  ///
                  Text(
                    visitModel.comment ?? '',
                    style: const TextStyle(
                      color: Colors.black87,
                    ),
                  ),
                if (visitModel.comment != null &&
                    visitModel.comment!.isNotEmpty)
                  const SizedBox(height: 10),
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
                color: visitModel.monitorNoteId.noteId.typeNote == 'p'
                    ? AppColors.APP_COLOR
                    : const Color(0xffB45309),
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
