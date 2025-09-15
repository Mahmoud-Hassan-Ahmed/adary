import 'package:adary/core/model/select_model.dart';

class Teacher extends SelectModel {
  final int id;
  final String name;

  Teacher({
    required this.id,
    required this.name,
  }) : super(id: id, name: name);

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'],
      name: json['name'],
    );
  }
}
