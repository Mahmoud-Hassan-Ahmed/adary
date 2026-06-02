import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/enums/snack_bar_type_enum.dart';
import 'package:adary/core/model/select_model.dart';
import 'package:adary/core/share/inputs/select_input.dart';
import 'package:adary/core/share/widgets/bottom_navigator_bar.dart';
import 'package:adary/core/share/widgets/btn_app.dart';
import 'package:adary/core/share/widgets/date_widget.dart';
import 'package:adary/core/share/widgets/my_app_bar.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/note_entity_model.dart';
import 'package:adary/features/adary/data/models/note_teacher.dart';
import 'package:adary/features/adary/data/models/teacher_model.dart';
import 'package:adary/features/adary/domain/entities/monitor_note.dart';
import 'package:adary/features/adary/domain/entities/teacher_note_entity.dart';
import 'package:adary/features/adary/domain/entities/teachers_entity.dart';
import 'package:adary/features/adary/presentation/bloc/teacher_note/teacher_notes_bloc.dart';
import 'package:adary/features/adary/presentation/widgets/note_teacher/item_teacher_comment.dart';
import 'package:adary/features/adary/presentation/widgets/note_teacher/titile.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:easy_localization/easy_localization.dart' as easy;

class SendNoteContent extends StatefulWidget {
  const SendNoteContent(
      {super.key,
      this.pagingController,
      this.teachern,
      this.add,
      this.isTeacher = false,
      this.edit = false});
  final PagingController? pagingController;
  final NotesTeacher? teachern;
  final bool? add;
  final bool isTeacher;
  final bool edit;

  @override
  State<SendNoteContent> createState() => _SendNoteContentState();
}

class _SendNoteContentState extends State<SendNoteContent> {
  var groupValue = 4;
  String? selectDate;
  List<NoteModel> notes = [];
  List<Teacher> teachers = [];
  List<TeacherNote> teacherNote = [];
  DateTime? gregorianDate;
  SelectModel? selectModel = sessionChoices[0];
  NoteModel? noteModel;
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    if (widget.teachern != null) {
      selectDate = widget.teachern!.monitorNoteId.dateHijri;
      gregorianDate = DateTime.tryParse(widget.teachern!.monitorNoteId.date);
      selectModel = sessionChoices.firstWhereOrNull((e) =>
          (e as SessionModel).id ==
          int.parse(widget.teachern!.monitorNoteId.session ?? '0'));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<TeacherNotesBloc>(),
      child: BlocBuilder<TeacherNotesBloc, TeacherNotesState>(
        builder: (context, state) {
          if (state is TeacherNotesInitial) {
            BaseBloc.get<TeacherNotesBloc>(context).add(GetNotesEvent());
          } else if (state is DoneGetNotesState) {
            notes = state.notes;
            if (state.notes.isNotEmpty) {
              noteModel = state.notes.first;
              groupValue = noteModel!.id;
            }

            if (widget.teachern == null) {
              BaseBloc.get<TeacherNotesBloc>(context).add(GetTeachersEvent());
            } else {
              noteModel = notes.firstWhereOrNull(
                  (e) => e.id == widget.teachern!.monitorNoteId.noteId.id);
              groupValue = noteModel!.id;
              if (teachers.firstWhereOrNull(
                      (e) => e.id == widget.teachern!.teacherId.id) ==
                  null) {
                teachers.add(widget.teachern!.teacherId);

                teacherNote.add(TeacherNote(
                    isActive: true,
                    id: widget.teachern!.id,
                    comment: widget.teachern!.comment ?? '',
                    monitorNote: widget.teachern!.monitorNoteId.id ?? 0,
                    teacher: widget.teachern!.teacherId.id));
              }
            }
          } else if (state is DoneSelectRadioBtnEvent) {
            groupValue = state.groupValue;
            noteModel = notes.firstWhere((e) => e.id == groupValue);
          } else if (state is DoneDateState) {
            selectDate = state.value;
          } else if (state is DoneGetDataTeachersState) {
            teachers = state.list;
          } else if (state is ChangeSessionState) {
            selectModel = state.enity;
          } else if (state is DoneUpdateNoteTeacher) {
            AppUtils.showCustomSnackbar(
                easy.tr('update_note'), SnackType.SUCESS);
            Navigator.pop(context);
            widget.pagingController!.refresh();
          } else if (state is DoneCreateNoteTeachers) {
            AppUtils.showCustomSnackbar(
                easy.tr('done_add_note'), SnackType.SUCESS);
          }

          return Padding(
            padding: EdgeInsets.only(top: widget.isTeacher ? 30 : 0),
            child: SafeArea(
              child: Scaffold(
                appBar: widget.isTeacher
                    ? MyAppBar(
                        title: widget.edit
                            ? easy.tr('note_update')
                            : easy.tr('add_note'))
                    : null,
                bottomNavigationBar: BottomNavigatorBar(
                  items: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: BtnApp(
                          onTap: () {
                            List<TeacherNote> list = [];
                            for (var element in teacherNote) {
                              if (element.isActive) {
                                list.add(element);
                              }
                            }
                            if (formKey.currentState!.validate()) {
                              final noteSelect = notes.firstWhereOrNull(
                                  (test) => test.id == groupValue);
                              if (noteSelect!.activeWhatsapp) {
                                if (!AppUtils
                                    .appUser!.whatsappService.isActive) {
                                  AppUtils.showCustomSnackbar(
                                      easy.tr('whatsapp_not_active'),
                                      SnackType.FAILURE);
                                  return;
                                } else if (AppUtils
                                        .appUser!.whatsappService.remaining <
                                    list.length) {
                                  AppUtils.showCustomSnackbar(
                                      easy.tr('whatsapp_not_remaining'),
                                      SnackType.FAILURE);
                                  return;
                                }
                              }

                              if (widget.teachern != null &&
                                  widget.add == false) {
                                BaseBloc.get<TeacherNotesBloc>(context).add(
                                    UpdateNoteTeacherEvent(
                                        baseEnity: TeachersEntity(
                                            list: list,
                                            monitorNoteEntity:
                                                MonitorNoteEntity(
                                                    note: groupValue,
                                                    date: gregorianDate!,
                                                    dateHijri: selectDate ?? '',
                                                    session:
                                                        noteModel!.howSession
                                                            ? selectModel!.id
                                                            : null))));
                              } else {
                                BaseBloc.get<TeacherNotesBloc>(context).add(
                                    CreateTeacherNoteEvent(
                                        enity: TeachersEntity(
                                            list: list,
                                            monitorNoteEntity:
                                                MonitorNoteEntity(
                                                    note: groupValue,
                                                    date: gregorianDate!,
                                                    dateHijri: selectDate ?? '',
                                                    session:
                                                        noteModel!.howSession
                                                            ? selectModel!.id
                                                            : null))));
                              }
                            }
                          },
                          label: easy.tr('save'),
                        ),
                      ),
                    ),
                  ],
                ),
                body: Form(
                  key: formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(10),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Text(
                        easy.tr('send_not'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.checkbox),
                      ),
                      Titile(
                        label: easy.tr('choose_notes'),
                      ),
                      SelectInput(
                        items: notes,
                        onChanged: (value) {
                          BaseBloc.get<TeacherNotesBloc>(context)
                              .add(SelectRadioBtnEvent(groupValue: value!.id));
                        },
                        label: easy.tr('choose_notes'),
                        selectedValue: notes
                            .firstWhereOrNull((test) => test.id == groupValue),
                      ),
                      if (noteModel != null && noteModel!.howSession)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Titile(
                              label: easy.tr('session'),
                            ),
                            SelectInput(
                                items: sessionChoices,
                                selectedValue: selectModel,
                                onChanged: (v) {
                                  BaseBloc.get<TeacherNotesBloc>(context)
                                      .add(ChangeSessionEvent(enity: v!));
                                },
                                label: easy.tr('choose_session'))
                          ],
                        ),
                      Titile(
                        label: easy.tr('choose_date'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      DateWidget(
                        onChange: (value) {
                          gregorianDate = value.gregorianDate;
                          Navigator.pop(context);
                          BaseBloc.get<TeacherNotesBloc>(context)
                              .add(SelectDateEvent(value: value.hijriDate));
                        },
                        selectDate: selectDate,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Titile(label: easy.tr('choose_teacher')),
                      ...teachers.map((e) {
                        var note = teacherNote
                            .firstWhereOrNull((m) => m.teacher == e.id);

                        if (note == null) {
                          note = TeacherNote(
                              teacher: e.id,
                              monitorNote: groupValue,
                              comment: '',
                              isActive: false);

                          teacherNote.add(note);
                        }
                        return ItemTeacherComment(
                          teacherNote: note,
                          teacher: e,
                        );
                      })
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
