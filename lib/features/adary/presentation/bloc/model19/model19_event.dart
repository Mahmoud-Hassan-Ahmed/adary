part of 'model19_bloc.dart';

sealed class Model19Event extends Equatable {
  const Model19Event();

  @override
  List<Object> get props => [];
}

final class GetTeachersEvent extends Model19Event {}

final class DownloadFileEvent extends Model19Event {
  final FileDownloadEneity baseEnity;

  const DownloadFileEvent({required this.baseEnity});
}

final class AddModel19event extends Model19Event {
  final BaseEnity baseEnity;

  const AddModel19event({required this.baseEnity});
}

final class UpdaeModel19Event extends Model19Event {
  final Model19 model19;

  const UpdaeModel19Event({required this.model19});
}

final class DeleteModel19Event extends Model19Event {
  final DeleteEntity entity;

  const DeleteModel19Event({required this.entity});
}
