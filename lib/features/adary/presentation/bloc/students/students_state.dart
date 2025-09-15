part of 'students_bloc.dart';

sealed class StudentsState extends Equatable {
  const StudentsState();
  static int num = 0;
  @override
  List<Object> get props => [num++];
}

final class StudentsInitial extends StudentsState {}

final class DoneGetClassRoomState extends StudentsState {
  final List<Classroom> list;

  const DoneGetClassRoomState({required this.list});
}

final class DoneUpdateClassState extends StudentsState {}

final class DoneDeleteClassState extends StudentsState {}

final class DoneDeleteStudentState extends StudentsState {}

final class DoneAddClassState extends StudentsState {}

final class DoneGetClasses extends StudentsState {
  final List<Classes> list;

  const DoneGetClasses({required this.list});
}
