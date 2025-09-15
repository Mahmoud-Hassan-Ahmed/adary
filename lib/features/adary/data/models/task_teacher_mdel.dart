import 'package:adary/features/adary/data/models/task_model.dart';
import 'package:adary/features/adary/data/models/teacher_model.dart';

class DailyTaskModel {
  String date;
  List<DailyTask> dailyTasks;

  DailyTaskModel({
    required this.date,
    required this.dailyTasks,
  });

  // Factory method to create an instance from JSON
  factory DailyTaskModel.fromJson(Map<String, dynamic> json) {
    return DailyTaskModel(
      date: json['date'],
      dailyTasks: (json['daily_tasks'] as List)
          .map((item) => DailyTask.fromJson(item))
          .toList(),
    );
  }

  // Method to convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'daily_tasks': dailyTasks.map((task) => task.toJson()).toList(),
    };
  }
}

class DailyTask {
  int id;
  int school;
  Teacher teacher;
  TaskModel task;
  String date;
  String startTime;
  String endTime;
  bool completed;
  String? dateCreated;
  int dayNum;

  DailyTask({
    required this.id,
    required this.school,
    required this.teacher,
    required this.task,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.completed,
    required this.dateCreated,
    required this.dayNum,
  });

  // Factory method to create an instance from JSON
  factory DailyTask.fromJson(Map<String, dynamic> json) {
    return DailyTask(
      id: json['id'],
      school: json['school'],
      teacher: Teacher.fromJson(json['teacher']),
      task: TaskModel.fromJson(json['task']),
      date: json['date'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      completed: json['completed'],
      dateCreated: json['date_created'],
      dayNum: json['day_num'],
    );
  }

  // Method to convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'school': school,
      'teacher': teacher,
      'task': task,
      'date': date,
      'start_time': startTime,
      'end_time': endTime,
      'completed': completed,
      'date_created': dateCreated,
      'day_num': dayNum,
    };
  }
}
