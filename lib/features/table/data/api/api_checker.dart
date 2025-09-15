import 'dart:developer';

import 'package:get/get.dart';

import '../../view/base/custom_snack_bar.dart';

class ApiChecker {
  static void checkApi(Response response) {
    if (response.statusCode == 401) {
      // delete shared data
      // Get.find<AuthController>().clearSharedData();
      // Get.offAllNamed(RouteHelper.getSignInRoute());
    } else if (response.statusCode == 500) {
      showCustomSnackBar(response.body["msg"]);
      print(
          "==============================>" + response.body["msg"].toString());
    } else {
      print("==============================>" + (response.request!.url.path));
      showCustomSnackBar(response.statusText!);
    }
  }
}
