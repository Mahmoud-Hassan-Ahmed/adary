part of 'delay_bloc.dart';

sealed class DelayEvent extends Equatable {
  const DelayEvent();

  @override
  List<Object> get props => [];
}

final class GetTeachersEvent extends DelayEvent {}

final class DownloadFileEvent extends DelayEvent {
  final FileDownloadEneity baseEnity;

  const DownloadFileEvent({required this.baseEnity});
}

final class DeleteModel18event extends DelayEvent {
  final DeleteEntity entity;

  const DeleteModel18event({required this.entity});
}

final class UpdateModel18Event extends DelayEvent {
  final Model18 model18;

  const UpdateModel18Event({required this.model18});
}

final class AddModel18Event extends DelayEvent {
  final Model18 model18;

  const AddModel18Event({required this.model18});
}
