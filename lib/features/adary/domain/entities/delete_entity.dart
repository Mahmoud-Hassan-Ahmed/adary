import 'package:adary/features/adary/domain/entities/base_enity.dart';

class DeleteEntity extends BaseEnity {
  final int id;

  DeleteEntity({required this.id});

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
