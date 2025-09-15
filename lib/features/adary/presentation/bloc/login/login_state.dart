part of 'login_bloc.dart';

sealed class LoginState extends Equatable {
  const LoginState();
  static int num = 0;
  @override
  List<Object> get props => [num++];
}

final class LoginInitial extends LoginState {}

final class DoneLoginState extends LoginState {}
