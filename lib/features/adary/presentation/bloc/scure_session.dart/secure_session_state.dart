part of 'secure_session_bloc.dart';

sealed class SecureSessionState extends Equatable {
  const SecureSessionState();

  @override
  List<Object> get props => [];
}

final class SecureSessionInitial extends SecureSessionState {}

final class SecureSessionLoading extends SecureSessionState {}

final class SecureSessionDone extends SecureSessionState {
  final PageinationModel<LeaveRequestModel> requests;

  const SecureSessionDone({required this.requests});

  @override
  List<Object> get props => [requests];
}

final class ChangeStatusDone extends SecureSessionState {}
