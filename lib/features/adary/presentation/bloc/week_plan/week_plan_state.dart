part of 'week_plan_bloc.dart';

sealed class WeekPlanState extends Equatable {
  const WeekPlanState();
  static int num = 0;
  @override
  List<Object> get props => [num++];
}

final class WeekPlanInitial extends WeekPlanState {}

final class DoneDeletePlanState extends WeekPlanState {}

final class SelectDateState1 extends WeekPlanState {
  final String value;

  const SelectDateState1({required this.value});
}

final class SelectDateState2 extends WeekPlanState {
  final String value;

  const SelectDateState2({required this.value});
}

final class SelectedTeachersState extends WeekPlanState {
  final SelectModel value;

  const SelectedTeachersState({required this.value});
}

final class DoneGetTeachers extends WeekPlanState {
  final List<Teacher> list;

  const DoneGetTeachers({
    required this.list,
  });
}
