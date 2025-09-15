part of 'task_bloc.dart';

sealed class TaskState extends Equatable {
  const TaskState();
  static int sum = 0;
  @override
  List<Object> get props => [sum++];
}

final class TaskInitial extends TaskState {}

final class DoneAddTask extends TaskState {}

final class DoneDeletTask extends TaskState {}

final class DoneUpdateTask extends TaskState {}

final class GetTasksState extends TaskState {
  final List<TaskModel> task;

  GetTasksState({required this.task});
}
