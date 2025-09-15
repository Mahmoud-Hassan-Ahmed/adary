import 'package:adary/features/adary/domain/entities/base_enity.dart';

class Model18 extends BaseEnity {
  int? id;
  String? name;
  int? teacherId;
  String? dayName;
  String? dayDate;
  String? startLateness;
  String? endLateness;
  String? fromLateness;
  String? toLateness;

  Model18({
    this.id,
    this.name,
    this.teacherId,
    this.dayName,
    this.dayDate,
    this.startLateness,
    this.endLateness,
    this.fromLateness,
    this.toLateness,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'teacher_id': teacherId,
      'day_name': dayName,
      'day_date': dayDate,
      'start_lateness': startLateness,
      'end_lateness': endLateness,
      'from_lateness': fromLateness,
      'to_lateness': toLateness,
    };
  }
}

class Model19 extends BaseEnity {
  final int? id;
  int? teacherId;
  String? name;
  double? exitTime;
  int? numDays;

  Model19({
    this.id,
    this.teacherId,
    this.name,
    this.exitTime,
    this.numDays,
  });

  // Serialize Model19 to JSON
  Map<String, dynamic> toJson() {
    return {
      'teacher_id': teacherId,
      'name': name,
      'exit_time': exitTime,
      'num_days': numDays,
    };
  }
}

class Model20 extends BaseEnity {
  final int? id;
  int? teacherId;
  String? name;
  String? atDay;
  String? atDayDate;
  String? toDay;
  String? toDayDate;

  Model20({
    this.id,
    this.teacherId,
    this.name,
    this.atDay,
    this.atDayDate,
    this.toDay,
    this.toDayDate,
  });

  // Serialize Model20 to JSON
  Map<String, dynamic> toJson() {
    return {
      'teacher_id': teacherId,
      'name': name,
      'at_day': atDay,
      'at_day_date': atDayDate,
      'to_day': toDay,
      'to_day_date': toDayDate,
    };
  }
}
