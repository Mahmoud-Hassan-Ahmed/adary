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
import 'package:adary/features/adary/data/models/student_model.dart';
import 'package:adary/features/adary/domain/entities/student_entity.dart';
import 'package:adary/features/adary/presentation/bloc/social/social_bloc.dart';
import 'package:adary/features/adary/presentation/widgets/note_teacher/titile.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:easy_localization/easy_localization.dart' as e;

class AddSocial extends StatefulWidget {
  const AddSocial({super.key, this.student, this.pagingController});
  final StudentModel? student;
  final PagingController? pagingController;

  @override
  State<AddSocial> createState() => _AddSocialState();
}

class _AddSocialState extends State<AddSocial> {
  late TextEditingController name;
  late TextEditingController parentName;
  late TextEditingController relation;
  int valueGroup = 1;
  int valueGroup2 = 3;
  bool valueSelect = false;
  bool sendSms = false;
  SelectModel? valueClass, valueRealtion;
  List<SelectModel> list = [];
  final formState = GlobalKey<FormState>();
  @override
  void initState() {
    name = TextEditingController(text: widget.student?.name);
    parentName = TextEditingController(text: widget.student?.studentGuardian);
    relation = TextEditingController(text: widget.student?.kinshipWithStudent);
    if (widget.student != null) {
      valueGroup = widget.student!.fatherIsAlive ? 1 : 2;
      valueGroup2 = widget.student!.motherIsAlive ? 3 : 4;
      valueSelect = widget.student?.notifyTeacher ?? false;
      sendSms = widget.student?.sendSms ?? false;
      valueRealtion = relationList.firstWhereOrNull(
          (e) => (e as Relations).value == widget.student!.withLive);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SocialBloc>(),
      child: BlocBuilder<SocialBloc, SocialState>(
        builder: (context, state) {
          if (state is DoneGetClassesState) {
            list = state.list;
            if (widget.student != null) {
              valueClass = list.firstWhereOrNull(
                  (e) => e.id == widget.student!.className.id);
            }
          } else if (state is SocialInitial) {
            BaseBloc.get<SocialBloc>(context).add(GetClasses());
          } else if (state is ChangeClassState) {
            valueClass = state.selectModel;
          } else if (state is ChangeRealtionState) {
            valueRealtion = state.selectModel;
          } else if (state is ChangeGroupState) {
            valueGroup = state.value;
          } else if (state is ChangeGroupState2) {
            valueGroup2 = state.value;
          } else if (state is DoneCreateStudentState) {
            AppUtils.showCustomSnackbar(
                e.tr('added_student'), SnackType.SUCESS);
            // BaseBloc.get<StudentsBloc>(ClassRoomPage.context!)
            //     .add(GetClassesRoomEvent());
            // WidgetsBinding.instance.addPersistentFrameCallback(
            //   (timeStamp) {
            //     // Navigator.pop(context);
            //   },
            // );
            Navigator.pop(context);
            widget.pagingController!.refresh();
          } else if (state is DoneUpdateStudentState) {
            AppUtils.showCustomSnackbar(
                e.tr('updated_student'), SnackType.SUCESS);
            // BaseBloc.get<StudentsBloc>(ClassRoomPage.context!)
            //     .add(GetClassesRoomEvent());

            Navigator.pop(context);
            widget.pagingController!.refresh();
          }
          if (state is ChnageNotifyState) {
            valueSelect = !valueSelect;
          }
          if (state is ChnageNotifyState3) {
            sendSms = !sendSms;
          }
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Scaffold(
                bottomNavigationBar: BottomNavigatorBar(items: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (formState.currentState!.validate()) {
                          if (widget.student == null) {
                            BaseBloc.get<SocialBloc>(context)
                                .add(CreatestudentEvent(
                              entity: StudentEntity(
                                  notifyTeacher: valueSelect,
                                  sendSms: sendSms,
                                  className: valueClass!.id,
                                  name: name.text,
                                  fatherIsAlive: valueGroup2 == 3,
                                  motherIsAlive: valueGroup2 == 1,
                                  kinshipWithStudent: relation.text,
                                  studentGuardian: parentName.text,
                                  withLive: (valueRealtion as Relations).value),
                            ));
                          } else {
                            BaseBloc.get<SocialBloc>(context).add(
                                UpdatestudentEvent(
                                    entity: StudentEntity(
                                        notifyTeacher: valueSelect,
                                        sendSms: sendSms,
                                        id: widget.student?.id,
                                        className: valueClass!.id,
                                        name: name.text,
                                        fatherIsAlive: valueGroup2 == 3,
                                        motherIsAlive: valueGroup2 == 1,
                                        kinshipWithStudent: relation.text,
                                        studentGuardian: parentName.text,
                                        withLive: (valueRealtion as Relations)
                                            .value)));
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        elevation: 4,
                      ),
                      child: Text(
                        e.tr('save'),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ]),
                appBar: MyAppBar(title: e.tr('back')),
                body: Form(
                  key: formState,
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(10),
                    children: [
                      InputApp(
                          textEditingController: name,
                          label: e.tr('name_student'),
                          hint: e.tr('write_here')),
                      Titile(label: e.tr('name_class')),
                      SelectInput(
                        items: list,
                        onChanged: (v) {
                          BaseBloc.get<SocialBloc>(context)
                              .add(ChangeClass(selectModel: v!));
                        },
                        label: e.tr('class'),
                        selectedValue: valueClass,
                      ),
                      InputApp(
                          textEditingController: parentName,
                          label: e.tr('parents_student'),
                          hint: e.tr('write_here')),
                      InputApp(
                          textEditingController: relation,
                          label: e.tr('nearning'),
                          hint: e.tr('write_here')),
                      Titile(label: e.tr('with_live')),
                      SelectInput(
                          selectedValue: valueRealtion,
                          items: relationList,
                          onChanged: (v) {
                            BaseBloc.get<SocialBloc>(context)
                                .add(ChangeRealtion(selectModel: v!));
                          },
                          label: e.tr('with_live')),
                      Titile(label: e.tr('father_on_live')),
                      Row(
                        children: [
                          RadioBtn(
                              group: valueGroup2,
                              label: e.tr('yes'),
                              value: 3,
                              valueChanged: (v) {
                                BaseBloc.get<SocialBloc>(context)
                                    .emitState(ChangeGroupState2(value: v!));
                              }),
                          const SizedBox(
                            width: 10,
                          ),
                          RadioBtn(
                              group: valueGroup2,
                              label: e.tr('no'),
                              value: 4,
                              valueChanged: (v) {
                                BaseBloc.get<SocialBloc>(context)
                                    .emitState(ChangeGroupState2(value: v!));
                              })
                        ],
                      ),
                      Titile(label: e.tr('mother_on_live')),
                      Row(
                        children: [
                          RadioBtn(
                              group: valueGroup,
                              label: e.tr('yes'),
                              value: 1,
                              valueChanged: (v) {
                                BaseBloc.get<SocialBloc>(context)
                                    .emitState(ChangeGroupState(value: v!));
                              }),
                          const SizedBox(
                            width: 10,
                          ),
                          RadioBtn(
                              group: valueGroup,
                              label: e.tr('no'),
                              value: 2,
                              valueChanged: (v) {
                                BaseBloc.get<SocialBloc>(context)
                                    .emitState(ChangeGroupState(value: v!));
                              })
                        ],
                      ),

                      Titile(
                        label: e.tr('not_teachers'),
                      ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              BaseBloc.get<SocialBloc>(context)
                                  .emitState(ChnageNotifyState());
                            },
                            child: RadioBtn(
                                group: valueSelect ? 1 : 0,
                                label: e.tr('yes'),
                                value: 1,
                                valueChanged: (v) {
                                  BaseBloc.get<SocialBloc>(context)
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
                                    BaseBloc.get<SocialBloc>(context)
                                        .emitState(ChnageNotifyState3());
                                  },
                                  child: RadioBtn(
                                      group: sendSms ? 1 : 0,
                                      label: e.tr('yes'),
                                      value: 1,
                                      valueChanged: (v) {
                                        BaseBloc.get<SocialBloc>(context)
                                            .emitState(ChnageNotifyState3());
                                      }),
                                ),
                              ],
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
