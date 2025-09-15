import 'package:adary/features/table/controller/waiting_controller.dart';
import 'package:adary/features/table/data/repository/teacher_repository.dart';
import 'package:adary/features/table/view/base/custom_snack_bar.dart';
import 'package:get/get.dart';

import '../data/api/api_checker.dart';
import 'package:easy_localization/easy_localization.dart' as easy;

import '../data/model/response/absent_teacher_model.dart';

class TeacherController extends GetxController implements GetxService {
  late TeacherRepository _teacherRepository;
  TeacherController({required TeacherRepository teacherRepository}) {
    _teacherRepository = teacherRepository;
  }

  bool _isLoading = false;
  bool _isSending = false;

  final List<absetnTeacherModel> _teacherList = [];
  List<int> _absentTeachersIds = [];
  List<absetnTeacherModel> get teacherList => _teacherList;
  List<Map<String, String>> _failedmessages = [];
  List<Map<String, String>> get failedmessages => _failedmessages;

  List<Map<String, String>> _successmessages = [];
  List<Map<String, String>> get successmessages => _successmessages;
  bool get isLoading => _isLoading;
  bool get isSending => _isSending;

  Future<void> getAllTeachers(
      {required bool reload, required String dayNum}) async {
    _teacherList.clear();
    _isLoading = true;
    update();
    if (_teacherList.isEmpty || reload) {
      Response response =
          await _teacherRepository.getTechersList(dayNum: dayNum);
      if (response.statusCode == 200) {
        _teacherList.clear();
        _absentTeachersIds.clear();
        if (response.body['data']['teachers_list'] == null) {
          showCustomSnackBar(easy.tr("${response.body['msg']}"),
              isError: false);
        } else {
          response.body['data']['teachers_list'].forEach((value) {
            _teacherList.add(absetnTeacherModel.fromJson(value));
          });
        }
      } else {
        ApiChecker.checkApi(response);
      }
    }

    _isLoading = false;
    update();
  }

  Future<void> setAbsentTeachers({required int dayNum}) async {
    if (_absentTeachersIds.isNotEmpty) {
      _isSending = true;
      update();

      Response response = await _teacherRepository.setAbsentTechers(
          absentTeachersIds: _absentTeachersIds, dayNum: dayNum);
      _failedmessages.clear();
      response.body["data"]["waiting_classes"].forEach((e) {
        if (e["waiting_class_added"] == false &&
            e["waiting_class_already_exists"] == false) {
          _failedmessages.add(
              {"note": e["note"].toString(), "title": e["title"].toString()});
        } else {
          _successmessages.add({
            "note": e["note"].toString(),
            "cell_text": e["cell"]["cell_text"].toString()
          });
        }
      });

      if (response.statusCode == 200) {
        Get.find<WaitingController>().getWaitingList(reload: true);
        showCustomSnackBar(easy.tr("added_to_upsent_teacher"), isError: false);

        _absentTeachersIds.clear();
      } else {
        ApiChecker.checkApi(response);
      }
      _isSending = false;
      update();
    } else {
      showCustomSnackBar(easy.tr("add_one_teacher_atleast"), isError: true);
    }
  }

  void toggleAbsent({required int instructorID}) {
    _teacherList.forEach((element) {
      if (element.id == instructorID) {
        element.hasAbsentToday = !element.hasAbsentToday!;
        if (element.hasAbsentToday!) {
          _setAbsentTeachersIds(teacherId: instructorID);
        } else {
          _removeFromAbsentTeachersList(teacherId: instructorID);
        }
        update();
      }
    });
  }

  void _setAbsentTeachersIds({required int teacherId}) {
    _absentTeachersIds.add(teacherId);
  }

  void _removeFromAbsentTeachersList({required int teacherId}) {
    _absentTeachersIds.removeWhere((Value) => Value == teacherId);
  }
}
