import 'package:adary/features/adary/domain/entities/base_enity.dart';

class FilterPer extends BaseEnity {
  int page;
  final String? date;
  final int? className;
  final int? session;
  final String? school;
  final String? dateHijri;

  FilterPer({
    this.date,
    this.className,
    this.session,
    this.dateHijri,
    this.school,
    required this.page,
  });

  @override
  Map<String, dynamic> toJson() => {
        "date": date ?? '',
        "class_name": className ?? '',
        "session": session ?? '',
        "page": page,
        "date_hijri": dateHijri ?? '',
        "school": school ?? ''
      };
}
