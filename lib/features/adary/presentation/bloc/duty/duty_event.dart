part of 'duty_bloc.dart';

sealed class DutyEvent extends Equatable {
  const DutyEvent();

  @override
  List<Object> get props => [];
}

/// `teacherId` فارغ = كل المعلمين.
final class GetDutyScheduleEvent extends DutyEvent {
  final int? teacherId;

  const GetDutyScheduleEvent({this.teacherId});
}
