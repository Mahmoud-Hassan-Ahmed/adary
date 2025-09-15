class WeeklyPan {
  final int id;
  final int weekNumber;
  final String weekNumberText;
  final int weeklyPlansCount;

  WeeklyPan({
    required this.id,
    required this.weekNumber,
    required this.weekNumberText,
    required this.weeklyPlansCount,
  });

  factory WeeklyPan.fromJson(Map<String, dynamic> json) {
    return WeeklyPan(
      id: json['id'],
      weekNumber: json['week_number'],
      weekNumberText: json['week_number_text'],
      weeklyPlansCount: json['weekly_plans_count'],
    );
  }
}
