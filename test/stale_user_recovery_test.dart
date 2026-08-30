import 'dart:convert';

import 'package:adary/core/utils/app_utils_imp.dart';
import 'package:adary/core/utils/check_internet.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A `user` blob as an older build of the app wrote it: several fields that
/// `AppUser` now declares as required and non-nullable are simply absent.
const _staleUserBlob = {
  'school': 'المدرسة الافتراضية',
  'username': 'manager',
  'is_smartble_active': true,
};

Future<AppUtilsImp> _utilsWith(Map<String, Object> prefsValues) async {
  SharedPreferences.setMockInitialValues(prefsValues);
  return AppUtilsImp(
    dio: Dio(),
    checkinternet:
        CheckInternetConnection(internetConnection: InternetConnection()),
    prefs: await SharedPreferences.getInstance(),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('a stale stored user is discarded instead of throwing', () async {
    final utils = await _utilsWith({'user': jsonEncode(_staleUserBlob)});

    // Before the fix this threw a TypeError out of AppUser.fromJson, which
    // escaped into SplashPage's unguarded .then() and left the app parked on
    // the splash image forever — the "white screen" users reported.
    expect(utils.getUser(), isNull);

    // And the bad blob is cleared, so the app falls back to the login screen
    // instead of hitting the same failure on every future launch.
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.containsKey('user'), isFalse);
  });

  test('garbage in the user key is survivable too', () async {
    final utils = await _utilsWith({'user': 'not json at all'});
    expect(utils.getUser(), isNull);
  });

  test('no stored user simply means signed out', () async {
    final utils = await _utilsWith({});
    expect(utils.getUser(), isNull);
  });
}
