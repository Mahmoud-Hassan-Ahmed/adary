import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/model/select_model.dart';
import 'package:adary/features/adary/data/models/teacher_model.dart';
import 'package:adary/features/adary/domain/entities/base_enity.dart';
import 'package:adary/features/adary/domain/entities/delay_entity.dart';
import 'package:adary/features/adary/domain/entities/delete_entity.dart';
import 'package:adary/features/adary/domain/entities/file_download_entity.dart';
import 'package:adary/features/adary/domain/usecases/create_model20_use_case.dart';
import 'package:adary/features/adary/domain/usecases/delete_model20_use_case.dart';
import 'package:adary/features/adary/domain/usecases/download_file_20_use_case%20.dart';
import 'package:adary/features/adary/domain/usecases/get_teachers_use_case.dart';
import 'package:adary/features/adary/domain/usecases/updat_model20_use_case.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'model20_event.dart';
part 'model20_state.dart';

class Model20Bloc extends BaseBloc<Model20Event, Model20State> {
  final GetTeachersUseCase getTeachersUseCase;
  final CreateModel20UseCase createModel20UseCase;
  final UpdatModel20UseCase updatModel20UseCase;
  final DeleteModel20UseCase deleteModel20UseCase;
  final DownloadFile20UseCase downloadFile20UseCase;
  Model20Bloc(
      {required this.getTeachersUseCase,
      required this.createModel20UseCase,
      required this.deleteModel20UseCase,
      required this.downloadFile20UseCase,
      required this.updatModel20UseCase})
      : super(Model20Initial()) {
    on<Model20Event>((event, emit) async {
      if (event is GetTeachersEvent) {
        result = await getTeachersUseCase();
        emitDone((value) => emit(DobeGetTechersState(lusl: value)));
      } else if (event is AddModel20Event) {
        result = await createModel20UseCase(event.enity);
        emitDone((value) => emit(DoneAddModel20State()));
      } else if (event is DeleteModel20Event) {
        result = await deleteModel20UseCase(event.entity);
        emitDone((value) => emit(DoneDeleteModel20()));
      } else if (event is UpdateMode20Event) {
        result = await updatModel20UseCase(event.model20);
        emitDone((value) => emit(UpdateModel20State()));
      } else if (event is DownloadFileEvent) {
        result = await downloadFile20UseCase(event.baseEnity);
        emitDone((value) =>
            emit(DownloadFileState(fileDownloadEneity: event.baseEnity)));
      }
    });
  }
}
