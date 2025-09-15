import 'dart:convert';
import 'package:adary/features/table/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_client.dart';

class TeacherPageRepository {
  ApiClient apiClient;

  TeacherPageRepository({required this.apiClient});

  Future<Response> getTechersList() async {
    return await apiClient.getData(AppConstants.GET_TEACHERS_NAMES_LIST);
  }

  Future<Response> sendNotification(
      {required int teacherId, required String message}) async {
    return await apiClient.postData(
      AppConstants.SEND_NOTIFICATION,
      json.encode({
        "msg": "$message",
        "to": [teacherId]
      }),
    );
  }

  Future<Response> getClassessData() async {
    return await apiClient.getData(AppConstants.CLASSESS_META);
  }
}
