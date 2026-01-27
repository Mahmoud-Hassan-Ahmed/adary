part of 'circular_bloc.dart';

sealed class CircularState extends Equatable {
  const CircularState();

  @override
  List<Object> get props => [num++];
  static int num = 0;
}

final class CircularInitial extends CircularState {}

final class DoneAddCircularState extends CircularState {}

final class GetTeachersState extends CircularState {
  final List<Teacher> list;

  const GetTeachersState({required this.list});
}

final class SelectedTeachersState extends CircularState {
  final List<SelectModel> list;

  const SelectedTeachersState({required this.list});
}

final class SelectDateState extends CircularState {
  final String enity;

  const SelectDateState({required this.enity});
}

final class ChnageNotifyState extends CircularState {}

final class ChnageNotifyState3 extends CircularState {}

final class ChnageNotifyState2 extends CircularState {}

final class DoneUpdateCircularState extends CircularState {}

final class DoneDeleteCircularState extends CircularState {}

final class DoneGetAllCirularsState extends CircularState {
  final List<TeacherCircular> list;

  const DoneGetAllCirularsState({required this.list});
}

final class ExportCirculasPdfState extends CircularState {
  final FileDownloadEneity eneity;

  const ExportCirculasPdfState({required this.eneity});
}
