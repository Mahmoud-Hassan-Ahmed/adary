import 'package:adary/features/adary/domain/entities/base_enity.dart';

class EvidencePaginationEntity extends BaseEnity {
  int page = 1;
  final int school;
  int? category;
  int? teacher;

  EvidencePaginationEntity({required this.school});

  @override
  Map<String, dynamic> toJson() => {
        "page": page,
        "school": school,
        if (category != null) "category": category,
        if (teacher != null) "teacher": teacher
      };
}
