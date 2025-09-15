import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/app_constants.dart';
import '../api/api_client.dart';

class SplashRepo {
  ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  SplashRepo({required this.sharedPreferences, required this.apiClient});

  Future<bool> initSharedData() {
    if (!sharedPreferences.containsKey(AppConstants.theme)) {
      return sharedPreferences.setBool(AppConstants.theme, false);
    }

    if (!sharedPreferences.containsKey(AppConstants.languageCode)) {
      return sharedPreferences.setString(
          AppConstants.languageCode, AppConstants.languages[0].languageCode);
    }
    if (!sharedPreferences.containsKey(AppConstants.notification)) {
      return sharedPreferences.setBool(AppConstants.notification, true);
    }
    if (!sharedPreferences.containsKey(AppConstants.intro)) {
      return sharedPreferences.setBool(AppConstants.intro, true);
    }
    if (!sharedPreferences.containsKey(AppConstants.intro)) {
      return sharedPreferences.setInt(AppConstants.notificationCount, 0);
    }
    return Future.value(true);
  }

  bool showIntro() {
    return sharedPreferences.getBool(AppConstants.intro) ?? true;
  }

  void setIntro(bool intro) {
    sharedPreferences.setBool(AppConstants.intro, intro);
  }

  Future<bool> removeSharedData() {
    return sharedPreferences.clear();
  }
}
