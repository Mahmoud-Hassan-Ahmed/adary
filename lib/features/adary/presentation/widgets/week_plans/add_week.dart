import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/model/select_model.dart';
import 'package:adary/core/share/inputs/input_app.dart';
import 'package:adary/core/share/inputs/select_input.dart';
import 'package:adary/core/share/widgets/bottom_navigator_bar.dart';
import 'package:adary/core/share/widgets/btn_app.dart';
import 'package:adary/core/share/widgets/my_app_bar.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/task_teacher_mdel.dart';
import 'package:adary/features/adary/data/models/week_group.dart';
import 'package:adary/features/adary/data/models/week_plan.dart';
import 'package:adary/features/adary/presentation/bloc/delay_task/delay_task_bloc.dart';
import 'package:adary/features/adary/presentation/bloc/week_plan/week_plan_bloc.dart';
import 'package:adary/features/adary/presentation/pages/done_added_page.dart';
import 'package:adary/features/adary/presentation/widgets/note_teacher/titile.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart' as e;

class AddWeek extends StatefulWidget {
  AddWeek({
    super.key,
    this.weekGroupModel,
  });

  final WeekGroupModel? weekGroupModel;

  @override
  State<AddWeek> createState() => _AddWeekState();
}

class _AddWeekState extends State<AddWeek> {
  final formState = GlobalKey<FormState>();
  List<SessionModel> items = [
    SessionModel(id: 1, name: 'مفعل'),
    SessionModel(id: 2, name: 'غير مفعل')
  ];
  SelectModel? value;
  late TextEditingController name;
  late TextEditingController numberOfWeeks;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    name = TextEditingController(
        text: widget.weekGroupModel != null ? widget.weekGroupModel!.name : '');
    numberOfWeeks = TextEditingController(
        text: widget.weekGroupModel != null
            ? widget.weekGroupModel!.weeksCount.toString()
            : '');
    value = widget.weekGroupModel != null
        ? items.firstWhere((element) =>
            element.id == (widget.weekGroupModel!.isActive ? 1 : 2))
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<WeekPlanBloc>(),
      child: BlocBuilder<WeekPlanBloc, WeekPlanState>(
        builder: (context, state) {
          if (state is SelectedTeachersState) {
            value = state.value;
          } else if (state is DoneAddWeekGroupState) {
            WidgetsBinding.instance.addPostFrameCallback((callback) {
              AppUtils.go(DoneAddedPage(
                  label: 'تمت الإضافة بنجاح', title: 'اضافة مجموعة اسبوع'));
            });
            Navigator.pop(context);
          } else if (state is DoneUpdateWeekGroupState) {
            WidgetsBinding.instance.addPostFrameCallback((callback) {
              AppUtils.go(DoneAddedPage(
                  label: 'تمت التعديل بنجاح', title: 'تعديل مجموعة اسبوع'));
            });
            Navigator.pop(context);
          }
          return Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Form(
              key: formState,
              child: SafeArea(
                child: Scaffold(
                  appBar: MyAppBar(title: e.tr('إضافة مجموعة اسبوع')),
                  bottomNavigationBar: BottomNavigatorBar(items: [
                    Expanded(
                      child: BtnApp(
                          label: e.tr('save'),
                          onTap: () {
                            if (formState.currentState!.validate()) {
                              if (widget.weekGroupModel != null) {
                                BaseBloc.get<WeekPlanBloc>(context).add(
                                    UpdateWeekGroupEvent(
                                        entity: WeekGroupModel(
                                            name: name.text,
                                            id: widget.weekGroupModel!.id,
                                            isActive:
                                                value!.id == 1 ? true : false,
                                            plansNumber: 0,
                                            weeksCount: int.parse(
                                                numberOfWeeks.text))));
                              } else {
                                BaseBloc.get<WeekPlanBloc>(context).add(
                                    AddWeekGroupEvent(
                                        entity: WeekGroupModel(
                                            name: name.text,
                                            id: 0,
                                            isActive:
                                                value!.id == 1 ? true : false,
                                            plansNumber: 0,
                                            weeksCount: int.parse(
                                                numberOfWeeks.text))));
                              }
                            }
                          }),
                    )
                  ]),
                  body: ListView(
                    padding: const EdgeInsets.only(
                        top: 0, right: 10, left: 10, bottom: 10),
                    children: [
                      // Titile(label: e.tr('teacher')),
                      // SelectMutiple(
                      //   selectedItems: teacher ?? [],
                      //   items: teachers,
                      //   onChange: (value) {
                      //     BaseBloc.get<DelayTaskBloc>(context).emitState(
                      //         SelectTeacherState(selectModel: value));
                      //   },
                      //   label: e.tr('choose_teachers'),
                      // ),
                      InputApp(
                          textEditingController: name,
                          label: 'أسم المجموعة',
                          hint: 'ادخل أسم المجموعة'),
                      InputApp(
                          textEditingController: numberOfWeeks,
                          label: 'عدد الاسابيع ',
                          textInputType: TextInputType.number,
                          hint: 'عدد الاسابيع'),

                      Titile(label: e.tr('الحالة  ')),
                      SelectInput(
                        items: items,
                        onChanged: (v) {
                          BaseBloc.get<WeekPlanBloc>(context)
                              .emitState(SelectedTeachersState(value: v!));
                        },
                        label: e.tr('الحالة  '),
                        selectedValue: value,
                      ),
                      // Titile(
                      //   label: e.tr('choose_date'),
                      // ),
                      // DateWidget(
                      //   selectDate: dateHijri,
                      //   onChange: (value) {
                      //     final hijriDate = value.hijriDate;

                      //     gregorianDate = value.gregorianDate;
                      //     Navigator.pop(context);
                      //     BaseBloc.get<DelayTaskBloc>(context)
                      //         .emitState(SelectDateState(value: hijriDate));
                      //   },
                      // ),
                      // Titile(label: e.tr('choose_time')),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: TimeButton(
                      //         label: '${e.tr('from_houre')}',
                      //         onChange: (v) {
                      //           BaseBloc.get<DelayTaskBloc>(context).emitState(
                      //               ChangeTime1State(
                      //                   value: DateFormat('HH:mm').format(v)));
                      //         },
                      //         selectDate: time1,
                      //       ),
                      //     ),
                      //     const SizedBox(
                      //       width: 10,
                      //     ),
                      //     Expanded(
                      //       child: TimeButton(
                      //         label: '${e.tr('to_houre')}',
                      //         onChange: (v) {
                      //           BaseBloc.get<DelayTaskBloc>(context).emitState(
                      //               ChangeTime2State(
                      //                   value: DateFormat('HH:mm').format(v)));
                      //         },
                      //         selectDate: time2,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // Titile(label: e.tr('repeat')),
                      // SelectInput(
                      //   items: repeats,
                      //   onChanged: (v) {
                      //     BaseBloc.get<DelayTaskBloc>(context)
                      //         .emitState(SelectRepeatState(selectModel: v!));
                      //   },
                      //   label: e.tr('repeat'),
                      //   selectedValue: repeat,
                      // ),
                      // if (repeat!.id != 0)
                      //   Titile(
                      //     label: e.tr('end_date'),
                      //   ),
                      // if (repeat!.id != 0)
                      //   DateWidget(
                      //     selectDate: dateHijri2,
                      //     onChange: (value) {
                      //       final hijriDate = value.hijriDate;

                      //       gregorianDate2 = value.gregorianDate;
                      //       Navigator.pop(context);
                      //       BaseBloc.get<DelayTaskBloc>(context)
                      //           .emitState(SelectDate2State(value: hijriDate));
                      //     },
                      //   ),
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
