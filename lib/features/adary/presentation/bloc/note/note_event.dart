part of 'note_bloc.dart';

sealed class NoteEvent extends Equatable {
  const NoteEvent();

  @override
  List<Object> get props => [];
}

final class AddNoteEvent extends NoteEvent {
  final BaseEnity enity;

  const AddNoteEvent({required this.enity});
}

final class UpdateNoteEvent extends NoteEvent {
  final BaseEnity entity;

  UpdateNoteEvent({required this.entity});
}

final class DeleteNoteEvent extends NoteEvent {
  final DeleteEntity entity;

  DeleteNoteEvent({required this.entity});
}
