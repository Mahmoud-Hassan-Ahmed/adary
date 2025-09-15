import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/model/select_model.dart';
import 'package:adary/features/adary/data/models/task_model.dart';
import 'package:adary/features/adary/data/models/teacher_model.dart';
import 'package:adary/features/adary/domain/entities/base_enity.dart';
import 'package:adary/features/adary/domain/usecases/create_task_teacher.dart';
import 'package:adary/features/adary/domain/usecases/get_tasks_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_teachers_use_case.dart';
import 'package:adary/features/adary/domain/usecases/remove_task_teacher_use_case.dart';
import 'package:adary/features/adary/domain/usecases/update_task_teacher.dart';
import 'package:equatable/equatable.dart';

part 'delay_task_event.dart';
part 'delay_task_state.dart';

class DelayTaskBloc extends BaseBloc<DelayTaskEvent, DelayTaskState> {
  final GetTasksUseCase getTasksUseCase;
  final GetTeachersUseCase getTeachersUseCase;
  final CreateTaskTeacher createTaskTeacher;
  final UpdateTaskTeacher updateTaskTeacher;
  final RemoveTaskTeacherUseCase removeTaskTeacherUseCase;
  DelayTaskBloc(
      {required this.getTasksUseCase,
      required this.getTeachersUseCase,
      required this.createTaskTeacher,
      required this.removeTaskTeacherUseCase,
      required this.updateTaskTeacher})
      : super(DelayTaskInitial()) {
    on<DelayTaskEvent>((event, emit) async {
      if (event is GetTasksEvent) {
        result = await getTasksUseCase();
        emitDone((value) => emit(DoneGetTasksState(list: value)));
      } else if (event is GetTeacherEvent) {
        result = await getTeachersUseCase();
        emitDone((value) => emit(DoneGetTeacherState(list: value)));
      } else if (event is RemoveTakTeaccherEvent) {
        result = await removeTaskTeacherUseCase(event.enity);
        emitDone((value) => emit(DobneRemoveTaskTeacherState()));
      } else if (event is AddTaskTeacherEvtnt) {
        result = await createTaskTeacher(event.baseEnity);
        emitDone((value) => emit(DobneAddTaskTeacherState()));
      } else if (event is UpdateTaskTeacherEvent) {
        result = await updateTaskTeacher(event.enity);
        emitDone((value) => emit(DobneUpdateTaskTeacherState()));
      }
    });
  }
}
