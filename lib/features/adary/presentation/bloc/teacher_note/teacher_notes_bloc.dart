import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/model/select_model.dart';
import 'package:adary/features/adary/data/models/note_entity_model.dart';
import 'package:adary/features/adary/data/models/teacher_model.dart';
import 'package:adary/features/adary/domain/entities/base_enity.dart';
import 'package:adary/features/adary/domain/entities/delete_entity.dart';
import 'package:adary/features/adary/domain/entities/pagination_entity.dart';
import 'package:adary/features/adary/domain/entities/teachers_entity.dart';
import 'package:adary/features/adary/domain/usecases/create_note_teachers_use_case.dart';
import 'package:adary/features/adary/domain/usecases/delete_note_teacher_use_case.dart';
import 'package:adary/features/adary/domain/usecases/download_teacher_note_pdf_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_notes_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_teachers_use_case.dart';
import 'package:adary/features/adary/domain/usecases/update_note_teacher_use_case.dart';
import 'package:equatable/equatable.dart';

part 'teacher_notes_event.dart';
part 'teacher_notes_state.dart';

class TeacherNotesBloc extends BaseBloc<TeacherNotesEvent, TeacherNotesState> {
  final GetNotesUseCase getNotesUseCase;
  final GetTeachersUseCase teachersUseCase;
  final CreateNoteTeachersUseCase createNoteTeachersUseCase;
  final UpdateNoteTeacherUseCase updateNoteTeacherUseCase;
  final DeleteNoteTeacherUseCase deleteNoteTeacherUseCase;
  final DownloadTeacherNotePdfUseCase downloadTeacherNotePdfUseCase;
  TeacherNotesBloc(
      {required this.getNotesUseCase,
      required this.teachersUseCase,
      required this.createNoteTeachersUseCase,
      required this.deleteNoteTeacherUseCase,
      required this.downloadTeacherNotePdfUseCase,
      required this.updateNoteTeacherUseCase})
      : super(TeacherNotesInitial()) {
    on<TeacherNotesEvent>((event, emit) async {
      if (event is GetNotesEvent) {
        result = await getNotesUseCase();
        emitDone((value) => emit(DoneGetNotesState(notes: value)));
      } else if (event is SelectRadioBtnEvent) {
        emit(DoneSelectRadioBtnEvent(groupValue: event.groupValue));
      } else if (event is SelectDateEvent) {
        emit(DoneDateState(value: event.value));
      } else if (event is GetTeachersEvent) {
        result = await teachersUseCase();
        emitDone((value) => emit(DoneGetDataTeachersState(list: value)));
      } else if (event is CreateTeacherNoteEvent) {
        result = await createNoteTeachersUseCase(event.enity);
        emitDone((value) => emit(DoneCreateNoteTeachers()));
      } else if (event is ChangeSessionEvent) {
        emit(ChangeSessionState(enity: event.enity));
      } else if (event is UpdateNoteTeacherEvent) {
        result = await updateNoteTeacherUseCase(event.baseEnity);
        emitDone((value) => emit(DoneUpdateNoteTeacher()));
      } else if (event is DeleteTeacherNoteEvent) {
        result = await deleteNoteTeacherUseCase(event.entity);
        emitDone((value) => emit(DoneDeleteNoteTeacherState()));
      } else if (event is DownloadTeacherPdfEvent) {
        result = await downloadTeacherNotePdfUseCase(event.paginationEntity);
        emitDone((value) =>
            emit(DoneDownloadTeacherState(entity: event.paginationEntity)));
      }
    });
  }
}
