class absetnTeacherModel {
  int? id;
  String? name;
  String? nickname;
  bool? hasAbsentToday;
  String? note;

  absetnTeacherModel(
      {this.id, this.name, this.nickname, this.hasAbsentToday, this.note});

  absetnTeacherModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nickname = json['nickname'];
    hasAbsentToday = json['has_absent_today'];
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['nickname'] = nickname;
    data['has_absent_today'] = hasAbsentToday;
    data['note'] = note;
    return data;
  }
}
