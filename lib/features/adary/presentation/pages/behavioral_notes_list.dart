import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/share/widgets/my_app_bar.dart';
import 'package:adary/features/adary/data/models/student_per.dart';
import 'package:adary/features/adary/presentation/bloc/behavoir_notes/behavoir_notes_bloc.dart';
import 'package:adary/features/adary/presentation/widgets/perseverance/add_note_behavoir.dart';
import 'package:adary/features/adary/presentation/widgets/perseverance/filter.dart'
    show FilterWidget;
import 'package:adary/features/adary/presentation/widgets/perseverance/list_note_base_on_type.dart';
import 'package:adary/features/adary/presentation/widgets/perseverance/note_item.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BehavioralNotesList extends StatelessWidget {
  const BehavioralNotesList({super.key});

  @override
  Widget build(BuildContext context) {
    List<BehaviorNote> notes = [];
    return BlocProvider(
      create: (context) => sl<BehavoirNotesBloc>(),
      child: BlocBuilder<BehavoirNotesBloc, BehavoirNotesState>(
        builder: (context, state) {
          if (state is BehavoirNotesInitial) {
            BaseBloc.get<BehavoirNotesBloc>(context).add(GetAllNotes());
          } else if (state is DoneGetNotes) {
            notes = state.notes;
          }
          return DefaultTabController(
              length: 3,
              child: Scaffold(
                backgroundColor: Colors.grey.shade200,
                appBar: MyAppBar(title: 'قائمة ملاحظات السلوك', actions: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) => const AddNoteBehavoir(),
                        ).then((_) {
                          // إعادة الجلب كي تظهر الملاحظة الجديدة فور الحفظ.
                          BaseBloc.get<BehavoirNotesBloc>(context)
                              .add(GetAllNotes());
                        });
                      },
                      child: const CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.APP_COLOR,
                        child: Icon(Icons.add, color: Colors.white, size: 24),
                      ),
                    ),
                  ),
                ]),
                body: Column(
                  children: [
                    /// 🔹 Segmented TabBar
                    Container(
                      margin: const EdgeInsets.all(12),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: AppColors.APP_COLOR),
                      ),
                      child: TabBar(
                        indicator: BoxDecoration(
                          color: AppColors.APP_COLOR,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        labelColor: Colors.white,
                        unselectedLabelColor: AppColors.APP_COLOR,
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        splashFactory: NoSplash.splashFactory,
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                        tabs: const [
                          Tab(text: 'الكل'),
                          Tab(text: 'إيجابي'),
                          Tab(text: 'بحاجة إلي تحسين'),
                        ],
                      ),
                    ),

                    /// 🔹 المحتوى
                    Expanded(
                      child: TabBarView(
                        children: [
                          // AttendanceStatsPage(),
                          ListNoteBaseOnType(notes: notes),
                          ListNoteBaseOnType(
                              notes: notes
                                  .where((test) => test.note_type == 'positive')
                                  .toList()),
                          ListNoteBaseOnType(
                              notes: notes
                                  .where((test) => test.note_type != 'positive')
                                  .toList()),
                        ],
                      ),
                    ),
                  ],
                ),
              ));
        },
      ),
    );
  }
}
