part of 'behavoir_notes_bloc.dart';

sealed class BehavoirNotesEvent extends Equatable {
  const BehavoirNotesEvent();

  @override
  List<Object> get props => [];
}

final class GetAllNotes extends BehavoirNotesEvent {}

final class AddNoteEvent extends BehavoirNotesEvent {
  final BaseEnity baseEnity;

  AddNoteEvent({required this.baseEnity});
}

final class GetBehaviorStatisticsEvent extends BehavoirNotesEvent {}

final class GetAttendanceStatisticsEvent extends BehavoirNotesEvent {}
