import 'package:adary/features/adary/domain/entities/base_enity.dart';

class TeacherTask extends BaseEnity {
  final int? id;
  List<int> teacher;
  int task;
  String date;
  String startTime;
  String endTime;
  String? endDate;
  int repeat = 0;

  TeacherTask({
    this.id,
    required this.teacher,
    required this.task,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.endDate,
    this.repeat = 0,
  });

  // Method to convert the instance to JSON
  @override
  Map<String, dynamic> toJson() {
    return {
      'teacher': teacher,
      'task': task,
      'date': date,
      'start_time': startTime,
      'end_time': endTime,
      "end_date": endDate,
      "repeat": repeat,
    };
  }
}
