import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/app_constants.dart';
import '../api/api_client.dart';
import 'package:get/get.dart';

class CallUsRepository {
  ApiClient apiClient;

  CallUsRepository({required this.apiClient});

  Future<Response> sendMsg({required String title, required String msg}) async {
    return await apiClient.postData(
      AppConstants.CONTACT_US,
      json.encode({
        "title": "$title",
        "message": "$msg",
      }),
    );
  }
}
