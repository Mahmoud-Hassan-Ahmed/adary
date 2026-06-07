import 'dart:async';
import 'package:adary/core/enums/snack_bar_type_enum.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class CheckInternetConnection {
  final InternetConnection internetConnection;
  late StreamSubscription<InternetStatus> listner;

  CheckInternetConnection({required this.internetConnection});

  void listener(
      {required String messageConnect, required String messageDisconnect}) {
    listner = internetConnection.onStatusChange.listen((InternetStatus status) {
      switch (status) {
        case InternetStatus.connected:
          if (!AppUtils.netConnect) {
            // AppUtils.showCustomSnackbar(messageConnect, SnackType.SUCESS);
            // AppUtils.netConnect = true;
          }
          break;
        case InternetStatus.disconnected:
          if (AppUtils.netConnect) {
            // AppUtils.showCustomSnackbar(messageDisconnect, SnackType.FAILURE);
            // AppUtils.netConnect = false;
          }
          break;
      }
    });
  }

  void cancel() {
    listner.cancel();
  }
}
