part of 'class_visit_bloc.dart';

sealed class ClassVisitEvent extends Equatable {
  const ClassVisitEvent();

  @override
  List<Object> get props => [];
}

final class GetClasses extends ClassVisitEvent {}

final class GetTeachersEvent extends ClassVisitEvent {}

final class AddClassVisitsEvent extends ClassVisitEvent {
  final BaseEnity enity;

  const AddClassVisitsEvent({required this.enity});
}

final class UpdateVisitevent extends ClassVisitEvent {
  final BaseEnity enity;

  const UpdateVisitevent({required this.enity});
}

final class DeleteStudentEvent extends ClassVisitEvent {
  final DeleteEntity entity;

  const DeleteStudentEvent({required this.entity});
}

final class DeletVisitEvent extends ClassVisitEvent {
  final BaseEnity enity;

  const DeletVisitEvent({required this.enity});
}

final class GetEvaluationByVisitEvent extends ClassVisitEvent {
  final int v;

  const GetEvaluationByVisitEvent({required this.v});
}

final class ExportVisitsEvent extends ClassVisitEvent {
  final FileDownloadEneity fileDownloadEneity;

  const ExportVisitsEvent({required this.fileDownloadEneity});
}
