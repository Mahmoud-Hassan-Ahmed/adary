import 'package:adary/features/adary/data/models/teacher_circular.dart';
import 'package:adary/features/table/utils/app_colors.dart';
import 'package:flutter/material.dart';

class ItemTeacherSign extends StatelessWidget {
  const ItemTeacherSign({super.key, required this.visitModel});
  final TeacherCircular visitModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            visitModel.teacherId.name,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          leading: visitModel.isSignature
              ? const Icon(
                  Icons.remove_red_eye_outlined,
                  color: AppColors.SECONDERYCOLOR,
                )
              : const Icon(
                  Icons.visibility_off,
                  color: Colors.grey,
                ),
        ),
        const Divider(
          height: 5,
          indent: 20,
          endIndent: 20,
          color: AppColors.SECONDERYCOLOR,
        )
      ],
    );
    // return Column(
    //   children: [
    //     ExpansionWidget(
    //       body: [
    //         if (visitModel.isSignature)
    //           Text(
    //             'signed'.tr(),
    //             style: Theme.of(context).textTheme.labelMedium,
    //           ),
    //         if (!visitModel.isSignature)
    //           Text(
    //             'no_signed'.tr(),
    //             style: Theme.of(context).textTheme.labelMedium,
    //           ),
    //         const SizedBox(
    //           height: 10,
    //         ),
    //       ],
    //       title: [
    //         Text(
    //           visitModel.teacherId.name,
    //           style: Theme.of(context).textTheme.labelMedium,
    //         )
    //       ],
    //     ),
    //     const SizedBox(
    //       height: 10,
    //     ),
    //   ],
    // );
  }
}
