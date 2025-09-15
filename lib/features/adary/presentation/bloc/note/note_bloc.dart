import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/model/select_model.dart';
import 'package:adary/features/adary/domain/entities/base_enity.dart';
import 'package:adary/features/adary/domain/entities/delete_entity.dart';
import 'package:adary/features/adary/domain/usecases/add_note_use_case.dart';
import 'package:adary/features/adary/domain/usecases/delete_note_use_case.dart';
import 'package:adary/features/adary/domain/usecases/update_note_use_case.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends BaseBloc<NoteEvent, NoteState> {
  final AddNoteUseCase addNoteUseCase;
  final UpdateNoteUseCase updateNoteUseCase;
  final DeleteNoteUseCase deleteNoteUseCase;
  NoteBloc(
      {required this.addNoteUseCase,
      required this.deleteNoteUseCase,
      required this.updateNoteUseCase})
      : super(NoteInitial()) {
    on<NoteEvent>((event, emit) async {
      if (event is AddNoteEvent) {
        result = await addNoteUseCase(event.enity);
        emitDone((value) => emit(DoneAddNoteState()));
      } else if (event is UpdateNoteEvent) {
        result = await updateNoteUseCase(event.entity);
        emitDone((value) => emit(DoneUpdateNoteState()));
      } else if (event is DeleteNoteEvent) {
        result = await deleteNoteUseCase(event.entity);
        emitDone((value) => emit(DoneDeleteNoteState()));
      }
    });
  }
}
