class LeaveRequestModel {
  final int id;
  final UserModel applicant;
  final UserModel substitute;
  final int cellNumber;
  final String tableNumber;
  final String status;
  final String statusText;
  final String note;
  final String lesson;
  final DateTime createdAt;
  final DateTime updatedAt;

  LeaveRequestModel({
    required this.id,
    required this.applicant,
    required this.substitute,
    required this.cellNumber,
    required this.tableNumber,
    required this.status,
    required this.statusText,
    required this.note,
    required this.lesson,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LeaveRequestModel.fromJson(Map<String, dynamic> json) {
    return LeaveRequestModel(
      id: json['id'] ?? 0,
      applicant: UserModel.fromJson(json['applicant'] ?? {}),
      substitute: UserModel.fromJson(json['substitute'] ?? {}),
      cellNumber: json['cell_number'] ?? 0,
      tableNumber: json['table_number'] ?? '',
      status: json['status'] ?? '',
      statusText: json['status_text'] ?? '',
      note: json['note'] ?? '',
      lesson: json['lesson'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'applicant': applicant.toJson(),
      'substitute': substitute.toJson(),
      'cell_number': cellNumber,
      'table_number': tableNumber,
      'status': status,
      'status_text': statusText,
      'note': note,
      'lesson': lesson,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class UserModel {
  final int id;
  final String name;

  UserModel({
    required this.id,
    required this.name,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
