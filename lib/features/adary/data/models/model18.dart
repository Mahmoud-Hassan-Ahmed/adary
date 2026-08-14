import 'package:adary/features/adary/data/models/procedure_cycle.dart';
import 'package:adary/features/adary/data/models/teacher_model.dart';

class Model18Model {
  final int? schoolId;
  final int id;
  final String? name;
  final Teacher teacher;
  final String? dayName;
  final String dayDate;
  final String? startLateness;
  final String? endLateness;
  final String? fromLateness;
  final String? toLateness;

  /// إفادة المعلّم ورأي المدير وقنوات إشعاره به.
  final ProcedureCycle cycle;

  // Constructor
  Model18Model({
    this.schoolId,
    required this.id,
    this.name,
    required this.teacher,
    this.dayName,
    required this.dayDate,
    this.startLateness,
    this.endLateness,
    this.fromLateness,
    this.toLateness,
    this.cycle = const ProcedureCycle(),
  });

  factory Model18Model.fromJson(Map<String, dynamic> json) {
    return Model18Model(
      schoolId: json['school'] != null ? json['school'] as int : null,
      name: json['name'] as String?,
      teacher: Teacher.fromJson(json['teacher']),
      id: json['id'],
      dayName: json['day_name'] as String?,
      dayDate: json['day_date'] as String,
      startLateness: json['start_lateness'] as String?,
      endLateness: json['end_lateness'] as String?,
      fromLateness: json['from_lateness'] as String?,
      toLateness: json['to_lateness'] as String?,
      cycle: ProcedureCycle.fromJson(json),
    );
  }
}
