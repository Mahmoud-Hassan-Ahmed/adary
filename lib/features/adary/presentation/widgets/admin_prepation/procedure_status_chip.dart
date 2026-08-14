import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/features/adary/data/models/procedure_cycle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// شريط حالة الإجراء الإداري أعلى بطاقة المعلّم: أين وصلت دورة النموذج —
/// بانتظار المعلّم، أم بانتظار قرار المدير، أم صدر القرار.
class ProcedureStatusChip extends StatelessWidget {
  const ProcedureStatusChip({super.key, required this.cycle});

  static const Color _pendingColor = Color(0xFFFF9F19);

  final ProcedureCycle cycle;

  Color get _background {
    if (cycle.isDecided) return const Color(0xFFE7F5EC);
    if (cycle.isPendingDecision) return const Color(0xFFFDF0DC);
    return const Color(0xFFF1F1F1);
  }

  Color get _foreground {
    if (cycle.isDecided) return const Color(0xFF2E7D32);
    if (cycle.isPendingDecision) return _pendingColor;
    return AppColors.GREYFONTCOLOR;
  }

  @override
  Widget build(BuildContext context) {
    final label = cycle.statusDisplay;
    if (label.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _background,
        border: Border.all(color: _foreground),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // الساعة الرملية لانتظار القرار وحده: الحالتان الأخريان لا انتظار
          // فيهما — إحداهما عند المعلّم والأخرى انتهت.
          if (cycle.isPendingDecision) ...[
            SvgPicture.asset(
              'assets/icons/waiting_hourglass.svg',
              height: 18,
              width: 18,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .copyWith(color: _foreground, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
