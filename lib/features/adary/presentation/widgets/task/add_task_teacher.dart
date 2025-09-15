import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/enums/relations.dart';
import 'package:adary/core/enums/snack_bar_type_enum.dart';
import 'package:adary/core/model/select_model.dart';
import 'package:adary/core/share/inputs/select_input.dart';
import 'package:adary/core/share/inputs/select_mutiple.dart';
import 'package:adary/core/share/widgets/bottom_navigator_bar.dart';
import 'package:adary/core/share/widgets/btn_app.dart';
import 'package:adary/core/share/widgets/date_widget.dart';
import 'package:adary/core/share/widgets/my_app_bar.dart';
import 'package:adary/core/share/widgets/time_button.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/task_teacher_mdel.dart';
import 'package:adary/features/adary/domain/entities/teacher_task.dart';
import 'package:adary/features/adary/presentation/bloc/delay_task/delay_task_bloc.dart';
import 'package:adary/features/adary/presentation/widgets/note_teacher/titile.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:easy_localization/easy_localization.dart' as e;

class AddTeacherTask extends StatelessWidget {
  const AddTeacherTask({super.key, this.dailyTask, this.pagingController});

  final DailyTask? dailyTask;
  final PagingController? pagingController;

  @override
  Widget build(BuildContext context) {
    final formState = GlobalKey<FormState>();
    List<SelectModel> teachers = [];
    List<SelectModel> tasks = [];
    SelectModel? task, repeat = repeats.first;
    List<SelectModel>? teacher;
    String? dateHijri, dateHijri2, time1, time2;
    DateTime? gregorianDate, gregorianDate2;
    if (dailyTask != null) {
      dateHijri = dailyTask!.date;
      gregorianDate = DateTime.parse(dateHijri);
      time1 = dailyTask!.startTime;
      time2 = dailyTask!.endTime;
    }
    return BlocProvider(
      create: (context) => sl<DelayTaskBloc>(),
      child: BlocBuilder<DelayTaskBloc, DelayTaskState>(
        builder: (context, state) {
          if (state is DelayTaskInitial) {
            BaseBloc.get<DelayTaskBloc>(context).add(GetTeacherEvent());
          } else if (state is DoneGetTeacherState) {
            teachers = state.list;
            if (dailyTask != null) {
              // teacher = teachers
              //     .firstWhereOrNull((e) => e.id == dailyTask!.teacher.id);
            }
            BaseBloc.get<DelayTaskBloc>(context).add(GetTasksEvent());
          } else if (state is DoneGetTasksState) {
            tasks = state.list;
            if (dailyTask != null) {
              task = tasks.firstWhereOrNull((e) => e.id == dailyTask!.task.id);
            }
          } else if (state is SelectTeacherState) {
            teacher = state.selectModel;
          } else if (state is SelectTaskState) {
            task = state.selectModel;
          } else if (state is SelectDateState) {
            dateHijri = state.value;
          } else if (state is ChangeTime2State) {
            time2 = state.value;
          } else if (state is ChangeTime1State) {
            time1 = state.value;
          } else if (state is DobneAddTaskTeacherState) {
            AppUtils.showCustomSnackbar(
                e.tr('added_mission'), SnackType.SUCESS);
            Navigator.pop(context);

            if (pagingController != null) {
              pagingController!.refresh();
            }
          } else if (state is DobneUpdateTaskTeacherState) {
            AppUtils.showCustomSnackbar(
                e.tr('updated_mission'), SnackType.SUCESS);
            Navigator.pop(context);

            if (pagingController != null) {
              pagingController!.refresh();
            }
          } else if (state is SelectRepeatState) {
            repeat = state.selectModel;
          } else if (state is SelectDate2State) {
            dateHijri2 = state.value;
          }
          return Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Form(
              key: formState,
              child: SafeArea(
                child: Scaffold(
                  appBar: MyAppBar(title: e.tr('assign_mission')),
                  bottomNavigationBar: BottomNavigatorBar(items: [
                    Expanded(
                      child: BtnApp(
                          label: e.tr('save'),
                          onTap: () {
                            if (formState.currentState!.validate()) {
                              if (dailyTask == null) {
                                BaseBloc.get<DelayTaskBloc>(context).add(
                                    AddTaskTeacherEvtnt(
                                        baseEnity: TeacherTask(
                                            date: DateFormat('yyyy-MM-dd')
                                                .format(gregorianDate!),
                                            endTime: time2!,
                                            startTime: time1!,
                                            teacher: teacher!
                                                .map((e) => e.id)
                                                .toList(),
                                            task: task!.id,
                                            endDate: gregorianDate2 != null
                                                ? DateFormat('yyyy-MM-dd')
                                                    .format(gregorianDate2!)
                                                : null)));
                              } else {
                                BaseBloc.get<DelayTaskBloc>(context).add(
                                    UpdateTaskTeacherEvent(
                                        enity: TeacherTask(
                                            id: dailyTask!.id,
                                            date: DateFormat('yyyy-MM-dd')
                                                .format(gregorianDate!),
                                            endTime: time2!,
                                            repeat: repeat!.id,
                                            startTime: time1!,
                                            teacher: teacher!
                                                .map((e) => e.id)
                                                .toList(),
                                            task: task!.id,
                                            endDate: gregorianDate2 != null
                                                ? DateFormat('yyyy-MM-dd')
                                                    .format(gregorianDate2!)
                                                : null)));
                              }
                            }
                          }),
                    )
                  ]),
                  body: ListView(
                    padding: const EdgeInsets.only(
                        top: 0, right: 10, left: 10, bottom: 10),
                    children: [
                      Titile(label: e.tr('teacher')),
                      SelectMutiple(
                        selectedItems: teacher ?? [],
                        items: teachers,
                        onChange: (value) {
                          BaseBloc.get<DelayTaskBloc>(context).emitState(
                              SelectTeacherState(selectModel: value));
                        },
                        label: e.tr('choose_teachers'),
                      ),
                      Titile(label: e.tr('mission')),
                      SelectInput(
                        items: tasks,
                        onChanged: (v) {
                          BaseBloc.get<DelayTaskBloc>(context)
                              .emitState(SelectTaskState(selectModel: v!));
                        },
                        label: e.tr('mission'),
                        selectedValue: task,
                      ),
                      Titile(
                        label: e.tr('choose_date'),
                      ),
                      DateWidget(
                        selectDate: dateHijri,
                        onChange: (value) {
                          final hijriDate = value.hijriDate;

                          gregorianDate = value.gregorianDate;
                          Navigator.pop(context);
                          BaseBloc.get<DelayTaskBloc>(context)
                              .emitState(SelectDateState(value: hijriDate));
                        },
                      ),
                      Titile(label: e.tr('from_houre')),
                      TimeButton(
                        onChange: (v) {
                          BaseBloc.get<DelayTaskBloc>(context).emitState(
                              ChangeTime1State(
                                  value: DateFormat('HH:mm').format(v)));
                        },
                        selectDate: time1,
                      ),
                      Titile(label: e.tr('to_houre')),
                      TimeButton(
                        onChange: (v) {
                          BaseBloc.get<DelayTaskBloc>(context).emitState(
                              ChangeTime2State(
                                  value: DateFormat('HH:mm').format(v)));
                        },
                        selectDate: time2,
                      ),
                      Titile(label: e.tr('repeat')),
                      SelectInput(
                        items: repeats,
                        onChanged: (v) {
                          BaseBloc.get<DelayTaskBloc>(context)
                              .emitState(SelectRepeatState(selectModel: v!));
                        },
                        label: e.tr('repeat'),
                        selectedValue: repeat,
                      ),
                      if (repeat!.id != 0)
                        Titile(
                          label: e.tr('end_date'),
                        ),
                      if (repeat!.id != 0)
                        DateWidget(
                          selectDate: dateHijri2,
                          onChange: (value) {
                            final hijriDate = value.hijriDate;

                            gregorianDate2 = value.gregorianDate;
                            Navigator.pop(context);
                            BaseBloc.get<DelayTaskBloc>(context)
                                .emitState(SelectDate2State(value: hijriDate));
                          },
                        ),
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
