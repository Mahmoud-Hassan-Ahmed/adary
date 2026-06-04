import 'package:adary/features/adary/domain/entities/base_enity.dart';

class ChangeStatusEntity extends BaseEnity {
  final int id;
  final String status;

  ChangeStatusEntity({
    required this.id,
    required this.status,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
    };
  }
}
