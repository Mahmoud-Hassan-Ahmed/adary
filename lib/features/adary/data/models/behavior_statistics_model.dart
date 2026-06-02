class BehaviorStatisticsModel {
  final String className;

  final int excellent;
  final int veryGood;
  final int good;
  final int acceptable;
  final int weak;

  BehaviorStatisticsModel({
    required this.className,
    required this.excellent,
    required this.veryGood,
    required this.good,
    required this.acceptable,
    required this.weak,
  });

  factory BehaviorStatisticsModel.fromJson(Map<String, dynamic> json) {
    return BehaviorStatisticsModel(
      className: json['class_name'] ?? '',
      excellent: json['excellent'] ?? 0,
      veryGood: json['very_good'] ?? 0,
      good: json['good'] ?? 0,
      acceptable: json['acceptable'] ?? 0,
      weak: json['weak'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'class_name': className,
      'excellent': excellent,
      'very_good': veryGood,
      'good': good,
      'acceptable': acceptable,
      'weak': weak,
    };
  }

  static List<BehaviorStatisticsModel> fromList(List<dynamic> data) {
    return data.map((e) => BehaviorStatisticsModel.fromJson(e)).toList();
  }
}
