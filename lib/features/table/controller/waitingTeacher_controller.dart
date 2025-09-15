import 'package:adary/features/table/controller/waiting_controller.dart';
import 'package:adary/features/table/data/model/response/waiting_teacher.dart';
import 'package:adary/features/table/data/repository/waitingTeacher_repository.dart';
import 'package:get/get.dart';

import '../data/api/api_checker.dart';
import '../data/model/body/add_waiting_teacher_model.dart';
import '../data/model/response/add_waiting_class_model.dart';

class WaitingTeacherController extends GetxController implements GetxService {
  late WaitingTeacherRepository _waitingTeacherRepository;
  WaitingTeacherController(
      {required WaitingTeacherRepository waitingTeacherRepository}) {
    _waitingTeacherRepository = waitingTeacherRepository;
  }

  String? _waitingTeacherWCID = null;
  String? _waitingTeacherCELLID = null;

  int _selectedInstructorIndex = 0;
  List<waitingTeacherModel> _waitingTeacherList = [];
  bool _isLoadingWaitingTeacher = false;
  bool _isLoadingWaitingTeacherBtn = false;
  bool get isLoadingWaitingTeacher => _isLoadingWaitingTeacher;
  String? get waitingTeacherWCID => _waitingTeacherWCID;
  String? get waitingTeacherCELLID => _waitingTeacherCELLID;
  bool get isLoadingWaitingTeacherBtn => _isLoadingWaitingTeacherBtn;
  List<waitingTeacherModel> get waitingTeacherList => _waitingTeacherList;
  int get selectedInstructorIndex => _selectedInstructorIndex;

  Future<void> getWaitingTeacher(
      {required bool reload, required String cellId}) async {
    _waitingTeacherList.clear();
    _isLoadingWaitingTeacher = true;
    _setCellId(cellId: cellId);
    _reInitializeTeacherWCID();
    update();
    if (_waitingTeacherList.isEmpty || reload) {
      Response response =
          await _waitingTeacherRepository.getWaitingTeacherList(cId: cellId);
      if (response.statusCode == 200) {
        response.body['data']['waiting_teachers_list'].forEach((value) {
          _waitingTeacherList.add(waitingTeacherModel.fromJson(value));
          _initSelectedInstructorIndex(
              index: value['teacher_id'], isTrue: value['current']);
        });
      } else {
        ApiChecker.checkApi(response);
      }
    }

    _isLoadingWaitingTeacher = false;
    update();
  }

  Future<addWaitingTeacherModel> addWaitingTeacher() async {
    _isLoadingWaitingTeacherBtn = true;
    update();

    if (_waitingTeacherWCID != null && _waitingTeacherWCID != null) {
      Response response = await _waitingTeacherRepository.addWaitingTeacher(
          CELL_ID: _waitingTeacherCELLID!, WCT_ID: _waitingTeacherWCID!);
      if (response.statusCode == 200) {
        Get.find<WaitingController>().getWaitingList(reload: true);
        _reInitializeTeacherWCID();
        addWaitingClassTeacherModel model =
            addWaitingClassTeacherModel.fromJson(response.body);
        _isLoadingWaitingTeacherBtn = false;
        update();
        return addWaitingTeacherModel(
            isSuccess: true, newWaitingTeacherModel: model);
      } else {
        ApiChecker.checkApi(response);
      }
      _isLoadingWaitingTeacherBtn = false;
      update();
    } else {
      _isLoadingWaitingTeacherBtn = false;
      update();
    }
    return addWaitingTeacherModel(
        isSuccess: false, newWaitingTeacherModel: null);
  }

  void setSelectedInstructorIndex({required index, required String WCTID}) {
    _selectedInstructorIndex = index;
    _waitingTeacherWCID = WCTID;

    update();
  }

  void _setCellId({required String cellId}) {
    _waitingTeacherCELLID = cellId;
  }

  void _reInitializeTeacherWCID() {
    _waitingTeacherWCID = null;
  }

  void _initSelectedInstructorIndex({required index, required bool isTrue}) {
    if (isTrue) {
      _selectedInstructorIndex = index;
      update();
    }
  }
}
