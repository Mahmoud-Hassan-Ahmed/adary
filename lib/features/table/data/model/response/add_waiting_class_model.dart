class addWaitingClassTeacherModel {
  bool? success;
  String? msg;
  Data? data;

  addWaitingClassTeacherModel({this.success, this.msg, this.data});

  addWaitingClassTeacherModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    msg = json['msg'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? waitingClassId;
  int? classroomId;
  int? cellId;
  int? teacherId;
  int? absentTeacherId;
  String? absentTeacherName;
  String? cellText;

  Data(
      {this.waitingClassId,
      this.classroomId,
      this.cellId,
      this.teacherId,
      this.absentTeacherId,
      this.absentTeacherName,
      this.cellText});

  Data.fromJson(Map<String, dynamic> json) {
    waitingClassId = json['waiting_class_id'];
    classroomId = json['classroom_id'];
    cellId = json['cell_id'];
    teacherId = json['teacher_id'];
    absentTeacherId = json['absent_teacher_id'];
    absentTeacherName = json['absent_teacher_name'];
    cellText = json['cell_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['waiting_class_id'] = this.waitingClassId;
    data['classroom_id'] = this.classroomId;
    data['cell_id'] = this.cellId;
    data['teacher_id'] = this.teacherId;
    data['absent_teacher_id'] = this.absentTeacherId;
    data['absent_teacher_name'] = this.absentTeacherName;
    data['cell_text'] = this.cellText;
    return data;
  }
}
