import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/enums/relations.dart';
import 'package:adary/core/enums/snack_bar_type_enum.dart';
import 'package:adary/core/model/select_model.dart';
import 'package:adary/core/share/inputs/select_input.dart';
import 'package:adary/core/share/widgets/btn_app.dart';
import 'package:adary/core/share/widgets/date_widget.dart';
import 'package:adary/core/share/widgets/my_app_bar.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/model_20.dart';
import 'package:adary/features/adary/data/models/teacher_model.dart';
import 'package:adary/features/adary/domain/entities/delay_entity.dart';
import 'package:adary/features/adary/presentation/bloc/model20/model20_bloc.dart';
import 'package:adary/features/adary/presentation/widgets/note_teacher/titile.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart' as e;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class AddModel20 extends StatelessWidget {
  const AddModel20(
      {super.key, required this.pagingController, this.model20model});
  final PagingController pagingController;
  final Model20Model? model20model;

  @override
  Widget build(BuildContext context) {
    SelectModel? selectTeacher, selectDay1, selectDay2;
    String? dateHijri1, dateHijri2;
    List<Teacher> techers = [];
    final formKey = GlobalKey<FormState>();

    if (model20model != null) {
      selectDay1 = days.firstWhereOrNull(
          (e) => (e as Relations).value == model20model!.atDay);
      dateHijri1 = model20model?.atDayDate;
      selectDay2 = days.firstWhereOrNull(
          (e) => (e as Relations).value == model20model!.toDay);
      dateHijri2 = model20model?.toDayDate;
    }
    return BlocProvider(
      create: (context) => sl<Model20Bloc>(),
      child: BlocBuilder<Model20Bloc, Model20State>(
        builder: (context, state) {
          if (state is Model20Initial) {
            BaseBloc.get<Model20Bloc>(context).add(GetTeachersEvent());
          } else if (state is DobeGetTechersState) {
            techers = state.lusl;
            if (model20model != null) {
              selectTeacher = techers
                  .firstWhereOrNull((e) => e.id == model20model?.teacher?.id);
            }
          } else if (state is SelectDayState) {
            selectDay1 = state.value;
          } else if (state is SelectDayState2) {
            selectDay2 = state.value;
          } else if (state is SelectDateState) {
            dateHijri1 = state.value;
          } else if (state is SelectDateState2) {
            dateHijri2 = state.value;
          } else if (state is DoneAddModel20State) {
            AppUtils.showCustomSnackbar(e.tr('added_model'), SnackType.SUCESS);
            pagingController.refresh();
            Navigator.pop(context);
          } else if (state is DoneChangeTechareState) {
            selectTeacher = state.value;
          } else if (state is UpdateModel20State) {
            pagingController.refresh();
            AppUtils.showCustomSnackbar(
                e.tr('updated_model'), SnackType.SUCESS);
            Navigator.pop(context);
          }
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Scaffold(
                appBar: MyAppBar(title: e.tr('back')),
                body: Form(
                  key: formKey,
                  child: ListView(
                      padding: const EdgeInsets.only(
                          top: 0, right: 10, left: 10, bottom: 10),
                      physics: const BouncingScrollPhysics(),
                      children: [
                        Titile(label: e.tr('teacher')),
                        SelectInput(
                            selectedValue: selectTeacher,
                            items: techers,
                            onChanged: (v) {
                              BaseBloc.get<Model20Bloc>(context)
                                  .emitState(DoneChangeTechareState(value: v!));
                            },
                            label: e.tr('teacher')),
                        Titile(label: e.tr('from_day')),
                        SelectInput(
                            selectedValue: selectDay1,
                            items: days,
                            onChanged: (v) {
                              BaseBloc.get<Model20Bloc>(context)
                                  .emitState(SelectDayState(value: v!));
                            },
                            label: e.tr('from_day')),
                        Titile(
                          label: e.tr('choose_date'),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DateWidget(
                          selectDate: dateHijri1,
                          onChange: (value) {
                            Navigator.pop(context);
                            BaseBloc.get<Model20Bloc>(context).emitState(
                                SelectDateState(value: value.hijriDate));
                          },
                        ),
                        Titile(label: e.tr('to_day')),
                        SelectInput(
                            selectedValue: selectDay2,
                            items: days,
                            onChanged: (v) {
                              BaseBloc.get<Model20Bloc>(context)
                                  .emitState(SelectDayState2(value: v!));
                            },
                            label: e.tr('day')),
                        Titile(
                          label: e.tr('choose_date'),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DateWidget(
                          selectDate: dateHijri2,
                          onChange: (value) {
                            Navigator.pop(context);
                            BaseBloc.get<Model20Bloc>(context).emitState(
                                SelectDateState2(value: value.hijriDate));
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        BtnApp(
                            label: e.tr('save'),
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                if (model20model != null) {
                                  BaseBloc.get<Model20Bloc>(context).add(
                                      UpdateMode20Event(
                                          model20: Model20(
                                              id: model20model?.id,
                                              teacherId: selectTeacher!.id,
                                              atDay: (selectDay1 as Relations)
                                                  .value,
                                              atDayDate: dateHijri1,
                                              toDay: (selectDay2 as Relations)
                                                  .value,
                                              toDayDate: dateHijri2)));
                                } else {
                                  BaseBloc.get<Model20Bloc>(context).add(
                                      AddModel20Event(
                                          enity: Model20(
                                              teacherId: selectTeacher!.id,
                                              atDay: (selectDay1 as Relations)
                                                  .value,
                                              atDayDate: dateHijri1,
                                              toDay: (selectDay2 as Relations)
                                                  .value,
                                              toDayDate: dateHijri2)));
                                }
                              }
                            })
                      ]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
