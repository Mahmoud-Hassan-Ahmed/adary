import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
// import 'package:intl/intl.dart';

final class DateSelect {
  final String hijriDate;
  final DateTime? gregorianDate2;
  final String? hijriDate2;
  final DateTime gregorianDate;

  DateSelect(
      {required this.hijriDate,
      required this.gregorianDate,
      this.hijriDate2,
      this.gregorianDate2});
}

class HijriCalendarWidget extends StatefulWidget {
  const HijriCalendarWidget(
      {super.key, required this.onChange, this.isRange = false});
  final ValueChanged<DateSelect> onChange;
  final bool isRange;
  @override
  State<HijriCalendarWidget> createState() => _HijriCalendarWidgetState();
}

class _HijriCalendarWidgetState extends State<HijriCalendarWidget> {
  DateTime? selectedDay = DateTime.now();
  DateTime? endDay = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      focusedDay: selectedDay!,
      rangeStartDay: selectedDay,
      rangeEndDay: endDay,
      rangeSelectionMode: widget.isRange
          ? RangeSelectionMode.enforced
          : RangeSelectionMode.disabled,
      availableCalendarFormats: const {CalendarFormat.month: 'month'},
      calendarFormat: CalendarFormat.month,
      onFormatChanged: (format) {},
      firstDay: DateTime.utc(2024, 1, 1),
      lastDay: DateTime.utc(2026, 12, 31),
      selectedDayPredicate: (day) => isSameDay(day, selectedDay),
      onRangeSelected: (start, end, focusedDay) {
        setState(() {
          selectedDay = start;
          endDay = end;
        });
        if (start == null && end == null) return;
        String startDate =
            DateFormat('dd-MM-yyyy', 'en').format(start!).toString();
        String endDate = DateFormat('dd-MM-yyyy', 'en').format(end!).toString();
        widget.onChange(DateSelect(
            hijriDate: startDate,
            gregorianDate: start,
            hijriDate2: endDate,
            gregorianDate2: end));
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          this.selectedDay = selectedDay;
        });
        String formattedDate =
            DateFormat('dd-MM-yyyy', 'en').format(selectedDay);
        final hijriDate = AppUtils.datesMap[formattedDate];
        widget.onChange(DateSelect(
            hijriDate: hijriDate!['day'].toString(),
            gregorianDate: selectedDay));
      },
      weekNumbersVisible: false,
      calendarBuilders: CalendarBuilders(
        headerTitleBuilder: (context, day) {
          String formattedDate = DateFormat('dd-MM-yyyy', 'en').format(day);
          final hijriDate = AppUtils.datesMap[formattedDate];
          return Text(
              '${hijriDate?['month']} ${hijriDate?['day']?.split('-')[2]}');
        },

        withinRangeBuilder: (context, day, focusedDay) {
          String formattedDate = DateFormat('dd-MM-yyyy', 'en').format(day);
          final hijriDate = AppUtils.datesMap[formattedDate];
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: AppColors.checkbox),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Text(
                  //   '${day.day}',
                  //   style: const TextStyle(
                  //       fontSize: 16,
                  //       color: Colors.white,
                  //       fontWeight: FontWeight.bold),
                  // ),
                  if (hijriDate != null)
                    Text(
                      hijriDate['day']?.split('-')[0] ?? '',
                      style: const TextStyle(
                          fontSize: 16, color: Colors.amberAccent),
                    ),
                ],
              ),
            ),
          );
        },
        // rangeHighlightBuilder: (context, day, isWithinRange) => Container(
        //   decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(50),
        //       color: AppColors.BORDERGREYCOLOR),
        //   child: Center(
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         // Text(
        //         //   '${day.day}',
        //         //   style: const TextStyle(
        //         //       fontSize: 16,
        //         //       color: Colors.white,
        //         //       fontWeight: FontWeight.bold),
        //         // ),
        //         Text(
        //           AppUtils.datesMap[DateFormat('dd-MM-yyyy', 'en').format(day)]
        //                       ?['day']
        //                   ?.split('-')[0] ??
        //               '',
        //           style:
        //               const TextStyle(fontSize: 16, color: Colors.amberAccent),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        rangeEndBuilder: (context, day, focusedDay) {
          String formattedDate = DateFormat('dd-MM-yyyy', 'en').format(day);
          final hijriDate = AppUtils.datesMap[formattedDate];
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: AppColors.checkbox),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Text(
                  //   '${day.day}',
                  //   style: const TextStyle(
                  //       fontSize: 16,
                  //       color: Colors.white,
                  //       fontWeight: FontWeight.bold),
                  // ),
                  if (hijriDate != null)
                    Text(
                      hijriDate['day']?.split('-')[0] ?? '',
                      style: const TextStyle(
                          fontSize: 16, color: Colors.amberAccent),
                    ),
                ],
              ),
            ),
          );
        },
        rangeStartBuilder: (context, day, focusedDay) {
          String formattedDate = DateFormat('dd-MM-yyyy', 'en').format(day);
          final hijriDate = AppUtils.datesMap[formattedDate];
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: AppColors.checkbox),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Text(
                  //   '${day.day}',
                  //   style: const TextStyle(
                  //       fontSize: 16,
                  //       color: Colors.white,
                  //       fontWeight: FontWeight.bold),
                  // ),
                  if (hijriDate != null)
                    Text(
                      hijriDate['day']?.split('-')[0] ?? '',
                      style: const TextStyle(
                          fontSize: 16, color: Colors.amberAccent),
                    ),
                ],
              ),
            ),
          );
        },
        outsideBuilder: (context, day, focusedDay) {
          String formattedDate = DateFormat('dd-MM-yyyy', 'en').format(day);
          final hijriDate = AppUtils.datesMap[formattedDate];
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Text(
                //   '${day.day}',
                //   style: const TextStyle(
                //       fontSize: 12,
                //       fontWeight: FontWeight.bold,
                //       color: Colors.grey),
                // ),
                if (hijriDate != null)
                  Text(
                    hijriDate['day']?.split('-')[0] ?? '',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
              ],
            ),
          );
        },
        todayBuilder: (context, day, focusedDay) {
          String formattedDate = DateFormat('dd-MM-yyyy', 'en').format(day);
          final hijriDate = AppUtils.datesMap[formattedDate];

          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: AppColors.BORDERGREYCOLOR),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Text(
                  //   '${day.day}',
                  //   style: const TextStyle(
                  //       fontSize: 16,
                  //       color: Colors.white,
                  //       fontWeight: FontWeight.bold),
                  // ),
                  if (hijriDate != null)
                    Text(
                      hijriDate['day']?.split('-')[0] ?? '',
                      style: const TextStyle(
                          fontSize: 16, color: Colors.amberAccent),
                    ),
                ],
              ),
            ),
          );
        },
        selectedBuilder: (context, day, focusedDay) {
          String formattedDate = DateFormat('dd-MM-yyyy', 'en').format(day);
          final hijriDate = AppUtils.datesMap[formattedDate];
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: AppColors.checkbox),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Text(
                  //   '${day.day}',
                  //   style: const TextStyle(
                  //       fontSize: 16,
                  //       color: Colors.white,
                  //       fontWeight: FontWeight.bold),
                  // ),
                  if (hijriDate != null)
                    Text(
                      hijriDate['day']?.split('-')[0] ?? '',
                      style: const TextStyle(
                          fontSize: 16, color: Colors.amberAccent),
                    ),
                ],
              ),
            ),
          );
        },
        defaultBuilder: (context, date, events) {
          String formattedDate = DateFormat('dd-MM-yyyy', 'en').format(date);
          final hijriDate = AppUtils.datesMap[formattedDate];

          AppUtils.log(AppUtils.datesMap.length.toString());
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Text(
                //   '${date.day}',
                //   style: const TextStyle(
                //       fontSize: 16, fontWeight: FontWeight.bold),
                // ),
                if (hijriDate != null)
                  Text(
                    hijriDate['day']?.split('-')[0] ?? '',
                    style: const TextStyle(fontSize: 16, color: Colors.blue),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
