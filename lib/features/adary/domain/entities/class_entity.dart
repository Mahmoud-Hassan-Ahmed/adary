import 'package:adary/features/adary/domain/entities/base_enity.dart';

class ClassEntity extends BaseEnity {
  final int? id;
  final String name;

  ClassEntity({this.id, required this.name});

  @override
  Map<String, dynamic> toJson() => {'name': name};
}
