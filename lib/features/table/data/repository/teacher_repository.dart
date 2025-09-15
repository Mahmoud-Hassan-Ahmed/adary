import 'dart:convert';

import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/table/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_client.dart';

class TeacherRepository {
  ApiClient apiClient;

  TeacherRepository({required this.apiClient});

// !TODO: change from header to body
  Future<Response> getTechersList({required String dayNum}) async {
    final user = AppUtils.instance.getUser();
    return await apiClient.getData("${AppConstants.ABSENT_TEACHER}$dayNum/",
        headers: {
          'username': user!.username,
          'app-key': user.ky,
          'Accept-Language': 'ar'
        });
  }

  Future<Response> setAbsentTechers(
      {required List<int> absentTeachersIds, required int dayNum}) async {
    return await apiClient.postData(
      "${AppConstants.ABSENT_TEACHER}$dayNum/",
      json.encode({
        "absent_teacher_ids": [...absentTeachersIds]
      }),
    );
  }

  Future<Response> UnsetAbsentTechers(
      {required int absentTeachersIds, required int dayNum}) async {
    return await apiClient.postData(
        AppConstants.UN_SET_ABSENT_TEACHER + "$dayNum" + "/",
        json.encode({
          "absent_teacher_ids": [int]
        }));
  }

  Future<Response> unSetAbsentTechers(
      {required List<int> absentTeachersIds}) async {
    return await apiClient.postData(
        AppConstants.UN_SET_ABSENT_TEACHER,
        json.encode({
          "absent_teacher_ids": [...absentTeachersIds],
          "delete": true
        }));
  }
}
