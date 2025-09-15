part of 'delay_task_bloc.dart';

sealed class DelayTaskState extends Equatable {
  const DelayTaskState();
  static int sum = 0;
  @override
  List<Object> get props => [sum++];
}

final class DelayTaskInitial extends DelayTaskState {}

final class DobneAddTaskTeacherState extends DelayTaskState {}

final class DobneRemoveTaskTeacherState extends DelayTaskState {}

final class DobneUpdateTaskTeacherState extends DelayTaskState {}

final class DoneGetTeacherState extends DelayTaskState {
  final List<Teacher> list;

  const DoneGetTeacherState({required this.list});
}

final class DoneGetTasksState extends DelayTaskState {
  final List<TaskModel> list;

  const DoneGetTasksState({required this.list});
}

final class SelectTaskState extends DelayTaskState {
  final SelectModel selectModel;

  SelectTaskState({required this.selectModel});
}

final class SelectRepeatState extends DelayTaskState {
  final SelectModel selectModel;

  SelectRepeatState({required this.selectModel});
}

final class SelectTeacherState extends DelayTaskState {
  final List<SelectModel> selectModel;

  const SelectTeacherState({required this.selectModel});
}

final class SelectDateState extends DelayTaskState {
  final String value;

  const SelectDateState({required this.value});
}

final class SelectDate2State extends DelayTaskState {
  final String value;

  const SelectDate2State({required this.value});
}

final class ChangeTime1State extends DelayTaskState {
  final String value;

  ChangeTime1State({required this.value});
}

final class ChangeTime2State extends DelayTaskState {
  final String value;

  ChangeTime2State({required this.value});
}
