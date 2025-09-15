import 'package:adary/features/table/controller/waiting_controller.dart';
import 'package:adary/features/table/data/model/response/work_days.dart';
import 'package:adary/features/table/data/repository/calender_repository.dart';
import 'package:get/get.dart';

import '../data/api/api_checker.dart';

class CalednerController extends GetxController implements GetxService {
  late CalenderRepository _calenderRepository;
  CalednerController({required CalenderRepository calenderRepository}) {
    _calenderRepository = calenderRepository;
  }

  int _selectedDayIndex = 0;
  int _todayIndex = 0;
  bool _isLoadingWorkDays = false;
  final List<workDaysModel> _workDays = [];
  List<workDaysModel> get workDaysList => _workDays;
  bool get isLoadingWorkDays => _isLoadingWorkDays;
  int get selectedDayIndex => _selectedDayIndex;
  int get todayIndex => _todayIndex;
  set selectedDayIndex(int val) => _selectedDayIndex = val;

  Future<void> getWorkDays({required bool reload}) async {
    _isLoadingWorkDays = true;
    update();
    if (_workDays.isEmpty || reload) {
      Response response = await _calenderRepository.getWorkDays();
      if (response.statusCode == 200) {
        _workDays.clear();
        response.body['data']['workdays_data']['days'].forEach((key, value) {
          _workDays.add(workDaysModel.fromJson(value));
          _setCurrentDay(
              isToday: value['current_day'], datNum: value['day_num']);
        });
      } else {
        ApiChecker.checkApi(response);
      }
    }

    _isLoadingWorkDays = false;
    update();
  }

  void _setCurrentDay({required bool isToday, required int datNum}) {
    if (isToday) {
      _selectedDayIndex = datNum;
      _todayIndex = datNum;
      update();
    }
  }

  void toggleSelectedDay({required int index}) {
    _selectedDayIndex = index;

    Get.find<WaitingController>().filterData(index: index);
    // Get.find<ClassRoomController>().filterData();
    update();
  }
}
