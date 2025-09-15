import 'dart:convert';

import 'package:adary/features/table/controller/authintication_controller.dart';
import 'package:adary/features/table/controller/calender_controller.dart';
import 'package:adary/features/table/controller/callus_controller.dart';
import 'package:adary/features/table/controller/class_room_controller.dart';
import 'package:adary/features/table/controller/dashBoard_controller.dart';
import 'package:adary/features/table/controller/notification_controller.dart';
import 'package:adary/features/table/controller/teacher_page_controller.dart';
import 'package:adary/features/table/controller/teatcher_controller.dart';
import 'package:adary/features/table/controller/waitingTeacher_controller.dart';
import 'package:adary/features/table/controller/waiting_controller.dart';
import 'package:adary/features/table/data/repository/auth_repository.dart';
import 'package:adary/features/table/data/repository/calender_repository.dart';
import 'package:adary/features/table/data/repository/call_us_repository.dart';
import 'package:adary/features/table/data/repository/class_room_repository.dart';
import 'package:adary/features/table/data/repository/notification_repository.dart';
import 'package:adary/features/table/data/repository/teacher_page_repository.dart';
import 'package:adary/features/table/data/repository/teacher_repository.dart';
import 'package:adary/features/table/data/repository/waitingTeacher_repository.dart';
import 'package:adary/features/table/data/repository/waiting_repository.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/localization_controller.dart';
import '../controller/share_data_controller.dart';
import '../controller/splash_controller.dart';
import '../controller/theme_controller.dart';
import '../data/api/api_client.dart';
import '../data/model/body/language_model.dart';
import '../data/repository/language_repo.dart';
import '../data/repository/shared_data_repository.dart';
import '../data/repository/splash_repo.dart';
import '../utils/app_constants.dart';

Future<Map<String, Map<String, String>>> init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);

  Get.lazyPut(() => ApiClient(
        appBaseUrl: AppConstants.baseUrl,
      ));

  // repo
  Get.lazyPut(
      () => SplashRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => LanguageRepo());

  Get.lazyPut(() =>
      AuthRepository(sharedPreferences: Get.find(), apiClient: Get.find()));

  Get.lazyPut(() => WaitingRepository(apiClient: Get.find()));

  Get.lazyPut(() => TeacherRepository(apiClient: Get.find()));
  Get.lazyPut(() => CalenderRepository(apiClient: Get.find()));

  Get.lazyPut(() => WaitingTeacherRepository(apiClient: Get.find()));

  Get.lazyPut(() => ClassRoomRepository(apiClient: Get.find()));

  Get.lazyPut(() => TeacherPageRepository(apiClient: Get.find()));

  Get.lazyPut(() => NotificationRepository(apiClient: Get.find()));

  Get.lazyPut(() => CallUsRepository(apiClient: Get.find()));

  Get.lazyPut(() => SahredDataRepository(apiClient: Get.find()));

  Get.lazyPut(() => LanguageRepo());

  // controller
  //Get.lazyPut(() => splashController(splashRepo: Get.find()));
  Get.lazyPut(() => DashBoardController());
  Get.lazyPut(() => WaitingController(waitingRepository: Get.find()));
  Get.lazyPut(() => CalednerController(calenderRepository: Get.find()));
  Get.lazyPut(() => TeacherController(teacherRepository: Get.find()));
  Get.lazyPut(
      () => WaitingTeacherController(waitingTeacherRepository: Get.find()));

  Get.lazyPut(() => ThemeController(sharedPreferences: Get.find()));
  Get.lazyPut(() => LocalizationController(apiClient: Get.find()));

  Get.lazyPut(() => AuthenticationController(authRepository: Get.find()));
  Get.lazyPut(() => ClassRoomController(classRoomRepository: Get.find()));
  Get.lazyPut(() => TeacherPageController(teacherPageRepository: Get.find()));
  Get.lazyPut(() => NotificationController(notificationRepository: Get.find()));
  Get.lazyPut(() => CallUsController(callUsRepository: Get.find()));
  Get.lazyPut(() => SharedDataController(sahredDataRepository: Get.find()));

  // Retrieving localized data
  Map<String, Map<String, String>> languages = {};
  for (LanguageModel languageModel in AppConstants.languages) {
    String jsonStringValues = await rootBundle
        .loadString('assets/lang/${languageModel.languageCode}.json');
    Map<String, dynamic> mappedJson = jsonDecode(jsonStringValues);
    Map<String, String> json = {};
    mappedJson.forEach((key, value) {
      json[key] = value.toString();
    });
    languages['${languageModel.languageCode}_${languageModel.countryCode}'] =
        json;
  }
  return languages;
}
