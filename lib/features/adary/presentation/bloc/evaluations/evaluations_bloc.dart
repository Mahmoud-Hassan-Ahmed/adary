import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/features/adary/data/models/evaluation_model.dart';
import 'package:adary/features/adary/domain/usecases/create_implementation_use_case.dart';
import 'package:adary/features/adary/domain/usecases/create_intraction_user_case.dart';
import 'package:adary/features/adary/domain/usecases/create_management_user_case.dart';
import 'package:adary/features/adary/domain/usecases/create_palnning_evaluation_use_case.dart';
import 'package:adary/features/adary/presentation/bloc/circular/circular_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'evaluations_event.dart';
part 'evaluations_state.dart';

class EvaluationsBloc extends BaseBloc<EvaluationsEvent, EvaluationsState> {
  final CreatePlanningEvaluationUseCase createPlanningEvaluationUseCase;
  final CreateInteractionEvaluationUseCase createInteractionEvaluationUseCase;
  final CreateManagementEvaluationUseCase createManagementEvaluationUseCase;
  final CreateImplementationUseCase createImplementationUseCase;
  EvaluationsBloc(
      {required this.createPlanningEvaluationUseCase,
      required this.createInteractionEvaluationUseCase,
      required this.createManagementEvaluationUseCase,
      required this.createImplementationUseCase})
      : super(EvaluationsInitial()) {
    on<EvaluationsEvent>((event, emit) async {
      if (event is UpdatePlanningEvaluationEvent) {
        result = await createPlanningEvaluationUseCase.call(event.planning);
        emitDone((value) {
          emit(DoneUpdatePlanningEvaluationState());
        });
      } else if (event is UpdateInteractionEvaluationEvent) {
        result =
            await createInteractionEvaluationUseCase.call(event.interaction);
        emitDone((value) {
          emit(DoneUpdateInteractionEvaluationState());
        });
      } else if (event is UpdateManagementEvaluationEvent) {
        result = await createManagementEvaluationUseCase.call(event.managment);
        emitDone((value) {
          emit(DoneUpdateManagementEvaluationState());
        });
      } else if (event is UpdateImplementationEvaluationEvent) {
        result = await createImplementationUseCase.call(event.implementation);
        emitDone((value) {
          emit(DoneUpdateImplementationEvaluationState());
        });
      }
    });
  }
}
