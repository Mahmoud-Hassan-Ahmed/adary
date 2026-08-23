import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/share/widgets/btn_app.dart';
import 'package:adary/core/share/widgets/my_app_bar.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/student_conduct.dart';
import 'package:adary/features/adary/domain/usecases/student_conduct_use_cases.dart';
import 'package:adary/features/adary/presentation/pages/done_added_page.dart';
import 'package:adary/features/adary/presentation/widgets/perseverance/conduct_widgets.dart';
import 'package:adary/features/adary/presentation/widgets/text/label_main_text.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// «إتخاذ إجراء» — تُفتح من قائمة النقاط الثلاث. تُحدَّد أنواع الإجراء ثم
/// تُرسل دفعة واحدة، فتنتهي الشاشة إلى «تم حفظ الإجراء بنجاح».
class TakeProcedurePage extends StatefulWidget {
  const TakeProcedurePage({
    super.key,
    required this.studentId,
    required this.studentName,
    this.className,
    this.statusLabel,
    this.statusColor,
    this.studentClassId,
    this.source = 'attendance',
    this.reason,
    this.date,
    this.dateHijri,
    this.session,
    this.attendanceRecordId,
    this.behaviorRecordId,
  });

  final int studentId;
  final String studentName;
  final String? className;

  /// حالة الطالب المعروضة تحت اسمه («غائب»).
  final String? statusLabel;
  final Color? statusColor;

  final int? studentClassId;
  final String source;
  final String? reason, date, dateHijri, session;
  final int? attendanceRecordId, behaviorRecordId;

  @override
  State<TakeProcedurePage> createState() => _TakeProcedurePageState();
}

class _TakeProcedurePageState extends State<TakeProcedurePage> {
  final Set<String> selected = {};
  bool saving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(
        title: 'إتخاذ إجراء',
        actions: [
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
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                physics: const BouncingScrollPhysics(),
                children: [
                  const SizedBox(height: 8),
                  StudentHeaderCard(
                    name: widget.studentName,
                    className: null,
                    trailing: widget.statusLabel,
                    trailingColor: widget.statusColor,
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LabelMainText(
                        text: 'اختر نوع الإجراء المناسب للطالب',
                        fontSize: 16,
                        bold: true,
                        color: AppColors.APP_COLOR,
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.swap_vert,
                          color: AppColors.APP_COLOR, size: 22),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...ProcedureType.all.map(_buildOption),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: BtnApp(
                padding: const EdgeInsets.symmetric(vertical: 16),
                label: saving ? 'جارٍ الحفظ...' : 'حفظ البيانات',
                onTap: saving ? () {} : _save,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(MapEntry<String, String> option) {
    final isSelected = selected.contains(option.key);
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: GestureDetector(
        onTap: () => setState(() {
          isSelected ? selected.remove(option.key) : selected.add(option.key);
        }),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: isSelected ? AppColors.APP_COLOR : const Color(0xFFD9D9D9),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.APP_COLOR : Colors.white,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.APP_COLOR
                        : const Color(0xFFB5B5B5),
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 17, color: Colors.white)
                    : null,
              ),
              const Spacer(),
              LabelMainText(
                text: option.value,
                fontSize: 16,
                bold: true,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('اختر نوع الإجراء أولًا')),
      );
      return;
    }

    setState(() => saving = true);

    final payload = selected
        .map(
          (type) => StudentProcedure.createPayload(
            studentId: widget.studentId,
            procedureType: type,
            studentClass: widget.studentClassId,
            source: widget.source,
            reason: widget.reason,
            date: widget.date ??
                DateTime.now().toIso8601String().split('T').first,
            dateHijri: widget.dateHijri,
            session: widget.session,
            attendanceRecord: widget.attendanceRecordId,
            behaviorRecord: widget.behaviorRecordId,
          ),
        )
        .toList();

    final result = await sl<AddStudentProceduresUseCase>()(payload);
    if (!mounted) return;
    setState(() => saving = false);

    result.fold(
      (failure) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(failure.message)),
      ),
      (_) => AppUtils.go(
        const DoneAddedPage(
          label: 'تم حفظ الإجراء بنجاح',
          title: 'إتخاذ الإجراء',
        ),
      ),
    );
  }
}
