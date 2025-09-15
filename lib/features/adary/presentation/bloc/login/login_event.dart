part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

final class LoginUserEvent extends LoginEvent {
  final LoginEntity entity;

  const LoginUserEvent({required this.entity});
}
