import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/model/select_model.dart';
import 'package:adary/features/adary/data/models/teacher_model.dart';
import 'package:adary/features/adary/domain/entities/base_enity.dart';
import 'package:adary/features/adary/domain/entities/delay_entity.dart';
import 'package:adary/features/adary/domain/entities/delete_entity.dart';
import 'package:adary/features/adary/domain/entities/file_download_entity.dart';
import 'package:adary/features/adary/domain/usecases/create_model19_use_case.dart';
import 'package:adary/features/adary/domain/usecases/delete_model19_use_case.dart';
import 'package:adary/features/adary/domain/usecases/download_file_use_case.dart';
import 'package:adary/features/adary/domain/usecases/file_download_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_teachers_use_case.dart';
import 'package:adary/features/adary/domain/usecases/update_model19_use_case.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'model19_event.dart';
part 'model19_state.dart';

class Model19Bloc extends BaseBloc<Model19Event, Model19State> {
  final GetTeachersUseCase getTeachersUseCase;
  final CreateModel19UseCase createModel19UseCase;
  final UpdateModel19UseCase updateModel19UseCase;
  final DeleteModel19UseCase deleteModel19UseCase;
  final DownloadFileUseCase fileDownloadUseCase;
  Model19Bloc(
      {required this.getTeachersUseCase,
      required this.createModel19UseCase,
      required this.deleteModel19UseCase,
      required this.fileDownloadUseCase,
      required this.updateModel19UseCase})
      : super(Model19Initial()) {
    on<Model19Event>((event, emit) async {
      if (event is GetTeachersEvent) {
        result = await getTeachersUseCase();
        emitDone((value) => emit(DobeGetTechersState(lusl: value)));
      } else if (event is AddModel19event) {
        result = await createModel19UseCase(event.baseEnity);
        emitDone((value) => emit(DoneAddModel19State()));
      } else if (event is UpdaeModel19Event) {
        result = await updateModel19UseCase(event.model19);
        emitDone((value) => emit(DoneUpdateModel19State()));
      } else if (event is DeleteModel19Event) {
        result = await deleteModel19UseCase(event.entity);
        emitDone((value) => emit(DoneDeleteModel19state()));
      } else if (event is DownloadFileEvent) {
        result = await fileDownloadUseCase(event.baseEnity);
        emitDone((value) =>
            emit(DownloadFileState(fileDownloadEneity: event.baseEnity)));
      }
    });
  }
}
