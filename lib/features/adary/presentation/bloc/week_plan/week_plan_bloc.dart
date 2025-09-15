import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/model/select_model.dart';
import 'package:adary/features/adary/data/models/teacher_model.dart';
import 'package:adary/features/adary/domain/entities/delete_entity.dart';
import 'package:adary/features/adary/domain/usecases/delete_plan_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_teachers_use_case.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'week_plan_event.dart';
part 'week_plan_state.dart';

class WeekPlanBloc extends BaseBloc<WeekPlanEvent, WeekPlanState> {
  final DeletePlanUseCase deletePlanUseCase;
  final GetTeachersUseCase getTeachersUseCase;
  WeekPlanBloc(
      {required this.deletePlanUseCase, required this.getTeachersUseCase})
      : super(WeekPlanInitial()) {
    on<WeekPlanEvent>((event, emit) async {
      if (event is DeleteWeekPlanEvent) {
        result = await deletePlanUseCase(event.entity);
        emitDone((value) => emit(DoneDeletePlanState()));
      } else if (event is GetTechersEvent) {
        result = await getTeachersUseCase();
        emitDone((value) => emit(DoneGetTeachers(list: value)));
      }
    });
  }
}
