import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/share/widgets/my_app_bar.dart';
import 'package:adary/features/adary/data/models/student_conduct.dart';
import 'package:adary/features/adary/domain/entities/student_conduct_entity.dart';
import 'package:adary/features/adary/domain/usecases/student_conduct_use_cases.dart';
import 'package:adary/features/adary/presentation/widgets/perseverance/conduct_widgets.dart';
import 'package:adary/features/adary/presentation/widgets/text/label_main_text.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// «سجل حضور الطالب» و«سجل سلوك الطالب» و«الإجراءات المتخذة» — تُفتح من قائمة
/// النقاط الثلاث على بطاقة الطالب. الشريط السفلي يبدّل بين السجل والإجراءات،
/// كما في التصميم.
class StudentRecordPage extends StatefulWidget {
  const StudentRecordPage({
    super.key,
    required this.studentId,
    required this.studentName,
    this.className,
    this.statusLabel,
    this.source = 'attendance',
    this.startOnProcedures = false,
  });

  final int studentId;
  final String studentName;
  final String? className;

  /// حالة الطالب كما ظهرت في القائمة («غائب»، «يتشاجر مع زملائه») — تُعرض
  /// على بطاقة الإجراءات كما في التصميم.
  final String? statusLabel;

  /// `attendance` تفتح سجل الحضور، و`behavior` تفتح سجل السلوك.
  final String source;
  final bool startOnProcedures;

  @override
  State<StudentRecordPage> createState() => _StudentRecordPageState();
}

class _StudentRecordPageState extends State<StudentRecordPage> {
  late bool showProcedures = widget.startOnProcedures;
  String period = ConductPeriod.thisMonth;

  bool get isAttendance => widget.source == 'attendance';

  String get title =>
      isAttendance ? 'سجل حضور الطالب' : 'سجل سلوك الطالب';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(
        title: showProcedures ? 'الاجراءات المتخذة' : title,
        actions: showProcedures
            ? null
            : [
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.APP_COLOR,
                    child: SvgPicture.asset(
                      'assets/icons/icon-filter.svg',
                      // ignore: deprecated_member_use
                      color: Colors.white,
                      width: 18,
                    ),
                  ),
                ),
              ],
      ),
      bottomNavigationBar: ConductBottomBar(
        rightLabel: isAttendance ? 'الحضور والغياب' : 'سجل السلوك',
        rightIcon: 'assets/icons/mingcute_user-add-line.svg',
        leftLabel: 'الإجراءات المتخذة',
        leftIcon: 'assets/icons/octicon_checklist-16.svg',
        rightSelected: !showProcedures,
        onRight: () => setState(() => showProcedures = false),
        onLeft: () => setState(() => showProcedures = true),
      ),
      body: SafeArea(
        child: showProcedures ? _buildProcedures() : _buildRecord(),
      ),
    );
  }

  // ── سجل الحضور / السلوك ────────────────────────────────────────────────

  Widget _buildRecord() {
    final entity =
        StudentRecordEntity(studentId: widget.studentId, period: period);

    return isAttendance
        ? _RecordBody<StudentAttendanceRecord>(
            key: ValueKey('att-$period'),
            load: () => sl<GetStudentAttendanceRecordUseCase>()(entity),
            builder: (record) => _attendanceContent(record),
          )
        : _RecordBody<StudentBehaviorRecord>(
            key: ValueKey('beh-$period'),
            load: () => sl<GetStudentBehaviorRecordUseCase>()(entity),
            builder: (record) => _behaviorContent(record),
          );
  }

  Widget _attendanceContent(StudentAttendanceRecord record) {
    final s = record.summary;
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      physics: const BouncingScrollPhysics(),
      children: [
        StudentHeaderCard(
          name: record.student.name,
          className: record.student.className ?? widget.className,
        ),
        const SizedBox(height: 16),
        // البطاقات الأربع: نسبة الحضور ثم أيام الغياب والتأخر والاستئذان.
        Row(
          children: [
            Expanded(
              child: ConductStatChip(
                value: '${s.permission.count} يوم',
                label: 'مستأذن',
                color: const Color(0xFF1B2A6B),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ConductStatChip(
                value: '${s.late.count} يوم',
                label: 'تأخر',
                color: const Color(0xFFF5B301),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ConductStatChip(
                value: '${s.absent.count} يوم',
                label: 'غائب',
                color: const Color(0xFFE53935),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ConductStatChip(
                value: '${s.present.percent} %',
                label: 'حاضر',
                color: const Color(0xFF43A047),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _periodRow(),
        const SizedBox(height: 12),
        if (record.days.isEmpty) const ConductEmpty(text: 'لا يوجد بيانات للعرض'),
        ...record.days.map(
          (day) => ConductDayGroup(
            title: day.dateDisplay ?? day.dateHijri ?? '',
            children: day.sessions
                .map(
                  (session) => ConductRow(
                    title: 'الحصة ${session.sessionDisplay ?? ''}',
                    subtitle: session.timeRange,
                    middle: session.className ?? '',
                    trailing: session.attendanceDisplay,
                    trailingColor: _attendanceColor(session),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _behaviorContent(StudentBehaviorRecord record) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      physics: const BouncingScrollPhysics(),
      children: [
        StudentHeaderCard(
          name: record.student.name,
          className: record.student.className ?? widget.className,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ConductStatChip(
                value: '${record.summary.negativeNotes}',
                label: 'بحاجة إلي تحسين',
                color: const Color(0xFFE53935),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ConductStatChip(
                value: '${record.summary.positiveNotes}',
                label: 'إيجابي',
                color: const Color(0xFF43A047),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ConductStatChip(
                value: '${record.summary.totalPoints}',
                label: 'النقاط',
                color: AppColors.APP_COLOR,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _periodRow(),
        const SizedBox(height: 12),
        if (record.days.isEmpty) const ConductEmpty(text: 'لا يوجد بيانات للعرض'),
        ...record.days.map(
          (day) => ConductDayGroup(
            title: day.dateDisplay ?? day.dateHijri ?? '',
            children: day.records
                .map(
                  (item) => ConductRow(
                    title: 'الحصة ${item.periodDisplay ?? ''}',
                    subtitle: item.timeRange,
                    middle: item.notes.map((n) => n.title ?? '').join('، '),
                    trailing: '${item.totalPoints}',
                    trailingColor: item.totalPoints < 0
                        ? const Color(0xFFE53935)
                        : const Color(0xFF43A047),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  static Color _attendanceColor(AttendanceSession session) {
    if (session.isPresent) return const Color(0xFF43A047);
    if (session.isAbsent) return const Color(0xFFE53935);
    if (session.isLate) return const Color(0xFFF5B301);
    return const Color(0xFF1B2A6B);
  }

  // ── الإجراءات المتخذة ──────────────────────────────────────────────────

  Widget _buildProcedures() {
    return _RecordBody<dynamic>(
      key: ValueKey('proc-$period'),
      load: () => sl<GetStudentProceduresUseCase>()(
        ProceduresFilterEntity(
          studentId: widget.studentId,
          source: widget.source,
          period: period,
        ),
      ),
      builder: (page) {
        final List<StudentProcedure> items =
            List<StudentProcedure>.from(page.results);
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          physics: const BouncingScrollPhysics(),
          children: [
            StudentHeaderCard(
              name: widget.studentName,
              className: widget.className,
              trailing: widget.statusLabel,
            ),
            const SizedBox(height: 16),
            _periodRow(),
            const SizedBox(height: 12),
            if (items.isEmpty)
              const ConductEmpty(text: 'لا توجد إجراءات في هذه الفترة'),
            ...items.map((p) => ProcedureCard(procedure: p)),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }

  // ── «الفترة» ───────────────────────────────────────────────────────────

  Widget _periodRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PeriodDropdown(
          value: period,
          onChanged: (value) => setState(() => period = value),
        ),
        const LabelMainText(text: 'الفترة', fontSize: 16, bold: true),
      ],
    );
  }
}

/// يتولّى حالات التحميل والفشل حول أي نداء من نداءات السجل.
class _RecordBody<T> extends StatefulWidget {
  const _RecordBody({super.key, required this.load, required this.builder});

  final Future<dynamic> Function() load;
  final Widget Function(dynamic data) builder;

  @override
  State<_RecordBody<T>> createState() => _RecordBodyState<T>();
}

class _RecordBodyState<T> extends State<_RecordBody<T>> {
  late Future<dynamic> future = widget.load();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.APP_COLOR),
          );
        }
        final result = snapshot.data;
        if (result == null) {
          return const ConductEmpty(text: 'تعذّر تحميل البيانات');
        }
        // النتيجة Either: يسار عند الفشل ويمين عند النجاح.
        return result.fold(
          (failure) => ConductRetry(
            onRetry: () => setState(() => future = widget.load()),
          ),
          (data) => widget.builder(data),
        );
      },
    );
  }
}
