part of 'duty_bloc.dart';

sealed class DutyState extends Equatable {
  const DutyState();
  static int sum = 0;

  /// نفس أسلوب بقية البلوكات هنا: كل حالة مميزة عن سابقتها حتى لا يبتلع
  /// `Equatable` إعادة بناء الشاشة عند تكرار نفس النتيجة.
  @override
  List<Object> get props => [sum++];
}

final class DutyInitial extends DutyState {}

final class DutyLoadingState extends DutyState {
  final int? teacherId;

  const DutyLoadingState({this.teacherId});
}

final class DutyFailureState extends DutyState {
  final int? teacherId;

  const DutyFailureState({this.teacherId});
}

final class GetDutyScheduleState extends DutyState {
  final DutyScheduleResponse data;
  final int? teacherId;

  const GetDutyScheduleState({required this.data, this.teacherId});
}
