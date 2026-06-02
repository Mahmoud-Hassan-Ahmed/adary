import 'package:adary/features/adary/domain/entities/base_enity.dart';

class ExamEntity extends BaseEnity {
  final String name;
  final String description;
  final String start_date;
  final String end_date;
  final int number_of_halls;
  final int date_system;

  ExamEntity(
      {required this.name,
      required this.description,
      required this.start_date,
      required this.end_date,
      required this.number_of_halls,
      required this.date_system});

  @override
  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "start_date": start_date,
        "end_date": end_date,
        "number_of_halls": number_of_halls,
        "date_system": date_system
      };
}
