part of 'note_bloc.dart';

sealed class NoteState extends Equatable {
  const NoteState();
  static int num = 0;

  @override
  List<Object> get props => [num++];
}

final class NoteInitial extends NoteState {}

final class DoneAddNoteState extends NoteState {}

final class SelectTypeNote extends NoteState {
  final SelectModel selectModel;

  const SelectTypeNote({required this.selectModel});
}

final class ActiveWhasappState extends NoteState {
  final int switchValue;

  const ActiveWhasappState({required this.switchValue});
}

final class ActiveSmsState extends NoteState {
  final int switchValue;

  const ActiveSmsState({required this.switchValue});
}

final class ActiveSessionState extends NoteState {
  final int switchValue;

  const ActiveSessionState({required this.switchValue});
}

final class ActiveNotificationsState extends NoteState {
  final int switchValue;

  const ActiveNotificationsState({required this.switchValue});
}

final class DoneUpdateNoteState extends NoteState {}

final class DoneDeleteNoteState extends NoteState {}
