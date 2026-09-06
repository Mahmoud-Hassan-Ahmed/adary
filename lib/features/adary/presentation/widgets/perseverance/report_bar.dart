import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/features/adary/presentation/widgets/text/label_main_text.dart';
import 'package:flutter/material.dart';

// عناصر بطاقات «التقارير والاحصائيات» المشتركة بين تقريرَي الحضور والسلوك.

/// شريحة واحدة في الشريط المجزّأ، بعدّادها ولونها وتسميتها في الليجند.
class ReportSegment {
  const ReportSegment({
    required this.value,
    required this.color,
    required this.label,
    this.inLegend = true,
  });

  final int value;
  final Color color;
  final String label;

  /// شريحة تلوّن الشريط بلا عدّاد في الليجند — للحالة الافتراضية التي لا
  /// تُسجَّل ولا تُقرأ كرقم، وحضورُها هو الأصل.
  final bool inLegend;
}

/// بطاقة فصل: الاسم، ثم الشريط المجزّأ، ثم الليجند بنقاطه الملوّنة.
class ReportClassCard extends StatelessWidget {
  const ReportClassCard({
    super.key,
    required this.className,
    required this.segments,
  });

  final String className;
  final List<ReportSegment> segments;

  @override
  Widget build(BuildContext context) {
    final total = segments.fold<int>(0, (sum, s) => sum + s.value);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEFEFEF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          LabelMainText(
            text: className,
            fontSize: 16,
            bold: true,
            color: Colors.black,
          ),
          const SizedBox(height: 10),
          _bar(total),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: segments.reversed
                .where((s) => s.inLegend)
                .map(_legendItem)
                .toList(),
          ),
        ],
      ),
    );
  }

  /// الشريط المجزّأ. الفصل الخالي من السجلات يعرض شريطًا رماديًا بدل القسمة
  /// على صفر.
  Widget _bar(int total) {
    if (total == 0) {
      return Container(
        height: 10,
        decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(10),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Row(
        children: segments
            .where((s) => s.value > 0)
            .map(
              (s) => Expanded(
                flex: s.value,
                child: Container(height: 10, color: s.color),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _legendItem(ReportSegment segment) {
    return Flexible(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          LabelMainText(
            text: '${segment.value} ${segment.label}',
            fontSize: 13,
            color: segment.color,
            maxLines: 1,
          ),
          const SizedBox(width: 4),
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: segment.color,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}

/// حلقة النسبة أعلى «تقارير الحضور»: «60 %» داخلها والتسمية تحتها.
class ReportPercentCard extends StatelessWidget {
  const ReportPercentCard({
    super.key,
    required this.percent,
    required this.color,
    required this.label,
  });

  final int percent;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE4E4E4), width: 4),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 62,
            height: 62,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox.expand(
                  child: CircularProgressIndicator(
                    value: percent / 100,
                    strokeWidth: 7,
                    backgroundColor: const Color(0xFFE4E4E4),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
                LabelMainText(
                  text: '$percent%',
                  fontSize: 15,
                  bold: true,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          LabelMainText(text: label, fontSize: 14, color: Colors.black87),
        ],
      ),
    );
  }
}

/// عنوان قسم داخل شاشات التقارير.
class ReportSectionTitle extends StatelessWidget {
  const ReportSectionTitle({super.key, required this.text, this.teal = false});

  final String text;
  final bool teal;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: LabelMainText(
        text: text,
        fontSize: 16,
        bold: true,
        color: teal ? AppColors.APP_COLOR : Colors.black,
      ),
    );
  }
}
