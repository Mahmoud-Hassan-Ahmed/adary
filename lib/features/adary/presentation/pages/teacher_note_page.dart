import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/conts/style.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/presentation/pages/add_note_page.dart';
import 'package:adary/features/adary/presentation/pages/note_teachers_page.dart';
import 'package:adary/features/adary/presentation/pages/notes_pgae.dart';
import 'package:adary/features/adary/presentation/widgets/note_teacher/send_note_teacher.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// تبويب واحد من شاشة «ملاحظات المعلمين»: عنوانه، محتواه، والصلاحية التي
/// يظهر بها. جمعُها في نوعٍ واحد يمنع تكرار الخطأ القديم: كانت العناوين
/// تُصفّى بالصلاحيات، والمحتويات ثابتةً ثلاثةً، وطول المتحكّم يُحسب بقاعدة
/// ثالثة مختلفة — فتختلف الأعداد وتختفي شريط التبويبات كلّه.
class _NoteTab {
  const _NoteTab({
    required this.permission,
    required this.label,
    required this.view,
  });

  final String permission;
  final String label;
  final Widget view;
}

class TeacherNotePage extends StatefulWidget {
  const TeacherNotePage({super.key});

  @override
  State<TeacherNotePage> createState() => _TeacherNotePageState();
}

class _TeacherNotePageState extends State<TeacherNotePage>
    with SingleTickerProviderStateMixin {
  late final List<_NoteTab> _tabs;
  TabController? _tabController;

  static const List<_NoteTab> _allTabs = [
    _NoteTab(
      permission: '/notes/monitor-note/',
      label: 'send_not',
      view: SendNoteContent(),
    ),
    _NoteTab(
      permission: '/notes/new/',
      label: 'nots_list',
      view: NotesPage(),
    ),
    _NoteTab(
      permission: '/notes/notes-teacher-list/',
      label: 'notes',
      view: NoteTeachersPage(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    // `checkPermission` هي القاعدة نفسها المستعملة في بقية الشاشات، وتُرجع
    // `true` للمدير كامل الصلاحية (قائمة صلاحياته فارغة).
    _tabs = _allTabs
        .where((tab) => AppUtils.checkPermission([tab.permission]))
        .toList();
    if (_tabs.isNotEmpty) {
      // في `initState` لا في `build`: إنشاؤه مع كل إعادة بناء كان يعيد
      // التبويب المختار إلى الأول ويسرّب المتحكّم القديم.
      _tabController = TabController(length: _tabs.length, vsync: this);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    return const FractionallySizedBox(
                      child: AddNotePage(),
                    );
                  },
                );
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
        body: _tabController == null
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'not_subscription'.tr(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              )
            : Column(
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
                        for (final tab in _tabs)
                          Tab(
                            child: Text(
                              tab.label.tr(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        for (final tab in _tabs) tab.view,
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }
}
