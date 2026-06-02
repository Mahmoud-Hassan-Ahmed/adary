import 'package:adary/features/table/data/model/response/classes_meta.dart';
import 'package:adary/features/table/data/model/response/table_model.dart';
import 'package:adary/features/table/data/repository/class_room_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/api/api_checker.dart';

class ClassRoomController extends GetxController implements GetxService {
  late ClassRoomRepository _classRoomRepository;
  ClassRoomController({required ClassRoomRepository classRoomRepository}) {
    _classRoomRepository = classRoomRepository;
  }

  final tableClassController = PageController();
  List<dynamic> _tablesList = [];
  List<dynamic> get tablesList => _tablesList;

  ClassesMeta _selectedClassModel = ClassesMeta(classId: 222, ClassName: "all");
  ClassesMeta get selectedClassModel => _selectedClassModel;
  String? _selectedClassId = null;
  String? get selectedClassId => _selectedClassId;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _isLoadingTables = false;
  bool get isLoadingTables => _isLoadingTables;
  List<ClassesMeta> _classesNames = [];
  List<Map<String, dynamic>> _singleClassTodayTable = [];
  List<Map<String, dynamic>> _allClassTable = [];
  List<Map<String, dynamic>> _classTableListIdBased = [];
  List<Map<String, dynamic>> get classTableListIdBased =>
      _classTableListIdBased;
  List<Map<String, dynamic>> get singleClassTodayTable =>
      _singleClassTodayTable;
  List<Map<String, dynamic>> get allClassTable => _allClassTable;
  Map<String, dynamic> _tableMap = {};
  Map<String, dynamic> get tableMap => _tableMap;
  List<Map<String, dynamic>> _singleClassTableMap = [];
  List<Map<String, dynamic>> get singleClassTableMap => _singleClassTableMap;

  List<tableModel> _classesTableList = [];
  List<tableModel> get classesTableList => _classesTableList;
  List<ClassesMeta> get classesNames => _classesNames;
  int currentIndex = 0;
  void onPageChanged(int index) {
    currentIndex = index;
    update();
  }

  final Map<String, String> _sessions = {
    "0": "first",
    "1": "second",
    "2": "three",
    "3": "four",
    "4": "five",
    "5": "six",
    "6": "seven",
    "7": "eight",
    "8": "nine",
    "9": "ten",
  };

  Map<String, String> get sessions => _sessions;

  Future<void> loadData() async {
    await getClassRoomNames(reload: true);
    await getClassesTables(reload: true);
  }

  Future<void> getClassRoomNames({required bool reload}) async {
    if (_classesNames.isEmpty || reload) {
      _isLoading = true;
      update();

      Response response = await _classRoomRepository.getClassRoomPages();

      if (response.statusCode == 200) {
        _classesNames.clear();
        _initSelectedClassRoom();
        await _saveClassesNames(
            classesList: response.body['data']['classrooms_list']);
      } else {
        ApiChecker.checkApi(response);
      }
      _isLoading = false;
      update();
    }
  }

  Future<void> _saveClassesNames({required List<dynamic> classesList}) async {
    classesList.forEach((value) {
      _classesNames.add(ClassesMeta(classId: value[0], ClassName: value[1]));
    });

    update();
  }

  void _initSelectedClassRoom() {
    _selectedClassModel = ClassesMeta(classId: 222, ClassName: "all");
    _classesNames.add(_selectedClassModel);
  }

  Future<void> getClassesTables({required bool reload}) async {
    _isLoadingTables = true;
    update();
    if (reload || _tableMap.isEmpty) {
      Response response = await _classRoomRepository.getClassRoomPages();
      if (response.statusCode == 200) {
        _tableMap.clear();
        _saveTables(tables: response.body['data']["tables"]);
      } else {
        ApiChecker.checkApi(response);
      }
    }
    _isLoadingTables = false;
    update();
  }

  Future<void> _saveTables({required Map<String, dynamic> tables}) async {
    tables.forEach((key, value) {
      _tableMap.putIfAbsent(
          key,
          () => {
                "classroom_id": value['classroom_id'],
                "classroom_name": value['classroom_name'],
                "table": value['table']
              });
    });
    convertTablesToList();
  }

  Future<void> convertTablesToList() async {
    _tablesList.clear();
    _tablesList = _tableMap.entries.map((e) {
      return e.value;
    }).toList();
  }

  // ignore: non_constant_identifier_names
  Future<void> FilterTeacherTableList() async {
    _tablesList.clear();

    if (_selectedClassModel.classId == 222) {
      convertTablesToList();
    } else {
      _tableMap.entries.forEach((e) {
        if (e.value["classroom_id"] == _selectedClassModel.classId) {
          _tablesList.add(e.value);
        }
      });
    }
    update();
  }

  void changeDropDownSelector({required ClassesMeta selectedClassModel}) {
    //_expansionTileController.collapse();
    _selectedClassModel = selectedClassModel;

    update();
  }

  // end of refactoring
}
