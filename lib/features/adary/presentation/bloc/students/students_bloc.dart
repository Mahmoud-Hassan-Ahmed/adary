import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/features/adary/data/models/class_room.dart';
import 'package:adary/features/adary/data/models/classes.dart';
import 'package:adary/features/adary/domain/entities/base_enity.dart';
import 'package:adary/features/adary/domain/entities/delete_entity.dart';
import 'package:adary/features/adary/domain/usecases/add_class_use_case.dart';
import 'package:adary/features/adary/domain/usecases/delete_class_use_case.dart';
import 'package:adary/features/adary/domain/usecases/delete_student_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_class_room_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_classes_use_case.dart';
import 'package:adary/features/adary/domain/usecases/update_class_use_case.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'students_event.dart';
part 'students_state.dart';

class StudentsBloc extends BaseBloc<StudentsEvent, StudentsState> {
  final GetClassRoomUseCase getClassRoomUseCase;
  final AddClassUseCase addClassUseCase;
  final UpdateClassUseCase updateClassUseCase;
  final DeleteClassUseCase deleteClassUseCase;
  final GetClassesUseCase getClassesUseCase;
  final DeleteStudentUseCase deleteStudentUseCase;
  StudentsBloc(
      {required this.getClassRoomUseCase,
      required this.addClassUseCase,
      required this.deleteClassUseCase,
      required this.deleteStudentUseCase,
      required this.getClassesUseCase,
      required this.updateClassUseCase})
      : super(StudentsInitial()) {
    on<StudentsEvent>((event, emit) async {
      if (event is GetClassesRoomEvent) {
        result = await getClassRoomUseCase();
        emitDone((value) => emit(DoneGetClassRoomState(list: value)));
      } else if (event is AddClassEvent) {
        result = await addClassUseCase(event.entity);
        emitDone((value) => emit(DoneAddClassState()));
      } else if (event is UpdateClassEvent) {
        result = await updateClassUseCase(event.entity);
        emitDone((v) => emit(DoneUpdateClassState()));
      } else if (event is DeleteClassEvent) {
        result = await deleteClassUseCase(event.entity);
        emitDone((v) => emit(DoneDeleteClassState()));
      } else if (event is DeleteStudentEvent) {
        result = await deleteStudentUseCase(event.entity);
        emitDone((v) => emit(DoneDeleteStudentState()));
      } else if (event is GetClassEvent) {
        result = await getClassesUseCase();
        emitDone((value) => emit(DoneGetClasses(list: value)));
      }
    });
  }
}
