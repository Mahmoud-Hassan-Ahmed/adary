import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/model/select_model.dart';
import 'package:adary/features/adary/data/models/teacher_model.dart';
import 'package:adary/features/adary/data/models/week_group.dart';
import 'package:adary/features/adary/domain/entities/base_enity.dart';
import 'package:adary/features/adary/domain/entities/delete_entity.dart';
import 'package:adary/features/adary/domain/usecases/add_week_group_use_case.dart';
import 'package:adary/features/adary/domain/usecases/delete_plan_use_case.dart';
import 'package:adary/features/adary/domain/usecases/delete_week_group_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_teachers_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_weeks_group.dart';
import 'package:adary/features/adary/domain/usecases/update_week_groups_user_case.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'week_plan_event.dart';
part 'week_plan_state.dart';

class WeekPlanBloc extends BaseBloc<WeekPlanEvent, WeekPlanState> {
  final DeletePlanUseCase deletePlanUseCase;
  final GetTeachersUseCase getTeachersUseCase;
  final GetWeeksGroup getWeeksGroup;
  final AddWeekGroupUseCase addWeekGroupUseCase;
  final UpdateWeekGroupUseCase updateWeekGroupUseCase;
  final DeleteWeekGroupUseCase deleteWeekGroupUseCase;
  WeekPlanBloc(
      {required this.deletePlanUseCase,
      required this.getTeachersUseCase,
      required this.getWeeksGroup,
      required this.addWeekGroupUseCase,
      required this.updateWeekGroupUseCase,
      required this.deleteWeekGroupUseCase})
      : super(WeekPlanInitial()) {
    on<WeekPlanEvent>((event, emit) async {
      if (event is DeleteWeekPlanEvent) {
        result = await deletePlanUseCase(event.entity);
        emitDone((value) => emit(DoneDeletePlanState()));
      } else if (event is GetTechersEvent) {
        result = await getTeachersUseCase();
        emitDone((value) => emit(DoneGetTeachers(list: value)));
      } else if (event is GetWeeksGroupEvent) {
        result = await getWeeksGroup();
        emitDone((value) => emit(DoneGetWeeksGroup(list: value)));
      } else if (event is AddWeekGroupEvent) {
        result = await addWeekGroupUseCase(event.entity);
        emitDone((value) => emit(DoneAddWeekGroupState()));
      } else if (event is UpdateWeekGroupEvent) {
        result = await updateWeekGroupUseCase(event.entity);
        emitDone((value) => emit(DoneUpdateWeekGroupState()));
      } else if (event is DeleteWeekGroupEvent) {
        result = await deleteWeekGroupUseCase(DeleteEntity(id: event.id));
        emitDone((value) => emit(DoneDeleteWeekGroupState()));
      }
    });
  }
}
