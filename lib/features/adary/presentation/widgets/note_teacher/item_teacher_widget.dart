import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/conts/icons.dart';
import 'package:adary/core/share/widgets/btn_icon.dart';
import 'package:adary/core/share/widgets/container_btns.dart';
import 'package:adary/core/share/widgets/expansion_widget.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/note_teacher.dart';
import 'package:adary/features/adary/domain/entities/delete_entity.dart';
import 'package:adary/features/adary/presentation/bloc/teacher_note/teacher_notes_bloc.dart';
import 'package:adary/features/adary/presentation/widgets/note_teacher/send_note_teacher.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ItemTeacherWidget extends StatelessWidget {
  const ItemTeacherWidget(
      {super.key, required this.visitModel, required this.pagingController});
  final NotesTeacher visitModel;
  final PagingController pagingController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpansionWidget(
          body: [
            Text(
              visitModel.comment ?? '',
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
                              .contains('api/notes/teacher/delete/') ||
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
                              title: 'delete_note'.tr(),
                              desc: 'sure_delete_note'.tr(),
                              btnCancelText: 'no'.tr(),
                              btnOkText: 'delete'.tr(),
                              btnCancelOnPress: () {},
                              btnOkOnPress: () {
                                BaseBloc.get<TeacherNotesBloc>(context).add(
                                    DeleteTeacherNoteEvent(
                                        entity: DeleteEntity(
                                            id: visitModel.id ?? 0)));
                              }).show();
                        }),
                  if (AppUtils.permissions.isNotEmpty &&
                          AppUtils.permissions
                              .contains('api/notes/teachers-update/') ||
                      AppUtils.permissions.isEmpty)
                    BtnIcon(
                        label: 'edit'.tr(),
                        icon: AppIcon.edit,
                        onTap: () {
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
                        }),
                  if (AppUtils.permissions.isNotEmpty &&
                          AppUtils.permissions
                              .contains('/api/notes/teachers-notes/') ||
                      AppUtils.permissions.isEmpty)
                    BtnIcon(
                        label: 'assign_note'.tr(),
                        icon: AppIcon.edit,
                        onTap: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (context) {
                              return SendNoteContent(
                                isTeacher: true,
                                edit: false,
                                teachern: visitModel,
                                add: true,
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
              child: Text(
                visitModel.teacherId.name,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                visitModel.monitorNoteId.noteId.description,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: visitModel.monitorNoteId.noteId.typeNote == 'n'
                        ? Colors.red
                        : Colors.green),
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
