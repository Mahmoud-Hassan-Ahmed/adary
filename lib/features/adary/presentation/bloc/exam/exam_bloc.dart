import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/features/adary/domain/entities/base_enity.dart';
import 'package:adary/features/adary/domain/usecases/add_exam_use_case.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'exam_event.dart';
part 'exam_state.dart';

class ExamBloc extends BaseBloc<ExamEvent, ExamState> {
  final AddExamUseCase addExamUseCase;
  ExamBloc({required this.addExamUseCase}) : super(ExamInitial()) {
    on<ExamEvent>((event, emit) async {
      if (event is AddExamEvent) {
        result = await addExamUseCase(event.baseEnity);
        emitDone((value) {
          emit(DoneAddExamState());
        });
      }
    });
  }
}
