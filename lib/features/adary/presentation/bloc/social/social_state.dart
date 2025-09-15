part of 'social_bloc.dart';

sealed class SocialState extends Equatable {
  const SocialState();
  static int num = 0;
  @override
  List<Object> get props => [num++];
}

final class SocialInitial extends SocialState {}

final class DoneGetClassesState extends SocialState {
  final List<Classes> list;

  const DoneGetClassesState({required this.list});
}

final class DoneUpdateStudentState extends SocialState {}

final class ChangeClassState extends SocialState {
  final SelectModel selectModel;

  const ChangeClassState({required this.selectModel});
}

final class ChangeRealtionState extends SocialState {
  final SelectModel selectModel;

  const ChangeRealtionState({required this.selectModel});
}

final class DoneCreateStudentState extends SocialState {}

final class ChangeGroupState extends SocialState {
  final int value;

  const ChangeGroupState({required this.value});
}

final class ChangeGroupState2 extends SocialState {
  final int value;

  const ChangeGroupState2({required this.value});
}

final class ChnageNotifyState extends SocialState {}
