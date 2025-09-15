import 'package:adary/features/adary/domain/entities/base_enity.dart';

class LoginEntity extends BaseEnity {
  final String username;
  final String password;

  LoginEntity({required this.username, required this.password});
  @override
  Map<String, dynamic> toJson() => {"username": username, "app-key": password};
}
