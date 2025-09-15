import 'dart:convert';

import 'package:adary/features/adary/data/models/teacher_model.dart';

class WeekPlan {
  final int weekNumber;
  final List<Plan> plans;

  WeekPlan({required this.weekNumber, required this.plans});

  factory WeekPlan.fromJson(Map<String, dynamic> json) {
    var plansList = json['plans'] as List;
    List<Plan> plans = plansList.map((i) => Plan.fromJson(i)).toList();

    return WeekPlan(
      weekNumber: json['week_number'],
      plans: plans,
    );
  }
}

class Plan {
  final int id;
  final String file;
  final DateTime createdAt;
  final Teacher teacher;

  Plan({
    required this.id,
    required this.file,
    required this.createdAt,
    required this.teacher,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['id'],
      file: json['file'],
      createdAt: DateTime.parse(json['created_at']),
      teacher: Teacher.fromJson(json['teacher']),
    );
  }
}
