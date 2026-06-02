part of 'perseverance_bloc.dart';

sealed class PerseveranceEvent extends Equatable {
  const PerseveranceEvent();

  @override
  List<Object> get props => [];
}

final class GetClassesEvent extends PerseveranceEvent {}

final class GetStudentEvent extends PerseveranceEvent {
  final int classId;

  GetStudentEvent({required this.classId});
}

final class DownloadReportEvent extends PerseveranceEvent {
  final FilterReportEntity entity;

  DownloadReportEvent({required this.entity});
}
