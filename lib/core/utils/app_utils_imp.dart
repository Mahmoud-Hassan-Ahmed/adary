import 'dart:convert';
import 'dart:ui';

import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/core/utils/check_internet.dart';
import 'package:adary/features/adary/data/models/user_app.dart';
import 'package:adary/features/adary/domain/entities/login_entity.dart';
import 'package:adary/features/adary/domain/usecases/login_use_case.dart';
import 'package:adary/features/adary/presentation/pages/main_screen.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppUtilsImp extends AppUtils {
  final Dio dio;
  final CheckInternetConnection checkinternet;
  final SharedPreferences prefs;

  AppUtilsImp(
      {required this.dio, required this.checkinternet, required this.prefs}) {
    loadDatesMapFromStorage();
    LoginEntity? loginEntity = getcredinal();
    AppUtils.log("loginEntity: ${loginEntity?.username}");
    AppUtils.log("loginEntity: ${loginEntity?.password}");
    final permissions = getLogin()?.permissions.length ?? 0;
    AppUtils.log("permissions: ${permissions}");
    if (loginEntity != null) {
      sl<LoginUseCase>()
          .call(LoginEntity(
            username: loginEntity.username,
            password: loginEntity.password,
          ))
          .then((value) => {
                AppUtils.log("log ${AppUtils.permissions.length}"),
                if (permissions != AppUtils.permissions.length)
                  {AppUtils.goAndReplace(MainScreen())}
              });
    }
  }

  @override
  Future<void> login(LoginEntity entity) async {
    await prefs.setString('username', entity.username);
    await prefs.setString('app-key', entity.password);
    await prefs.setStringList(
      'permissions',
      entity.permissions,
    );
    AppUtils.permissions = entity.permissions;
  }

  @override
  LoginEntity? getLogin() {
    if (prefs.containsKey('username')) {
      final userName = prefs.getString('username');
      final password = prefs.getString('app-key');
      final permissions = prefs.getStringList('permissions') ?? [];
      return LoginEntity(
          username: userName ?? "",
          password: password ?? '',
          permissions: permissions);
    } else {
      return null;
    }
  }

  @override
  Future<void> logout() async {
    await prefs.remove('username');
    await prefs.remove('app-key');
    await prefs.remove('user');
  }

  @override
  Future<void> setUser(AppUser user) async {
    await prefs.setString('user', jsonEncode(user.toJson()));
    AppUtils.appUser = user;
    if (!prefs.containsKey(user.username) && user.followerPlanInfo.isTrial) {
      print("satat");
      Future.delayed(
        const Duration(seconds: 10),
        () {
          print(AppUtils.contextApp);

          AwesomeDialog(
                  context: AppUtils.contextApp,
                  dialogType: DialogType.warning,
                  title: 'تجربة مجانية',
                  desc: user.followerPlanInfo.trialMessage,
                  btnOkText: 'موافق')
              .show();
        },
      );
      await prefs.setBool(user.username, true);
    }
    if (!prefs.containsKey('${user.username}#') &&
        user.smartblePlanInfo.isTrial) {
      Future.delayed(const Duration(seconds: 10), () {
        AwesomeDialog(
                context: AppUtils.contextApp,
                dialogType: DialogType.warning,
                title: 'تجربة مجانية',
                desc: user.smartblePlanInfo.trialMessage,
                btnOkText: 'موافق')
            .show();
      });
      await prefs.setBool('${user.username}#', true);
    }
  }

  @override
  AppUser? getUser() {
    if (prefs.containsKey('user')) {
      final data = jsonDecode(prefs.getString('user') ?? '');

      return AppUser.fromJson(data);
    } else {
      return null;
    }
  }

  @override
  Locale getLocale() {
    return prefs.getString('locale') != null
        ? Locale(prefs.getString('locale')!, prefs.getString('locale_2'))
        : const Locale('ar', 'SA');
  }

  @override
  void setLocale(String? locale, String locale_2) {
    if (locale != null) {
      prefs.setString('locale', locale);
      prefs.setString('locale_2', locale_2);
    } else {
      prefs.remove('locale');
    }
  }

  @override
  Future<void> saveDatesMapToStorage() async {
    final serialized = <String, String>{};
    for (final entry in AppUtils.datesMap.entries) {
      serialized[entry.key] = json.encode(entry.value);
    }

    // Store as single JSON string
    await prefs.setString('app_dates_map', json.encode(serialized));
  }

  @override
  Future<void> loadDatesMapFromStorage() async {
    try {
      final storedJson = prefs.getString('app_dates_map');
      if (storedJson == null || storedJson.isEmpty) {
        return;
      }
      final decodedOuter = json.decode(storedJson) as Map<String, dynamic>;
      for (final entry in decodedOuter.entries) {
        final innerJson = entry.value as String;
        final decodedInner = json.decode(innerJson) as Map<String, dynamic>;
        // Ensure structure matches: { "day": ..., "month": ... }
        AppUtils.datesMap[entry.key] = {
          "day": decodedInner['day']?.toString() ?? '',
          "month": decodedInner['month']?.toString() ?? '',
        };
      }
    } catch (e) {}
  }

  @override
  LoginEntity? getcredinal() {
    if (prefs.containsKey('username_user')) {
      final userName = prefs.getString('username_user');
      final password = prefs.getString('password_user');
      return LoginEntity(username: userName ?? "", password: password ?? '');
    } else {
      return null;
    }
  }

  @override
  Future<void> setcredinal(LoginEntity entity) async {
    await prefs.setString('username_user', entity.username);
    await prefs.setString('password_user', entity.password);
  }
}
