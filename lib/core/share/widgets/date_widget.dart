import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/conts/icons.dart';
import 'package:adary/core/share/widgets/btn_with_icon.dart';
import 'package:adary/core/share/widgets/hijri_calendart.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DateWidget extends StatefulWidget {
  const DateWidget(
      {super.key,
      this.selectDate,
      required this.onChange,
      this.isRange = false,
      this.isHijari = true});

  final String? selectDate;
  final ValueChanged<DateSelect> onChange;
  final bool isRange;
  final bool isHijari;

  @override
  State<DateWidget> createState() => _DateWidgetState();
}

class _DateWidgetState extends State<DateWidget> {
  late String label;

  @override
  void initState() {
    super.initState();
    label = widget.selectDate ?? 'يوم / شهر / سنة';
  }

  @override
  Widget build(BuildContext context) {
    label = widget.selectDate ?? label;

    return GestureDetector(
      onTap: () {
        AwesomeDialog(
          context: context,
          bodyHeaderDistance: 0,
          padding: const EdgeInsets.all(5),
          body: HijriCalendarWidget(
            isHijari: widget.isHijari,
            isRange: widget.isRange,
            onChange: (value) {
              widget.onChange(value);
              setState(() {
                if (widget.isHijari) {
                  label = value.hijriDate;
                } else {
                  label = DateFormat("dd-MM-yyyy").format(value.gregorianDate);
                }
              });
            },
          ),
          dialogType: DialogType.noHeader,
        ).show();
      },
      child: Container(
        height: 55,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.APP_COLOR,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            /// ICON

            /// TEXT
            Expanded(
              child: Text(
                label.isEmpty ? 'يوم / شهر / سنة' : label,
                style: TextStyle(
                  color:
                      label == 'يوم / شهر / سنة' ? Colors.grey : Colors.black,
                  fontSize: 14,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SvgPicture.asset(
                "assets/icons/date.svg",
                width: 22,
                height: 22,
                color: Colors.teal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
