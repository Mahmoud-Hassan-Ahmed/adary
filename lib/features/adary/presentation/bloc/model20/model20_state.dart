part of 'model20_bloc.dart';

sealed class Model20State extends Equatable {
  const Model20State();
  static int num = 0;
  @override
  List<Object> get props => [num++];
}

final class Model20Initial extends Model20State {}

final class Model19Initial extends Model20State {}

final class DelayInitial extends Model20State {}

final class DobeGetTechersState extends Model20State {
  final List<Teacher> lusl;

  const DobeGetTechersState({required this.lusl});
}

final class DoneChangeTechareState extends Model20State {
  final SelectModel value;

  const DoneChangeTechareState({required this.value});
}

final class SelectDayState extends Model20State {
  final SelectModel value;

  const SelectDayState({required this.value});
}

final class SelectDayState2 extends Model20State {
  final SelectModel value;

  const SelectDayState2({required this.value});
}

final class SelectTypeState extends Model20State {
  final SelectModel value;

  const SelectTypeState({required this.value});
}

final class SelectDateState extends Model20State {
  final String value;

  const SelectDateState({required this.value});
}

final class SelectDateState2 extends Model20State {
  final String value;

  const SelectDateState2({required this.value});
}

final class ChangeTime1State extends Model20State {
  final String value;

  const ChangeTime1State({required this.value});
}

final class ChangeTime2State extends Model20State {
  final String value;

  const ChangeTime2State({required this.value});
}

final class ChangeTime3State extends Model20State {
  final String value;

  const ChangeTime3State({required this.value});
}

final class ChangeTime4State extends Model20State {
  final String value;

  const ChangeTime4State({required this.value});
}

final class DownloadFileState extends Model20State {
  final FileDownloadEneity fileDownloadEneity;

  const DownloadFileState({required this.fileDownloadEneity});
}

final class DoneDeleteModel20 extends Model20State {}

final class UpdateModel20State extends Model20State {}

final class DoneAddModel20State extends Model20State {}
