class teacherTableMetaModel {
  int? teacherId;
  String? teacherName;
  String? teacherNickname;

  teacherTableMetaModel(
      {this.teacherId, this.teacherName, this.teacherNickname});

  teacherTableMetaModel.fromJson(Map<String, dynamic> json) {
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
