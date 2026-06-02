import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/model/select_model.dart';
import 'package:adary/core/share/inputs/input_app.dart';
import 'package:adary/core/share/inputs/select_input.dart';

import 'package:adary/core/share/widgets/bottom_navigator_bar.dart';
import 'package:adary/core/share/widgets/btn_app.dart';
import 'package:adary/core/share/widgets/date_widget.dart';
import 'package:adary/core/share/widgets/my_app_bar.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/task_teacher_mdel.dart';
import 'package:adary/features/adary/domain/entities/exam_entity.dart';
import 'package:adary/features/adary/presentation/bloc/exam/exam_bloc.dart';
import 'package:adary/features/adary/presentation/pages/done_added_page.dart';
import 'package:adary/features/adary/presentation/widgets/note_teacher/titile.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:easy_localization/easy_localization.dart' as e;

class AddExam extends StatelessWidget {
  const AddExam({super.key, this.pagingController});

  final PagingController? pagingController;

  @override
  Widget build(BuildContext context) {
    final formState = GlobalKey<FormState>();

    List<SelectModel> tasks = [
      SessionModel(id: 0, name: 'هجري'),
      SessionModel(id: 1, name: 'ميلادي')
    ];
    SelectModel? task = tasks.first;
    String? dateHijri, dateHijri2;
    DateTime? gregorianDate, gregorianDate2;

    TextEditingController nameGroup = TextEditingController();
    TextEditingController count = TextEditingController();
    TextEditingController description = TextEditingController();

    return BlocProvider(
      create: (context) => sl<ExamBloc>(),
      child: BlocBuilder<ExamBloc, ExamState>(
        builder: (context, state) {
          if (state is SelectDateTypeState) {
            task = tasks[state.index];
          } else if (state is DoneAddExamState) {
            WidgetsBinding.instance.addPostFrameCallback((callback) {
              AppUtils.go(DoneAddedPage(
                  label: e.tr('done_added_exam_hall_group'),
                  title: e.tr('add_exam_hall_group')));
            });
            pagingController?.refresh();
          }
          return Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Form(
              key: formState,
              child: SafeArea(
                child: Scaffold(
                  appBar: MyAppBar(title: e.tr('add_exam_hall_group')),
                  bottomNavigationBar: BottomNavigatorBar(items: [
                    Expanded(
                      child: BtnApp(
                          label: e.tr('save'),
                          onTap: () {
                            if (formState.currentState!.validate()) {
                              BaseBloc.get<ExamBloc>(context).add(AddExamEvent(
                                  baseEnity: ExamEntity(
                                      name: nameGroup.text,
                                      description: description.text,
                                      start_date: gregorianDate!
                                          .toIso8601String()
                                          .split('T')
                                          .first,
                                      end_date: gregorianDate2!
                                          .toIso8601String()
                                          .split('T')
                                          .first,
                                      number_of_halls: int.parse(count.text),
                                      date_system: task!.id)));
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
                        hint: 'أسم المجموعة ',
                        label: 'ادخل أسم اللجنة',
                        textEditingController: nameGroup,
                      ),
                      InputApp(
                        hint: 'عدد اللجان ',
                        label: 'ادخل عدد اللجان ',
                        textEditingController: count,
                        textInputType: TextInputType.number,
                      ),
                      Titile(label: e.tr('نظام التاريخ ')),
                      SelectInput(
                        items: tasks,
                        onChanged: (v) {
                          BaseBloc.get<ExamBloc>(context)
                              .emitState(SelectDateTypeState(index: v!.id));
                        },
                        label: e.tr('mission'),
                        selectedValue: task,
                      ),
                      Titile(
                        label: e.tr('تاريخ البداية  '),
                      ),
                      DateWidget(
                        isHijari: task!.id == 0,
                        selectDate: dateHijri,
                        onChange: (value) {
                          final hijriDate = value.hijriDate;

                          gregorianDate = value.gregorianDate;
                          Navigator.pop(context);
                          BaseBloc.get<ExamBloc>(context).emitState(
                              SelectDateStateValue(
                                  value: hijriDate,
                                  value2: gregorianDate!,
                                  index: 0));
                        },
                      ),
                      Titile(
                        label: e.tr('تاريخ النهاية  '),
                      ),
                      DateWidget(
                        selectDate: dateHijri2,
                        onChange: (value) {
                          final hijriDate = value.hijriDate;

                          gregorianDate2 = value.gregorianDate;
                          Navigator.pop(context);
                          BaseBloc.get<ExamBloc>(context).emitState(
                              SelectDateStateValue(
                                  value: hijriDate,
                                  value2: gregorianDate2!,
                                  index: 1));
                        },
                      ),

                      InputApp(
                        hint: 'الوصف',
                        label: 'ادخل وصف مجموعة اللجان',
                        textEditingController: description,
                        numLine: 2,
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
