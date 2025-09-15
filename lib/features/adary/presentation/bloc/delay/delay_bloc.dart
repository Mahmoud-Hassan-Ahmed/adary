import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/model/select_model.dart';
import 'package:adary/features/adary/data/models/teacher_model.dart';
import 'package:adary/features/adary/domain/entities/delay_entity.dart';
import 'package:adary/features/adary/domain/entities/delete_entity.dart';
import 'package:adary/features/adary/domain/entities/file_download_entity.dart';
import 'package:adary/features/adary/domain/usecases/create_model18_use_case.dart';
import 'package:adary/features/adary/domain/usecases/delete_model18_use_case.dart';
import 'package:adary/features/adary/domain/usecases/file_download_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_teachers_use_case.dart';
import 'package:adary/features/adary/domain/usecases/updat_model18_use_case.dart';
import 'package:equatable/equatable.dart';

part 'delay_event.dart';
part 'delay_state.dart';

class DelayBloc extends BaseBloc<DelayEvent, DelayState> {
  final GetTeachersUseCase getTeachersUseCase;
  final DeleteModel18UseCase deleteModel18UseCase;
  final UpdatModel18UseCase updatModel18UseCase;
  final FileDownloadUseCase fileDownloadUseCase;
  final CreateModel18UseCase createModel18UseCase;
  DelayBloc(
      {required this.getTeachersUseCase,
      required this.fileDownloadUseCase,
      required this.deleteModel18UseCase,
      required this.createModel18UseCase,
      required this.updatModel18UseCase})
      : super(DelayInitial()) {
    on<DelayEvent>((event, emit) async {
      if (event is GetTeachersEvent) {
        result = await getTeachersUseCase();
        emitDone((value) => emit(DobeGetTechersState(lusl: value)));
      } else if (event is DownloadFileEvent) {
        result = await fileDownloadUseCase(event.baseEnity);
        emitDone((value) =>
            emit(DownloadFileState(fileDownloadEneity: event.baseEnity)));
      } else if (event is DeleteModel18event) {
        result = await deleteModel18UseCase(event.entity);
        emitDone((value) => emit(DoneDeleteModel18()));
      } else if (event is UpdateModel18Event) {
        result = await updatModel18UseCase(event.model18);
        emitDone((value) => emit(UpdateModel18State()));
      } else if (event is AddModel18Event) {
        result = await createModel18UseCase(event.model18);
        emitDone((value) => emit(DoneAddModel18State()));
      }
    });
  }
}
