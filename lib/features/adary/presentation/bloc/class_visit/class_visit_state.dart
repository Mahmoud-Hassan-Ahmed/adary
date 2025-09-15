part of 'class_visit_bloc.dart';

sealed class ClassVisitState extends Equatable {
  const ClassVisitState();
  static int num = 0;
  @override
  List<Object> get props => [num++];
}

final class ClassVisitInitial extends ClassVisitState {}

final class DoneGetClassesState extends ClassVisitState {
  final List<Classes> list;

  const DoneGetClassesState({required this.list});
}

final class SelectedTeachersState extends ClassVisitState {
  final SelectModel teacher;

  const SelectedTeachersState({required this.teacher});
}

final class ExportVisitsState extends ClassVisitState {
  final FileDownloadEneity fileDownloadEneity;

  const ExportVisitsState({required this.fileDownloadEneity});
}

final class DoneGetTeachersState extends ClassVisitState {
  final List<Teacher> list;

  const DoneGetTeachersState({required this.list});
}

final class ChangeClassState extends ClassVisitState {
  final SelectModel selectModel;

  const ChangeClassState({required this.selectModel});
}

final class ChangeSession extends ClassVisitState {
  final SelectModel selectModel;

  const ChangeSession({required this.selectModel});
}

final class SelectDateState extends ClassVisitState {
  final String entity;

  const SelectDateState({required this.entity});
}

final class DoneAddVisitState extends ClassVisitState {}

final class DoneDeleteStudentState extends ClassVisitState {}

final class ChnageNotifyState extends ClassVisitState {}

final class DoneUpdateVisitState extends ClassVisitState {}

final class DoneDeleteVisitState extends ClassVisitState {}
