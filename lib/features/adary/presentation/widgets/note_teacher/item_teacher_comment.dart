import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/share/widgets/expansion_widget.dart';
import 'package:adary/features/adary/data/models/teacher_model.dart';
import 'package:adary/features/adary/domain/entities/teacher_note_entity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ItemTeacherComment extends StatefulWidget {
  const ItemTeacherComment({
    super.key,
    required this.teacher,
    required this.teacherNote,
  });
  final Teacher teacher;
  final TeacherNote teacherNote;

  @override
  State<ItemTeacherComment> createState() => _ItemTeacherCommentState();
}

class _ItemTeacherCommentState extends State<ItemTeacherComment> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.APP_COLOR),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          ExpansionWidget(
            isSelect: widget.teacherNote.isActive,
            title: [
              Checkbox(
                  fillColor: widget.teacherNote.isActive
                      ? const WidgetStatePropertyAll(AppColors.checkbox)
                      : null,
                  value: widget.teacherNote.isActive,
                  onChanged: (v) {
                    widget.teacherNote.isActive = v ?? false;
                    setState(() {
                      widget.teacherNote.isActive = v ?? false;
                    });
                  }),
              Text(widget.teacher.name),
            ],
            body: [
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.APP_COLOR),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: TextFormField(
                  onChanged: (value) {
                    widget.teacherNote.comment = value;
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10),
                    hintText: 'write_note_commint'.tr(),
                    border: InputBorder.none,
                  ),
                  maxLines: 4,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
