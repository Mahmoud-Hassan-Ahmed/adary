part of 'secure_session_bloc.dart';

sealed class SecureSessionEvent extends Equatable {
  const SecureSessionEvent();

  @override
  List<Object> get props => [];
}

final class GetRequestsEvent extends SecureSessionEvent {
  final BaseEnity status;

  const GetRequestsEvent({required this.status});

  @override
  List<Object> get props => [status];
}

final class ChangeStatusEvent extends SecureSessionEvent {
  final ChangeStatusEntity entity;

  const ChangeStatusEvent({required this.entity});

  @override
  List<Object> get props => [entity];
}
