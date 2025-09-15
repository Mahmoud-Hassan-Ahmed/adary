import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/features/adary/domain/entities/base_enity.dart';
import 'package:adary/features/adary/domain/entities/login_entity.dart';
import 'package:adary/features/adary/domain/usecases/login_use_case.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends BaseBloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;
  LoginBloc({required this.loginUseCase}) : super(LoginInitial()) {
    on<LoginEvent>((event, emit) async {
      if (event is LoginUserEvent) {
        result = await loginUseCase(event.entity);
        emitDone((value) => emit(DoneLoginState()));
      }
    });
  }
}
