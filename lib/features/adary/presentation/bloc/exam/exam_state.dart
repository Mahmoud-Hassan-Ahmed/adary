part of 'exam_bloc.dart';

sealed class ExamState extends Equatable {
  const ExamState();
  static int num = 0;
  @override
  List<Object> get props => [num++];
}

final class ExamInitial extends ExamState {}

final class SelectDateTypeState extends ExamState {
  final int index;

  SelectDateTypeState({required this.index});
}

final class SelectDateStateValue extends ExamState {
  final String value;
  final DateTime value2;
  final int index;

  SelectDateStateValue(
      {required this.value, required this.value2, required this.index});
}

final class DoneAddExamState extends ExamState {}
