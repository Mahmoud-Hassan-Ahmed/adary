import 'package:adary/features/adary/data/models/teacher_model.dart';

class Model20Model {
  final int id;
  final Teacher? teacher;
  final String? name;
  final String atDay;
  final String atDayDate;
  final String toDay;
  final String toDayDate;

  // Constructor
  Model20Model({
    required this.id,
    this.teacher,
    this.name,
    required this.atDay,
    required this.atDayDate,
    required this.toDay,
    required this.toDayDate,
  });

  // Factory constructor to create a Model20 from JSON
  factory Model20Model.fromJson(Map<String, dynamic> json) {
    return Model20Model(
      id: json['id'],
      teacher: json['teacher'] != null
          ? Teacher.fromJson(json['teacher'])
          : Teacher(id: 37, name: 'temps'),
      name: json['name'],
      atDay: json['at_day'],
      atDayDate: json['at_day_date'],
      toDay: json['to_day'],
      toDayDate: json['to_day_date'],
    );
  }
}
