import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/model/select_model.dart';
import 'package:adary/core/share/inputs/input_app.dart';
import 'package:adary/core/share/inputs/select_input.dart';
import 'package:adary/core/share/widgets/btn_app.dart';
import 'package:adary/core/share/widgets/date_widget.dart';
import 'package:adary/core/share/widgets/my_app_bar.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/user_app.dart';
import 'package:adary/features/adary/domain/entities/note_behavoir_entity.dart';
import 'package:adary/features/adary/presentation/bloc/behavoir_notes/behavoir_notes_bloc.dart';
import 'package:adary/features/adary/presentation/pages/done_added_page.dart';
import 'package:adary/features/adary/presentation/widgets/note_teacher/titile.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:easy_localization/easy_localization.dart' as e;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNoteBehavoir extends StatefulWidget {
  const AddNoteBehavoir({super.key});

  @override
  State<AddNoteBehavoir> createState() => _AddNoteBehavoirState();
}

class _AddNoteBehavoirState extends State<AddNoteBehavoir> {
  final TextEditingController name = TextEditingController();
  final TextEditingController points = TextEditingController();
  SelectModel? selectType;
  SelectModel? selectIcon;
  List<SelectModel> items = [
    SessionModel(id: 1, name: 'ايجابي'),
    SessionModel(id: 2, name: 'سلبي')
  ];
  @override
  Widget build(BuildContext context) {
    final formState = GlobalKey<FormState>();
    return BlocProvider(
      create: (context) => sl<BehavoirNotesBloc>(),
      child: BlocBuilder<BehavoirNotesBloc, BehavoirNotesState>(
        builder: (context, state) {
          if (state is SelectTypeState) {
            if (state.index == 0) {
              selectType = state.value;
            } else {
              selectIcon = state.value;
            }
          } else if (state is DoneAddNote) {
            WidgetsBinding.instance.addPostFrameCallback((callback) {
              AppUtils.go(DoneAddedPage(
                  label: 'تم إضافة ملاحظة السلوك بنجاح',
                  title: 'إضافة ملاحظة سلوك'));
            });
          }
          return Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Scaffold(
              appBar: MyAppBar(title: 'إضافة ملاحظة سلوك جديدة'),
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.all(14),
                child: BtnApp(
                    label: 'حفظ',
                    onTap: () {
                      if (!formState.currentState!.validate()) return;
                      if (selectType == null || selectIcon is! IconModel) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('اختر نوع الملاحظة وأيقونتها'),
                          ),
                        );
                        return;
                      }
                      BaseBloc.get<BehavoirNotesBloc>(context).add(
                          AddNoteEvent(
                              baseEnity: NoteBehavoirEntity(
                                  title: name.text,
                                  icon: (selectIcon as IconModel).value,
                                  note_type: selectType!.id == 1
                                      ? 'positive'
                                      : 'negative',
                                  points:
                                      int.tryParse(points.text.trim()) ?? 0)));
                    }),
              ),
              body: Padding(
                padding: const EdgeInsets.all(10),
                child: Form(
                  key: formState,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InputApp(
                          // selectDate: dateHijri,
                          label: 'أسم الملاحظة',
                          hint: 'ادخل أسم الملاحظة',
                          textEditingController: name,
                        ),
                        // SizedBox(height: 20),

                        InputApp(
                          textEditingController: points,
                          textInputType: TextInputType.number,
                          hint: 'ادخل النقط',
                          label: e.tr('النقاط'),
                          // selectedValue: selectedClass,
                        ),
                        // SizedBox(height: 20),
                        Titile(label: e.tr('نوع الملاحظة ')),
                        SelectInput(
                          items: items,
                          onChanged: (v) {
                            AppUtils.log(v!.id.toString());
                            BaseBloc.get<BehavoirNotesBloc>(context).emitState(
                                SelectTypeState(value: v!, index: 0));
                            // setState(() {
                            //   // selectedClass = v;
                            // });
                          },
                          label: e.tr('نوع الملاحظة'),
                          selectedValue: selectType,
                        ),
                        Titile(label: e.tr('ايقونة')),
                        SelectInput(
                          items: behaviorIcons,
                          onChanged: (v) {
                            AppUtils.log(v!.id.toString());
                            BaseBloc.get<BehavoirNotesBloc>(context)
                                .emitState(SelectTypeState(value: v, index: 1));
                          },
                          label: e.tr('ايقونة'),
                          selectedValue: selectIcon,
                        ),
                      ],
                    ),
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
