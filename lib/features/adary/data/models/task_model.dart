import 'package:adary/core/model/select_model.dart';
import 'package:adary/features/table/data/model/response/table_model.dart';

class TaskModel implements SelectModel {
  final String name;
  final int id;
  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      TaskModel(name: json['name'], id: json['id']);

  TaskModel({required this.name, required this.id});
}
