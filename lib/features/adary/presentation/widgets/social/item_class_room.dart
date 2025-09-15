import 'package:adary/core/conts/icons.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/class_room.dart';
import 'package:adary/features/adary/presentation/pages/students.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ItemClassRoom extends StatelessWidget {
  const ItemClassRoom({super.key, required this.classroom});
  final Classroom classroom;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        AppUtils.go(Students(
          classId: classroom,
        ));
      },
      trailing: SvgPicture.asset(AppIcon.go),
      title: Text(
        classroom.name,
        style: Theme.of(context).textTheme.labelMedium,
      ),
      subtitle: Text(
        '${classroom.studentCount} ${'student'.tr()}',
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}
