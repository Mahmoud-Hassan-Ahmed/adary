import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/conts/icons.dart';
import 'package:adary/core/share/widgets/btn_icon.dart';
import 'package:adary/core/share/widgets/container_btns.dart';
import 'package:adary/core/share/widgets/expansion_widget.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/class_room.dart';
import 'package:adary/features/adary/data/models/classes.dart';
import 'package:adary/features/adary/domain/entities/delete_entity.dart';
import 'package:adary/features/adary/presentation/bloc/students/students_bloc.dart';
import 'package:adary/features/adary/presentation/pages/students.dart';
import 'package:adary/features/adary/presentation/widgets/admin_prepation/add_class.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// class ItemClass extends StatelessWidget {
//   const ItemClass({super.key, required this.item});
//   final Classroom item;

//   @override
//   Widget build(BuildContext context) {
//     return ExpansionWidget(
//       title: [
//         Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               item.name,
//               style: Theme.of(context).textTheme.labelMedium,
//             ),
//             const SizedBox(
//               height: 5,
//             ),
//             Text(
//               item.studentCount > 0
//                   ? '${'num_student'.tr()} ${item.studentCount}'
//                   : 'no_student'.tr(),
//               style: Theme.of(context).textTheme.labelSmall!.copyWith(
//                   color: item.studentCount > 0 ? Colors.red : Colors.black),
//             ),
//           ],
//         )
//       ],
//       body: [
//         ContainerBtns(
//           content: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               if (AppUtils.permissions.isNotEmpty &&
//                       AppUtils.permissions
//                           .any((p) => p.contains("api/notes/laps/delete/")) ||
//                   AppUtils.permissions.isEmpty)
//                 BtnIcon(
//                     label: 'delete'.tr(),
//                     icon: AppIcon.rash,
//                     onTap: () {
//                       AwesomeDialog(
//                           context: context,
//                           dialogType: DialogType.warning,
//                           titleTextStyle: const TextStyle(
//                               color: Colors.red,
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold),
//                           title: 'delete_class'.tr(),
//                           desc: 'delete_class_des'.tr(),
//                           btnCancelText: 'no'.tr(),
//                           btnOkText: 'delete'.tr(),
//                           btnCancelOnPress: () {},
//                           btnOkOnPress: () {
//                             BaseBloc.get<StudentsBloc>(context).add(
//                                 DeleteClassEvent(
//                                     entity: DeleteEntity(id: item.id)));
//                           }).show();
//                     }),
//               if (AppUtils.permissions.isNotEmpty &&
//                       AppUtils.permissions
//                           .any((p) => p.contains("api/notes/laps/update/")) ||
//                   AppUtils.permissions.isEmpty)
//                 BtnIcon(
//                     label: 'edit'.tr(),
//                     icon: AppIcon.edit,
//                     onTap: () {
//                       showModalBottomSheet(
//                         isScrollControlled: true,
//                         context: context,
//                         builder: (context) {
//                           return AddClass(
//                             item: Classes(id: item.id, name: item.name),
//                           );
//                         },
//                       );
//                     }),
//               // BtnIcon(
//               //   label: 'go'.tr(),
//               //   icon: AppIcon.go,
//               //   onTap: () {
//               //     AppUtils.go(Students(
//               //       classId: item,
//               //     ));
//               //   },
//               // )
//             ],
//           ),
//         )
//       ],
//     );
//   }
// }

class ItemClass extends StatelessWidget {
  const ItemClass({super.key, required this.item});
  // final WeeklyPan weeklyPan;
  final Classroom item;

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
                item.id.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          // Middle text
          Expanded(
            child: Text(
              item.name,
              style: const TextStyle(fontSize: 12),
            ),
          ),

          IconButton(
              onPressed: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    return AddClass(
                      item: Classes(id: item.id, name: item.name),
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
                    titleTextStyle: const TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    title: 'delete_class'.tr(),
                    desc: 'delete_class_des'.tr(),
                    btnCancelText: 'no'.tr(),
                    btnOkText: 'delete'.tr(),
                    btnCancelOnPress: () {},
                    btnOkOnPress: () {
                      BaseBloc.get<StudentsBloc>(context).add(
                          DeleteClassEvent(entity: DeleteEntity(id: item.id)));
                    }).show();
              },
              icon: SvgPicture.asset("assets/icons/delete.svg"))

          // Right selected box
        ],
      ),
    );
  }
}
