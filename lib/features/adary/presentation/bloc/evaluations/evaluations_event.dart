part of 'evaluations_bloc.dart';

sealed class EvaluationsEvent extends Equatable {
  const EvaluationsEvent();
  static int num = 0;
  @override
  List<Object> get props => [num++];
}

final class UpdatePlanningEvaluationEvent extends EvaluationsEvent {
  final Planning planning;
  const UpdatePlanningEvaluationEvent({required this.planning});
}

final class UpdateInteractionEvaluationEvent extends EvaluationsEvent {
  final Interaction interaction;
  const UpdateInteractionEvaluationEvent({required this.interaction});
}

final class UpdateManagementEvaluationEvent extends EvaluationsEvent {
  final Managment managment;
  const UpdateManagementEvaluationEvent({required this.managment});
}

final class UpdateImplementationEvaluationEvent extends EvaluationsEvent {
  final Implementation implementation;
  const UpdateImplementationEvaluationEvent({required this.implementation});
}
