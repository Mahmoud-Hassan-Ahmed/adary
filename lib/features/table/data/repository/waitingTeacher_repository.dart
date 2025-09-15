import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/app_constants.dart';
import '../api/api_client.dart';
import 'package:get/get.dart';

class WaitingTeacherRepository {
  ApiClient apiClient;

  WaitingTeacherRepository({required this.apiClient});

  Future<Response> getWaitingTeacherList({required String cId}) async {
    return await apiClient.getData(AppConstants.WAITING_TEACHER + "$cId" + "/");
  }

  Future<Response> setAbsentTechers(
      {required List<int> absentTeachersIds}) async {
    return await apiClient.postData(
      AppConstants.ABSENT_TEACHER,
      json.encode({
        "absent_teacher_ids": [...absentTeachersIds]
      }),
    );
  }

  Future<Response> addWaitingTeacher(
      {required String CELL_ID, required String WCT_ID}) async {
    return await apiClient.postData(
      AppConstants.ADD_WAITING_TEACHER + "$CELL_ID" + "/" + "$WCT_ID" + "/",
      json.encode({}),
    );
  }
}
