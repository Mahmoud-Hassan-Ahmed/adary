import 'package:adary/features/adary/domain/entities/base_enity.dart';

class WeekGroupModel extends BaseEnity {
  final String name;
  final int id;
  final bool isActive;
  final int weeksCount;
  final int plansNumber;

  WeekGroupModel({
    required this.name,
    required this.id,
    required this.isActive,
    required this.plansNumber,
    required this.weeksCount,
  });

  factory WeekGroupModel.fromJson(Map<String, dynamic> json) {
    return WeekGroupModel(
      name: json['name'] as String,
      id: json['id'] as int,
      plansNumber: json['plans_number'] as int,
      isActive: json['is_active'] as bool,
      weeksCount: json['weeks_count'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'is_active': isActive,
      'weeks_count': weeksCount,
    };
  }
}
