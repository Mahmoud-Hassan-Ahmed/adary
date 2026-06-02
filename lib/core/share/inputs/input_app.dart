import 'package:adary/core/conts/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class InputApp extends StatelessWidget {
  const InputApp(
      {super.key,
      required this.textEditingController,
      required this.label,
      this.textInputType,
      this.numLine = 1,
      this.focusNode,
      required this.hint});
  final TextEditingController textEditingController;
  final String label;
  final TextInputType? textInputType;
  final String hint;
  final FocusNode? focusNode;
  final int numLine;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 5,
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          // height: double.parse((60 * 1).toString()),
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.APP_COLOR, width: 1)),
          child: TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'field_required'.tr();
              }
              return null;
            },
            maxLines: numLine,
            focusNode: focusNode,
            keyboardType: textInputType,
            controller: textEditingController,
            style: const TextStyle(color: Colors.grey),
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: TextStyle(color: Colors.grey)),
          ),
        ),
      ],
    );
  }
}
