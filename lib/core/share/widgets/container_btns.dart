import 'package:adary/core/conts/app_colors.dart';
import 'package:flutter/material.dart';

class ContainerBtns extends StatelessWidget {
  const ContainerBtns(
      {super.key, required this.content, this.hasBorder = true});
  final Widget content;
  final bool hasBorder;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: hasBorder
            ? BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.APP_COLOR, width: 2),
                borderRadius: const BorderRadius.all(Radius.circular(15)))
            : null,
        child: content,
      ),
    );
  }
}
