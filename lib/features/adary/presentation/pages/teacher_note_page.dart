import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/conts/style.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/presentation/bloc/teacher_note/teacher_notes_bloc.dart';
import 'package:adary/features/adary/presentation/pages/note_teachers_page.dart';
import 'package:adary/features/adary/presentation/pages/notes_pgae.dart';
import 'package:adary/features/adary/presentation/widgets/note_teacher/send_note_teacher.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TeacherNotePage extends StatelessWidget {
  const TeacherNotePage({super.key});

  @override
  Widget build(BuildContext context) {
    int tabsCount = [
      '/api/notes/teachers-notes/',
      '/api/notes/note/',
      '/api/notes/teachers/',
    ].where((perm) => AppUtils.permissions.any((p) => p.contains(perm))).length;
    return BlocProvider(
      create: (context) => sl<TeacherNotesBloc>(),
      child: BlocBuilder<TeacherNotesBloc, TeacherNotesState>(
        builder: (context, state) {
          return SafeArea(
            child: DefaultTabController(
              length: tabsCount > 0 ? tabsCount : 1,
              child: Scaffold(
                  appBar: AppBar(
                      bottom: TabBar(
                        indicatorColor: AppColors.checkbox,
                        labelStyle: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.checkbox),
                        unselectedLabelStyle: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontSize: 14),
                        tabs: [
                          if (AppUtils.permissions.isNotEmpty &&
                                  AppUtils.permissions
                                      .contains('/api/notes/teachers-notes/') ||
                              AppUtils.permissions.isEmpty)
                            Tab(
                              child: Text(
                                'send_not'.tr(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                // style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          if (AppUtils.permissions.isNotEmpty &&
                                  AppUtils.permissions
                                      .contains('/api/notes/note/') ||
                              AppUtils.permissions.isEmpty)
                            Tab(
                              child: Text(
                                'nots_list'.tr(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                // style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          if (AppUtils.permissions.isNotEmpty &&
                                  AppUtils.permissions
                                      .contains('/api/notes/teachers/') ||
                              AppUtils.permissions.isEmpty)
                            Tab(
                              child: Text(
                                'notes'.tr(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                // style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                        ],
                      ),
                      title: Text(
                        "Teacher'sNotes".tr(),
                        style: AbhayaLibre.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      )),
                  body: TabBarView(
                    children: [
                      if (AppUtils.permissions.isNotEmpty &&
                              AppUtils.permissions
                                  .contains('/api/notes/teachers-notes/') ||
                          AppUtils.permissions.isEmpty)
                        const SendNoteContent(),
                      if (AppUtils.permissions.isNotEmpty &&
                              AppUtils.permissions
                                  .contains('/api/notes/note/') ||
                          AppUtils.permissions.isEmpty)
                        const NotesPage(),
                      if (AppUtils.permissions.isNotEmpty &&
                              AppUtils.permissions
                                  .contains('/api/notes/teachers/') ||
                          AppUtils.permissions.isEmpty)
                        const NoteTeachersPage()
                    ],
                  )),
            ),
          );
        },
      ),
    );
  }
}
