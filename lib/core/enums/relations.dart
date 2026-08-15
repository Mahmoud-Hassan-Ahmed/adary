import 'package:adary/core/model/select_model.dart';

class Relations extends SelectModel {
  final String value;
  Relations({required super.id, required super.name, required this.value});
}

List<SelectModel> relationList = [
  Relations(id: 0, name: 'الآباء', value: 'p'),
  Relations(id: 2, name: 'الأم', value: 'm'),
  Relations(id: 3, name: 'الأب', value: 'f'),
  Relations(id: 4, name: 'الأجداد', value: 'g'),
  Relations(id: 5, name: 'آخرين', value: 'o'),
];

List<SelectModel> typNoties = [
  Relations(id: 0, name: 'إيجابي', value: 'p'),
  Relations(id: 1, name: 'يحتاج إلى تحسين', value: 'n'),
];

List<SelectModel> sessions = [
  Relations(id: 0, name: 'الأولى', value: '1'),
  Relations(id: 1, name: 'الثانية', value: '2'),
  Relations(id: 2, name: 'الثالثة', value: '3'),
  Relations(id: 3, name: 'الرابعة', value: '4'),
  Relations(id: 4, name: 'الخامسة', value: '5'),
  Relations(id: 5, name: 'السابعة', value: '6'),
];

List<SelectModel> days = [
  Relations(id: 0, name: 'السبت', value: 'saturday'),
  Relations(id: 1, name: 'الاحد', value: 'sunday'),
  Relations(id: 2, name: 'الإثنين', value: 'monday'),
  Relations(id: 3, name: 'الثلاثاء', value: 'tuesday'),
  Relations(id: 4, name: 'الأربعاء', value: 'wednesday'),
  Relations(id: 5, name: 'الخميس', value: 'thursday'),
  Relations(id: 6, name: 'الجمعة', value: 'friday'),
];

/// يرجّع اليوم من `days` المقابل لتاريخ ميلادي.
/// `DateTime.weekday` يبدأ من الإثنين = 1 وينتهي بالأحد = 7.
SelectModel dayFromDate(DateTime date) {
  const weekdayToValue = {
    DateTime.saturday: 'saturday',
    DateTime.sunday: 'sunday',
    DateTime.monday: 'monday',
    DateTime.tuesday: 'tuesday',
    DateTime.wednesday: 'wednesday',
    DateTime.thursday: 'thursday',
    DateTime.friday: 'friday',
  };
  return days.firstWhere(
      (d) => (d as Relations).value == weekdayToValue[date.weekday]);
}

List<SelectModel> typeDelays = [
  Relations(id: 0, name: 'الحضور متأخرا', value: '1'),
  Relations(id: 1, name: 'عدم التواجد أثناء العمل', value: '2'),
  Relations(id: 2, name: 'مغادره مبكرا', value: '3'),
];

List<SelectModel> repeats = [
  Relations(id: 0, name: 'لا يوجد تكرار', value: '0'),
  Relations(id: 1, name: 'يومي', value: '1'),
  Relations(id: 2, name: 'اسبوعي', value: '2'),
];
