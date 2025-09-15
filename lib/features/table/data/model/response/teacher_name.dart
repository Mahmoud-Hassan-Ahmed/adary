class teacherNamesModel {
  int? teacherId;
  String? teacherName;

  teacherNamesModel({this.teacherId, this.teacherName});

  teacherNamesModel.fromJson(Map<String, dynamic> json) {
    teacherId = json['teacher_Id'];
    teacherName = json['teacherName'];
  }
}
