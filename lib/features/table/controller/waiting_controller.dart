import 'package:adary/features/table/controller/calender_controller.dart';
import 'package:adary/features/table/data/model/response/work_days.dart';
import 'package:adary/features/table/data/repository/waiting_repository.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/api/api_checker.dart';
import '../data/model/response/response_model.dart';
import '../data/model/response/waiting_list.dart';

class WaitingController extends GetxController implements GetxService {
  late WaitingRepository _waitingRepository;
  WaitingController({required WaitingRepository waitingRepository}) {
    _waitingRepository = waitingRepository;
  }

  @override
  void onInit() {
    // if (Get.isRegistered<SharedPreferences>()) {
    // } else {
    //   Get.lazyPut(() async => await SharedPreferences.getInstance());
    // }

    super.onInit();
  }

  int _selectedIndex = 0;
  bool _isLoading = false;
  bool _isLoadingWorkDays = false;
  final List<workDaysModel> _workDays = [];
  final List<waitingListModel> _waitingList = [];
  final List<waitingListModel> _filterdWaitingList = [];
  final List<String> _absentInstructorList = [];
  final List<String> _waitingInstructorList = [];
  List<workDaysModel> get workDaysList => _workDays;
  List<waitingListModel> get waitingList => _waitingList;
  List<waitingListModel> get filterdWaitingList => _filterdWaitingList;
  List<String> get absentInstructor => _absentInstructorList;
  List<String> get waitingInstructor => _waitingInstructorList;
  bool get isLoading => _isLoading;
  bool get isLoadingWorkDays => _isLoadingWorkDays;
  int get selectedIndex => _selectedIndex;

  int _selectedWaitingClassID = 0;
  int get selectedWaitingClassID => _selectedWaitingClassID;

  bool _isDeleteing = false;
  bool get isDeleteing => _isDeleteing;

  Future<void> loadAllData() async {
    // await getWorkDays(reload: true);
    await Get.find<CalednerController>().getWorkDays(reload: true);
    await getWaitingList(reload: true);
  }

  // Future<void> getWorkDays({required bool reload}) async {
  //   _isLoadingWorkDays = true;
  //   update();
  //   if (_workDays.isEmpty || reload) {
  //     Response response = await _waitingRepository.getWorkDays();
  //     if (response.statusCode == 200) {
  //       _workDays.clear();
  //       response.body['data']['workdays_data']['days'].forEach((key, value) {
  //         _workDays.add(workDaysModel.fromJson(value));
  //         _setCurrentDay(
  //             isToday: value['current_day'], datNum: value['day_num']);
  //       });
  //     } else {
  //       ApiChecker.checkApi(response);
  //     }
  //   }

  //   _isLoadingWorkDays = false;
  //   update();
  // }

  Future<void> getWaitingList({required bool reload}) async {
    _isLoading = true;
    update();
    if (_waitingList.isEmpty || reload) {
      Response response = await _waitingRepository.getWaitingList();

      if (response.statusCode == 200) {
        _waitingList.clear();
        response.body['data']['waiting_classes'].forEach((key, value) {
          if (value['waiting_classes'].isNotEmpty) {
            for (int i = 0; i < value['waiting_classes'].length; i++) {
              _waitingList
                  .add(waitingListModel.fromJson(value['waiting_classes'][i]));
            }
          }
        });
        filterData(index: Get.find<CalednerController>().selectedDayIndex);
        await _filterEmpty(list: _waitingList);
        //   await _fillAbsentInstructorList();
        //  await _fillWaitingInstructorList();
      } else {
        ApiChecker.checkApi(response);
      }
    }

    _isLoading = false;
    update();
  }

  Future<void> _filterEmpty({required List<waitingListModel> list}) async {
    _waitingList.removeWhere((element) => element.dayNum == null);
  }

  Future<void> _fillAbsentInstructorList() async {
    _waitingList.forEach((element) {
      _absentInstructorList.add(element.cell!.absentTeacherNickname.toString());
    });
  }

  Future<void> _fillWaitingInstructorList() async {
    _waitingList.forEach((element) {
      _absentInstructorList.add(element.waitingTeacher.toString());
    });
  }

  void toggleSelectedDay({required int index}) {
    Get.find<CalednerController>().selectedDayIndex = index;

    filterData(index: index);
    // Get.find<ClassRoomController>().filterData();
    update();
  }

  void _setCurrentDay({required bool isToday, required int datNum}) {
    if (isToday) {
      Get.find<CalednerController>().selectedDayIndex = datNum;
      update();
    }
  }

  // this function filters waiting list data based on the selected day or current index
  void filterData({required int index}) {
    _filterdWaitingList.clear();
    _filterdWaitingList.addAll(_waitingList.where((element) {
      return element.dayNum == index;
    }).toList());
    update();
  }

  Future<ResponseModel> deleteWaitingCLass(
      {required int waiting_class_id}) async {
    _selectedWaitingClassID = waiting_class_id;
    _isDeleteing = true;
    update();
    ResponseModel responseModel;
    Response response = await _waitingRepository.deleteWaitingCLass(
        waiting_class_id: waiting_class_id.toString());

    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['msg']);
      _localeDeleteing(waiting_class_id: waiting_class_id);
      _selectedWaitingClassID = 0;
    } else {
      ApiChecker.checkApi(response);
      responseModel = ResponseModel(false, response.body['msg']);
    }

    _isDeleteing = true;
    update();
    return responseModel;
  }

  Future<void> _localeDeleteing({required int waiting_class_id}) async {
    _filterdWaitingList
        .removeWhere((element) => element.waitingClassId == waiting_class_id);
    _waitingList
        .removeWhere((element) => element.waitingClassId == waiting_class_id);
  }
}
