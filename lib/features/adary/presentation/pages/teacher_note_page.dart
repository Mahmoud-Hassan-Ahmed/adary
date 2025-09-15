import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/conts/style.dart';
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
    return BlocProvider(
      create: (context) => sl<TeacherNotesBloc>(),
      child: BlocBuilder<TeacherNotesBloc, TeacherNotesState>(
        builder: (context, state) {
          return SafeArea(
            child: DefaultTabController(
              length: 3,
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
                          Tab(
                            child: Text(
                              'send_not'.tr(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              // style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          Tab(
                            child: Text(
                              'nots_list'.tr(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              // style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
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
                  body: const TabBarView(
                    children: [
                      SendNoteContent(),
                      NotesPage(),
                      NoteTeachersPage()
                    ],
                  )),
            ),
          );
        },
      ),
    );
  }
}
