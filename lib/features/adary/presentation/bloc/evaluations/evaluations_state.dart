part of 'evaluations_bloc.dart';

sealed class EvaluationsState extends Equatable {
  const EvaluationsState();
  static int num = 0;

  @override
  List<Object> get props => [num++];
}

final class EvaluationsInitial extends EvaluationsState {}

final class DoneUpdatePlanningEvaluationState extends EvaluationsState {}

final class DoneUpdateInteractionEvaluationState extends EvaluationsState {}

final class DoneUpdateManagementEvaluationState extends EvaluationsState {}

final class DoneUpdateImplementationEvaluationState extends EvaluationsState {}
