import 'package:adary/features/table/controller/calender_controller.dart';
import 'package:adary/features/table/data/model/response/teacher_table.dart';
import 'package:adary/features/table/data/repository/teacher_page_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/api/api_checker.dart';
import '../data/model/response/response_model.dart';
import '../data/model/response/teacher_name.dart';

class TeacherPageController extends GetxController implements GetxService {
  late TeacherPageRepository _teacherPageRepository;
  TeacherPageController(
      {required TeacherPageRepository teacherPageRepository}) {
    _teacherPageRepository = teacherPageRepository;
  }

  bool _isLoading = false;
  bool _isSendingMsg = false;
  bool get isLoading => _isLoading;
  bool _isLoadingTable = false;
  bool get isSendingMsg => _isSendingMsg;
  bool get isLoadingTable => _isLoadingTable;

  List<dynamic> _teachersTableList = [];
  List<dynamic> get teachersTableList => _teachersTableList;

  teacherNamesModel _selectedTeacherModel =
      teacherNamesModel(teacherId: 111, teacherName: "all");

  teacherNamesModel get selectedTeacherModel => _selectedTeacherModel;

  Map<String, dynamic> _Teacherstables = {};
  Map<String, dynamic> get Teacherstables => _Teacherstables;

  final List<teacherNamesModel> _teacherList = [];
  final List<teacherTableModel> _teachersTable = [];
  final List<teacherNamesModel> _paginatedTeacherList = [];

  List<teacherNamesModel> get paginatedTeacherList => _paginatedTeacherList;
  List<teacherNamesModel> get teacherList => _teacherList;
  List<teacherTableModel> get teachersTable => _teachersTable;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _msgController = TextEditingController();
  GlobalKey<FormState> get formkey => _formKey;
  TextEditingController get msgController => _msgController;

  List<String> _classesNamesAndNumbers = [];
  List<String> get classesNamesAndNumbers => _classesNamesAndNumbers;

  int _pageSize = 10;
  int get pageSize => _pageSize;

  Future<void> loadData() async {
    await getTeachersList(reload: true);
    await getTeachersTable(reload: true);
    await getClassesNamesAndNumbers(reload: true);
    await Get.find<CalednerController>().getWorkDays(reload: true);
  }

  Future<void> getClassesNamesAndNumbers({required bool reload}) async {
    if (_classesNamesAndNumbers.isEmpty || reload) {
      Response response = await _teacherPageRepository.getClassessData();

      if (response.statusCode == 200) {
        _classesNamesAndNumbers.clear();

        response.body['data']['classes'].forEach((k, v) {
          _classesNamesAndNumbers.add(v["class_text"]);
        });
      } else {
        ApiChecker.checkApi(response);
      }
    }
  }

  Future<void> getTeachersList({required bool reload}) async {
    _isLoading = true;
    update();
    if (_teacherList.isEmpty || reload) {
      Response response = await _teacherPageRepository.getTechersList();
      if (response.statusCode == 200) {
        _teacherList.clear();
        initSelectedTeacherModel();
        response.body['data']['teachers_list'].forEach((value) {
          _teacherList.add(teacherNamesModel(
              teacherId: value[0], teacherName: value[1].toString()));
        });
        // _initPageSized();
      } else {
        ApiChecker.checkApi(response);
      }
    }

    _isLoading = false;
    update();
  }

  void initSelectedTeacherModel() {
    _selectedTeacherModel =
        teacherNamesModel(teacherId: 111, teacherName: "all");
    _teacherList.add(_selectedTeacherModel);
  }

  Future<void> getTeachersTable({required bool reload}) async {
    _isLoadingTable = true;
    update();
    if (_teacherList.isEmpty || reload) {
      Response response = await _teacherPageRepository.getTechersList();
      if (response.statusCode == 200) {
        _Teacherstables.clear();
        await _storeTables(tables: response.body['data']['tables']);
      } else {
        ApiChecker.checkApi(response);
      }
    }

    _isLoadingTable = false;
    update();
  }

  Future<void> _storeTables({required Map<String, dynamic> tables}) async {
    tables.forEach((key, value) {
      _Teacherstables.putIfAbsent(
          key,
          () => {
                "teacher_id": value['teacher_id'],
                "teacher_name": value['teacher_name'],
                "table": value['table']
              });
    });
    convertToList();
  }

  Future<void> convertToList() async {
    _teachersTableList.clear();
    _teachersTableList = _Teacherstables.entries.map((e) {
      return e.value;
    }).toList();
  }

  // ignore: non_constant_identifier_names
  Future<void> FilterTeacherTableList() async {
    _isLoadingTable = true;
    update();
    _teachersTableList.clear();

    if (_selectedTeacherModel.teacherId == 111) {
      convertToList();
    } else {
      _Teacherstables.entries.forEach((e) {
        if (e.value["teacher_id"] == _selectedTeacherModel.teacherId) {
          _teachersTableList.add(e.value);
        }
      });
    }
    _isLoadingTable = false;
    update();
  }

  Future<ResponseModel> sendNotification({required teacherID}) async {
    _isSendingMsg = true;
    update();
    ResponseModel responseModel;
    Response response = await _teacherPageRepository.sendNotification(
        teacherId: teacherID, message: _msgController.text.trim());
    if (response.statusCode == 200) {
      _msgController.clear();
      responseModel = ResponseModel(true, response.body['msg']);
    } else {
      responseModel = ResponseModel(false, response.body['msg']);
      ApiChecker.checkApi(response);
    }

    _isSendingMsg = false;
    update();
    return responseModel;
  }

  void changeSelectedInstructorId({required teacherNamesModel teacherModel}) {
    _selectedTeacherModel = teacherModel;
    update();
  }

  int _pageIndex = 0;

  final tableController = PageController();
  int currentIndex = 0;

  int get pageIndex => _pageIndex;

  void onPageChanged(int index) {
    _pageIndex = index;
    currentIndex = index;
    update();
  }

  void onTapPager(int index) {
    tableController.jumpToPage(index);
    _pageIndex = index;
    update();
  }
}
