import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/enums/relations.dart';
import 'package:adary/core/enums/snack_bar_type_enum.dart';
import 'package:adary/core/model/select_model.dart';
import 'package:adary/core/share/inputs/select_input.dart';
import 'package:adary/core/share/widgets/btn_app.dart';
import 'package:adary/core/share/widgets/date_widget.dart';
import 'package:adary/core/share/widgets/my_app_bar.dart';
import 'package:adary/core/share/widgets/time_button.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/model18.dart';
import 'package:adary/features/adary/domain/entities/delay_entity.dart';
import 'package:adary/features/adary/presentation/bloc/delay/delay_bloc.dart';
import 'package:adary/features/adary/presentation/widgets/note_teacher/titile.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:easy_localization/easy_localization.dart' as e;

class AddDelayedAlert extends StatelessWidget {
  const AddDelayedAlert(
      {super.key, required this.pagingController, this.model18model});
  final PagingController pagingController;
  final Model18Model? model18model;

  @override
  Widget build(BuildContext context) {
    SelectModel? selectTeacher, selectDay, typeMasalh;
    List<SelectModel> techers = [];
    String? dateHijri, time1, time2, time3, time4;
    DateTime? gregorianDate;
    final formKry = GlobalKey<FormState>();
    if (model18model != null) {
      selectDay = days.firstWhereOrNull(
          (e) => (e as Relations).value == model18model!.dayName);
      if (model18model?.fromLateness != null &&
          model18model?.toLateness != null) {
        typeMasalh = typeDelays[1];
        time2 = model18model!.fromLateness;
        time3 = model18model?.toLateness;
      } else if (model18model?.startLateness != null) {
        typeMasalh = typeDelays[0];
        time1 = model18model!.startLateness;
      } else if (model18model?.endLateness != null) {
        typeMasalh = typeDelays[2];
        time4 = model18model!.endLateness;
      }
      dateHijri = model18model!.dayDate;
    }
    return BlocProvider(
      create: (context) => sl<DelayBloc>(),
      child: BlocBuilder<DelayBloc, DelayState>(
        builder: (context, state) {
          if (state is DelayInitial) {
            BaseBloc.get<DelayBloc>(context).add(GetTeachersEvent());
          } else if (state is DobeGetTechersState) {
            techers = state.lusl;
            if (model18model != null) {
              selectTeacher = techers
                  .firstWhereOrNull((e) => e.id == model18model?.teacher.id);
            }
          } else if (state is DoneChangeTechareState) {
            selectTeacher = state.value;
          } else if (state is SelectDayState) {
            selectDay = state.value;
          } else if (state is SelectTypeState) {
            typeMasalh = state.value;
          } else if (state is SelectDateState) {
            dateHijri = state.value;
          } else if (state is ChangeTime1State) {
            time1 = state.value;
          } else if (state is ChangeTime2State) {
            time2 = state.value;
          } else if (state is ChangeTime3State) {
            time3 = state.value;
          } else if (state is ChangeTime4State) {
            time4 = state.value;
          } else if (state is DoneAddModel18State) {
            Navigator.pop(context);
            pagingController.refresh();
            AppUtils.showCustomSnackbar(e.tr('added_model'), SnackType.SUCESS);
          } else if (state is UpdateModel18State) {
            Navigator.pop(context);
            pagingController.refresh();
            AppUtils.showCustomSnackbar(e.tr('updaed_model'), SnackType.SUCESS);
          }
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Scaffold(
                appBar: MyAppBar(title: e.tr('back')),
                bottomNavigationBar: BtnApp(
                    label: e.tr('save'),
                    onTap: () {
                      if (formKry.currentState!.validate()) {
                        if (model18model == null) {
                          BaseBloc.get<DelayBloc>(context).add(AddModel18Event(
                              model18: Model18(
                                  dayDate: dateHijri,
                                  dayName: (selectDay as Relations).value,
                                  teacherId: selectTeacher?.id,
                                  startLateness: time1,
                                  endLateness: time2,
                                  fromLateness: time3,
                                  toLateness: time4)));
                        } else {
                          BaseBloc.get<DelayBloc>(context).add(
                              UpdateModel18Event(
                                  model18: Model18(
                                      id: model18model!.id,
                                      dayDate: dateHijri,
                                      dayName: (selectDay as Relations).value,
                                      teacherId: selectTeacher?.id,
                                      startLateness: time1,
                                      endLateness: time2,
                                      fromLateness: time3,
                                      toLateness: time4)));
                        }
                      } else {
                        print("invalide form");
                      }
                    }),
                body: Form(
                  key: formKry,
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
                            BaseBloc.get<DelayBloc>(context)
                                .emitState(DoneChangeTechareState(value: v!));
                          },
                          label: e.tr('teacher')),
                      Titile(label: e.tr('at_day')),
                      SelectInput(
                          selectedValue: selectDay,
                          items: days,
                          onChanged: (v) {
                            BaseBloc.get<DelayBloc>(context)
                                .emitState(SelectDayState(value: v!));
                          },
                          label: e.tr('at_day')),
                      Titile(
                        label: e.tr('choose_date'),
                      ),
                      DateWidget(
                        selectDate: dateHijri,
                        onChange: (value) {
                          gregorianDate = value.gregorianDate;
                          Navigator.pop(context);
                          BaseBloc.get<DelayBloc>(context).emitState(
                              SelectDateState(value: value.hijriDate));
                        },
                      ),
                      Titile(label: e.tr('choose_type_model')),
                      SelectInput(
                          selectedValue: typeMasalh,
                          items: typeDelays,
                          onChanged: (v) {
                            BaseBloc.get<DelayBloc>(context)
                                .emitState(SelectTypeState(value: v!));
                          },
                          label: e.tr('at_day')),
                      if (typeMasalh != null && typeMasalh!.id == 0)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Titile(label: e.tr('comming_at')),
                            TimeButton(
                              onChange: (v) {
                                BaseBloc.get<DelayBloc>(context).emitState(
                                    ChangeTime1State(
                                        value:
                                            DateFormat('hh:mm a').format(v)));
                              },
                              selectDate: time1,
                            ),
                          ],
                        ),
                      if (typeMasalh != null && typeMasalh!.id == 1)
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Titile(label: e.tr('from_houre')),
                            TimeButton(
                              onChange: (v) {
                                BaseBloc.get<DelayBloc>(context).emitState(
                                    ChangeTime2State(
                                        value:
                                            DateFormat('hh:mm a').format(v)));
                              },
                              selectDate: time2,
                            ),
                          ],
                        ),
                      if (typeMasalh != null && typeMasalh!.id == 1)
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Titile(label: e.tr('to_houre')),
                            TimeButton(
                              onChange: (v) {
                                BaseBloc.get<DelayBloc>(context).emitState(
                                    ChangeTime3State(
                                        value:
                                            DateFormat('hh:mm a').format(v)));
                              },
                              selectDate: time3,
                            ),
                          ],
                        ),
                      if (typeMasalh != null && typeMasalh!.id == 2)
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Titile(label: e.tr('exit_houre')),
                            TimeButton(
                              onChange: (v) {
                                BaseBloc.get<DelayBloc>(context).emitState(
                                    ChangeTime3State(
                                        value:
                                            DateFormat('hh:mm a').format(v)));
                              },
                              selectDate: time3,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
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
