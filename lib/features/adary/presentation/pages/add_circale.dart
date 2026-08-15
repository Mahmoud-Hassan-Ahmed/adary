import 'dart:io';

import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/enums/snack_bar_type_enum.dart';
import 'package:adary/core/model/select_model.dart';
import 'package:adary/core/share/inputs/input_app.dart';
import 'package:adary/core/share/inputs/select_mutiple.dart';
import 'package:adary/core/share/widgets/bottom_navigator_bar.dart';
import 'package:adary/core/share/widgets/btn_app.dart';
import 'package:adary/core/share/widgets/date_widget.dart';
import 'package:adary/core/share/widgets/file_input.dart';
import 'package:adary/core/share/widgets/my_app_bar.dart';
import 'package:adary/core/share/widgets/radio_btn.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/circular_model.dart';
import 'package:adary/features/adary/data/models/teacher_model.dart';
import 'package:adary/features/adary/domain/entities/circular_entity.dart';
import 'package:adary/features/adary/domain/entities/pagination_entity.dart';
import 'package:adary/features/adary/presentation/bloc/circular/circular_bloc.dart';
import 'package:adary/features/adary/presentation/pages/done_added_page.dart';
import 'package:adary/features/adary/presentation/widgets/note_teacher/titile.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:easy_localization/easy_localization.dart' as e;

class AddCircale extends StatefulWidget {
  const AddCircale(
      {super.key, this.administrativeCircular, required this.pagingController});
  final AdministrativeCircular? administrativeCircular;
  final PagingController pagingController;

  @override
  State<AddCircale> createState() => _AddCircaleState();
}

class _AddCircaleState extends State<AddCircale> {
  late TextEditingController title;
  late TextEditingController name;
  List<Teacher> teachers = [];
  List<SelectModel> selected = [];
  DateTime? gregorianDate;
  String? dateHijri;

  /// أشعار المعلمين عن طريق التطبيق -> send_notif
  bool valueSelect = false;

  /// إرسال رسالة نصية -> send_sms
  bool sendSms = false;

  /// أشعار المعلمين عن طريق الواتس اب -> whatsapp_notif
  bool sendwhats = false;

  /// جميع المعلمين -> select_all
  bool valueSelect2 = true;
  File? file;
  final formState = GlobalKey<FormState>();

  @override
  void initState() {
    title = TextEditingController(text: widget.administrativeCircular?.title);
    name = TextEditingController(text: widget.administrativeCircular?.issuer);
    if (widget.administrativeCircular != null) {
      gregorianDate = widget.administrativeCircular!.date;
      dateHijri = widget.administrativeCircular!.dateHijri;
      valueSelect = widget.administrativeCircular!.sendNotification;
      valueSelect2 = widget.administrativeCircular!.selectAll;
      sendSms = widget.administrativeCircular!.sendSms;
      sendwhats = widget.administrativeCircular!.sendWhatsapp;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CircularBloc>(),
      child: BlocBuilder<CircularBloc, CircularState>(
        builder: (context, state) {
          if (state is CircularInitial) {
            BaseBloc.get<CircularBloc>(context).add(GetTeachersEvent());
          } else if (state is GetTeachersState) {
            teachers = state.list;
            if (widget.administrativeCircular != null &&
                !widget.administrativeCircular!.selectAll) {
              BaseBloc.get<CircularBloc>(context).add(
                  GetAllCircularTeacherEvent(
                      entity: PaginationEntity(
                          page: 1,
                          classId: widget.administrativeCircular?.id)));
            }
            if (valueSelect2) {
              selected = teachers;
            }
          } else if (state is SelectedTeachersState) {
            selected = state.list;
            valueSelect2 = false;
          } else if (state is SelectDateState) {
            dateHijri = state.enity;
          } else if (state is ChnageNotifyState) {
            valueSelect = !valueSelect;
          } else if (state is ChnageNotifyState3) {
            sendSms = !sendSms;
          } else if (state is ChnageNotifyState4) {
            sendwhats = !sendwhats;
          } else if (state is ChnageNotifyState2) {
            valueSelect2 = !valueSelect2;
            if (valueSelect2) {
              selected = teachers;
            } else {
              selected = [];
            }
          } else if (state is DoneAddCircularState) {
            // AppUtils.showCustomSnackbar(
            //     e.tr('added_circular'), SnackType.SUCESS);
            WidgetsBinding.instance.addPostFrameCallback((callback) {
              AppUtils.go(const DoneAddedPage(
                  label: 'تم إضافة التعميم بنجاح', title: 'إضافة تعميم جديد'));
            });
            Navigator.pop(context);
            widget.pagingController.refresh();
          } else if (state is DoneGetAllCirularsState) {
            for (var e in state.list) {
              final techer =
                  teachers.firstWhereOrNull((m) => m.id == e.teacherId.id);
              if (techer != null) {
                selected.add(techer);
              }
            }
          } else if (state is DoneUpdateCircularState) {
            // AppUtils.showCustomSnackbar(
            //     e.tr('updated_circular'), SnackType.SUCESS);
            WidgetsBinding.instance.addPostFrameCallback((callback) {
              AppUtils.go(DoneAddedPage(
                  label: e.tr('updated_circular'), title: 'إضافة تعميم جديد'));
            });
            Navigator.pop(context);
            widget.pagingController.refresh();
          }
          return SafeArea(
            child: Scaffold(
              appBar: MyAppBar(title: e.tr('إضافة تعميم جديد ')),
              bottomNavigationBar: BottomNavigatorBar(items: [
                Expanded(
                  child: BtnApp(
                    label: e.tr('save'),
                    onTap: () {
                      if (formState.currentState!.validate()) {
                        if (!valueSelect2 && selected.isEmpty) {
                          AppUtils.showCustomSnackbar(
                              e.tr('choose_teachers'), SnackType.FAILURE);
                          return;
                        }
                        if (widget.administrativeCircular != null) {
                          BaseBloc.get<CircularBloc>(context).add(
                              UpdateCircularEvent(
                                  entity: CircularEntity(
                                      id: widget.administrativeCircular!.id,
                                      title: title.text,
                                      date: gregorianDate!,
                                      dateHijri: dateHijri!,
                                      issuer: name.text,
                                      file: file,
                                      sendSms: sendSms,
                                      sendNotif: valueSelect,
                                      sendWhatsapp: sendwhats,
                                      selectAll: valueSelect2,
                                      teachers: selected)));
                        } else {
                          if (file == null) {
                            AppUtils.showCustomSnackbar(
                                e.tr('add_file'), SnackType.FAILURE);
                            return;
                          }
                          BaseBloc.get<CircularBloc>(context).add(
                              AddCircularEvent(
                                  enity: CircularEntity(
                                      title: title.text,
                                      date: gregorianDate!,
                                      dateHijri: dateHijri!,
                                      issuer: name.text,
                                      file: file!,
                                      sendSms: sendSms,
                                      sendNotif: valueSelect,
                                      sendWhatsapp: sendwhats,
                                      selectAll: valueSelect2,
                                      teachers: selected)));
                        }
                      }
                    },
                  ),
                ),
              ]),
              body: Form(
                key: formState,
                child: ListView(
                  padding: const EdgeInsets.all(10),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    InputApp(
                        textEditingController: title,
                        label: e.tr('title_circular'),
                        hint: e.tr('write_here')),
                    InputApp(
                        textEditingController: name,
                        label: e.tr('name_issues'),
                        hint: e.tr('write_here')),
                    Titile(
                      label: e.tr('choose_date'),
                    ),
                    DateWidget(
                      selectDate: dateHijri,
                      onChange: (value) {
                        gregorianDate = value.gregorianDate;
                        Navigator.pop(context);
                        BaseBloc.get<CircularBloc>(context)
                            .add(SelectDateEvent(enity: value.hijriDate));
                      },
                    ),
                    Titile(
                      label: e.tr('choose_teachers'),
                    ),
                    SelectMutiple(
                      selectedItems: selected,
                      items: teachers,
                      onChange: (value) {
                        BaseBloc.get<CircularBloc>(context)
                            .emitState(SelectedTeachersState(list: value));
                      },
                      label: e.tr('choose_teachers'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // جميع المعلمين -> select_all
                    RadioBtn(
                        group: valueSelect2 ? 2 : -1,
                        label: e.tr('all_teachers'),
                        value: 2,
                        valueChanged: (v) {
                          BaseBloc.get<CircularBloc>(context)
                              .add(ChnageNotifyEvent2());
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    // أشعار المعلمين عن طريق الواتس اب -> whatsapp_notif
                    RadioBtn(
                        group: sendwhats ? 4 : -1,
                        label: e.tr('أشعار المعلميين عن طريق الواتس اب '),
                        value: 4,
                        valueChanged: (v) {
                          BaseBloc.get<CircularBloc>(context)
                              .add(ChnageNotifyEvent4());
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    // أشعار المعلمين عن طريق التطبيق -> send_notif
                    RadioBtn(
                        group: valueSelect ? 1 : -1,
                        label: e.tr('أشعار المعلميين عن طريق التطبيق '),
                        value: 1,
                        valueChanged: (v) {
                          BaseBloc.get<CircularBloc>(context)
                              .add(ChnageNotifyEvent());
                        }),
                    if (AppUtils.appUser?.smsService != null &&
                        AppUtils.appUser!.smsService!.isActive)
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),

                            //   height: 10,
                            // ),
                            Row(
                              children: [
                                RadioBtn(
                                    group: sendSms ? 1 : -1,
                                    label: e.tr('yes'),
                                    value: 1,
                                    valueChanged: (v) {
                                      BaseBloc.get<CircularBloc>(context)
                                          .add(ChnageNotifyEvent3());
                                    }),
                              ],
                            ),
                          ]),
                    const SizedBox(
                      height: 10,
                    ),
                    FileInput(
                      selectFile: (f) {
                        file = f;
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
