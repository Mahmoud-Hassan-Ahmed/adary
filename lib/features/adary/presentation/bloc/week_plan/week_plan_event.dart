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
