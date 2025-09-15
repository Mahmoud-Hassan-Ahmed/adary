import 'package:get/get.dart';

import '../data/api/api_checker.dart';
import '../data/model/response/response_model.dart';
import '../data/repository/call_us_repository.dart';

class CallUsController extends GetxController implements GetxService {
  late CallUsRepository _callUsRepository;
  CallUsController({required CallUsRepository callUsRepository}) {
    _callUsRepository = callUsRepository;
  }

  bool _isSendingMsg = false;
  bool get isSendingMsg => _isSendingMsg;

  Future<ResponseModel> sendMessage(
      {required String title, required String msg}) async {
    _isSendingMsg = true;
    update();
    ResponseModel responseModel;
    Response response = await _callUsRepository.sendMsg(msg: msg, title: title);
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['msg']);
    } else {
      responseModel = ResponseModel(false, response.body['msg']);
      ApiChecker.checkApi(response);
    }

    _isSendingMsg = false;
    update();
    return responseModel;
  }
}
