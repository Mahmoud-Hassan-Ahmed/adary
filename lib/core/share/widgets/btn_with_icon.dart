import 'package:adary/core/conts/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BtnWithIcon extends StatelessWidget {
  const BtnWithIcon(
      {super.key, required this.label, this.pathIcon, required this.onTp});
  final String label;
  final String? pathIcon;
  final Function() onTp;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTp,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.APP_COLOR, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          // mainAxisSize: MainAxisSize.max,
          children: [
            if (pathIcon != null)
              SvgPicture.asset(
                pathIcon!,
                width: 30,
                height: 30,
              ),
            if (pathIcon != null)
              const SizedBox(
                width: 10,
              ),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
      ),
    );
  }
}
