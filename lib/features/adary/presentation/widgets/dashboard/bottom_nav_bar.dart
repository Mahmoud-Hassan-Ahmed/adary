import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/conts/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BottomNavItem extends StatelessWidget {
  final String? iconPath;
  final Function onTap;
  final bool isSelected;
  final String pageName;
  const BottomNavItem({
    super.key,
    required this.iconPath,
    required this.onTap,
    this.isSelected = false,
    required this.pageName,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () => onTap(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          // min so the bar keeps its own height instead of relying on a fixed
          // one that overflows as soon as the label or the font grows.
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 4,
                width: isSelected ? 40 : 0,
                decoration: BoxDecoration(
                  color: AppColors.APP_COLOR,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 8),
              if (iconPath != null)
                SvgPicture.asset(
                  iconPath!,
                  colorFilter: ColorFilter.mode(
                    isSelected ? AppColors.FONTCOLOR : AppColors.SECONDERYCOLOR,
                    BlendMode.srcIn,
                  ),
                  width: 25,
                  height: 25,
                ),
              const SizedBox(height: 4),
              Text(
                pageName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: AppTextStyles.navLabel.copyWith(
                  color:
                      isSelected ? AppColors.FONTCOLOR : AppColors.SECONDERYCOLOR,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
