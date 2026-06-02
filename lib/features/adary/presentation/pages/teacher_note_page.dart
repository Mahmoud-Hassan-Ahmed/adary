import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/conts/style.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/presentation/bloc/teacher_note/teacher_notes_bloc.dart';
import 'package:adary/features/adary/presentation/pages/add_note_page.dart';
import 'package:adary/features/adary/presentation/pages/note_teachers_page.dart';
import 'package:adary/features/adary/presentation/pages/notes_pgae.dart';
import 'package:adary/features/adary/presentation/widgets/note_teacher/send_note_teacher.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TeacherNotePage extends StatefulWidget {
  const TeacherNotePage({super.key});

  @override
  State<TeacherNotePage> createState() => _TeacherNotePageState();
}

class _TeacherNotePageState extends State<TeacherNotePage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    int tabsCount = [
      '/api/notes/teachers-notes/',
      '/api/notes/note/',
      '/api/notes/teachers/',
    ].where((perm) => AppUtils.permissions.any((p) => p.contains(perm))).length;
    TabController _tabController = TabController(length: 3, vsync: this);
    ;
    return BlocProvider(
      create: (context) => sl<TeacherNotesBloc>(),
      child: BlocBuilder<TeacherNotesBloc, TeacherNotesState>(
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  iconTheme: const IconThemeData(color: AppColors.APP_COLOR),
                  title: Text(
                    "Teacher'sNotes".tr(),
                    style: AbhayaLibre.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.APP_COLOR),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        // if (_tabController.index == 1) {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return const FractionallySizedBox(
                              child: AddNotePage(),
                            );
                          },
                        );
                        // }
                      },
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.APP_COLOR,
                        ),
                        child: const Icon(Icons.add, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                body: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(12),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: AppColors.APP_COLOR),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        indicator: BoxDecoration(
                          color: AppColors.APP_COLOR,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        labelColor: Colors.white,
                        unselectedLabelColor: AppColors.APP_COLOR,
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,

                        /// 🔥 إزالة تأثير الضغط
                        splashFactory: NoSplash.splashFactory,
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
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
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: const [
                          SendNoteContent(),
                          // if (AppUtils.permissions.isNotEmpty &&
                          //         AppUtils.permissions
                          //             .contains('/api/notes/note/') ||
                          //     AppUtils.permissions.isEmpty)
                          NotesPage(),
                          // if (AppUtils.permissions.isNotEmpty &&
                          //         AppUtils.permissions
                          //             .contains('/api/notes/teachers/') ||
                          //     AppUtils.permissions.isEmpty)
                          NoteTeachersPage()
                        ],
                      ),
                    ),
                  ],
                )),
          );
        },
      ),
    );
  }
}
