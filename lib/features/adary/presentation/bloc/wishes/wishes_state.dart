part of 'wishes_bloc.dart';

sealed class WishesState extends Equatable {
  const WishesState();
  static int sum = 0;

  /// نفس أسلوب بقية البلوكات هنا: كل حالة مميزة عن سابقتها حتى لا يبتلع
  /// `Equatable` إعادة بناء الشاشة عند تكرار نفس النتيجة.
  @override
  List<Object> get props => [sum++];
}

final class WishesInitial extends WishesState {}

final class WishesLoadingState extends WishesState {}

final class WishesFailureState extends WishesState {}

final class GetWishTeachersState extends WishesState {
  final PageinationModel<WishTeacherModel> teachers;

  const GetWishTeachersState({required this.teachers});
}

final class GetTeacherWishesState extends WishesState {
  final TeacherWishesResponse data;

  const GetTeacherWishesState({required this.data});
}
