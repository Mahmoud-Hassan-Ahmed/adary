class teacherTableModel {
  String? day;
  int? dayNum;
  int? classNumber;
  String? classesTiming;
  List<dynamic>? cellIds;
  List<dynamic>? cellText;
  List<dynamic>? classroomsIds;
  Flags? flags;

  teacherTableModel(
      {this.day,
      this.dayNum,
      this.classNumber,
      this.classesTiming,
      this.cellIds,
      this.cellText,
      this.classroomsIds,
      this.flags});

  teacherTableModel.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    dayNum = json['day_num'];
    classNumber = json['class_number'];
    classesTiming = json['classes_timing'];
    cellIds = json['cell_ids'];
    cellText = json['cell_text'];
    classroomsIds = json['classrooms_ids'].cast<int>();
    flags = json['flags'] != null ? new Flags.fromJson(json['flags']) : null;
  }
}

class Flags {
  bool? isEmpty;
  bool? isWaiting;
  bool? isAnotherTeacher;

  Flags({this.isEmpty, this.isWaiting, this.isAnotherTeacher});

  Flags.fromJson(Map<String, dynamic> json) {
    isEmpty = json['is_empty'];
    isWaiting = json['is_waiting'];
    isAnotherTeacher = json['is_another_teacher'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_empty'] = isEmpty;
    data['is_waiting'] = isWaiting;
    data['is_another_teacher'] = isAnotherTeacher;
    return data;
  }
}
