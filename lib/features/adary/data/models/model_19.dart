import 'package:adary/features/adary/data/models/teacher_model.dart';

class Model19Model {
  final int id;
  final Teacher teacher;
  final int? schoolId;
  final String? name;
  final double exitTime;
  final int numDays;

  Model19Model({
    required this.id,
    required this.teacher,
    this.schoolId,
    this.name,
    required this.exitTime,
    required this.numDays,
  });

  factory Model19Model.fromJson(Map<String, dynamic> json) {
    return Model19Model(
      id: json['id'],
      teacher: Teacher.fromJson(json['teacher']),
      schoolId: json['school'],
      name: json['name'],
      exitTime: json['exit_time'].toDouble(),
      numDays: json['num_days'],
    );
  }
}
