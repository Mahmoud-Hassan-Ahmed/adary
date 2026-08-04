import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/features/adary/data/models/duty_model.dart';
import 'package:adary/features/adary/domain/entities/duty_filter_entity.dart';
import 'package:adary/features/adary/domain/usecases/get_duty_schedule_use_case.dart';
import 'package:equatable/equatable.dart';

part 'duty_event.dart';
part 'duty_state.dart';

/// المناوبة والإشراف — عرض فقط: لا أحداث إضافة أو تعديل أو حذف هنا،
/// فالتوزيع كله يتم من لوحة المدرسة على الويب.
class DutyBloc extends BaseBloc<DutyEvent, DutyState> {
  final GetDutyScheduleUseCase getDutyScheduleUseCase;

  DutyBloc({required this.getDutyScheduleUseCase}) : super(DutyInitial()) {
    on<DutyEvent>((event, emit) async {
      if (event is GetDutyScheduleEvent) {
        emit(DutyLoadingState(teacherId: event.teacherId));
        result = await getDutyScheduleUseCase(
            DutyFilterEntity(teacherId: event.teacherId));
        result.fold(
          (failure) => emit(DutyFailureState(teacherId: event.teacherId)),
          (value) => emit(
              GetDutyScheduleState(data: value, teacherId: event.teacherId)),
        );
      }
    });
  }
}
