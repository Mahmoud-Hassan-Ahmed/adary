part of 'behavoir_notes_bloc.dart';

sealed class BehavoirNotesState extends Equatable {
  const BehavoirNotesState();
  static int num = 0;
  @override
  List<Object> get props => [num++];
}

final class BehavoirNotesInitial extends BehavoirNotesState {}

final class DoneGetNotes extends BehavoirNotesState {
  final List<BehaviorNote> notes;

  DoneGetNotes({required this.notes});
}

final class SelectTypeState extends BehavoirNotesState {
  final SelectModel value;
  final int index;

  SelectTypeState({required this.value, required this.index});
}

final class DoneAddNote extends BehavoirNotesState {}

final class DoneGetBehaviorStatistics extends BehavoirNotesState {
  final List<BehaviorStatisticsModel> statistics;

  DoneGetBehaviorStatistics({required this.statistics});
}

final class DoneGetAttendanceStatistics extends BehavoirNotesState {
  final AttendanceStatisticsModel statistics;

  DoneGetAttendanceStatistics({required this.statistics});
}
