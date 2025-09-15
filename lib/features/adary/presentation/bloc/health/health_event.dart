part of 'health_bloc.dart';

sealed class HealthEvent extends Equatable {
  const HealthEvent();

  @override
  List<Object> get props => [];
}

final class GetClassesEvent extends HealthEvent {}

final class GetClassHealthsEvent extends HealthEvent {}

final class UpdateHealthEvent extends HealthEvent {
  final BaseEnity baseEnity;

  const UpdateHealthEvent({required this.baseEnity});
}

final class DeleteHealthEvent extends HealthEvent {
  final DeleteEntity baseEnity;

  const DeleteHealthEvent({required this.baseEnity});
}

final class AddHealthEvent extends HealthEvent {
  final BaseEnity baseEnity;

  const AddHealthEvent({required this.baseEnity});
}

final class ExportPfdEvent extends HealthEvent {
  final FileDownloadEneity baseEnity;

  const ExportPfdEvent({required this.baseEnity});
}
