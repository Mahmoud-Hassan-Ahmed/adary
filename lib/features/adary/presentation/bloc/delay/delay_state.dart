part of 'delay_bloc.dart';

sealed class DelayState extends Equatable {
  const DelayState();
  static int sum = 0;
  @override
  List<Object> get props => [sum++];
}

final class DelayInitial extends DelayState {}

final class DobeGetTechersState extends DelayState {
  final List<Teacher> lusl;

  const DobeGetTechersState({required this.lusl});
}

final class DoneChangeTechareState extends DelayState {
  final SelectModel value;

  const DoneChangeTechareState({required this.value});
}

final class SelectDayState extends DelayState {
  final SelectModel value;

  const SelectDayState({required this.value});
}

final class SelectTypeState extends DelayState {
  final SelectModel value;

  const SelectTypeState({required this.value});
}

final class SelectDateState extends DelayState {
  final String value;

  const SelectDateState({required this.value});
}

final class ChangeTime1State extends DelayState {
  final String value;

  const ChangeTime1State({required this.value});
}

final class ChangeTime2State extends DelayState {
  final String value;

  const ChangeTime2State({required this.value});
}

final class ChangeTime3State extends DelayState {
  final String value;

  const ChangeTime3State({required this.value});
}

final class ChangeTime4State extends DelayState {
  final String value;

  const ChangeTime4State({required this.value});
}

final class DownloadFileState extends DelayState {
  final FileDownloadEneity fileDownloadEneity;

  const DownloadFileState({required this.fileDownloadEneity});
}

final class DoneDeleteModel18 extends DelayState {}

final class UpdateModel18State extends DelayState {}

final class DoneAddModel18State extends DelayState {}
