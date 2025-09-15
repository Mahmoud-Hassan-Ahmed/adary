import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/app_constants.dart';
import '../api/api_client.dart';
import 'package:get/get.dart';

class CalenderRepository {
  ApiClient apiClient;

  CalenderRepository({required this.apiClient});

  Future<Response> getWorkDays() async {
    return await apiClient.getData(AppConstants.WORK_DAYS);
  }
}
