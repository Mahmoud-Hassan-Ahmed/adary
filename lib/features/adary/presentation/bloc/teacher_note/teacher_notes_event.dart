part of 'teacher_notes_bloc.dart';

sealed class TeacherNotesEvent extends Equatable {
  const TeacherNotesEvent();

  @override
  List<Object> get props => [];
}

final class GetNotesEvent extends TeacherNotesEvent {}

final class SelectRadioBtnEvent extends TeacherNotesEvent {
  final int groupValue;

  const SelectRadioBtnEvent({required this.groupValue});
}

final class SelectDateEvent extends TeacherNotesEvent {
  final String? value;

  const SelectDateEvent({required this.value});
}

final class GetTeachersEvent extends TeacherNotesEvent {}

final class CreateTeacherNoteEvent extends TeacherNotesEvent {
  final TeachersEntity enity;

  const CreateTeacherNoteEvent({required this.enity});
}

final class ChangeSessionEvent extends TeacherNotesEvent {
  final SelectModel enity;

  const ChangeSessionEvent({required this.enity});
}

final class UpdateNoteTeacherEvent extends TeacherNotesEvent {
  final BaseEnity baseEnity;

  const UpdateNoteTeacherEvent({required this.baseEnity});
}

final class DeleteTeacherNoteEvent extends TeacherNotesEvent {
  final DeleteEntity entity;

  const DeleteTeacherNoteEvent({required this.entity});
}

final class DownloadTeacherPdfEvent extends TeacherNotesEvent {
  final PaginationEntity paginationEntity;

  const DownloadTeacherPdfEvent({required this.paginationEntity});
}
