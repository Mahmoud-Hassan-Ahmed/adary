part of 'perseverance_bloc.dart';

sealed class PerseveranceState extends Equatable {
  const PerseveranceState();
  static int num = 0;
  @override
  List<Object> get props => [num++];
}

final class PerseveranceInitial extends PerseveranceState {}

final class DoneGetClassesstate extends PerseveranceState {
  final List<Classes> classes;

  const DoneGetClassesstate({required this.classes});
}

final class ChangeClassState extends PerseveranceState {
  final SelectModel selectModel;
  final int index;

  const ChangeClassState({required this.selectModel, required this.index});
}

final class SelectDateState extends PerseveranceState {
  final String enity;

  const SelectDateState({required this.enity});
}
