import 'package:adary/features/adary/domain/entities/base_enity.dart';

class PaginationEntity extends BaseEnity {
  int page;
  int? classId;
  String? startDate;
  String? endDate;
  String teacher;
  String note;
  String? path;
  String? savePath;

  PaginationEntity(
      {required this.page,
      this.classId,
      this.teacher = '',
      this.note = '',
      this.endDate = '',
      this.path,
      this.startDate = ''});

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
