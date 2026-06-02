import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/model/select_model.dart';
import 'package:adary/features/adary/data/models/evidence_model.dart';
import 'package:adary/features/adary/data/models/pagination_model.dart';
import 'package:adary/features/adary/data/models/teacher_model.dart';
import 'package:adary/features/adary/domain/entities/evidence_entity.dart';
import 'package:adary/features/adary/domain/usecases/create_category_evi_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_evidences_caregories.dart';
import 'package:adary/features/adary/domain/usecases/get_evidences_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_teachers_use_case.dart';
import 'package:adary/features/adary/domain/usecases/rate_file_use_case.dart';
import 'package:adary/features/adary/presentation/pages/rate_file.dart';
import 'package:equatable/equatable.dart';

part 'evidence_event.dart';
part 'evidence_state.dart';

class EvidenceBloc extends BaseBloc<EvidenceEvent, EvidenceState> {
  final GetEvidencesUseCase getEvidencesUseCase;
  final GetEvidencesCaregories getEvidencesCaregories;
  final GetTeachersUseCase getTechersUseCase;
  final CreateCategoryEvidenceUseCase createCategoryEvidenceUseCase;
  final RateFileUseCase rateFileUseCase;
  EvidenceBloc(
      {required this.getEvidencesUseCase,
      required this.getEvidencesCaregories,
      required this.getTechersUseCase,
      required this.rateFileUseCase,
      required this.createCategoryEvidenceUseCase})
      : super(EvidenceInitial()) {
    on<EvidenceEvent>((event, emit) async {
      if (event is GetTeachersEvent) {
        result = await getTechersUseCase();
        emitDone((value) {
          emit(DoneGetTeachersState(model: value));
        });
      } else if (event is GetEvidencesCaregoriesEvent) {
        result = await getEvidencesCaregories();
        emitDone((value) {
          emit(DoneGetEvidencesCaregoriesState(model: value));
        });
      } else if (event is GetEvidencesEvent) {
        result = await getEvidencesUseCase(event.entity);
        emitDone((value) {
          emit(DoneGetEvidencesState(model: value));
        });
      } else if (event is AddCategoryEveidenceEvent) {
        result = await createCategoryEvidenceUseCase(event.entity);
        emitDone((value) {
          emit(const DoneAddCategoryEveidenceState());
        });
      } else if (event is RateFileEvent) {
        result = await rateFileUseCase(event.entity);
        emitDone((value) {
          emit(const DoneRateFileState());
        });
      }
    });
  }
}
