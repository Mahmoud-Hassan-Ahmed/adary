import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/features/adary/data/models/task_model.dart';
import 'package:adary/features/adary/domain/entities/base_enity.dart';
import 'package:adary/features/adary/domain/usecases/create_task_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_tasks_use_case.dart';
import 'package:adary/features/adary/domain/usecases/remove_task_use_case.dart';
import 'package:adary/features/adary/domain/usecases/update_task_use_case.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends BaseBloc<TaskEvent, TaskState> {
  final CreateTaskUseCase createTaskUseCase;
  final RemoveTaskUseCase removeTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;
  final GetTasksUseCase getTasksUseCase;
  TaskBloc(
      {required this.createTaskUseCase,
      required this.getTasksUseCase,
      required this.removeTaskUseCase,
      required this.updateTaskUseCase})
      : super(TaskInitial()) {
    on<TaskEvent>((event, emit) async {
      if (event is AddTaskEvent) {
        result = await createTaskUseCase(event.entity);
        emitDone((value) => emit(DoneAddTask()));
      } else if (event is UpdateTask) {
        result = await updateTaskUseCase(event.entity);
        emitDone((value) => emit(DoneUpdateTask()));
      }
      if (event is DeletTask) {
        result = await removeTaskUseCase(event.entity);
        emitDone((value) => emit(DoneDeletTask()));
      } else if (event is GetTasksEvent) {
        result = await getTasksUseCase();
        emitDone((value) => emit(GetTasksState(task: value)));
      }
    });
  }
}
