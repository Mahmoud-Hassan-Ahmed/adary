part of 'week_plan_bloc.dart';

sealed class WeekPlanEvent extends Equatable {
  const WeekPlanEvent();

  @override
  List<Object> get props => [];
}

final class DeleteWeekPlanEvent extends WeekPlanEvent {
  final DeleteEntity entity;

  const DeleteWeekPlanEvent({required this.entity});
}

final class GetTechersEvent extends WeekPlanEvent {}

final class GetWeeksGroupEvent extends WeekPlanEvent {}

final class AddWeekGroupEvent extends WeekPlanEvent {
  final BaseEnity entity;

  const AddWeekGroupEvent({required this.entity});
}

final class UpdateWeekGroupEvent extends WeekPlanEvent {
  final BaseEnity entity;

  const UpdateWeekGroupEvent({required this.entity});
}

final class DeleteWeekGroupEvent extends WeekPlanEvent {
  final int id;

  const DeleteWeekGroupEvent({required this.id});
}
