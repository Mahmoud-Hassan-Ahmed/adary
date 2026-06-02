import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/model/select_model.dart';
import 'package:adary/features/adary/data/models/classes.dart';
import 'package:adary/features/adary/domain/entities/filter_report_entity.dart';
import 'package:adary/features/adary/domain/usecases/download_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_classes_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_students_use_case.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'perseverance_event.dart';
part 'perseverance_state.dart';

class PerseveranceBloc extends BaseBloc<PerseveranceEvent, PerseveranceState> {
  final GetClassesUseCase getClassesUseCase;
  final GetStudentsUseCase getStudentsUseCase;
  final DownloadUseCase downloadUseCase;

  PerseveranceBloc(
      {required this.getClassesUseCase,
      required this.getStudentsUseCase,
      required this.downloadUseCase})
      : super(PerseveranceInitial()) {
    on<PerseveranceEvent>((event, emit) async {
      if (event is GetClassesEvent) {
        result = await getClassesUseCase();
        emitDone((value) => emit(DoneGetClassesstate(classes: value)));
      } else if (event is DownloadReportEvent) {
        await downloadUseCase(event.entity);
      }
      // TODO: implement event handler
    });
  }
}
