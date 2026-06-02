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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          EasyRadio<int>(
            value: value,
            groupValue: group,
            dotStyle: const DotStyle.check(StrokeCap.square),
            shape: const RadioShape.square(),
            activeFillColor: AppColors.APP_COLOR,
            dotColor: Colors.white,
            onChanged: (int? v) {
              if (v != null) {
                valueChanged(v);
              }
            },
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.black, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
