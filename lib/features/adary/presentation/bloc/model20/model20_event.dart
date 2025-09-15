part of 'model20_bloc.dart';

sealed class Model20Event extends Equatable {
  const Model20Event();

  @override
  List<Object> get props => [];
}

final class GetTeachersEvent extends Model20Event {}

final class DownloadFileEvent extends Model20Event {
  final FileDownloadEneity baseEnity;

  const DownloadFileEvent({required this.baseEnity});
}

final class AddModel20Event extends Model20Event {
  final BaseEnity enity;

  const AddModel20Event({required this.enity});
}

final class UpdateMode20Event extends Model20Event {
  final Model20 model20;

  const UpdateMode20Event({required this.model20});
}

final class DeleteModel20Event extends Model20Event {
  final DeleteEntity entity;

  const DeleteModel20Event({required this.entity});
}
