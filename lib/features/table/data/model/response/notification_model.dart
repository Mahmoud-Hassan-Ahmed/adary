class notificationModel {
  int? id;
  String? message;
  bool? newMessage;
  String? createdAt;

  notificationModel({this.id, this.message, this.newMessage, this.createdAt});

  notificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    newMessage = json['new_message'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['message'] = this.message;
    data['new_message'] = this.newMessage;
    data['created_at'] = this.createdAt;
    return data;
  }
}
