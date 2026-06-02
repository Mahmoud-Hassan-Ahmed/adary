import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/enums/relations.dart';
import 'package:adary/core/enums/snack_bar_type_enum.dart';
import 'package:adary/core/model/select_model.dart';
import 'package:adary/core/share/inputs/input_app.dart';
import 'package:adary/core/share/inputs/select_input.dart';
import 'package:adary/core/share/widgets/btn_app.dart';
import 'package:adary/core/share/widgets/my_app_bar.dart';
import 'package:adary/core/share/widgets/radio_btn.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/note_entity_model.dart';
import 'package:adary/features/adary/domain/entities/note_entity.dart';
import 'package:adary/features/adary/presentation/bloc/note/note_bloc.dart';
import 'package:adary/features/adary/presentation/pages/done_added_page.dart';
import 'package:adary/features/adary/presentation/widgets/note_teacher/titile.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:easy_localization/easy_localization.dart' as e;

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key, this.pagingController, this.noteModel});
  final PagingController? pagingController;
  final NoteModel? noteModel;

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  late TextEditingController name;
  SelectModel? typeNote;
  late TextEditingController numRepeat;
  late TextEditingController arranging;
  int sessionactive = 4;
  int whatsapp = 5;
  int sms = 9;
  int notification = 7;
  late TextEditingController template;
  final formState = GlobalKey<FormState>();
  @override
  void initState() {
    name = TextEditingController(text: widget.noteModel?.description);
    numRepeat = TextEditingController(
        text: widget.noteModel?.numToSend.toString() ?? '1');
    arranging = TextEditingController(
        text: widget.noteModel?.arranging.toString() ?? '0');
    template = TextEditingController(
        text: widget.noteModel?.templateMessage ??
            'الأستاذ: {name}، تم تدوين ملاحظة {note}. العدد : {num} ');

    if (widget.noteModel != null) {
      sessionactive = widget.noteModel!.howSession ? 3 : 4;
      whatsapp = widget.noteModel!.activeWhatsapp ? 5 : 6;
      sms = widget.noteModel!.activeSms ? 8 : 9;
      notification = widget.noteModel!.activeNotification ? 7 : 8;
      typeNote = typNoties.firstWhereOrNull(
          (e) => (e as Relations).value == widget.noteModel!.typeNote);
    } else {
      typeNote = typNoties.first;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<NoteBloc>(),
      child: BlocBuilder<NoteBloc, NoteState>(
        builder: (context, state) {
          if (state is SelectTypeNote) {
            typeNote = state.selectModel;
          } else if (state is ActiveNotificationsState) {
            notification = state.switchValue;
          } else if (state is ActiveSessionState) {
            sessionactive = state.switchValue;
          } else if (state is ActiveWhasappState) {
            if (!AppUtils.appUser!.whatsappService.isActive) {
              whatsapp = 5;
              AppUtils.showCustomSnackbar(
                  e.tr('whatsapp_not_active'), SnackType.FAILURE);
            } else {
              whatsapp = state.switchValue;
            }
          } else if (state is ActiveSmsState) {
            if (AppUtils.appUser!.smsService == null ||
                !AppUtils.appUser!.smsService!.isActive) {
              sms = 9;
              AppUtils.showCustomSnackbar(
                  e.tr('sms_not_active'), SnackType.FAILURE);
            } else {
              sms = state.switchValue;
            }
          } else if (state is DoneAddNoteState) {
            // AppUtils.showCustomSnackbar(e.tr('added_note'), SnackType.SUCESS);
            WidgetsBinding.instance.addPostFrameCallback((callback) {
              AppUtils.go(const DoneAddedPage(
                  label: 'تم إضافة الملاحظة بنجاح',
                  title: 'إنشاء ملاحظة جديدة  '));
            });
            widget.pagingController?.refresh();
            Navigator.pop(context);

            // WidgetsBinding.instance.addPostFrameCallback((callback) {

            // });
          } else if (state is DoneUpdateNoteState) {
            // AppUtils.showCustomSnackbar(e.tr('updated_note'), SnackType.SUCESS);
            WidgetsBinding.instance.addPostFrameCallback((callback) {
              AppUtils.go(DoneAddedPage(
                  label: e.tr('updated_note'), title: 'إنشاء ملاحظة جديدة  '));
            });
            widget.pagingController?.refresh();
            Navigator.pop(context);
          }
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Scaffold(
                appBar: MyAppBar(title: e.tr('إنشاء ملاحظة جديدة  ')),
                body: Form(
                  key: formState,
                  child: ListView(
                    padding: const EdgeInsets.only(
                        top: 0, right: 10, left: 10, bottom: 10),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      InputApp(
                          // numLine: 2,
                          textEditingController: name,
                          label: e.tr('أسم الملاحظة '),
                          hint: e.tr('ادخل أسم الملاحظة')),
                      Titile(label: e.tr('type_note')),
                      SelectInput(
                          selectedValue: typeNote,
                          items:
                              // SessionModel(id: 0,name: '')
                              typNoties,
                          onChanged: (value) {
                            BaseBloc.get<NoteBloc>(context)
                                .emitState(SelectTypeNote(selectModel: value!));
                          },
                          // selectedValue: typeNote,
                          label: e.tr('type_note')),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //   children: [
                      //     ...typNoties.map((e) => RadioBtn(
                      //         group: typeNote?.id ?? 1,
                      //         label: e.name,
                      //         value: e.id,
                      //         valueChanged: (v) {
                      //           BaseBloc.get<NoteBloc>(context)
                      //               .emitState(SelectTypeNote(selectModel: e));
                      //         }))
                      //   ],
                      // ),
                      InputApp(
                          textInputType: TextInputType.number,
                          textEditingController: numRepeat,
                          label: e.tr('num_repeating'),
                          hint: e.tr('write_here')),
                      InputApp(
                          textInputType: TextInputType.number,
                          textEditingController: arranging,
                          label: e.tr('arranging'),
                          hint: e.tr('write_here')),
                      // Titile(label: e.tr('session_active')),
                      const SizedBox(
                        height: 10,
                      ),
                      RadioBtn(
                          group: 3,
                          label: e.tr('session_active'),
                          value: sessionactive,
                          valueChanged: (v) {
                            AppUtils.log(v.toString());
                            AppUtils.log(sessionactive.toString());
                            if (sessionactive == 3) {
                              sessionactive = 4;
                            } else {
                              sessionactive = 3;
                            }
                            BaseBloc.get<NoteBloc>(context).emitState(
                                ActiveSessionState(switchValue: sessionactive));
                          }),
                      // Row(
                      //   children: [
                      //     const SizedBox(
                      //       width: 10,
                      //     ),
                      //     RadioBtn(
                      //         group: sessionactive,
                      //         label: e.tr('no'),
                      //         value: 4,
                      //         valueChanged: (v) {
                      //           BaseBloc.get<NoteBloc>(context).emitState(
                      //               ActiveSessionState(switchValue: v!));
                      //         })
                      //   ],
                      // ),

                      const SizedBox(
                        height: 10,
                      ),
                      RadioBtn(
                          group: 5,
                          label: e.tr('whatsapp_active'),
                          value: whatsapp,
                          valueChanged: (v) {
                            if (whatsapp == 5) {
                              whatsapp = 6;
                            } else {
                              whatsapp = 5;
                            }
                            BaseBloc.get<NoteBloc>(context).emitState(
                                ActiveWhasappState(switchValue: whatsapp));
                          }),
                      const SizedBox(
                        height: 10,
                      ),
                      RadioBtn(
                          group: 8,
                          label: e.tr('sms_active'),
                          value: sms,
                          valueChanged: (v) {
                            if (sms == 8) {
                              sms = 9;
                            } else {
                              sms = 8;
                            }
                            BaseBloc.get<NoteBloc>(context)
                                .emitState(ActiveSmsState(switchValue: sms));
                          }),
                      const SizedBox(
                        height: 10,
                      ),
                      RadioBtn(
                          group: 7,
                          label: e.tr('notification_active'),
                          value: notification,
                          valueChanged: (v) {
                            if (notification == 7) {
                              notification = 8;
                            } else {
                              notification = 7;
                            }
                            BaseBloc.get<NoteBloc>(context).emitState(
                                ActiveNotificationsState(
                                    switchValue: notification));
                          }),

                      if (whatsapp == 5 || notification == 7 || sms == 8)
                        Column(
                          children: [
                            InputApp(
                                numLine: 5,
                                textEditingController: template,
                                label: e.tr('template_message'),
                                hint: e.tr('write_here')),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'name تكون اسم المعلم ,type_not تكون نوع الملاحظة, num يكون عدد تكرار الملاحظة,note تكون الوصف',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(fontSize: 12),
                            ),
                          ],
                        ),
                      const SizedBox(
                        height: 10,
                      ),
                      BtnApp(
                          label: e.tr('save'),
                          onTap: () {
                            if (formState.currentState!.validate()) {
                              if (widget.noteModel != null) {
                                BaseBloc.get<NoteBloc>(context).add(
                                    UpdateNoteEvent(
                                        entity: NoteEntity(
                                            id: widget.noteModel!.id,
                                            description: name.text,
                                            typeNote:
                                                (typeNote as Relations).value,
                                            activeNotification:
                                                notification == 7,
                                            activeWhatsapp: whatsapp == 5,
                                            activeSms: sms == 8,
                                            arranging:
                                                int.tryParse(arranging.text),
                                            howSession: sessionactive == 3,
                                            numToSend:
                                                int.parse(numRepeat.text),
                                            templateMessage: template.text)));
                              } else {
                                BaseBloc.get<NoteBloc>(context).add(
                                    AddNoteEvent(
                                        enity: NoteEntity(
                                            description: name.text,
                                            typeNote:
                                                (typeNote as Relations).value,
                                            activeNotification:
                                                notification == 7,
                                            activeWhatsapp: whatsapp == 5,
                                            activeSms: sms == 8,
                                            arranging:
                                                int.tryParse(arranging.text),
                                            howSession: sessionactive == 3,
                                            numToSend:
                                                int.parse(numRepeat.text),
                                            templateMessage: template.text)));
                              }
                            }
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
