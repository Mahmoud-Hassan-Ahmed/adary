part of 'social_bloc.dart';

sealed class SocialEvent extends Equatable {
  const SocialEvent();

  @override
  List<Object> get props => [];
}

final class GetClasses extends SocialEvent {}

final class ChangeClass extends SocialEvent {
  final SelectModel selectModel;

  const ChangeClass({required this.selectModel});
}

final class ChangeRealtion extends SocialEvent {
  final SelectModel selectModel;

  const ChangeRealtion({required this.selectModel});
}

final class UpdatestudentEvent extends SocialEvent {
  final BaseEnity entity;

  const UpdatestudentEvent({required this.entity});
}

final class CreatestudentEvent extends SocialEvent {
  final StudentEntity entity;

  const CreatestudentEvent({required this.entity});
}
