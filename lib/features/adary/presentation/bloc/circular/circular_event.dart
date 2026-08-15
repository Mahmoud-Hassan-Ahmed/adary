part of 'circular_bloc.dart';

sealed class CircularEvent extends Equatable {
  const CircularEvent();

  @override
  List<Object> get props => [];
}

final class GetTeachersEvent extends CircularEvent {}

final class SelectedTeachersEvent extends CircularEvent {
  final List<SelectModel> list;

  const SelectedTeachersEvent({required this.list});
}

final class AddCircularEvent extends CircularEvent {
  final BaseEnity enity;

  const AddCircularEvent({required this.enity});
}

final class SelectDateEvent extends CircularEvent {
  final String enity;

  const SelectDateEvent({required this.enity});
}

/// إشعار المعلمين عن طريق التطبيق (send_notif)
final class ChnageNotifyEvent extends CircularEvent {}

/// جميع المعلمين (select_all)
final class ChnageNotifyEvent2 extends CircularEvent {}

/// إرسال رسالة نصية SMS (send_sms)
final class ChnageNotifyEvent3 extends CircularEvent {}

/// إشعار المعلمين عن طريق الواتس اب (whatsapp_notif)
final class ChnageNotifyEvent4 extends CircularEvent {}

final class UpdateCircularEvent extends CircularEvent {
  final BaseEnity entity;

  const UpdateCircularEvent({required this.entity});
}

final class DeleteCircularEvent extends CircularEvent {
  final DeleteEntity entity;

  const DeleteCircularEvent({required this.entity});
}

final class GetAllCircularTeacherEvent extends CircularEvent {
  final PaginationEntity entity;

  GetAllCircularTeacherEvent({required this.entity});
}

final class ExportCirculasPdfEvent extends CircularEvent {
  final FileDownloadEneity eneity;

  ExportCirculasPdfEvent({required this.eneity});
}
