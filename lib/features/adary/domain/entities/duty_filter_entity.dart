import 'package:adary/features/adary/domain/entities/base_enity.dart';

/// فلتر شاشة المناوبة والإشراف. `teacherId` فارغ = كل المعلمين.
class DutyFilterEntity extends BaseEnity {
  final int? teacherId;

  DutyFilterEntity({this.teacherId});

  @override
  Map<String, dynamic> toJson() => {'teacher_id': teacherId};
}
