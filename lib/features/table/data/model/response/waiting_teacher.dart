class waitingTeacherModel {
  dynamic wctId;
  dynamic teacherId;
  dynamic name;
  dynamic nickname;
  dynamic note;
  dynamic priority;
  dynamic current;

  waitingTeacherModel(
      {this.wctId,
      this.teacherId,
      this.name,
      this.nickname,
      this.note,
      this.priority,
      this.current});

  waitingTeacherModel.fromJson(Map<String, dynamic> json) {
    wctId = json['wct_id'];
    teacherId = json['teacher_id'];
    name = json['name'];
    nickname = json['nickname'];
    note = json['note'];
    priority = json['priority'];
    current = json['current'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['wct_id'] = this.wctId;
    data['teacher_id'] = this.teacherId;
    data['name'] = this.name;
    data['nickname'] = this.nickname;
    data['note'] = this.note;
    data['priority'] = this.priority;
    data['current'] = this.current;
    return data;
  }
}
