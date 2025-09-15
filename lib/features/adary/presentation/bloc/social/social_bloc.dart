import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/model/select_model.dart';
import 'package:adary/features/adary/data/models/classes.dart';
import 'package:adary/features/adary/domain/entities/student_entity.dart';
import 'package:adary/features/adary/domain/usecases/create_student_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_classes_use_case.dart';
import 'package:adary/features/adary/domain/usecases/update_student_use_case.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/base_enity.dart';

part 'social_event.dart';
part 'social_state.dart';

class SocialBloc extends BaseBloc<SocialEvent, SocialState> {
  final GetClassesUseCase getClassesUseCase;
  final CreateStudentUseCase createStudentUseCase;
  final UpdateStudentUseCase updateStudentUseCase;
  SocialBloc(
      {required this.getClassesUseCase,
      required this.createStudentUseCase,
      required this.updateStudentUseCase})
      : super(SocialInitial()) {
    on<SocialEvent>((event, emit) async {
      if (event is GetClasses) {
        result = await getClassesUseCase();
        emitDone((value) => emit(DoneGetClassesState(list: value)));
      } else if (event is ChangeClass) {
        emit(ChangeClassState(selectModel: event.selectModel));
      } else if (event is ChangeRealtion) {
        emit(ChangeRealtionState(selectModel: event.selectModel));
      } else if (event is CreatestudentEvent) {
        result = await createStudentUseCase(event.entity);
        emitDone((value) => emit(DoneCreateStudentState()));
      } else if (event is UpdatestudentEvent) {
        result = await updateStudentUseCase(event.entity);
        emitDone((value) => emit(DoneUpdateStudentState()));
      }
    });
  }
}
