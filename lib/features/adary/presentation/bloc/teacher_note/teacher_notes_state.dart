part of 'teacher_notes_bloc.dart';

sealed class TeacherNotesState extends Equatable {
  const TeacherNotesState();
  static int num = 0;
  @override
  List<Object> get props => [num++];
}

final class TeacherNotesInitial extends TeacherNotesState {}

final class DoneGetNotesState extends TeacherNotesState {
  final List<NoteModel> notes;

  const DoneGetNotesState({required this.notes});
}

final class DoneSelectRadioBtnEvent extends TeacherNotesState {
  final int groupValue;

  const DoneSelectRadioBtnEvent({required this.groupValue});
}

final class DoneDateState extends TeacherNotesState {
  final String? value;

  const DoneDateState({required this.value});
}

final class DoneGetDataTeachersState extends TeacherNotesState {
  final List<Teacher> list;

  const DoneGetDataTeachersState({required this.list});
}

final class DoneCreateNoteTeachers extends TeacherNotesState {}

final class ChangeSessionState extends TeacherNotesState {
  final SelectModel enity;

  const ChangeSessionState({required this.enity});
}

final class DoneUpdateNoteTeacher extends TeacherNotesState {}

final class DoneDeleteNoteTeacherState extends TeacherNotesState {}

final class DoneDownloadTeacherState extends TeacherNotesState {
  final PaginationEntity entity;

  const DoneDownloadTeacherState({required this.entity});
}
