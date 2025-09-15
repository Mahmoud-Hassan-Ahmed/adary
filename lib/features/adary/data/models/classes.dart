import 'package:adary/core/model/select_model.dart';

class Classes extends SelectModel {
  Classes({required super.id, required super.name});
  factory Classes.fromJson(Map<String, dynamic> json) =>
      Classes(id: json['id'], name: json['name']);
}
