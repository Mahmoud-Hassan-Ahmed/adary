import 'package:adary/features/adary/domain/entities/base_enity.dart';

/// صفحة من قائمة المعلمين في شاشة "قائمة الرغبات". `search` جزء من الاسم.
class WishTeachersEntity extends BaseEnity {
  final int page;
  final String search;

  WishTeachersEntity({this.page = 1, this.search = ''});

  @override
  Map<String, dynamic> toJson() => {
        'page': page,
        if (search.isNotEmpty) 'search': search,
      };
}

/// طلب بطاقات معلم بعينه.
class TeacherWishesEntity extends BaseEnity {
  final int teacherId;

  TeacherWishesEntity({required this.teacherId});

  @override
  Map<String, dynamic> toJson() => {'teacher_id': teacherId};
}
