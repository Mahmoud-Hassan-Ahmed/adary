import 'package:adary/core/enums/snack_bar_type_enum.dart';
import 'package:adary/features/adary/data/models/user_app.dart';
import 'package:adary/features/adary/domain/entities/login_entity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

abstract class AppUtils {
  static bool netConnect = true;
  static final instance = sl<AppUtils>();
  static final GetIt sl = GetIt.instance;
  static late BuildContext contextApp;
  static AppUser? appUser;
  static List<String> permissions = [];
  static Map<String, Map<String, String>> datesMap = {};
  static final logger = Logger();
  static void log(String log, {Level levelLog = Level.info}) {
    logger.log(levelLog, log);
  }

  static String convertToWesternNumerals(String input) {
    const easternArabicNumerals = '٠١٢٣٤٥٦٧٨٩';
    const westernArabicNumerals = '0123456789';

    return input.split('').map((char) {
      int index = easternArabicNumerals.indexOf(char);
      return index != -1 ? westernArabicNumerals[index] : char;
    }).join('');
  }

  static List<T> generateList<T>(List<dynamic> data, Function fromJson) {
    final list = <T>[];
    for (final item in data) {
      list.add(fromJson(item));
    }
    return list;
  }

  static void go(Widget page) {
    Get.to(page);
  }

  static void goAndReplace(Widget page) {
    Get.offAll(page);
  }

  Future<void> setUser(AppUser user);
  AppUser? getUser();

  static String formatTime(
    String time,
  ) {
    final timeParts = time.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    final dateTime = DateTime(0, 1, 1, hour, minute);
    final formattedTime = DateFormat('hh:mm a').format(dateTime);
    return formattedTime;
  }

  static String latestMessage = "";

  static void showCustomSnackbar(String message, SnackType type,
      {String title = ''}) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (latestMessage == message) {
        Future.delayed(const Duration(seconds: 10), () {
          latestMessage = '';
        });
        return;
      }
      latestMessage = message;
      Get.snackbar(
        title,
        message,
        titleText: title.isEmpty
            ? Container()
            : Text(
                title,
                style: const TextStyle(color: Colors.white),
              ),
        snackPosition: SnackPosition.TOP,
        forwardAnimationCurve: Curves.easeInOutCubic,
        reverseAnimationCurve: Curves.easeInOutCubic,
        backgroundColor: type == SnackType.FAILURE ? Colors.red : Colors.green,
        colorText: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        icon: type != SnackType.FAILURE
            ? const Icon(
                Icons.check_circle,
                color: Colors.white,
              )
            : const Icon(
                Icons.error,
                color: Colors.white,
              ),
        duration: const Duration(milliseconds: 3000),
      );
    });
  }

  Locale getLocale();
  Future<void> saveDatesMapToStorage();
  Future<void> loadDatesMapFromStorage();
  void setLocale(String? locale, String locale_2);

  Future<void> login(LoginEntity entity);
  Future<void> setcredinal(LoginEntity entity);
  LoginEntity? getcredinal();
  LoginEntity? getLogin();
  Future<void> logout();
  static Future<String?> downloadFile(String fileUrl, String fileName) async {
    EasyLoading.show();
    try {
      Directory? directory = await getApplicationDocumentsDirectory();
      String savePath = "${directory.path}/$fileName";
      Dio dio = Dio();
      await dio.download(fileUrl, savePath,
          onReceiveProgress: (received, total) {
        if (total != -1) {
          print("Progress: ${(received / total * 100).toStringAsFixed(0)}%");
        }
      });
      EasyLoading.dismiss();

      return savePath;
    } catch (e) {
      EasyLoading.dismiss();
      return null;
    }
  }
}
