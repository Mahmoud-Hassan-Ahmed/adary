part of 'wishes_bloc.dart';

sealed class WishesEvent extends Equatable {
  const WishesEvent();

  @override
  List<Object> get props => [];
}

/// شاشة "قائمة الرغبات": صفحة من المعلمين الذين سجّلوا رغبات.
final class GetWishTeachersEvent extends WishesEvent {
  final int page;
  final String search;

  const GetWishTeachersEvent({this.page = 1, this.search = ''});

  @override
  List<Object> get props => [page, search];
}

/// شاشة "رغبات <اسم المعلم>": بطاقات معلم بعينه.
final class GetTeacherWishesEvent extends WishesEvent {
  final int teacherId;

  const GetTeacherWishesEvent({required this.teacherId});

  @override
  List<Object> get props => [teacherId];
}
