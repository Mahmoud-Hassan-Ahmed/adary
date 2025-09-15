import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/app_constants.dart';
import '../api/api_client.dart';
import 'package:get/get.dart';

class NotificationRepository {
  ApiClient apiClient;
  NotificationRepository({required this.apiClient});

  Future<Response> geNotificationCount() async {
    return await apiClient.getData(AppConstants.NOTIFICATION_COUNT);
  }

  Future<Response> getNotification() async {
    return await apiClient.getData(AppConstants.NOTIFICATION);
  }

  Future<Response> deleteNotification({required int notificationId}) async {
    return await apiClient.deleteData(
      "${AppConstants.DELETE_NOTIFICATION + notificationId.toString()}/",
    );
  }
}
