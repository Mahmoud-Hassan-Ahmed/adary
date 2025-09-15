import 'package:get/get.dart';

import '../data/api/api_checker.dart';
import '../data/repository/shared_data_repository.dart';

class SharedDataController extends GetxController implements GetxService {
  late SahredDataRepository _sahredDataRepository;
  SharedDataController({required SahredDataRepository sahredDataRepository}) {
    _sahredDataRepository = sahredDataRepository;
  }

  List<String> _classesNamesAndNumbers = [];
  List<String> get classesNamesAndNumbers => _classesNamesAndNumbers;

  bool _isLoadingClassesNamesData = false;
  bool get isLoadingClassesNamesData => _isLoadingClassesNamesData;

  Future<void> getClassesNamesAndNumbers({required bool reload}) async {
    _isLoadingClassesNamesData = true;
    update();
    if (_classesNamesAndNumbers.isEmpty || reload) {
      Response response = await _sahredDataRepository.getClassessData();

      if (response.statusCode == 200) {
        _classesNamesAndNumbers.clear();

        response.body['data']['classes'].forEach((k, v) {
          _classesNamesAndNumbers.add(v["class_text"]);
        });
      } else {
        ApiChecker.checkApi(response);
      }
      _isLoadingClassesNamesData = false;
      update();
    }
  }
}
