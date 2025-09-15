class tableModel {
  String? day;
  int? dayNum;
  int? classNumber;
  String? specialTiming;
  int? cellId;
  String? cellText;
  bool? isEmpty;
  bool? isActive;

  tableModel(
      {this.day,
      this.dayNum,
      this.classNumber,
      this.specialTiming,
      this.cellId,
      this.cellText,
      this.isEmpty,
      this.isActive});

  tableModel.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    dayNum = json['day_num'];
    classNumber = json['class_number'];
    specialTiming = json['special_timing'];
    cellId = json['cell_id'];
    cellText = json['cell_text'];
    isEmpty = json['is_empty'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    data['day_num'] = this.dayNum;
    data['class_number'] = this.classNumber;
    data['special_timing'] = this.specialTiming;
    data['cell_id'] = this.cellId;
    data['cell_text'] = this.cellText;
    data['is_empty'] = this.isEmpty;
    data['is_active'] = this.isActive;
    return data;
  }
}
