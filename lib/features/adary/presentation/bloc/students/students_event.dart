part of 'students_bloc.dart';

sealed class StudentsEvent extends Equatable {
  const StudentsEvent();

  @override
  List<Object> get props => [];
}

final class GetClassesRoomEvent extends StudentsEvent {}

final class DeleteStudentEvent extends StudentsEvent {
  final DeleteEntity entity;

  const DeleteStudentEvent({required this.entity});
}

final class DeleteClassEvent extends StudentsEvent {
  final DeleteEntity entity;

  const DeleteClassEvent({required this.entity});
}

final class UpdateClassEvent extends StudentsEvent {
  final BaseEnity entity;

  const UpdateClassEvent({required this.entity});
}

final class AddClassEvent extends StudentsEvent {
  final BaseEnity entity;

  const AddClassEvent({required this.entity});
}

final class GetClassEvent extends StudentsEvent {}
