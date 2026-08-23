import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/features/adary/data/models/student_per.dart';
import 'package:adary/features/adary/presentation/widgets/text/label_main_text.dart';
import 'package:flutter/material.dart';

// ترويسة شاشتَي «قائمة الحضور» و«سلوك الطلاب» وما يتبعها من صفوف التحديد.

/// عدّاد حالة واحد في الترويسة: مربّع ملوّن ثم «33 حاضر».
class ConductCount {
  const ConductCount(this.label, this.value, this.color);

  final String label;
  final int value;
  final Color color;
}

/// «التاريخ : 1447/12/4  الحصة: الرابعة  الفصل : 1/م1» ثم عدّادات الحالات،
/// ثم صف «أسماء الطلاب» ومعه «تحديد الكل» في وضع التسجيل.
class ConductFilterHeader extends StatelessWidget {
  const ConductFilterHeader({
    super.key,
    required this.dateHijri,
    required this.sessionName,
    required this.className,
    this.counts = const [],
    this.selectAll,
    this.onSelectAll,
  });

  final String dateHijri, sessionName, className;
  final List<ConductCount> counts;

  /// حين تُمرَّر، يظهر «تحديد الكل» بجانب «أسماء الطلاب».
  final bool? selectAll;
  final ValueChanged<bool>? onSelectAll;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _pair('الفصل :', className),
              _pair('الحصة:', sessionName),
              _pair('التاريخ :', dateHijri),
            ],
          ),
          if (counts.isNotEmpty) ...[
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: counts.reversed.map(_count).toList(),
            ),
          ],
          const SizedBox(height: 10),
          Row(
            children: [
              if (selectAll != null) ...[
                const LabelMainText(
                  text: 'تحديد الكل',
                  fontSize: 14,
                  color: Colors.black87,
                ),
                const SizedBox(width: 6),
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: selectAll,
                    activeColor: AppColors.APP_COLOR,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    onChanged: (v) => onSelectAll?.call(v ?? false),
                  ),
                ),
              ],
              const Spacer(),
              const LabelMainText(
                text: 'أسماء الطلاب',
                fontSize: 14,
                color: Colors.black87,
              ),
              const SizedBox(width: 6),
              const Icon(Icons.groups_2_outlined,
                  size: 20, color: AppColors.APP_COLOR),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pair(String label, String value) {
    return Flexible(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: LabelMainText(
              text: value,
              fontSize: 14,
              color: AppColors.APP_COLOR,
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 3),
          LabelMainText(text: label, fontSize: 14, color: Colors.black87),
        ],
      ),
    );
  }

  Widget _count(ConductCount item) {
    return Flexible(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          LabelMainText(
            text: '${item.value} ${item.label}',
            fontSize: 12,
            color: item.color,
            maxLines: 1,
          ),
          const SizedBox(width: 4),
          Container(width: 10, height: 10, color: item.color),
        ],
      ),
    );
  }
}

/// منسدلة «اختر ملاحظة» أعلى قائمة التسجيل — ملاحظة واحدة تُطبَّق على من
/// يُحدَّد من الطلاب، كما في التصميم.
class NoteSelector extends StatelessWidget {
  const NoteSelector({
    super.key,
    required this.notes,
    required this.selected,
    required this.onChanged,
    this.onManage,
  });

  final List<BehaviorNote> notes;
  final BehaviorNote? selected;
  final ValueChanged<BehaviorNote?> onChanged;

  /// يفتح «قائمة ملاحظات السلوك» لإضافة الملاحظات وتعديلها.
  final VoidCallback? onManage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (onManage != null)
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: GestureDetector(
              onTap: onManage,
              child: const CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.APP_COLOR,
                child: Icon(Icons.tune, color: Colors.white, size: 22),
              ),
            ),
          ),
        Expanded(child: _dropdown()),
      ],
    );
  }

  Widget _dropdown() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFCFCFCF)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<BehaviorNote>(
          value: selected,
          isExpanded: true,
          hint: const LabelMainText(
            text: 'اختر ملاحظة',
            fontSize: 15,
            color: Colors.grey,
          ),
          icon: const Icon(Icons.keyboard_arrow_down),
          borderRadius: BorderRadius.circular(12),
          items: notes
              .map(
                (note) => DropdownMenuItem(
                  value: note,
                  child: Row(
                    children: [
                      Icon(
                        note.note_type == 'positive'
                            ? Icons.sentiment_satisfied_alt
                            : Icons.sentiment_dissatisfied,
                        color: note.color,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: LabelMainText(
                          text: note.title ?? '',
                          fontSize: 15,
                          maxLines: 1,
                        ),
                      ),
                      LabelMainText(
                        text: '${note.points} نقاط',
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

/// بطاقة الطالب في وضع التسجيل: الصورة والاسم ومربّع التحديد.
class StudentSelectCard extends StatelessWidget {
  const StudentSelectCard({
    super.key,
    required this.name,
    required this.selected,
    required this.onChanged,
  });

  final String name;
  final bool selected;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!selected),
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: selected,
                activeColor: AppColors.APP_COLOR,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                onChanged: (v) => onChanged(v ?? false),
              ),
            ),
            const Spacer(),
            LabelMainText(
              text: name,
              fontSize: 15,
              bold: true,
              color: Colors.black,
            ),
            const SizedBox(width: 10),
            const CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage('assets/images/student.jpg'),
            ),
          ],
        ),
      ),
    );
  }
}
