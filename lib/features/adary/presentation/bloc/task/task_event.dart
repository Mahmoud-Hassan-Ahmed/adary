part of 'task_bloc.dart';

sealed class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

final class AddTaskEvent extends TaskEvent {
  final BaseEnity entity;

  const AddTaskEvent({required this.entity});
}

final class GetTasksEvent extends TaskEvent {}

final class UpdateTask extends TaskEvent {
  final BaseEnity entity;

  const UpdateTask({required this.entity});
}

final class DeletTask extends TaskEvent {
  final BaseEnity entity;

  const DeletTask({required this.entity});
}
