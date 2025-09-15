import 'package:adary/core/conts/app_colors.dart';
import 'package:easy_radio/easy_radio.dart';
import 'package:flutter/material.dart';

class RadioBtn extends StatelessWidget {
  const RadioBtn(
      {super.key,
      required this.group,
      required this.label,
      required this.value,
      required this.valueChanged});
  final int group;
  final String label;
  final int value;
  final ValueChanged<int?> valueChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        valueChanged(value);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(20),
            color: value == group ? AppColors.radiobgColor : null),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            EasyRadio<int>(
              activeFillColor: AppColors.checkbox,
              dotColor: Colors.white,
              value: value,
              groupValue: group,
              onChanged: (v) {
                valueChanged(v);
              },
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: group == value ? Colors.white : Colors.black,
                  fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
