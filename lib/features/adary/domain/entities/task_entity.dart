import 'package:adary/features/adary/domain/entities/base_enity.dart';

class TaskEntity extends BaseEnity {
  final int? id;

  final String name;

  TaskEntity({required this.name, this.id});

  @override
  Map<String, dynamic> toJson() {
    return {"name": name};
  }
}
