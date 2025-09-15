class workDaysModel {
  String? day;
  int? dayNum;
  String? dateGregorian;
  String? dateHijiri;
  bool? currentDay;

  workDaysModel(
      {this.day,
      this.dayNum,
      this.dateGregorian,
      this.dateHijiri,
      this.currentDay});

  workDaysModel.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    dayNum = json['day_num'];
    dateGregorian = json['date_gregorian'];
    dateHijiri = json['date_hijiri'];
    currentDay = json['current_day'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    data['day_num'] = this.dayNum;
    data['date_gregorian'] = this.dateGregorian;
    data['date_hijiri'] = this.dateHijiri;
    data['current_day'] = this.currentDay;
    return data;
  }
}
