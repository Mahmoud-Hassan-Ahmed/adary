import 'package:adary/core/conts/app_colors.dart';
import 'package:easy_localization/easy_localization.dart'
    show StringTranslateExtension;
import 'package:flutter/material.dart';

class CustomSegmentedButton extends StatefulWidget {
  const CustomSegmentedButton({super.key, this.onChanged});
  final ValueChanged<int>? onChanged;

  @override
  State<CustomSegmentedButton> createState() => _CustomSegmentedButtonState();
}

class _CustomSegmentedButtonState extends State<CustomSegmentedButton> {
  int selectedIndex = 0; // 0 = left, 1 = right

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.APP_COLOR),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: _buildItem(
              title: "smart_table".tr(),
              index: 0,
            ),
          ),
          Expanded(
            child: _buildItem(
              title: "follower".tr(),
              index: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem({required String title, required int index}) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
          widget.onChanged?.call(index);
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.APP_COLOR : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          title,
          style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w600,
              fontFamily: 'BahijTheSansArabic',
              fontSize: 18),
        ),
      ),
    );
  }
}
