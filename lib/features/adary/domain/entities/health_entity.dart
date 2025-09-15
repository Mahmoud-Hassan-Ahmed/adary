import 'package:adary/features/adary/domain/entities/base_enity.dart';

class HealthEntity extends BaseEnity {
  final int? id;
  final String nameStudent;
  final int classNameId;
  final String name;
  final String? recommendations;
  final String dealingWithSituation;
  final bool notifyTeacher;

  HealthEntity({
    this.id,
    required this.nameStudent,
    required this.classNameId,
    required this.name,
    required this.notifyTeacher,
    this.recommendations,
    required this.dealingWithSituation,
  });

  // Method to convert HealthEntity instance to JSON
  @override
  Map<String, dynamic> toJson() {
    return {
      'name_student': nameStudent,
      'class_name_id': classNameId,
      'name': name,
      'notify_teacher': notifyTeacher,
      'recommendations': recommendations,
      'dealing_with_situation': dealingWithSituation,
    };
  }
}
