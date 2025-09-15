class teacherModel {
  int? teacherNumber;
  String? teacherName;
  bool setAbsent = false;

  teacherModel({this.teacherNumber, this.teacherName});

  teacherModel.fromJson(Map<String, dynamic> json) {
    teacherNumber = json['teacherNumber'];
    teacherName = json['teacherName'];
  }
}
