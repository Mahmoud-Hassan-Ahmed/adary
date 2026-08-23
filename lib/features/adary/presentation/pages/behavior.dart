import 'package:adary/features/adary/presentation/pages/behavioral_notes_list.dart';
import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/share/widgets/btn_app.dart';
import 'package:adary/features/adary/data/models/student_per.dart';
import 'package:adary/features/adary/domain/entities/filter_per.dart';
import 'package:adary/features/adary/domain/entities/register_student_entity.dart';
import 'package:adary/features/adary/domain/usecases/add_behavoir_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_student_calss_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_students_behavoir.dart';
import 'package:adary/features/adary/presentation/bloc/behavoir_notes/behavoir_notes_bloc.dart';
import 'package:adary/features/adary/presentation/pages/done_added_page.dart';
import 'package:adary/features/adary/presentation/widgets/perseverance/StudentPointsCard%20.dart';
import 'package:adary/features/adary/presentation/widgets/perseverance/conduct_header.dart';
import 'package:adary/features/adary/presentation/widgets/perseverance/conduct_widgets.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../core/utils/app_utils.dart';

/// تبويب «السلوك»: عرض سلوك الطلاب، أو تسجيل ملاحظة واحدة على من يُحدَّد منهم.
class Behavior extends StatefulWidget {
  const Behavior(
      {super.key,
      required this.isView,
      this.classId,
      this.date,
      this.sessionName,
      this.className,
      this.session,
      this.dateTime});

  final bool isView;
  final int? classId;
  final String? date;
  final int? session;
  final String? sessionName;
  final String? className;
  final DateTime? dateTime;

  @override
  State<Behavior> createState() => _BehaviorState();
}

class _BehaviorState extends State<Behavior> {
  final PagingController<int, StudentBehavior> _pagingController =
      PagingController(firstPageKey: 1);
  final PagingController<int, StudentInfo> _pagingController1 =
      PagingController(firstPageKey: 1);

  late FilterPer entity;
  late FilterPer entity1;

  final getstudents = sl<GetStudentsBehavoir>();
  final geStudentsByClass = sl<GetStudentCalssUseCase>();

  List<BehaviorNote> notes = [];

  /// الملاحظة المختارة من المنسدلة، تُطبَّق على كل طالب مُحدَّد.
  BehaviorNote? selectedNote;

  /// معرّفات الطلاب المحدَّدين — مجموعة بدل قائمة كي لا تتكرّر مع كل إعادة بناء.
  final Set<int> selectedStudents = {};
  bool saving = false;

  @override
  void initState() {
    entity = FilterPer(
        page: 1,
        className: widget.classId,
        date: widget.dateTime?.toIso8601String().split('T').first,
        dateHijri: widget.date ?? "1/1/1111",
        school: AppUtils.appUser?.id.toString(),
        session: widget.session);
    entity1 = FilterPer(page: 1, className: widget.classId);
    _pagingController.addPageRequestListener(_fetchPage);
    _pagingController1.addPageRequestListener(_fetchPage1);
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _pagingController1.dispose();
    super.dispose();
  }

  Future<void> _fetchPage(int pageKey) async {
    var result = await getstudents(entity..page = pageKey);
    try {
      result.fold((l) => null, (paginationModel) {
        final isLastPage = paginationModel.next == null;
        if (isLastPage) {
          _pagingController.appendLastPage(paginationModel.results);
        } else {
          _pagingController.appendPage(paginationModel.results, pageKey + 1);
        }
      });
    } catch (error) {
      _pagingController.error = error;
      AppUtils.log(error.toString());
    }
  }

  Future<void> _fetchPage1(int pageKey) async {
    var result = await geStudentsByClass(entity1..page = pageKey);
    try {
      result.fold((l) => null, (paginationModel) {
        final isLastPage = paginationModel.next == null;
        if (isLastPage) {
          _pagingController1.appendLastPage(paginationModel.results);
        } else {
          _pagingController1.appendPage(paginationModel.results, pageKey + 1);
        }
      });
    } catch (error) {
      _pagingController1.error = error;
      AppUtils.log(error.toString());
    }
  }

  List<StudentInfo> get _loadedStudents => _pagingController1.itemList ?? [];

  bool get _allSelected =>
      _loadedStudents.isNotEmpty &&
      selectedStudents.length == _loadedStudents.length;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<BehavoirNotesBloc>(),
      child: BlocBuilder<BehavoirNotesBloc, BehavoirNotesState>(
        builder: (context, state) {
          if (state is BehavoirNotesInitial) {
            BaseBloc.get<BehavoirNotesBloc>(context).add(GetAllNotes());
          } else if (state is DoneGetNotes) {
            notes = state.notes;
          }

          return Column(
            children: [
              ConductFilterHeader(
                dateHijri: widget.date ?? '',
                sessionName: widget.sessionName ?? '',
                className: widget.className ?? '',
                selectAll: widget.isView ? null : _allSelected,
                onSelectAll: (value) => setState(() {
                  selectedStudents
                    ..clear()
                    ..addAll(
                      value ? _loadedStudents.map((s) => s.id) : const <int>[],
                    );
                }),
              ),
              Expanded(
                child: widget.isView ? _buildList() : _buildRegister(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildList() {
    return PagedListView<int, StudentBehavior>(
      padding: const EdgeInsets.only(top: 8),
      physics: const BouncingScrollPhysics(),
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<StudentBehavior>(
        noItemsFoundIndicatorBuilder: (context) => ConductEmpty(
          text: widget.classId == null
              ? 'فلتر بالفصل والحصة لعرض البيانات'
              : 'لا يوجد بيانات للعرض',
        ),
        itemBuilder: (context, item, index) => StudentPointsCard(
          studentBehavior: item,
          className: widget.className ?? '',
          classId: widget.classId,
          dateHijri: widget.date,
        ),
      ),
    );
  }

  Widget _buildRegister() {
    return Column(
      children: [
        NoteSelector(
          notes: notes,
          selected: selectedNote,
          onChanged: (note) => setState(() => selectedNote = note),
          onManage: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BehavioralNotesList()),
          ).then((_) {
            if (mounted) setState(() {});
          }),
        ),
        Expanded(
          child: PagedListView<int, StudentInfo>(
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(),
            pagingController: _pagingController1,
            builderDelegate: PagedChildBuilderDelegate<StudentInfo>(
              noItemsFoundIndicatorBuilder: (context) => ConductEmpty(
                text: widget.classId == null
                    ? 'فلتر بالفصل والحصة لعرض البيانات'
                    : 'لا يوجد بيانات للعرض',
              ),
              itemBuilder: (context, item, index) => StudentSelectCard(
                name: item.name,
                selected: selectedStudents.contains(item.id),
                onChanged: (value) => setState(() {
                  value
                      ? selectedStudents.add(item.id)
                      : selectedStudents.remove(item.id);
                }),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: BtnApp(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            label: saving ? 'جارٍ الحفظ...' : 'حفظ البيانات',
            onTap: saving ? () {} : _save,
          ),
        ),
      ],
    );
  }

  Future<void> _save() async {
    if (selectedNote == null || selectedStudents.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('اختر ملاحظة وحدّد طالبًا واحدًا على الأقل')),
      );
      return;
    }

    setState(() => saving = true);

    // سجل لكل طالب مُحدَّد، بالملاحظة نفسها.
    final records = selectedStudents
        .map(
          (studentId) => BehavoirRecordEntity(
            studentId: studentId,
            gregorian_date: widget.dateTime ?? DateTime.now(),
            date_hijri: widget.date ?? '1/1/1111',
            student_class: widget.classId ?? 9,
            period: widget.session ?? 9,
          )
            ..notes_ids = [selectedNote!.id]
            ..submit = true,
        )
        .toList();

    final result = await sl<AddBehavoirUseCase>().call(records);
    if (!mounted) return;
    setState(() => saving = false);

    result.fold(
      (failure) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(failure.message)),
      ),
      (_) => AppUtils.go(
        const DoneAddedPage(
          label: 'تم تسجيل السلوك بنجاح',
          title: 'تسجيل السلوك',
        ),
      ),
    );
  }
}
