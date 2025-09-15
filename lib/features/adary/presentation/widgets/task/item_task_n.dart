import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/conts/icons.dart';
import 'package:adary/core/share/widgets/btn_icon.dart';
import 'package:adary/core/share/widgets/container_btns.dart';
import 'package:adary/core/share/widgets/expansion_widget.dart';
import 'package:adary/features/adary/data/models/task_model.dart';
import 'package:adary/features/adary/domain/entities/delete_entity.dart';
import 'package:adary/features/adary/presentation/bloc/task/task_bloc.dart';
import 'package:adary/features/adary/presentation/widgets/task/add_task.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ItemTaskN extends StatelessWidget {
  const ItemTaskN({super.key, required this.visitModel});
  final TaskModel visitModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpansionWidget(
          body: [
            ContainerBtns(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  BtnIcon(
                      label: 'delete'.tr(),
                      icon: AppIcon.rash,
                      onTap: () {
                        AwesomeDialog(
                            context: context,
                            dialogType: DialogType.warning,
                            titleTextStyle: const TextStyle(
                                color: Colors.red,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            title: 'delete_mission'.tr(),
                            desc: 'delete_mission_des'.tr(),
                            btnCancelText: 'no'.tr(),
                            btnOkText: 'delete'.tr(),
                            btnCancelOnPress: () {},
                            btnOkOnPress: () {
                              BaseBloc.get<TaskBloc>(context).add(DeletTask(
                                  entity: DeleteEntity(id: visitModel.id)));
                            }).show();
                      }),
                  BtnIcon(
                      label: 'edit'.tr(),
                      icon: AppIcon.edit,
                      onTap: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return AddTask(
                              taskModel: visitModel,
                            );
                          },
                        );
                      })
                ],
              ),
            )
          ],
          title: [
            Text(
              visitModel.name,
              style: Theme.of(context).textTheme.labelMedium,
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
