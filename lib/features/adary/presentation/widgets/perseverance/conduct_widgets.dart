import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/features/adary/data/models/student_conduct.dart';
import 'package:adary/features/adary/domain/entities/student_conduct_entity.dart';
import 'package:adary/features/adary/presentation/widgets/text/label_main_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// الودجت المشتركة بين شاشات «المواظبة والسلوك» — قسم 7.

/// الشريط السفلي المستدير ذو الخيارين، كما يظهر أسفل كل شاشات القسم.
class ConductBottomBar extends StatelessWidget {
  const ConductBottomBar({
    super.key,
    required this.rightLabel,
    required this.leftLabel,
    required this.rightSelected,
    required this.onRight,
    required this.onLeft,
    this.rightIcon,
    this.leftIcon,
    this.onSearch,
  });

  final String rightLabel, leftLabel;
  final String? rightIcon, leftIcon;
  final bool rightSelected;
  final VoidCallback onRight, onLeft;

  /// زر البحث الدائري — يظهر في شاشات القوائم فقط.
  final VoidCallback? onSearch;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
        child: Row(
          children: [
            if (onSearch != null) ...[
              GestureDetector(
                onTap: onSearch,
                child: const CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColors.APP_COLOR,
                  child: Icon(Icons.search, color: Colors.white),
                ),
              ),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.APP_COLOR),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child:
                          _item(rightLabel, rightIcon, rightSelected, onRight),
                    ),
                    Expanded(
                      child: _item(leftLabel, leftIcon, !rightSelected, onLeft),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(String label, String? icon, bool selected, VoidCallback onTap) {
    final color = selected ? AppColors.APP_COLOR : Colors.grey;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            SvgPicture.asset(
              icon,
              // ignore: deprecated_member_use
              color: color,
              height: 20,
            )
          else
            Icon(Icons.list_alt, color: color, size: 20),
          const SizedBox(height: 4),
          LabelMainText(text: label, fontSize: 13, color: color),
        ],
      ),
    );
  }
}

/// بطاقة الطالب أعلى شاشات السجل: الصورة والاسم والفصل.
class StudentHeaderCard extends StatelessWidget {
  const StudentHeaderCard({
    super.key,
    required this.name,
    this.className,
    this.trailing,
    this.trailingColor,
  });

  final String name;
  final String? className;

  /// نص جانبي اختياري («تأخر صباحي» في شاشة الإجراءات).
  final String? trailing;
  final Color? trailingColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(blurRadius: 8, offset: Offset(0, 2), color: Colors.black12),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 26,
            backgroundImage: AssetImage('assets/images/student.jpg'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabelMainText(
                  text: name,
                  fontSize: 16,
                  bold: true,
                  color: Colors.black,
                ),
                if (className != null) ...[
                  const SizedBox(height: 6),
                  LabelMainText(
                    text: 'الفصل : $className',
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null)
            LabelMainText(
              text: trailing!,
              fontSize: 14,
              color: trailingColor ?? const Color(0xFF6C63FF),
            ),
        ],
      ),
    );
  }
}

/// بطاقة إحصائية مؤطّرة بلون الحالة: «82 % حاضر»، «2 يوم غائب».
class ConductStatChip extends StatelessWidget {
  const ConductStatChip({
    super.key,
    required this.value,
    required this.label,
    required this.color,
  });

  final String value, label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          LabelMainText(text: value, fontSize: 15, bold: true, color: color),
          const SizedBox(height: 2),
          LabelMainText(
            text: label,
            fontSize: 12,
            color: color,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}

/// مجموعة يوم مطويّة، عنوانها «الخميس 15 أغسطس 2026».
class ConductDayGroup extends StatefulWidget {
  const ConductDayGroup({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  State<ConductDayGroup> createState() => _ConductDayGroupState();
}

class _ConductDayGroupState extends State<ConductDayGroup> {
  bool expanded = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => setState(() => expanded = !expanded),
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                Icon(
                  expanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                  color: AppColors.APP_COLOR,
                ),
                const Spacer(),
                LabelMainText(
                  text: widget.title,
                  fontSize: 15,
                  bold: true,
                  color: AppColors.APP_COLOR,
                ),
                const SizedBox(width: 6),
                const Icon(Icons.calendar_today_outlined,
                    size: 16, color: AppColors.APP_COLOR),
              ],
            ),
          ),
          if (expanded) ...[
            const SizedBox(height: 8),
            ...widget.children,
          ],
        ],
      ),
    );
  }
}

/// سطر داخل مجموعة اليوم: الحصة ووقتها، ثم المادة/الفصل، ثم الحالة ملوّنة.
class ConductRow extends StatelessWidget {
  const ConductRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.middle,
    required this.trailing,
    required this.trailingColor,
  });

  final String title, subtitle, middle, trailing;
  final Color trailingColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE3E3E3)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: LabelMainText(
              text: trailing,
              fontSize: 14,
              bold: true,
              color: trailingColor,
            ),
          ),
          Expanded(
            flex: 3,
            child: LabelMainText(
              text: middle,
              fontSize: 14,
              color: Colors.black87,
              maxLines: 2,
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                LabelMainText(
                  text: title,
                  fontSize: 14,
                  color: Colors.black,
                ),
                if (subtitle.isNotEmpty)
                  LabelMainText(
                    text: subtitle,
                    fontSize: 12,
                    color: AppColors.APP_COLOR,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// بطاقة إجراء في «الإجراءات المتخذة».
class ProcedureCard extends StatelessWidget {
  const ProcedureCard({super.key, required this.procedure});

  final StudentProcedure procedure;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(blurRadius: 8, offset: Offset(0, 2), color: Colors.black12),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              LabelMainText(
                text: procedure.procedureTypeDisplay,
                fontSize: 15,
                bold: true,
                color: const Color(0xFFF07A2B),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.circle, size: 8, color: Color(0xFFF07A2B)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              LabelMainText(
                text: procedure.dateHijri ?? procedure.date ?? '',
                fontSize: 13,
                color: Colors.black87,
              ),
              const SizedBox(width: 6),
              const Icon(Icons.calendar_today_outlined,
                  size: 14, color: AppColors.APP_COLOR),
            ],
          ),
          if ((procedure.reason ?? '').isNotEmpty) ...[
            const SizedBox(height: 6),
            LabelMainText(
              text: 'السبب : ${procedure.reason}',
              fontSize: 13,
              color: const Color(0xFFE53935),
            ),
          ],
        ],
      ),
    );
  }
}

/// قائمة «الفترة» المنسدلة.
class PeriodDropdown extends StatelessWidget {
  const PeriodDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFCFCFCF)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          borderRadius: BorderRadius.circular(10),
          items: ConductPeriod.options
              .map(
                (option) => DropdownMenuItem(
                  value: option.key,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_today_outlined,
                          size: 15, color: Colors.black54),
                      const SizedBox(width: 6),
                      LabelMainText(text: option.value, fontSize: 14),
                    ],
                  ),
                ),
              )
              .toList(),
          onChanged: (v) => v == null ? null : onChanged(v),
        ),
      ),
    );
  }
}

/// حالة «لا يوجد بيانات للعرض» بأيقونتها كما في التصميم.
class ConductEmpty extends StatelessWidget {
  const ConductEmpty({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: const Color(0xFFFDF1E7),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.info_outline,
                size: 44, color: Color(0xFFE0526B)),
          ),
          const SizedBox(height: 16),
          LabelMainText(text: text, fontSize: 17),
        ],
      ),
    );
  }
}

/// حالة فشل النداء مع إعادة المحاولة.
class ConductRetry extends StatelessWidget {
  const ConductRetry({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off, size: 44, color: Colors.grey),
          const SizedBox(height: 12),
          const LabelMainText(text: 'تعذّر تحميل البيانات', fontSize: 16),
          const SizedBox(height: 12),
          TextButton(
            onPressed: onRetry,
            child: const LabelMainText(
              text: 'إعادة المحاولة',
              fontSize: 15,
              color: AppColors.APP_COLOR,
            ),
          ),
        ],
      ),
    );
  }
}
