import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/model/select_model.dart';
import 'package:adary/core/share/inputs/select_input.dart';
import 'package:adary/core/share/widgets/btn_app.dart';
import 'package:adary/core/share/widgets/date_widget.dart';
import 'package:adary/core/share/widgets/my_app_bar.dart';
import 'package:adary/features/adary/presentation/bloc/perseverance/perseverance_bloc.dart';
import 'package:adary/features/adary/presentation/widgets/note_teacher/titile.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:easy_localization/easy_localization.dart' as e;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterWidget extends StatefulWidget {
  const FilterWidget({
    super.key,
    required this.date,
  });
  final ValueChanged<(String?, DateTime?, int?, int?, String?, String?)> date;

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  List<SelectModel> classes = [];

  SelectModel? selectedClass;
  SelectModel? selectSession;
  final formState = GlobalKey<FormState>();
  DateTime? gregorianDate;
  String? dateHijri;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PerseveranceBloc>(),
      child: BlocBuilder<PerseveranceBloc, PerseveranceState>(
        builder: (context, state) {
          if (state is PerseveranceInitial) {
            BaseBloc.get<PerseveranceBloc>(context).add(GetClassesEvent());
          } else if (state is DoneGetClassesstate) {
            classes = state.classes;
          } else if (state is ChangeClassState) {
            if (state.index == 0) {
              selectedClass = state.selectModel;
            } else {
              selectSession = state.selectModel;
            }
          } else if (state is SelectDateState) {
            dateHijri = state.enity;
          }
          return Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Scaffold(
              appBar: MyAppBar(title: 'فلتر '),
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.all(14),
                child: BtnApp(
                    label: 'بحث',
                    onTap: () {
                      if (formState.currentState!.validate()) {
                        widget.date((
                          dateHijri,
                          gregorianDate,
                          selectedClass?.id,
                          selectSession?.id,
                          selectedClass?.name,
                          selectSession?.name
                        ));
                        Navigator.pop(context);
                      }
                    }),
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formState,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Titile(label: 'التاريخ'),
                      DateWidget(
                        selectDate: dateHijri,
                        onChange: (value) {
                          gregorianDate = value.gregorianDate;
                          Navigator.pop(context);
                          BaseBloc.get<PerseveranceBloc>(context).emitState(
                              SelectDateState(enity: value.hijriDate));
                        },
                      ),
                      // SizedBox(height: 20),
                      const Titile(label: 'أسم الفصل'),
                      SelectInput(
                        items: classes,
                        onChanged: (v) {
                          BaseBloc.get<PerseveranceBloc>(context).emitState(
                              ChangeClassState(selectModel: v!, index: 0));
                        },
                        label: e.tr('class'),
                        selectedValue: selectedClass,
                      ),
                      // SizedBox(height: 20),
                      const Titile(label: 'الحصة'),
                      SelectInput(
                        items: sessionChoices,
                        onChanged: (v) {
                          BaseBloc.get<PerseveranceBloc>(context).emitState(
                              ChangeClassState(selectModel: v!, index: 1));
                        },
                        label: e.tr('session'),
                        selectedValue: selectSession,
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
