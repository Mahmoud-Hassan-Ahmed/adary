import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/app_constants.dart';
import '../api/api_client.dart';
import 'package:get/get.dart';

class AuthRepository {
  ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  AuthRepository({required this.sharedPreferences, required this.apiClient});

  Future<Response> login(String appKey, String password) async {
    return await apiClient.postData(
        AppConstants.LOGIN_URI,
        json.encode({
          "username": "$appKey",
          "app-key": "$password",
        }),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept-Language':
              sharedPreferences.getString(AppConstants.languageCode) ?? "ar"
        });
  }

  Future<Response> updateToken() async {
    String _deviceToken;

    _deviceToken = await _saveDeviceToken();

    return await apiClient.postData(AppConstants.tokenUri,
        {"_method": "put", "token": getUserToken(), "fcm_token": _deviceToken});
  }

  Future<String> _saveDeviceToken() async {
    String _deviceToken = '';

    if (_deviceToken != null) {
      print('--------Device Token---------- ' + _deviceToken);
    }
    return _deviceToken;
  }

  Future<bool> saveUserappKey(String appKey) async {
    apiClient.token = appKey;
    // apiClient.updateHeader(
    //   appKey,
    // );
    return await sharedPreferences.setString(AppConstants.APP_KEY, appKey);
  }

  Future<bool> saveUsername(String userName) async {
    return await sharedPreferences.setString(AppConstants.USER_NAME, userName);
  }

  Future<void> updateheaders() async {
    apiClient.updateHeader();
  }

  Future<bool> logut() async {
    await sharedPreferences.remove(AppConstants.APP_KEY);
    await sharedPreferences.remove(AppConstants.USER_NAME);
    await sharedPreferences.remove(AppConstants.languageCode);
    await sharedPreferences.remove(AppConstants.COUNTRY_CODE);

    return true;
  }

  String getUserToken() {
    return sharedPreferences.getString(AppConstants.token) ?? "";
  }

  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.APP_KEY);
  }

  Future<bool> clearSharedData() async {
    if (!GetPlatform.isWeb) {
      apiClient.postData(AppConstants.tokenUri,
          {"_method": "put", "token": getUserToken(), "fcm_token": '@'});
    }
    await sharedPreferences.remove(AppConstants.token);
    return true;
  }

  Future<void> saveUserNumberAndPassword(String number, String password) async {
    try {
      await sharedPreferences.setString(AppConstants.userPassword, password);
      await sharedPreferences.setString(AppConstants.userNumber, number);
    } catch (e) {
      throw e;
    }
  }
}
