import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/features/adary/data/models/pagination_model.dart';
import 'package:adary/features/adary/data/models/requests_model.dart';
import 'package:adary/features/adary/domain/entities/base_enity.dart';
import 'package:adary/features/adary/domain/entities/change_status_entity.dart';
import 'package:adary/features/adary/domain/usecases/change_status_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_requests_use_case.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'secure_session_event.dart';
part 'secure_session_state.dart';

class SecureSessionBloc
    extends BaseBloc<SecureSessionEvent, SecureSessionState> {
  final GetRequestsUseCase getRequestsUseCase;
  final ChangeStatusUseCase changeStatusUseCase;
  SecureSessionBloc({
    required this.getRequestsUseCase,
    required this.changeStatusUseCase,
  }) : super(SecureSessionInitial()) {
    on<SecureSessionEvent>((event, emit) async {
      if (event is GetRequestsEvent) {
        result = await getRequestsUseCase(event.status);
        emitDone((value) {
          emit(SecureSessionDone(requests: value));
        });
      }
      if (event is ChangeStatusEvent) {
        result = await changeStatusUseCase(event.entity);
        emitDone((value) {
          emit(ChangeStatusDone());
        });
      }
    });
  }
}
