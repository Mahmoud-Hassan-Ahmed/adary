import 'package:adary/core/conts/icons.dart';
import 'package:adary/core/share/widgets/btn_with_icon.dart';
import 'package:adary/core/share/widgets/hijri_calendart.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DateWidget extends StatefulWidget {
  const DateWidget(
      {super.key,
      this.selectDate,
      required this.onChange,
      this.isRange = false});
  final String? selectDate;
  final ValueChanged<DateSelect> onChange;
  final bool isRange;

  @override
  State<DateWidget> createState() => _DateWidgetState();
}

class _DateWidgetState extends State<DateWidget> {
  var label = '';
  @override
  void initState() {
    label = widget.selectDate ?? 'choose_date'.tr();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    label = widget.selectDate ?? 'choose_date'.tr();
    final TextEditingController validatorController =
        TextEditingController(text: widget.selectDate);
    return Stack(
      children: [
        TextFormField(
          style: const TextStyle(color: Colors.white),
          controller: validatorController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'choose_date'.tr();
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
                    body: HijriCalendarWidget(
                      isRange: widget.isRange,
                      onChange: (value) {
                        widget.onChange(value);
                        setState(() {
                          label = value.hijriDate;
                        });
                        // Navigator.pop(context);
                      },
                    ),
                    dialogType: DialogType.noHeader)
                .show();
          },
          label: label,
          pathIcon: AppIcon.date,
        )
      ],
    );
  }
}
