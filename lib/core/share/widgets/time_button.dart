import 'package:adary/core/conts/icons.dart';
import 'package:adary/core/share/widgets/btn_with_icon.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:time_picker_spinner/time_picker_spinner.dart';

class TimeButton extends StatefulWidget {
  const TimeButton({super.key, this.selectDate, required this.onChange});
  final String? selectDate;
  final ValueChanged<DateTime> onChange;

  @override
  State<TimeButton> createState() => _DateWidgetState();
}

class _DateWidgetState extends State<TimeButton> {
  var label = '';
  @override
  void initState() {
    label = widget.selectDate ?? 'اختر الوقت'.tr();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    label = widget.selectDate ?? 'choose_time'.tr();
    final TextEditingController validatorController =
        TextEditingController(text: widget.selectDate);
    return Stack(
      children: [
        TextFormField(
          style: const TextStyle(color: Colors.white),
          controller: validatorController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'choose_time'.tr();
            }
            return null;
          },
        ),
        BtnWithIcon(
          onTp: () {
            AwesomeDialog(
                    context: context,
                    bodyHeaderDistance: 0,
                    padding: const EdgeInsets.all(5),
                    body: TimePickerSpinner(
                      locale: const Locale('ar', ''),
                      time: DateTime.now(),
                      is24HourMode: false,
                      isShowSeconds: true,
                      itemHeight: 80,
                      normalTextStyle: const TextStyle(
                        fontSize: 24,
                      ),
                      highlightedTextStyle:
                          const TextStyle(fontSize: 24, color: Colors.blue),
                      isForce2Digits: true,
                      onTimeChange: (time) {
                        widget.onChange(time);
                      },
                    ),
                    dialogType: DialogType.noHeader)
                .show();
          },
          label: label,
          pathIcon: AppIcon.date,
        ),
      ],
    );
  }
}
