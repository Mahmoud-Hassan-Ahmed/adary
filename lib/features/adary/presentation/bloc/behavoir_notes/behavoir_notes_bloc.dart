import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/model/select_model.dart';
import 'package:adary/features/adary/data/models/attendance_statistics_model.dart';
import 'package:adary/features/adary/data/models/behavior_statistics_model.dart';
import 'package:adary/features/adary/data/models/student_per.dart';
import 'package:adary/features/adary/domain/entities/base_enity.dart';
import 'package:adary/features/adary/domain/usecases/add_note_behavoir_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_attendence_statistics_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_behavoir_static_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_list_behavoir_notes.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'behavoir_notes_event.dart';
part 'behavoir_notes_state.dart';

class BehavoirNotesBloc
    extends BaseBloc<BehavoirNotesEvent, BehavoirNotesState> {
  final GetListBehavoirNotes getListBehavoirNotes;
  final GetAttendenceStatisticsUseCase getAttendenceStatisticsUseCase;
  final GetBehavoirStaticUseCase getBehavoirStaticUseCase;
  final AddNoteBehavoirUseCase addNoteBehavoirUseCase;
  BehavoirNotesBloc({
    required this.getListBehavoirNotes,
    required this.getAttendenceStatisticsUseCase,
    required this.getBehavoirStaticUseCase,
    required this.addNoteBehavoirUseCase,
  }) : super(BehavoirNotesInitial()) {
    on<BehavoirNotesEvent>((event, emit) async {
      if (event is GetAllNotes) {
        result = await getListBehavoirNotes();
        emitDone((value) {
          emit(DoneGetNotes(notes: value));
        });
      }
      if (event is GetAttendanceStatisticsEvent) {
        result = await getAttendenceStatisticsUseCase();
        emitDone((value) {
          emit(DoneGetAttendanceStatistics(statistics: value));
        });
      }
      if (event is AddNoteEvent) {
        result = await addNoteBehavoirUseCase(event.baseEnity);
        emitDone((_) => emit(DoneAddNote()));
      }
      if (event is GetBehaviorStatisticsEvent) {
        result = await getBehavoirStaticUseCase();
        emitDone((value) {
          emit(DoneGetBehaviorStatistics(statistics: value));
        });
      }
    });
  }
}
