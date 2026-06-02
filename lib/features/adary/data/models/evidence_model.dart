import 'package:adary/features/adary/data/models/teacher_model.dart';
import 'package:adary/features/adary/domain/entities/base_enity.dart';

class EvidenceCategoryModel extends BaseEnity {
  final String name;
  final int id;
  final String add;

  EvidenceCategoryModel({required this.name, required this.id, this.add = 'a'});

  factory EvidenceCategoryModel.fromJson(Map<String, dynamic> json) {
    return EvidenceCategoryModel(
      name: json['name'] ?? '',
      id: json['id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}

class EvidenceTeacherModel extends BaseEnity {
  final int id;
  final String file;
  final String typeFile;
  final EvidenceCategoryModel? category;
  final Teacher teacher;
  final String createdAt; // تاريخ الإضافة
  int rate;

  // يستخدم وقت الإرسال فقط
  final int? categoryId;

  EvidenceTeacherModel({
    required this.id,
    required this.file,
    required this.typeFile,
    required this.teacher,
    this.category,
    this.rate = 0,
    required this.createdAt,
    this.categoryId,
  });

  factory EvidenceTeacherModel.fromJson(Map<String, dynamic> json) {
    return EvidenceTeacherModel(
      id: json['id'],
      rate: json['rate'] ?? 0,
      createdAt: json['uploaded_at'] ?? '',
      file: json['file'] ?? '',
      typeFile: json['type_file'] ?? '',
      teacher: Teacher.fromJson(json['techer']),
      category: json['category'] != null
          ? EvidenceCategoryModel.fromJson(json['category'])
          : null,
      categoryId: json['category_id'], // غالبًا مش بترجع من API
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'rate': rate,
    };
  }
}
