import 'package:adary/features/table/controller/dashBoard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/model/response/response_model.dart';
import '../data/repository/auth_repository.dart';
import '../helper/route_helper.dart';

class AuthenticationController extends GetxController implements GetxService {
  late AuthRepository _authRepository;
  AuthenticationController({required AuthRepository authRepository}) {
    _authRepository = authRepository;
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _userNameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  FocusNode get userNameFocus => _userNameFocus;
  FocusNode get passwordFocus => _passwordFocus;

  GlobalKey<FormState> get formkey => _formKey;
  TextEditingController get userNameController => _userNameController;
  TextEditingController get passwordController => _passwordController;

  Future<ResponseModel> login(
      {required String userName, required String appKey}) async {
    _isLoading = true;
    update();
    Response response = await _authRepository.login(userName, appKey);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      //تطبيق-الجوال
      //Qwert321

      //حساب150
      //Qwert321@

      //smt0040
      //q4ag3e9i

      //st00344
      //3i7so3b9
      _authRepository.saveUsername(response.body['data']['username']);
      _authRepository.saveUserappKey(response.body['data']['app-key']);
      _authRepository.updateheaders();
      responseModel = ResponseModel(true, response.body['msg']);
      Get.offAllNamed(RouteHelper.geDashBoardRoute());
    } else {
      responseModel = ResponseModel(false, response.body['msg']);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  bool isLoggedIn() {
    return _authRepository.isLoggedIn();
  }

  Future<bool> LogOut() {
    Get.find<DashBoardController>().onPageChanged(0);
    return _authRepository.logut();
  }
}
