import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/enums/snack_bar_type_enum.dart';
import 'package:adary/core/share/inputs/input_app.dart';
import 'package:adary/core/share/widgets/btn_app.dart';
import 'package:adary/core/share/widgets/my_app_bar.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/classes.dart';
import 'package:adary/features/adary/domain/entities/class_entity.dart';
import 'package:adary/features/adary/presentation/bloc/students/students_bloc.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddClass extends StatefulWidget {
  const AddClass({super.key, this.item});
  final Classes? item;

  @override
  State<AddClass> createState() => _AddClassState();
}

class _AddClassState extends State<AddClass> {
  late TextEditingController name;
  @override
  void initState() {
    name = TextEditingController(text: widget.item?.name);
    super.initState();
  }

  final formState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<StudentsBloc>(),
      child: BlocBuilder<StudentsBloc, StudentsState>(
        builder: (context, state) {
          if (state is DoneAddClassState) {
            AppUtils.showCustomSnackbar('added_class'.tr(), SnackType.SUCESS);
            Navigator.pop(context);
            // BaseBloc.get<StudentsBloc>(context).add(GetClassesRoomEvent());
          } else if (state is DoneUpdateClassState) {
            AppUtils.showCustomSnackbar('updated_class'.tr(), SnackType.SUCESS);
            Navigator.pop(context);
            // BaseBloc.get<StudentsBloc>(context).add(GetClassesRoomEvent());
          }
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Scaffold(
                appBar: MyAppBar(title: 'back'.tr()),
                body: Form(
                  key: formState,
                  child: ListView(
                    padding: const EdgeInsets.only(
                        top: 0, right: 10, left: 10, bottom: 10),
                    children: [
                      InputApp(
                          textEditingController: name,
                          label: 'name_class'.tr(),
                          hint: 'write_here'.tr()),
                      const SizedBox(
                        height: 10,
                      ),
                      BtnApp(
                          label: 'save'.tr(),
                          onTap: () {
                            if (formState.currentState!.validate()) {
                              if (widget.item == null) {
                                BaseBloc.get<StudentsBloc>(context).add(
                                    AddClassEvent(
                                        entity: ClassEntity(name: name.text)));
                              } else {
                                BaseBloc.get<StudentsBloc>(context).add(
                                    UpdateClassEvent(
                                        entity: ClassEntity(
                                            id: widget.item!.id,
                                            name: name.text)));
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
