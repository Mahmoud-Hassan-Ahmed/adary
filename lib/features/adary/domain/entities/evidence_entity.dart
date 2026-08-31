import 'package:adary/features/adary/domain/entities/base_enity.dart';

class EvidencePaginationEntity extends BaseEnity {
  int page = 1;
  final int school;
  int? category;
  int? teacher;

  /// ترتيب الخادم — الأحدث أولًا. بدونه يرجع الاستعلام بترتيب قاعدة البيانات
  /// العشوائي، وترقيم الصفحات فوق استعلام غير مرتّب يكرّر عناصر ويُسقط أخرى
  /// بين صفحة وأخرى.
  String ordering;

  EvidencePaginationEntity(
      {required this.school, this.ordering = '-uploaded_at'});

  /// نسخة ثابتة لصفحة واحدة. الكيان نفسه يتغيّر مع كل فلتر، فلو أُرسل مباشرة
  /// قد يتبدّل قبل أن يعود ردّ الطلب الجاري.
  EvidencePaginationEntity forPage(int page) =>
      EvidencePaginationEntity(school: school, ordering: ordering)
        ..page = page
        ..category = category
        ..teacher = teacher;

  @override
  Map<String, dynamic> toJson() => {
        "page": page,
        "school": school,
        "ordering": ordering,
        if (category != null) "category": category,
        if (teacher != null) "teacher": teacher
      };
}
