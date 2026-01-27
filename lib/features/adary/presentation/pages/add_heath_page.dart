import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/enums/snack_bar_type_enum.dart';
import 'package:adary/core/model/select_model.dart';
import 'package:adary/core/share/inputs/input_app.dart';
import 'package:adary/core/share/inputs/select_input.dart';
import 'package:adary/core/share/widgets/btn_app.dart';
import 'package:adary/core/share/widgets/my_app_bar.dart';
import 'package:adary/core/share/widgets/radio_btn.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/health_model.dart';
import 'package:adary/features/adary/domain/entities/health_entity.dart';
import 'package:adary/features/adary/presentation/bloc/health/health_bloc.dart';
import 'package:adary/features/adary/presentation/widgets/note_teacher/titile.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import "package:easy_localization/easy_localization.dart" as e;

class AddHeathPage extends StatefulWidget {
  const AddHeathPage({super.key, this.healthCondition, this.refreshKey});
  final GlobalKey<RefreshIndicatorState>? refreshKey;
  final HealthCondition? healthCondition;

  @override
  State<AddHeathPage> createState() => _AddHeathPageState();
}

class _AddHeathPageState extends State<AddHeathPage> {
  late TextEditingController name;
  late TextEditingController lead;
  late TextEditingController des;
  late TextEditingController health;
  bool valueSelect = false;
  bool sendSms = false;
  List<SelectModel> classes = [];
  SelectModel? selectedClass;
  final formState = GlobalKey<FormState>();
  @override
  void initState() {
    name = TextEditingController(text: widget.healthCondition?.nameStudent);
    lead = TextEditingController(
        text: widget.healthCondition?.dealingWithSituation);
    health = TextEditingController(text: widget.healthCondition?.name);
    des = TextEditingController(text: widget.healthCondition?.recommendations);
    valueSelect = widget.healthCondition?.notifyTeacher ?? false;
    sendSms = widget.healthCondition?.sendSms ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HealthBloc>(),
      child: BlocBuilder<HealthBloc, HealthState>(
        builder: (context, state) {
          if (state is HealthInitial) {
            BaseBloc.get<HealthBloc>(context).add(GetClassesEvent());
          } else if (state is DoneGetClassesstate) {
            classes = state.classes;
            if (widget.healthCondition != null) {
              selectedClass = classes.firstWhereOrNull(
                  (e) => e.id == widget.healthCondition!.classNameId.id);
            }
          } else if (state is ChangeClassState) {
            selectedClass = state.selectModel;
          } else if (state is DoneAddHealthState) {
            AppUtils.showCustomSnackbar(e.tr('added_health'), SnackType.SUCESS);

            widget.refreshKey?.currentState?.show();
            Navigator.pop(context);
          } else if (state is DoneUpdateHealthState) {
            AppUtils.showCustomSnackbar(
                e.tr('updated_health'), SnackType.SUCESS);
            widget.refreshKey?.currentState?.show();
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
                body: Form(
                    key: formState,
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(
                          top: 0, right: 10, left: 10, bottom: 10),
                      children: [
                        InputApp(
                            textEditingController: name,
                            label: e.tr('name'),
                            hint: e.tr('write_here')),
                        Titile(label: e.tr('name_class')),
                        SelectInput(
                          items: classes,
                          onChanged: (v) {
                            BaseBloc.get<HealthBloc>(context)
                                .emitState(ChangeClassState(selectModel: v!));
                          },
                          label: e.tr('class'),
                          selectedValue: selectedClass,
                        ),
                        InputApp(
                            textEditingController: health,
                            label: e.tr('name_health'),
                            hint: e.tr('write_here')),
                        InputApp(
                            numLine: 4,
                            textEditingController: lead,
                            label: e.tr('dealing'),
                            hint: e.tr('write_here')),
                        InputApp(
                            numLine: 4,
                            textEditingController: des,
                            label: e.tr('recomm'),
                            hint: e.tr('write_here')),
                        const SizedBox(
                          height: 10,
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
                                BaseBloc.get<HealthBloc>(context)
                                    .emitState(ChnageNotifyState());
                              },
                              child: RadioBtn(
                                  group: valueSelect ? 1 : 0,
                                  label: e.tr('yes'),
                                  value: 1,
                                  valueChanged: (v) {
                                    BaseBloc.get<HealthBloc>(context)
                                        .emitState(ChnageNotifyState());
                                  }),
                            ),
                          ],
                        ),
                        if (AppUtils.appUser?.smsService != null &&
                            AppUtils.appUser!.smsService!.isActive)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
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
                                      BaseBloc.get<HealthBloc>(context)
                                          .emitState(ChnageNotifyState3());
                                    },
                                    child: RadioBtn(
                                        group: sendSms ? 1 : 0,
                                        label: e.tr('yes'),
                                        value: 1,
                                        valueChanged: (v) {
                                          BaseBloc.get<HealthBloc>(context)
                                              .emitState(ChnageNotifyState3());
                                        }),
                                  ),
                                ],
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
                                if (widget.healthCondition == null) {
                                  BaseBloc.get<HealthBloc>(context).add(
                                      AddHealthEvent(
                                          baseEnity: HealthEntity(
                                              notifyTeacher: valueSelect,
                                              sendSms: sendSms,
                                              nameStudent: name.text,
                                              classNameId: selectedClass!.id,
                                              name: health.text,
                                              dealingWithSituation: lead.text,
                                              recommendations: des.text)));
                                } else {
                                  BaseBloc.get<HealthBloc>(context).add(
                                      UpdateHealthEvent(
                                          baseEnity: HealthEntity(
                                              id: widget.healthCondition!.id,
                                              nameStudent: name.text,
                                              classNameId: selectedClass!.id,
                                              sendSms: sendSms,
                                              name: health.text,
                                              notifyTeacher: valueSelect,
                                              dealingWithSituation: lead.text,
                                              recommendations: des.text)));
                                }
                              }
                            })
                      ],
                    )),
              ),
            ),
          );
        },
      ),
    );
  }
}
