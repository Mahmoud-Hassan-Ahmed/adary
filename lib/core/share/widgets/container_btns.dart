import 'package:adary/core/conts/app_colors.dart';
import 'package:flutter/material.dart';

class ContainerBtns extends StatelessWidget {
  const ContainerBtns({super.key, required this.content});
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          color: AppColors.fileBg,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: content,
    );
  }
}
