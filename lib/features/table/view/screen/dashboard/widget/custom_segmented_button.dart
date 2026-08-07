import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/conts/app_text_styles.dart';
import 'package:easy_localization/easy_localization.dart'
    show StringTranslateExtension;
import 'package:flutter/material.dart';

class CustomSegmentedButton extends StatefulWidget {
  const CustomSegmentedButton({super.key, this.onChanged, this.selectedIndex});

  final ValueChanged<int>? onChanged;

  /// Lets the parent stay the source of truth for the active tab.
  final int? selectedIndex;

  @override
  State<CustomSegmentedButton> createState() => _CustomSegmentedButtonState();
}

class _CustomSegmentedButtonState extends State<CustomSegmentedButton> {
  int _internalIndex = 0; // 0 = smart table, 1 = follower

  int get _selected => widget.selectedIndex ?? _internalIndex;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Height follows the label, so the pill never clips its own text.
        final labelHeight = MediaQuery.textScalerOf(context)
            .scale(AppTextStyles.subtitle1)
            .clamp(14.0, 28.0);
        final height = labelHeight * 1.4 + 20;

        return Container(
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(height / 2),
            border: Border.all(color: AppColors.APP_COLOR),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: _buildItem(title: "smart_table".tr(), index: 0),
              ),
              Expanded(
                child: _buildItem(title: "follower".tr(), index: 1),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildItem({required String title, required int index}) {
    final isSelected = _selected == index;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() => _internalIndex = index);
        widget.onChanged?.call(index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.APP_COLOR : Colors.transparent,
          borderRadius: BorderRadius.circular(100),
        ),
        // Shrinks the label instead of wrapping it when the pill is narrow.
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            title,
            maxLines: 1,
            softWrap: false,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: AppTextStyles.subtitle1,
              height: 1.4,
            ),
          ),
        ),
      ),
    );
  }
}
