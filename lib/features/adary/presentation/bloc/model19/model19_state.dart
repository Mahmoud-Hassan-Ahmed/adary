part of 'model19_bloc.dart';

sealed class Model19State extends Equatable {
  const Model19State();
  static int num = 0;
  @override
  List<Object> get props => [num++];
}

final class Model19Initial extends Model19State {}

final class DelayInitial extends Model19State {}

final class DobeGetTechersState extends Model19State {
  final List<Teacher> lusl;

  const DobeGetTechersState({required this.lusl});
}

final class DoneChangeTechareState extends Model19State {
  final SelectModel value;

  const DoneChangeTechareState({required this.value});
}

final class SelectDayState extends Model19State {
  final SelectModel value;

  const SelectDayState({required this.value});
}

final class SelectTypeState extends Model19State {
  final SelectModel value;

  const SelectTypeState({required this.value});
}

final class SelectDateState extends Model19State {
  final String value;

  const SelectDateState({required this.value});
}

final class ChangeTime1State extends Model19State {
  final String value;

  const ChangeTime1State({required this.value});
}

final class ChangeTime2State extends Model19State {
  final String value;

  const ChangeTime2State({required this.value});
}

final class ChangeTime3State extends Model19State {
  final String value;

  const ChangeTime3State({required this.value});
}

final class ChangeTime4State extends Model19State {
  final String value;

  const ChangeTime4State({required this.value});
}

final class DownloadFileState extends Model19State {
  final FileDownloadEneity fileDownloadEneity;

  const DownloadFileState({required this.fileDownloadEneity});
}

final class DoneDeleteModel18 extends Model19State {}

final class UpdateModel18State extends Model19State {}

final class DoneAddModel18State extends Model19State {}

final class DoneAddModel19State extends Model19State {}

final class DoneUpdateModel19State extends Model19State {}

final class DoneDeleteModel19state extends Model19State {}
