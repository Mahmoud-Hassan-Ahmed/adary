import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/model/select_model.dart';
import 'package:adary/features/adary/data/models/class_health.dart';
import 'package:adary/features/adary/data/models/classes.dart';
import 'package:adary/features/adary/domain/entities/base_enity.dart';
import 'package:adary/features/adary/domain/entities/delete_entity.dart';
import 'package:adary/features/adary/domain/entities/file_download_entity.dart';
import 'package:adary/features/adary/domain/usecases/add_healths_use_case.dart';
import 'package:adary/features/adary/domain/usecases/delete_healths_use_case.dart';
import 'package:adary/features/adary/domain/usecases/export_healths_to_pdf_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_class_healths_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_classes_use_case.dart';
import 'package:adary/features/adary/domain/usecases/update_healths_use_case.dart';
import 'package:equatable/equatable.dart';

part 'health_event.dart';
part 'health_state.dart';

class HealthBloc extends BaseBloc<HealthEvent, HealthState> {
  final GetClassesUseCase getClassesUseCase;
  final GetClassHealthsUseCase getClassHealthsUseCase;
  final AddHealthsUseCase addHealthsUseCase;
  final UpdateHealthsUseCase updateHealthsUseCase;
  final DeleteHealthsUseCase deleteHealthsUseCase;
  final ExportHealthsToPdfUseCase exportHealthsToPdfUseCase;
  HealthBloc(
      {required this.getClassesUseCase,
      required this.addHealthsUseCase,
      required this.deleteHealthsUseCase,
      required this.getClassHealthsUseCase,
      required this.exportHealthsToPdfUseCase,
      required this.updateHealthsUseCase})
      : super(HealthInitial()) {
    on<HealthEvent>((event, emit) async {
      if (event is GetClassesEvent) {
        result = await getClassesUseCase();
        emitDone((value) => emit(DoneGetClassesstate(classes: value)));
      } else if (event is GetClassHealthsEvent) {
        result = await getClassHealthsUseCase();
        emitDone((value) => emit(DoneClassHealthstate(list: value)));
      } else if (event is AddHealthEvent) {
        result = await addHealthsUseCase(event.baseEnity);
        emitDone((value) => emit(DoneAddHealthState()));
      } else if (event is UpdateHealthEvent) {
        result = await updateHealthsUseCase(event.baseEnity);
        emitDone((value) => emit(DoneUpdateHealthState()));
      } else if (event is DeleteHealthEvent) {
        result = await deleteHealthsUseCase(event.baseEnity);
        emitDone((value) => emit(DoneDeleteHealthState()));
      } else if (event is ExportPfdEvent) {
        result = await exportHealthsToPdfUseCase(event.baseEnity);
        emitDone((value) => emit(ExportPfdState(baseEnity: event.baseEnity)));
      }
    });
  }
}
