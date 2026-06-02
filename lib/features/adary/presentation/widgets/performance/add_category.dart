import 'package:adary/core/share/inputs/input_app.dart';
import 'package:adary/core/share/widgets/btn_app.dart';
import 'package:adary/core/share/widgets/my_app_bar.dart';
import 'package:adary/features/adary/data/models/evidence_model.dart';
import 'package:adary/features/adary/presentation/bloc/evidence/evidence_bloc.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/bloc/base_bloc.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key, this.model});
  final EvidenceCategoryModel? model;

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  late TextEditingController nameController;
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(
      text: widget.model != null ? widget.model!.name : '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<EvidenceBloc>(),
      child: BlocBuilder<EvidenceBloc, EvidenceState>(
        builder: (context, state) {
          if (state is DoneAddCategoryEveidenceState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pop(context);
            });
          }
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Scaffold(
                appBar: MyAppBar(title: 'إضافة فئة جديدة'),
                bottomNavigationBar: Padding(
                  padding: const EdgeInsets.all(10),
                  child: BtnApp(
                      label: 'حفظ',
                      onTap: () {
                        BaseBloc.get<EvidenceBloc>(context).add(
                            AddCategoryEveidenceEvent(
                                entity: EvidenceCategoryModel(
                                    name: nameController.text,
                                    id: 0,
                                    add: widget.model != null ? 'u' : 'a')));
                      }),
                ),
                body: Form(
                    child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      InputApp(
                          textEditingController: nameController,
                          label: 'أسم الفئة ',
                          hint: 'ادخل أسم الفئة ')
                    ],
                  ),
                )),
              ),
            ),
          );
        },
      ),
    );
  }
}
