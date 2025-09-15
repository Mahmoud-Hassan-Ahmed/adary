import 'package:adary/core/enums/snack_bar_type_enum.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'app_utils.dart';

class DioConfig {
  final Dio dio;

  DioConfig({required this.dio});
  Dio config() {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (!(AppUtils.netConnect)) return;
        if (options.method != 'get' && options.method != 'GET') {
          EasyLoading.show();
        }

        AppUtils.log(options.path);
        if (options.data is FormData) {
          AppUtils.log((options.data as FormData).fields.toString());
          AppUtils.log((options.data as FormData).files.toString());
        } else {
          AppUtils.log(options.data.toString());
        }
        // final user = AppUtils.userApp;
        // if (user != null) {
        //   AppUtils.log(user.access ?? 'not here access token ');
        //   options.headers["Authorization"] = "Bearer  ${user.access}";
        // }
        final login = await AppUtils.instance.getLogin();
        if (login != null &&
            (options.data is! Map ||
                (options.data as Map)['username'] == null)) {
          final local = AppUtils.instance.getLocale();
          options.headers.addAll({
            'app-key': login.password,
            'username': login.username,
            'Accept-Language': local.languageCode
          });
        }
        options.headers.addAll({'Accept-Language': 'ar'});

        return handler.next(options);
      },
      onError: (error, handler) {
        EasyLoading.dismiss();
        final respose = error.response;

        if (respose?.data['detail'] != null) {
          AppUtils.showCustomSnackbar(
              title: 'خطأ', respose?.data['detail'] ?? '', SnackType.FAILURE);
        } else if (respose?.data['msg'] != null) {
          AppUtils.showCustomSnackbar(
              title: 'خطأ', respose?.data['msg'] ?? '', SnackType.FAILURE);
        }
        // }
      },
      onResponse: (response, handler) {
        EasyLoading.dismiss();
        AppUtils.log(response.data.toString());
        return handler.next(response);
      },
    ));
    return dio;
  }
}
