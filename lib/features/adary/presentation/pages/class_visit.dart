import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/enums/relations.dart';
import 'package:adary/core/enums/snack_bar_type_enum.dart';
import 'package:adary/core/model/select_model.dart';
import 'package:adary/core/share/inputs/input_app.dart';
import 'package:adary/core/share/inputs/select_input.dart';
import 'package:adary/core/share/widgets/bottom_navigator_bar.dart';
import 'package:adary/core/share/widgets/my_app_bar.dart';
import 'package:adary/core/share/widgets/radio_btn.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/teacher_model.dart';
import 'package:adary/features/adary/data/models/visits_model.dart';
import 'package:adary/features/adary/domain/entities/visits_entity.dart';
import 'package:adary/features/adary/presentation/bloc/class_visit/class_visit_bloc.dart';
import 'package:adary/features/adary/presentation/widgets/note_teacher/titile.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../core/share/widgets/date_widget.dart';
import 'package:easy_localization/easy_localization.dart' as e;

class AddClassVisit extends StatefulWidget {
  const AddClassVisit(
      {super.key, required this.pagingController, this.visitModel});
  final PagingController pagingController;
  final VisitModel? visitModel;

  @override
  State<AddClassVisit> createState() => _AddClassVisitState();
}

class _AddClassVisitState extends State<AddClassVisit> {
  DateTime? gregorianDate;
  String? dateHijri;
  SelectModel? selected, selectedClass, valueSession;
  List<SelectModel> classes = [];
  List<Teacher> teachers = [];
  late TextEditingController nameVisitor;
  final formState = GlobalKey<FormState>();
  bool valueSelect = false;
  bool sendSms = false;

  @override
  void initState() {
    nameVisitor = TextEditingController(text: widget.visitModel?.visitorName);
    if (widget.visitModel != null) {
      valueSession = sessions.firstWhereOrNull(
          (e) => (e as Relations).value == (widget.visitModel?.session ?? '1'));
      AppUtils.log('valueSession ${valueSession!.name}');
      dateHijri = widget.visitModel!.dateHijri;
      gregorianDate = widget.visitModel!.date;
      valueSelect = widget.visitModel?.notifyTeacher ?? false;
      sendSms = widget.visitModel?.sendSms ?? false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ClassVisitBloc>(),
      child: BlocBuilder<ClassVisitBloc, ClassVisitState>(
        builder: (context, state) {
          if (state is DoneGetClassesState) {
            classes = state.list;
            BaseBloc.get<ClassVisitBloc>(context).add(GetTeachersEvent());

            if (widget.visitModel != null) {
              selectedClass = classes
                  .firstWhereOrNull((e) => e.id == widget.visitModel!.id);
            }
          } else if (state is ClassVisitInitial) {
            BaseBloc.get<ClassVisitBloc>(context).add(GetClasses());
          } else if (state is ChangeClassState) {
            selectedClass = state.selectModel;
          } else if (state is ChangeSession) {
            valueSession = state.selectModel;
          } else if (state is SelectDateState) {
            dateHijri = state.entity;
          } else if (state is DoneGetTeachersState) {
            teachers = state.list;
            if (widget.visitModel != null) {
              selected = teachers.firstWhereOrNull(
                  (e) => e.id == widget.visitModel!.teacher.id);
            }
          } else if (state is SelectedTeachersState) {
            selected = state.teacher;
          } else if (state is DoneAddVisitState) {
            AppUtils.showCustomSnackbar(e.tr('added_visit'), SnackType.SUCESS);
            widget.pagingController.refresh();
            Navigator.pop(context);
          } else if (state is DoneUpdateVisitState) {
            AppUtils.showCustomSnackbar(
                e.tr('updated_visit'), SnackType.SUCESS);
            widget.pagingController.refresh();
            Navigator.pop(context);
          } else if (state is ChnageNotifyState) {
            valueSelect = !valueSelect;
          } else if (state is ChnageNotifyState3) {
            sendSms = !sendSms;
          }
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Scaffold(
                appBar: MyAppBar(title: e.tr('back')),
                bottomNavigationBar: BottomNavigatorBar(items: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (formState.currentState!.validate()) {
                          if (widget.visitModel != null) {
                            BaseBloc.get<ClassVisitBloc>(context).add(
                                UpdateVisitevent(
                                    enity: VisitEntity(
                                        notifyTeacher: valueSelect,
                                        sendSms: sendSms,
                                        id: widget.visitModel!.id,
                                        teacher: selected!.id,
                                        visitorName: nameVisitor.text,
                                        date: gregorianDate!,
                                        className: selectedClass?.id,
                                        session: valueSession != null
                                            ? (valueSession as Relations).value
                                            : null,
                                        dateHijri: dateHijri!,
                                        sendNotif: true,
                                        isVisible: true)));
                          } else {
                            BaseBloc.get<ClassVisitBloc>(context).add(
                                AddClassVisitsEvent(
                                    enity: VisitEntity(
                                        notifyTeacher: valueSelect,
                                        sendSms: sendSms,
                                        teacher: selected!.id,
                                        visitorName: nameVisitor.text,
                                        date: gregorianDate!,
                                        className: selectedClass?.id,
                                        session: valueSession != null
                                            ? (valueSession as Relations).value
                                            : null,
                                        dateHijri: dateHijri!,
                                        sendNotif: true,
                                        isVisible: true)));
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        elevation: 4,
                      ),
                      child: Text(
                        e.tr('save'),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ]),
                body: Form(
                  key: formState,
                  child: ListView(
                    padding: const EdgeInsets.only(
                        top: 0, right: 10, left: 10, bottom: 10),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      InputApp(
                          textEditingController: nameVisitor,
                          label: e.tr('name_visitor'),
                          hint: e.tr('write_here')),
                      Titile(label: e.tr('name_class')),
                      SelectInput(
                        items: classes,
                        onChanged: (v) {
                          BaseBloc.get<ClassVisitBloc>(context)
                              .emitState(ChangeClassState(selectModel: v!));
                        },
                        label: e.tr('class'),
                        selectedValue: selectedClass,
                      ),
                      Titile(label: e.tr('session')),
                      SelectInput(
                        items: sessions,
                        onChanged: (v) {
                          BaseBloc.get<ClassVisitBloc>(context)
                              .emitState(ChangeSession(selectModel: v!));
                        },
                        label: e.tr('session'),
                        selectedValue: valueSession,
                      ),
                      Titile(
                        label: e.tr('choose_date'),
                      ),

                      DateWidget(
                        selectDate: dateHijri,
                        onChange: (value) {
                          gregorianDate = value.gregorianDate;
                          Navigator.pop(context);
                          BaseBloc.get<ClassVisitBloc>(context).emitState(
                              SelectDateState(entity: value.hijriDate));
                        },
                      ),
                      Titile(
                        label: e.tr('choose_teachers'),
                      ),

                      SelectInput(
                        selectedValue: selected,
                        items: teachers,
                        onChanged: (value) {
                          BaseBloc.get<ClassVisitBloc>(context).emitState(
                              SelectedTeachersState(teacher: value!));
                        },
                        label: e.tr('choose_teachers'),
                      ),
                      Titile(
                        label: e.tr('not_teacher'),
                      ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              BaseBloc.get<ClassVisitBloc>(context)
                                  .emitState(ChnageNotifyState());
                            },
                            child: RadioBtn(
                                group: valueSelect ? 1 : 0,
                                label: e.tr('yes'),
                                value: 1,
                                valueChanged: (v) {
                                  BaseBloc.get<ClassVisitBloc>(context)
                                      .emitState(ChnageNotifyState());
                                }),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (AppUtils.appUser?.smsService != null ||
                          AppUtils.appUser!.smsService!.isActive)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Titile(
                              label: e.tr('send_sms'),
                            ),
                            // const SizedBox(
                            //   height: 10,
                            // ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    BaseBloc.get<ClassVisitBloc>(context)
                                        .emitState(ChnageNotifyState3());
                                  },
                                  child: RadioBtn(
                                      group: sendSms ? 1 : 0,
                                      label: e.tr('yes'),
                                      value: 1,
                                      valueChanged: (v) {
                                        BaseBloc.get<ClassVisitBloc>(context)
                                            .emitState(ChnageNotifyState3());
                                      }),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        )
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
