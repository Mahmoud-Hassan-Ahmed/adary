import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/enums/snack_bar_type_enum.dart';
import 'package:adary/core/share/inputs/input_app.dart';
import 'package:adary/core/share/widgets/btn_app.dart';
import 'package:adary/core/share/widgets/my_app_bar.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/task_model.dart';
import 'package:adary/features/adary/domain/entities/task_entity.dart';
import 'package:adary/features/adary/presentation/bloc/task/task_bloc.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddTask extends StatefulWidget {
  const AddTask({
    super.key,
    this.taskModel,
    this.fun,
  });

  final TaskModel? taskModel;
  final Function()? fun;
  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final formState = GlobalKey<FormState>();
  late TextEditingController name;
  @override
  void initState() {
    name = TextEditingController(text: widget.taskModel?.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<TaskBloc>(),
      child: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is DoneAddTask) {
            AppUtils.showCustomSnackbar('added_mission'.tr(), SnackType.SUCESS);

            Navigator.pop(context);
            widget.fun!();
          } else if (state is DoneUpdateTask) {
            AppUtils.showCustomSnackbar(
                'updared_mission'.tr(), SnackType.SUCESS);

            Navigator.pop(context);
            widget.fun!();
          }
          return Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Form(
              key: formState,
              child: SafeArea(
                child: Scaffold(
                  appBar: MyAppBar(title: 'back'.tr()),
                  body: ListView(
                    padding: const EdgeInsets.only(
                        top: 0, right: 10, left: 10, bottom: 10),
                    children: [
                      InputApp(
                          textEditingController: name,
                          label: 'name'.tr(),
                          hint: 'write_here'.tr()),
                      const SizedBox(
                        height: 10,
                      ),
                      BtnApp(
                          label: 'save'.tr(),
                          onTap: () {
                            if (formState.currentState!.validate()) {
                              if (widget.taskModel == null) {
                                BaseBloc.get<TaskBloc>(context).add(
                                    AddTaskEvent(
                                        entity: TaskEntity(name: name.text)));
                              } else {
                                BaseBloc.get<TaskBloc>(context).add(UpdateTask(
                                    entity: TaskEntity(
                                        name: name.text,
                                        id: widget.taskModel!.id)));
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
