import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/app_constants.dart';
import '../api/api_client.dart';
import 'package:get/get.dart';

class WaitingRepository {
  ApiClient apiClient;
  WaitingRepository({required this.apiClient});

  Future<Response> getWorkDays() async {
    return await apiClient.getData(AppConstants.WORK_DAYS);
  }

  Future<Response> getWaitingList() async {
    return await apiClient.getData(AppConstants.WAITING_CLASS);
  }

  Future<Response> deleteWaitingCLass(
      {required String waiting_class_id}) async {
    return await apiClient.deleteData(
        AppConstants.ADD_WAITING_TEACHER + "$waiting_class_id" + "/");
  }
}
