import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/enums/snack_bar_type_enum.dart';
import 'package:adary/core/model/select_model.dart';
import 'package:adary/core/share/inputs/input_app.dart';
import 'package:adary/core/share/inputs/select_input.dart';
import 'package:adary/core/share/widgets/btn_app.dart';
import 'package:adary/core/share/widgets/my_app_bar.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/model_19.dart';
import 'package:adary/features/adary/domain/entities/delay_entity.dart';
import 'package:adary/features/adary/presentation/bloc/model19/model19_bloc.dart';
import 'package:adary/features/adary/presentation/widgets/note_teacher/titile.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:easy_localization/easy_localization.dart' as e;

class AddModel19 extends StatefulWidget {
  const AddModel19(
      {super.key, required this.pagingController, this.model19model});
  final PagingController pagingController;
  final Model19Model? model19model;

  @override
  State<AddModel19> createState() => _AddModel19State();
}

class _AddModel19State extends State<AddModel19> {
  final keyForm = GlobalKey<FormState>();

  final FocusNode f1 = FocusNode();
  final FocusNode f2 = FocusNode();
  late TextEditingController sumHours;
  late TextEditingController numDays;
  SelectModel? selectTeacher;
  List<SelectModel> techers = [];
  @override
  void initState() {
    sumHours =
        TextEditingController(text: widget.model19model?.exitTime.toString());
    numDays =
        TextEditingController(text: widget.model19model?.numDays.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<Model19Bloc>(),
      child: BlocBuilder<Model19Bloc, Model19State>(
        builder: (context, state) {
          if (state is Model19Initial) {
            BaseBloc.get<Model19Bloc>(context).add(GetTeachersEvent());
          } else if (state is DobeGetTechersState) {
            techers = state.lusl;
            if (widget.model19model != null) {
              selectTeacher = techers.firstWhereOrNull(
                  (e) => e.id == widget.model19model?.teacher.id);
            }
          } else if (state is DoneChangeTechareState) {
            selectTeacher = state.value;
          } else if (state is DoneAddModel19State) {
            AppUtils.showCustomSnackbar(e.tr('added_model'), SnackType.SUCESS);

            widget.pagingController.refresh();
            Future.delayed(Duration(milliseconds: 500), () {
              Navigator.pop(context);
            });
          } else if (state is DoneUpdateModel19State) {
            AppUtils.showCustomSnackbar(
                e.tr('updated_model'), SnackType.SUCESS);

            widget.pagingController.refresh();
            Future.delayed(Duration(milliseconds: 500), () {
              Navigator.pop(context);
            });
          }
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Scaffold(
                appBar: MyAppBar(title: e.tr('back')),
                body: Form(
                  key: keyForm,
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
                            BaseBloc.get<Model19Bloc>(context)
                                .emitState(DoneChangeTechareState(value: v!));
                          },
                          label: e.tr('teacher')),
                      InputApp(
                          focusNode: f1,
                          textInputType: TextInputType.number,
                          textEditingController: sumHours,
                          label: e.tr('sum_hourse'),
                          hint: e.tr('write_here')),
                      InputApp(
                          focusNode: f2,
                          textInputType: TextInputType.number,
                          textEditingController: numDays,
                          label: e.tr('sum_days'),
                          hint: e.tr('write_here')),
                      const SizedBox(
                        height: 10,
                      ),
                      BtnApp(
                          label: e.tr('save'),
                          onTap: () {
                            if (keyForm.currentState!.validate()) {
                              if (widget.model19model != null) {
                                BaseBloc.get<Model19Bloc>(context).add(
                                    UpdaeModel19Event(
                                        model19: Model19(
                                            id: widget.model19model?.id,
                                            teacherId: selectTeacher!.id,
                                            exitTime:
                                                double.parse(sumHours.text),
                                            numDays: int.parse(numDays.text))));
                              } else {
                                BaseBloc.get<Model19Bloc>(context).add(
                                    AddModel19event(
                                        baseEnity: Model19(
                                            teacherId: selectTeacher!.id,
                                            exitTime:
                                                double.parse(sumHours.text),
                                            numDays: int.parse(numDays.text))));
                              }
                            }
                          })
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
