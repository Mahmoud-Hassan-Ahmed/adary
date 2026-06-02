import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/model/select_model.dart';
import 'package:adary/features/adary/data/models/classes.dart';
import 'package:adary/features/adary/data/models/evaluation_model.dart';
import 'package:adary/features/adary/data/models/teacher_model.dart';
import 'package:adary/features/adary/domain/entities/base_enity.dart';
import 'package:adary/features/adary/domain/entities/delete_entity.dart';
import 'package:adary/features/adary/domain/entities/file_download_entity.dart';
import 'package:adary/features/adary/domain/usecases/add_visit_use_case.dart';
import 'package:adary/features/adary/domain/usecases/delete_student_use_case.dart';
import 'package:adary/features/adary/domain/usecases/delete_visit_use_case.dart';
import 'package:adary/features/adary/domain/usecases/export_visitis_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_classes_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_evaluation_by_visit.dart';
import 'package:adary/features/adary/domain/usecases/get_teachers_use_case.dart';
import 'package:adary/features/adary/domain/usecases/update_visit_use_case.dart';
import 'package:equatable/equatable.dart';

part 'class_visit_event.dart';
part 'class_visit_state.dart';

class ClassVisitBloc extends BaseBloc<ClassVisitEvent, ClassVisitState> {
  final GetClassesUseCase getClassesUseCase;
  final GetTeachersUseCase getTeachersUseCase;
  final AddVisitUseCase addVisitUseCase;
  final UpdateVisitUseCase updateVisitUseCase;
  final DeleteVisitUseCase deleteVisitUseCase;
  final ExportVisitisUseCase exportVisitisUseCase;
  final DeleteStudentUseCase deleteStudentUseCase;
  final GetEvaluationByVisit getEvaluationByVisit;

  ClassVisitBloc(
      {required this.getClassesUseCase,
      required this.getTeachersUseCase,
      required this.updateVisitUseCase,
      required this.deleteVisitUseCase,
      required this.exportVisitisUseCase,
      required this.deleteStudentUseCase,
      required this.getEvaluationByVisit,
      required this.addVisitUseCase})
      : super(ClassVisitInitial()) {
    on<ClassVisitEvent>((event, emit) async {
      if (event is GetClasses) {
        result = await getClassesUseCase();
        emitDone((value) => emit(DoneGetClassesState(list: value)));
      } else if (event is GetTeachersEvent) {
        result = await getTeachersUseCase();
        emitDone((value) => emit(DoneGetTeachersState(list: value)));
      } else if (event is AddClassVisitsEvent) {
        result = await addVisitUseCase(event.enity);
        emitDone((value) => emit(DoneAddVisitState()));
      } else if (event is UpdateVisitevent) {
        result = await updateVisitUseCase(event.enity);
        emitDone((value) => emit(DoneUpdateVisitState()));
      } else if (event is DeletVisitEvent) {
        result = await deleteVisitUseCase(event.enity);
        emitDone((value) => emit(DoneDeleteVisitState()));
      } else if (event is ExportVisitsEvent) {
        result = await exportVisitisUseCase(event.fileDownloadEneity);
        emitDone((value) => emit(
            ExportVisitsState(fileDownloadEneity: event.fileDownloadEneity)));
      } else if (event is DeleteStudentEvent) {
        result = await deleteStudentUseCase(event.entity);
        emitDone((v) => emit(DoneDeleteStudentState()));
      } else if (event is GetEvaluationByVisitEvent) {
        result = await getEvaluationByVisit(event.v);
        emitDone((v) => emit(DoneGetIdEvaluationState(visit: v)));
      }
    });
  }
}
