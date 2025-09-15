import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/model/select_model.dart';
import 'package:adary/core/share/inputs/select_input.dart';
import 'package:adary/core/share/widgets/btn_app.dart';
import 'package:adary/core/share/widgets/date_widget.dart';
import 'package:adary/core/share/widgets/my_app_bar.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/teacher_model.dart';
import 'package:adary/features/adary/domain/entities/pagination_entity.dart';
import 'package:adary/features/adary/presentation/bloc/week_plan/week_plan_bloc.dart';

import 'package:adary/features/adary/presentation/widgets/note_teacher/titile.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class FilterWeek extends StatelessWidget {
  const FilterWeek(
      {super.key,
      required this.pagingController,
      required this.paginationEntity});
  final PagingController pagingController;
  final PaginationEntity paginationEntity;

  @override
  Widget build(BuildContext context) {
    DateTime? gregorianDate1, gregorianDate2;
    String? dateHijri1 = 'start_end'.tr();
    List<Teacher> teachers = [];
    SelectModel? selected;
    return BlocProvider(
      create: (context) => sl<WeekPlanBloc>(),
      child: BlocBuilder<WeekPlanBloc, WeekPlanState>(
        builder: (context, state) {
          if (state is WeekPlanInitial) {
            BaseBloc.get<WeekPlanBloc>(context).add(GetTechersEvent());
          } else if (state is DoneGetTeachers) {
            teachers = state.list;
          } else if (state is SelectDateState1) {
            dateHijri1 = state.value;
          } else if (state is SelectedTeachersState) {
            selected = state.value;
          }
          return Padding(
            padding: const EdgeInsets.only(top: 30),
            child: SafeArea(
              child: Scaffold(
                appBar: MyAppBar(title: 'back'.tr()),
                body: ListView(
                  padding: const EdgeInsets.only(
                      top: 0, right: 10, left: 10, bottom: 10),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    DateWidget(
                      selectDate: dateHijri1,
                      isRange: true,
                      onChange: (value) {
                        gregorianDate1 = value.gregorianDate;
                        gregorianDate2 = value.gregorianDate2;
                        dateHijri1 = '${value.hijriDate} ${value.hijriDate2}';

                        paginationEntity.startDate =
                            AppUtils.convertToWesternNumerals(
                                DateFormat('yyyy-MM-dd')
                                    .format(value.gregorianDate));
                        paginationEntity.endDate =
                            AppUtils.convertToWesternNumerals(
                                DateFormat('yyyy-MM-dd')
                                    .format(value.gregorianDate));
                        Navigator.pop(context);
                        BaseBloc.get<WeekPlanBloc>(context).emitState(
                            SelectDateState1(value: dateHijri1 ?? ''));
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SelectInput(
                      selectedValue: selected,
                      items: teachers,
                      onChanged: (value) {
                        paginationEntity.teacher = value!.id.toString();
                        BaseBloc.get<WeekPlanBloc>(context)
                            .emitState(SelectedTeachersState(value: value!));
                      },
                      label: 'choose_teacher'.tr(),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    BtnApp(
                        label: 'search'.tr(),
                        onTap: () {
                          paginationEntity.startDate = gregorianDate1 != null
                              ? DateFormat('yyyy-MM-dd').format(gregorianDate1!)
                              : null;
                          paginationEntity.endDate = gregorianDate2 != null
                              ? DateFormat('yyyy-MM-dd').format(gregorianDate2!)
                              : null;
                          paginationEntity.classId = selected?.id;
                          Navigator.pop(context);
                          pagingController.refresh();
                        })
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
