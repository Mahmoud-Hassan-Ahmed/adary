import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BtnIcon extends StatelessWidget {
  const BtnIcon(
      {super.key,
      required this.icon,
      required this.label,
      required this.onTap});
  final String icon;
  final String label;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(icon),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium,
          )
        ],
      ),
    );
  }
}
