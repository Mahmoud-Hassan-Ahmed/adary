part of 'delay_task_bloc.dart';

sealed class DelayTaskEvent extends Equatable {
  const DelayTaskEvent();

  @override
  List<Object> get props => [];
}

final class GetTeacherEvent extends DelayTaskEvent {}

final class GetTasksEvent extends DelayTaskEvent {}

final class AddTaskTeacherEvtnt extends DelayTaskEvent {
  final BaseEnity baseEnity;

  const AddTaskTeacherEvtnt({required this.baseEnity});
}

final class UpdateTaskTeacherEvent extends DelayTaskEvent {
  final BaseEnity enity;

  UpdateTaskTeacherEvent({required this.enity});
}

final class RemoveTakTeaccherEvent extends DelayTaskEvent {
  final BaseEnity enity;

  RemoveTakTeaccherEvent({required this.enity});
}
