import 'package:adary/core/model/select_model.dart';

/// المناوبة والإشراف — نماذج القراءة فقط لاستجابة
/// `pro/pro_duty_roster/api/teachers-schedule/`.

/// معلم في قائمة الفلتر. `id` معرّف المعلم نفسه لا معرّف صف المنسوب،
/// لأنه ما يُرسل في `?teacher_id=`.
class DutyTeacherOption extends SelectModel {
  DutyTeacherOption({required super.id, required super.name});

  factory DutyTeacherOption.fromJson(Map<String, dynamic> json) =>
      DutyTeacherOption(id: json['id'], name: json['name'] ?? '');
}

/// تكليف واحد: مناوبة أو إشراف، بوقته وموقعه.
class DutyItem {
  final String name;
  final String icon;

  /// `duty` مناوبة أو `supervision` إشراف — الفئتان توزَّعان بشكل مستقل.
  final String category;
  final String categoryLabel;

  /// فترة المناوبة (بداية/نهاية الدوام) أو نوع الإشراف (فسحة/صلاة...)، قد تكون فارغة.
  final String subtypeLabel;
  final String startTime;
  final String endTime;
  final List<String> locations;

  DutyItem({
    required this.name,
    required this.icon,
    required this.category,
    required this.categoryLabel,
    required this.subtypeLabel,
    required this.startTime,
    required this.endTime,
    required this.locations,
  });

  bool get isSupervision => category == 'supervision';

  String get locationsLabel => locations.join('، ');

  /// "مناوبة — بداية الدوام"، وهو ما يُطبع في النموذج الرسمي.
  String get fullLabel =>
      subtypeLabel.isEmpty ? categoryLabel : '$categoryLabel — $subtypeLabel';

  factory DutyItem.fromJson(Map<String, dynamic> json) => DutyItem(
        name: json['duty_name'] ?? '',
        icon: json['duty_icon'] ?? '',
        category: json['category'] ?? '',
        categoryLabel: json['category_label'] ?? '',
        subtypeLabel: json['subtype_label'] ?? '',
        startTime: json['start_time'] ?? '',
        endTime: json['end_time'] ?? '',
        locations: List<String>.from(json['locations'] ?? const []),
      );
}

/// يوم واحد من جدول المعلم. `date` فارغ في القالب الأسبوعي المتكرر،
/// ومُعبَّأ في الخطة الشهرية.
class DutyDay {
  final int weekday;
  final String weekdayLabel;
  final String? date;
  final List<DutyItem> duties;

  DutyDay({
    required this.weekday,
    required this.weekdayLabel,
    required this.date,
    required this.duties,
  });

  factory DutyDay.fromJson(Map<String, dynamic> json) => DutyDay(
        weekday: json['weekday'] ?? 0,
        weekdayLabel: json['weekday_label'] ?? '',
        date: json['date'],
        duties: List<Map<String, dynamic>>.from(json['duties'] ?? const [])
            .map(DutyItem.fromJson)
            .toList(),
      );
}

/// جدول معلم واحد.
class DutyTeacherSchedule {
  final int staffId;
  final int teacherId;
  final String name;
  final String stageLabel;
  final int dutyCount;
  final List<DutyDay> days;

  DutyTeacherSchedule({
    required this.staffId,
    required this.teacherId,
    required this.name,
    required this.stageLabel,
    required this.dutyCount,
    required this.days,
  });

  factory DutyTeacherSchedule.fromJson(Map<String, dynamic> json) =>
      DutyTeacherSchedule(
        staffId: json['staff_id'] ?? 0,
        teacherId: json['teacher_id'] ?? 0,
        name: json['name'] ?? '',
        stageLabel: json['stage_label'] ?? '',
        dutyCount: json['duty_count'] ?? 0,
        days: List<Map<String, dynamic>>.from(json['days'] ?? const [])
            .map(DutyDay.fromJson)
            .toList(),
      );
}

/// الجدول المعتمد الذي تُقرأ منه هذه الشاشة.
class DutyPlanInfo {
  final String title;
  final String periodLabel;
  final String hijriLabel;

  DutyPlanInfo({
    required this.title,
    required this.periodLabel,
    required this.hijriLabel,
  });

  factory DutyPlanInfo.fromJson(Map<String, dynamic> json) => DutyPlanInfo(
        title: json['title'] ?? '',
        periodLabel: json['period_label'] ?? '',
        hijriLabel: json['hijri_label'] ?? '',
      );
}

class DutyScheduleResponse {
  final DutyPlanInfo? plan;

  /// خيارات الفلتر كاملة — لا تتأثر باختيار معلم بعينه.
  final List<DutyTeacherOption> teachers;
  final List<DutyTeacherSchedule> results;

  DutyScheduleResponse({
    required this.plan,
    required this.teachers,
    required this.results,
  });

  factory DutyScheduleResponse.fromJson(Map<String, dynamic> json) =>
      DutyScheduleResponse(
        plan: json['plan'] == null ? null : DutyPlanInfo.fromJson(json['plan']),
        teachers:
            List<Map<String, dynamic>>.from(json['teachers'] ?? const [])
                .map(DutyTeacherOption.fromJson)
                .toList(),
        results: List<Map<String, dynamic>>.from(json['results'] ?? const [])
            .map(DutyTeacherSchedule.fromJson)
            .toList(),
      );
}
