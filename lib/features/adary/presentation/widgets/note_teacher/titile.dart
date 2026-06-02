import 'package:flutter/material.dart';

class Titile extends StatelessWidget {
  const Titile({super.key, required this.label, this.color, this.fontSize});
  final String label;
  final Color? color;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 10,
        ),
        Text(
          label,
          style: TextStyle(
              fontSize: fontSize ?? 16,
              fontWeight: FontWeight.bold,
              color: color),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
