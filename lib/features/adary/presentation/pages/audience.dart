import 'package:adary/features/adary/presentation/pages/behavioral_notes_list.dart';
import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/share/widgets/btn_app.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/student_model.dart';
import 'package:adary/features/adary/data/models/student_per.dart';
import 'package:adary/features/adary/domain/entities/filter_per.dart';
import 'package:adary/features/adary/domain/entities/register_student_entity.dart';
import 'package:adary/features/adary/domain/usecases/add_behavoir_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_student_attendnce.dart';
import 'package:adary/features/adary/domain/usecases/get_student_calss_use_case.dart';
import 'package:adary/features/adary/domain/usecases/register_students_use_case.dart';
import 'package:adary/features/adary/presentation/bloc/behavoir_notes/behavoir_notes_bloc.dart';
import 'package:adary/features/adary/presentation/pages/done_added_page.dart';
import 'package:adary/features/adary/presentation/pages/perseverance.dart';
import 'package:adary/features/adary/presentation/widgets/perseverance/StudentCard.dart';
import 'package:adary/features/adary/presentation/widgets/perseverance/conduct_header.dart';
import 'package:adary/features/adary/presentation/widgets/perseverance/conduct_widgets.dart';
import 'package:adary/features/adary/presentation/widgets/perseverance/student_actions_menu.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

/// تبويب «المواظبة» بأوضاعه الثلاثة: قائمة الطلاب، تسجيل الحضور، تسجيل ملاحظة.
class Audience extends StatefulWidget {
  const Audience(
      {super.key,
      required this.mode,
      this.classId,
      this.date,
      this.sessionName,
      this.className,
      this.session,
      this.dateTime});

  final int mode;
  final int? classId;
  final String? date;
  final int? session;
  final String? sessionName;
  final String? className;
  final DateTime? dateTime;

  @override
  State<Audience> createState() => _AudienceState();
}

class _AudienceState extends State<Audience> {
  final PagingController<int, StudentPer> _pagingController =
      PagingController(firstPageKey: 1);
  final PagingController<int, StudentInfo> _pagingController1 =
      PagingController(firstPageKey: 1);

  late FilterPer entity;
  late FilterPer entity1;

  final getstudents = sl<GetStudentAttendnce>();
  final geStudentsByClass = sl<GetStudentCalssUseCase>();

  List<BehaviorNote> notes = [];
  BehaviorNote? selectedNote;

  /// معرّفات الطلاب المحدَّدين في وضع تسجيل الملاحظة — مجموعة كي لا تتكرّر مع
  /// كل إعادة بناء للقائمة.
  final Set<int> selectedStudents = {};

  /// حالة الحضور لكل طالب في وضع تسجيل الحضور، مفهرسة بمعرّفه للسبب نفسه.
  final Map<int, RegisterStudentEntity> attendanceDrafts = {};

  bool saving = false;

  bool get isList => widget.mode == ConductMode.list;

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

  int _countOf(String code) =>
      _pagingController.itemList?.where((t) => t.attendance == code).length ?? 0;

  List<StudentInfo> get _loadedStudents => _pagingController1.itemList ?? [];

  bool get _allSelected =>
      _loadedStudents.isNotEmpty &&
      selectedStudents.length == _loadedStudents.length;

  /// مسوّدة حضور الطالب، تُنشأ مرة واحدة ثم تُحدَّث.
  RegisterStudentEntity _draftFor(StudentInfo student) =>
      attendanceDrafts.putIfAbsent(
        student.id,
        () => RegisterStudentEntity(
          studentId: student.id,
          date: widget.dateTime ?? DateTime.now(),
          dateHijri: widget.date ?? '1/1/1111',
          className: widget.classId ?? 9,
          session: widget.session ?? 9,
        ),
      );

  String get _emptyText => widget.classId == null
      ? 'فلتر بالفصل والحصة لعرض البيانات'
      : 'لا يوجد بيانات للعرض';

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

          return Scaffold(
            backgroundColor: const Color(0xfff5f5f5),
            body: SafeArea(
              child: Column(
                children: [
                  ConductFilterHeader(
                    dateHijri: widget.date ?? '',
                    sessionName: widget.sessionName ?? '',
                    className: widget.className ?? '',
                    counts: [
                      ConductCount(
                          'حاضر', _countOf('s'), const Color(0xFF43A047)),
                      ConductCount(
                          'غائب', _countOf('a'), const Color(0xFFE53935)),
                      ConductCount(
                          'متأخر', _countOf('l'), const Color(0xFFF5B301)),
                      ConductCount(
                          'مستأذن', _countOf('p'), const Color(0xFF1B2A6B)),
                    ],
                    // «تحديد الكل» يخص تسجيل الملاحظة وحده.
                    selectAll: widget.mode == ConductMode.registerNote
                        ? _allSelected
                        : null,
                    onSelectAll: (value) => setState(() {
                      selectedStudents
                        ..clear()
                        ..addAll(
                          value
                              ? _loadedStudents.map((s) => s.id)
                              : const <int>[],
                        );
                    }),
                  ),
                  Expanded(child: _buildBody()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    switch (widget.mode) {
      case ConductMode.registerAttendance:
        return _buildAttendanceRegister();
      case ConductMode.registerNote:
        return _buildNoteRegister();
      default:
        return _buildList();
    }
  }

  // ── قائمة الطلاب ────────────────────────────────────────────────────────

  Widget _buildList() {
    return PagedListView<int, StudentPer>(
      padding: const EdgeInsets.fromLTRB(15, 8, 15, 0),
      physics: const BouncingScrollPhysics(),
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<StudentPer>(
        noItemsFoundIndicatorBuilder: (context) => ConductEmpty(text: _emptyText),
        itemBuilder: (context, item, index) => StudentCard(
          studentAud: item,
          classId: widget.classId,
          className: widget.className,
          dateHijri: widget.date,
        ),
      ),
    );
  }

  // ── تسجيل الحضور ────────────────────────────────────────────────────────

  Widget _buildAttendanceRegister() {
    return Column(
      children: [
        Expanded(
          child: PagedListView<int, StudentInfo>(
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(),
            pagingController: _pagingController1,
            builderDelegate: PagedChildBuilderDelegate<StudentInfo>(
              noItemsFoundIndicatorBuilder: (context) =>
                  ConductEmpty(text: _emptyText),
              itemBuilder: (context, item, index) {
                final draft = _draftFor(item);
                return StudentCardRegister(
                  student: item,
                  index: index,
                  onChange: (value) {
                    draft.attendance = value.$1;
                    draft.note = value.$2;
                  },
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: BtnApp(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            label: saving ? 'جارٍ الحفظ...' : 'حفظ التسجيل',
            onTap: saving ? () {} : _saveAttendance,
          ),
        ),
      ],
    );
  }

  Future<void> _saveAttendance() async {
    if (attendanceDrafts.isEmpty) {
      _toast('لا يوجد طلاب للتسجيل');
      return;
    }

    setState(() => saving = true);
    final result =
        await sl<RegisterStudentsUseCase>().call(attendanceDrafts.values.toList());
    if (!mounted) return;
    setState(() => saving = false);

    result.fold(
      (failure) => _toast(failure.message),
      (_) => AppUtils.go(
        const DoneAddedPage(
          label: 'تم تسجيل الحضور',
          title: 'تسجيل الحضور',
        ),
      ),
    );
  }

  // ── تسجيل ملاحظة ────────────────────────────────────────────────────────

  Widget _buildNoteRegister() {
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
              noItemsFoundIndicatorBuilder: (context) =>
                  ConductEmpty(text: _emptyText),
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
            onTap: saving ? () {} : _saveNote,
          ),
        ),
      ],
    );
  }

  Future<void> _saveNote() async {
    if (selectedNote == null || selectedStudents.isEmpty) {
      _toast('اختر ملاحظة وحدّد طالبًا واحدًا على الأقل');
      return;
    }

    setState(() => saving = true);

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
      (failure) => _toast(failure.message),
      (_) => AppUtils.go(
        const DoneAddedPage(
          label: 'تم تسجيل الملاحظة بنجاح',
          title: 'تسجيل ملاحظة',
        ),
      ),
    );
  }

  void _toast(String message) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(message)));
}

/// بطاقة الطالب في «قائمة الحضور» — الاسم وحالته تحته، وقائمة النقاط الثلاث
/// على اليسار كما في التصميم.
class StudentCard extends StatelessWidget {
  const StudentCard({
    super.key,
    required this.studentAud,
    this.classId,
    this.className,
    this.dateHijri,
  });

  final StudentPer studentAud;
  final int? classId;
  final String? className;
  final String? dateHijri;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            blurRadius: 6,
            offset: Offset(0, 2),
            color: Colors.black12,
          )
        ],
      ),
      child: Row(
        children: [
          StudentActionsMenu(
            studentId: studentAud.student.id,
            studentName: studentAud.student.name,
            className: className,
            statusLabel: studentAud.statusName,
            statusColor: studentAud.color,
            studentClassId: classId,
            source: 'attendance',
            reason: studentAud.attendance == 'a' ? 'غياب بدون عذر' : null,
            date: studentAud.date,
            dateHijri: dateHijri ?? studentAud.dateHijri,
            session: studentAud.session,
            attendanceRecordId: studentAud.id,
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                studentAud.student.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                studentAud.statusName,
                style: TextStyle(
                  color: studentAud.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          const CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage("assets/images/student.jpg"),
          ),
        ],
      ),
    );
  }
}
