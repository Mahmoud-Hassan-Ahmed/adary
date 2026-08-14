import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/features/adary/data/models/pagination_model.dart';
import 'package:adary/features/adary/data/models/wishes_model.dart';
import 'package:adary/features/adary/domain/entities/wishes_entity.dart';
import 'package:adary/features/adary/domain/usecases/get_teacher_wishes_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_wish_teachers_use_case.dart';
import 'package:equatable/equatable.dart';

part 'wishes_event.dart';
part 'wishes_state.dart';

/// الرغبات عند المدير — عرض فقط.
///
/// التسجيل والتعديل والحذف كلّها في تطبيق المعلم؛ المدير يقرأ ما سجّلوه،
/// فلا أحداث كتابة هنا قصدًا.
class WishesBloc extends BaseBloc<WishesEvent, WishesState> {
  final GetWishTeachersUseCase getWishTeachersUseCase;
  final GetTeacherWishesUseCase getTeacherWishesUseCase;

  WishesBloc({
    required this.getWishTeachersUseCase,
    required this.getTeacherWishesUseCase,
  }) : super(WishesInitial()) {
    on<WishesEvent>((event, emit) async {
      if (event is GetWishTeachersEvent) {
        emit(WishesLoadingState());
        result = await getWishTeachersUseCase(
            WishTeachersEntity(page: event.page, search: event.search));
        result.fold(
          (failure) => emit(WishesFailureState()),
          (value) => emit(GetWishTeachersState(teachers: value)),
        );
      }
      if (event is GetTeacherWishesEvent) {
        emit(WishesLoadingState());
        result = await getTeacherWishesUseCase(
            TeacherWishesEntity(teacherId: event.teacherId));
        result.fold(
          (failure) => emit(WishesFailureState()),
          (value) => emit(GetTeacherWishesState(data: value)),
        );
      }
    });
  }
}
