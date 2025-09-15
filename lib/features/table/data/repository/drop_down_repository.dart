import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_client.dart';

class DropDownRepository {
  ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  DropDownRepository(
      {required this.sharedPreferences, required this.apiClient});
}
