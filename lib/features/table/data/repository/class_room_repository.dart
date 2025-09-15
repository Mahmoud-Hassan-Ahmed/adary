import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/app_constants.dart';
import '../api/api_client.dart';
import 'package:get/get.dart';

class ClassRoomRepository {
  ApiClient apiClient;
  ClassRoomRepository({required this.apiClient});

  Future<Response> getClassRoomPages() async {
    return await apiClient.getData(AppConstants.CLASS_ROOM_PAGES);
  }
}
