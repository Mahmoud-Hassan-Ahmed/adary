class waitingListModel {
  int? waitingClassId;
  int? dayNum;
  int? classNumber;
  String? specialTiming;
  String? class_number_text;
  Cell? cell;
  WaitingTeacher? waitingTeacher;

  waitingListModel(
      {this.waitingClassId,
      this.dayNum,
      this.classNumber,
      this.specialTiming,
      this.class_number_text,
      this.cell,
      this.waitingTeacher});

  waitingListModel.fromJson(Map<String, dynamic> json) {
    waitingClassId = json['waiting_class_id'];
    dayNum = json['day_num'];
    classNumber = json['class_number'];
    class_number_text = json['class_number_text'];
    specialTiming = json['special_timing'];
    cell = json['cell'] != null ? new Cell.fromJson(json['cell']) : null;
    waitingTeacher = json['waiting_teacher'] != null
        ? new WaitingTeacher.fromJson(json['waiting_teacher'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['waiting_class_id'] = this.waitingClassId;
    data['day_num'] = this.dayNum;
    data['class_number'] = this.classNumber;
    data['special_timing'] = this.specialTiming;
    if (this.cell != null) {
      data['cell'] = this.cell!.toJson();
    }
    if (this.waitingTeacher != null) {
      data['waiting_teacher'] = this.waitingTeacher!.toJson();
    }
    return data;
  }
}

class Cell {
  int? cellId;
  int? absentTeacherId;
  String? absentTeacherNickname;
  int? classroomId;
  String? classroomName;
  String? cellText;

  Cell(
      {this.cellId,
      this.absentTeacherId,
      this.absentTeacherNickname,
      this.classroomId,
      this.classroomName,
      this.cellText});

  Cell.fromJson(Map<String, dynamic> json) {
    cellId = json['cell_id'];
    absentTeacherId = json['absent_teacher_id'];
    absentTeacherNickname = json['absent_teacher_nickname'];
    classroomId = json['classroom_id'];
    classroomName = json['classroom_name'];
    cellText = json['cell_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cell_id'] = this.cellId;
    data['absent_teacher_id'] = this.absentTeacherId;
    data['absent_teacher_nickname'] = this.absentTeacherNickname;
    data['classroom_id'] = this.classroomId;
    data['classroom_name'] = this.classroomName;
    data['cell_text'] = this.cellText;
    return data;
  }
}

class WaitingTeacher {
  int? teacherId;
  String? teacherName;
  String? teacherNickname;

  WaitingTeacher({this.teacherId, this.teacherName, this.teacherNickname});

  WaitingTeacher.fromJson(Map<String, dynamic> json) {
    teacherId = json['teacher_id'];
    teacherName = json['teacher_name'];
    teacherNickname = json['teacher_nickname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['teacher_id'] = this.teacherId;
    data['teacher_name'] = this.teacherName;
    data['teacher_nickname'] = this.teacherNickname;
    return data;
  }
}
