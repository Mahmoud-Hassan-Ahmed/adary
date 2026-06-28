import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/features/adary/data/models/task_model.dart';
import 'package:adary/features/adary/domain/entities/delete_entity.dart';
import 'package:adary/features/adary/presentation/bloc/task/task_bloc.dart';
import 'package:adary/features/adary/presentation/widgets/task/add_task.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:adary/core/conts/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ItemTaskN extends StatelessWidget {
  const ItemTaskN({super.key, required this.visitModel});
  // final WeeklyPan weeklyPan;
  final TaskModel visitModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      // padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF4DB6AC)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Left arrow
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
            decoration: const BoxDecoration(
              color: Color(0xFF4DB6AC),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(11),
                bottomRight: Radius.circular(11),
              ),
            ),
            width: 50,
            height: 60,
            child: Center(
              child: Text(
                visitModel.id.toString(),
                style: AppTextStyles.bodyBold.copyWith(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          // Middle text
          Expanded(
            child: Text(
              visitModel.name,
              style: AppTextStyles.bodyText,    // 15sp — was too small at 12px
            ),
          ),

          IconButton(
              onPressed: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    return AddTask(
                      taskModel: visitModel,
                    );
                  },
                );
              },
              icon: SvgPicture.asset("assets/icons/edit.svg")),
          IconButton(
              onPressed: () {
                AwesomeDialog(
                    context: context,
                    dialogType: DialogType.warning,
                    titleTextStyle: AppTextStyles.dialogTitle.copyWith(color: Colors.red),
                    title: 'delete_mission'.tr(),
                    desc: 'delete_mission_des'.tr(),
                    btnCancelText: 'no'.tr(),
                    btnOkText: 'delete'.tr(),
                    btnCancelOnPress: () {},
                    btnOkOnPress: () {
                      BaseBloc.get<TaskBloc>(context).add(
                          DeletTask(entity: DeleteEntity(id: visitModel.id)));
                    }).show();
              },
              icon: SvgPicture.asset("assets/icons/delete.svg"))

          // Right selected box
        ],
      ),
    );
  }
}
