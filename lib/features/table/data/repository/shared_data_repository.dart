import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/app_constants.dart';
import '../api/api_client.dart';

class SahredDataRepository {
  ApiClient apiClient;
  SahredDataRepository({required this.apiClient});

  Future<Response> getClassessData() async {
    return await apiClient.getData(AppConstants.CLASSESS_META);
  }
}
