import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/model/select_model.dart';
import 'package:adary/features/adary/data/models/teacher_circular.dart';
import 'package:adary/features/adary/data/models/teacher_model.dart';
import 'package:adary/features/adary/domain/entities/base_enity.dart';
import 'package:adary/features/adary/domain/entities/delete_entity.dart';
import 'package:adary/features/adary/domain/entities/file_download_entity.dart';
import 'package:adary/features/adary/domain/entities/pagination_entity.dart';
import 'package:adary/features/adary/domain/usecases/add_circular_use_case.dart';
import 'package:adary/features/adary/domain/usecases/delete_circular_use_case.dart';
import 'package:adary/features/adary/domain/usecases/export_circulars_pdf_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_all_teachers_circular_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_teachers_use_case.dart';
import 'package:adary/features/adary/domain/usecases/update_circular_use_case.dart';
import 'package:equatable/equatable.dart';

part 'circular_event.dart';
part 'circular_state.dart';

class CircularBloc extends BaseBloc<CircularEvent, CircularState> {
  final GetTeachersUseCase getTeachersUseCase;
  final AddCircularUseCase addCircularUseCase;
  final UpdateCircularUseCase updateCircularUseCase;
  final DeleteCircularUseCase deleteCircularUseCase;
  final ExportCircularsPdfUseCase exportCircularsPdfUseCase;
  final GetAllTeachersCircularUseCase getAllTeachersCircularUseCase;
  CircularBloc(
      {required this.getTeachersUseCase,
      required this.addCircularUseCase,
      required this.updateCircularUseCase,
      required this.deleteCircularUseCase,
      required this.exportCircularsPdfUseCase,
      required this.getAllTeachersCircularUseCase})
      : super(CircularInitial()) {
    on<CircularEvent>((event, emit) async {
      if (event is GetTeachersEvent) {
        result = await getTeachersUseCase();
        emitDone((value) => {emit(GetTeachersState(list: value))});
      } else if (event is SelectedTeachersEvent) {
        emit(SelectedTeachersState(list: event.list));
      } else if (event is AddCircularEvent) {
        result = await addCircularUseCase(event.enity);
        emitDone((value) => emit(DoneAddCircularState()));
      } else if (event is SelectDateEvent) {
        emit(SelectDateState(enity: event.enity));
      } else if (event is ChnageNotifyEvent) {
        emit(ChnageNotifyState());
      } else if (event is UpdateCircularEvent) {
        result = await updateCircularUseCase(event.entity);
        emitDone((value) => emit(DoneUpdateCircularState()));
      } else if (event is DeleteCircularEvent) {
        result = await deleteCircularUseCase(event.entity);
        emitDone((value) => emit(DoneDeleteCircularState()));
      } else if (event is GetAllCircularTeacherEvent) {
        result = await getAllTeachersCircularUseCase(event.entity);
        emitDone((value) => emit(DoneGetAllCirularsState(list: value)));
      } else if (event is ExportCirculasPdfEvent) {
        result = await exportCircularsPdfUseCase(event.eneity);
        emitDone((value) => emit(ExportCirculasPdfState(eneity: event.eneity)));
      }
    });
  }
}
