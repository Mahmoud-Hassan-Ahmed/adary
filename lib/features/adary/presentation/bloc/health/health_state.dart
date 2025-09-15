part of 'health_bloc.dart';

sealed class HealthState extends Equatable {
  const HealthState();
  static int num = 0;
  @override
  List<Object> get props => [num++];
}

final class HealthInitial extends HealthState {}

final class ChangeClassState extends HealthState {
  final SelectModel selectModel;

  const ChangeClassState({required this.selectModel});
}

final class DoneGetClassesstate extends HealthState {
  final List<Classes> classes;

  const DoneGetClassesstate({required this.classes});
}

final class DoneClassHealthstate extends HealthState {
  final List<ClassHealth> list;

  const DoneClassHealthstate({required this.list});
}

final class DoneAddHealthState extends HealthState {}

final class ChnageNotifyState extends HealthState {}

final class DoneUpdateHealthState extends HealthState {}

final class DoneDeleteHealthState extends HealthState {}

final class ExportPfdState extends HealthState {
  final FileDownloadEneity baseEnity;

  const ExportPfdState({required this.baseEnity});
}
