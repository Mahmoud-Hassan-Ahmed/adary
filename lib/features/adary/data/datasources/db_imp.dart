import 'package:adary/features/adary/domain/entities/student_conduct_entity.dart';
import 'package:adary/features/adary/data/models/student_conduct.dart';
import 'dart:convert';

import 'package:adary/core/conts/api.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/datasources/db.dart';
import 'package:adary/features/adary/data/models/attendance_statistics_model.dart';
import 'package:adary/features/adary/data/models/behavior_statistics_model.dart';
import 'package:adary/features/adary/data/models/circular_model.dart';
import 'package:adary/features/adary/data/models/class_health.dart';
import 'package:adary/features/adary/data/models/class_room.dart';
import 'package:adary/features/adary/data/models/classes.dart';
import 'package:adary/features/adary/data/models/duty_model.dart';
import 'package:adary/features/adary/data/models/evaluation_model.dart';
import 'package:adary/features/adary/data/models/evidence_model.dart';
import 'package:adary/features/adary/data/models/exam_model.dart';
import 'package:adary/features/adary/data/models/health_model.dart';
import 'package:adary/features/adary/data/models/model18.dart';
import 'package:adary/features/adary/data/models/model_19.dart';
import 'package:adary/features/adary/data/models/model_20.dart';
import 'package:adary/features/adary/data/models/note_entity_model.dart';
import 'package:adary/features/adary/data/models/note_teacher.dart';
import 'package:adary/features/adary/data/models/pagination_model.dart';
import 'package:adary/features/adary/data/models/requests_model.dart';
import 'package:adary/features/adary/data/models/student_model.dart';
import 'package:adary/features/adary/data/models/student_per.dart';
import 'package:adary/features/adary/data/models/task_model.dart';
import 'package:adary/features/adary/data/models/task_teacher_mdel.dart';
import 'package:adary/features/adary/data/models/teacher_circular.dart';
import 'package:adary/features/adary/data/models/teacher_model.dart';
import 'package:adary/features/adary/data/models/user_app.dart';
import 'package:adary/features/adary/data/models/visits_model.dart';
import 'package:adary/features/adary/data/models/week_group.dart';
import 'package:adary/features/adary/data/models/week_plan.dart';
import 'package:adary/features/adary/data/models/weekly_pan.dart';
import 'package:adary/features/adary/data/models/wishes_model.dart';
import 'package:adary/features/adary/domain/entities/base_enity.dart';
import 'package:adary/features/adary/domain/entities/change_status_entity.dart';
import 'package:adary/features/adary/domain/entities/circular_entity.dart';
import 'package:adary/features/adary/domain/entities/class_entity.dart';
import 'package:adary/features/adary/domain/entities/delay_entity.dart';
import 'package:adary/features/adary/domain/entities/manager_decision_entity.dart';
import 'package:adary/features/adary/domain/entities/delete_entity.dart';
import 'package:adary/features/adary/domain/entities/duty_filter_entity.dart';
import 'package:adary/features/adary/domain/entities/evidence_entity.dart';
import 'package:adary/features/adary/domain/entities/file_download_entity.dart';
import 'package:adary/features/adary/domain/entities/filter_per.dart';
import 'package:adary/features/adary/domain/entities/filter_report_entity.dart';
import 'package:adary/features/adary/domain/entities/health_entity.dart';
import 'package:adary/features/adary/domain/entities/login_entity.dart';
import 'package:adary/features/adary/domain/entities/note_entity.dart';
import 'package:adary/features/adary/domain/entities/pagination_entity.dart';
import 'package:adary/features/adary/domain/entities/register_student_entity.dart';
import 'package:adary/features/adary/domain/entities/student_entity.dart';
import 'package:adary/features/adary/domain/entities/task_entity.dart';
import 'package:adary/features/adary/domain/entities/teacher_circular_entity.dart';
import 'package:adary/features/adary/domain/entities/teacher_task.dart';
import 'package:adary/features/adary/domain/entities/teachers_entity.dart';
import 'package:adary/features/adary/domain/entities/visits_entity.dart';
import 'package:adary/features/adary/domain/entities/wishes_entity.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

class DbImp implements Db {
  final Dio dio;

  DbImp({required this.dio});

  @override
  Future<List<NoteModel>> getNotes() async {
    final response = await dio.get('${Api.notes}list_all/');
    return AppUtils.generateList(response.data, NoteModel.fromJson);
  }

  @override
  Future<List<Teacher>> getTeacher() async {
    if (AppUtils.appUser!.isFollowerActive) {
      final response = await dio.get(Api.teachers);
      return AppUtils.generateList(response.data, Teacher.fromJson);
    } else {
      final response = await dio.get('dashboard-mobile/set-absent-teachers/0/');
      return AppUtils.generateList(
          response.data['data']['teachers_list'], Teacher.fromJson);
    }
  }

  @override
  Future<void> createNotTeacher(TeachersEntity data) async {
    final response =
        await dio.post(Api.monitorNote, data: data.monitorNoteEntity.toJson());
    final id = response.data['id'];
    List<Map<String, dynamic>> jsonList = data.list
        .map((teacherNote) => (teacherNote..monitorNote = id).toJson())
        .toList();
    await dio.post(Api.ceateNotTeacher, data: jsonEncode(jsonList));
  }

  @override
  Future<void> updateNoteTeacher(TeachersEntity data) async {
    final response =
        await dio.post(Api.monitorNote, data: data.monitorNoteEntity.toJson());
    final id = response.data['id'];
    await dio.patch("${Api.ceateNotTeachers}${data.list.first.id}/",
        data: (data.list.first..monitorNote = id).toJson());
  }

  @override
  Future<void> createCircular(CircularEntity data) async {
    final response = await dio.post(Api.circulars, data: await data.getform());
    if (!data.selectAll) {
      List<Map<String, dynamic>> jsonList = data.teachers
          .map((teacher) => TeacherCircularEntity(
                  administrativeCirculars: response.data['id'],
                  isSignature: false,
                  teacher: teacher.id)
              .toJson())
          .toList();

      await dio.post(
          '${Api.circulars}${response.data['id']}/teacher-circulars/',
          data: jsonEncode(jsonList));
    }
  }

  @override
  Future<List<Classes>> getClasses() async {
    final response = await dio.get(Api.classes);
    return AppUtils.generateList(response.data, Classes.fromJson);
  }

  @override
  Future<void> createStudent(BaseEnity entity) async {
    await dio.post(Api.students, data: entity.toJson());
  }

  @override
  Future<void> crateModel18(BaseEnity entity) async {
    await dio.post(Api.model18, data: entity.toJson());
  }

  @override
  Future<PageinationModel<Model18Model>> getModel18(
      PaginationEntity entity) async {
    final response = await dio.get('${Api.model18}?page=${entity.page}');
    return PageinationModel.fromJson(response.data, Model18Model.fromJson);
  }

  @override
  Future<void> doenlaodFileDelay(FileDownloadEneity entity) async {
    EasyLoading.show();
    await dio.download(
        "${Api.model18}${entity.id}/download/", entity.pathDownload);
  }

  @override
  Future<void> deleteDelay(DeleteEntity entity) async {
    await dio.delete('${Api.model18}${entity.id}/');
  }

  @override
  Future<void> updateDelay(Model18 enity) async {
    await dio.patch('${Api.model18}${enity.id}/', data: enity.toJson());
  }

  @override
  Future<void> crateModel19(BaseEnity entity) async {
    await dio.post(Api.model19, data: entity.toJson());
  }

  @override
  Future<void> deleteModel19(DeleteEntity entity) async {
    await dio.delete('${Api.model19}${entity.id}/');
  }

  @override
  Future<void> doenlaodFileModel19(FileDownloadEneity entity) async {
    EasyLoading.show();
    await dio.download(
        "${Api.model19}${entity.id}/download/", entity.pathDownload);
  }

  @override
  Future<PageinationModel<Model19Model>> getModel19(
      PaginationEntity entity) async {
    final response = await dio.get('${Api.model19}?page=${entity.page}');
    return PageinationModel.fromJson(response.data, Model19Model.fromJson);
  }

  @override
  Future<void> updateModel19(Model19 enity) async {
    await dio.patch('${Api.model19}${enity.id}', data: enity.toJson());
  }

  @override
  Future<void> crateModel20(BaseEnity entity) async {
    await dio.post(Api.model20, data: entity.toJson());
  }

  @override
  Future<void> deleteModel20(DeleteEntity entity) async {
    await dio.delete('${Api.model20}${entity.id}/');
  }

  @override
  Future<void> doenlaodFileModel20(FileDownloadEneity entity) async {
    EasyLoading.show();
    await dio.download(
        "${Api.model20}${entity.id}/download/", entity.pathDownload);
  }

  @override
  Future<PageinationModel<Model20Model>> getModel20(
      PaginationEntity entity) async {
    final response = await dio.get('${Api.model20}?page=${entity.page}');
    return PageinationModel.fromJson(response.data, Model20Model.fromJson);
  }

  @override
  Future<void> updateModel20(Model20 enity) async {
    await dio.patch('${Api.model20}${enity.id}', data: enity.toJson());
  }

  @override
  Future<void> sendModel18Decision(ManagerDecisionEntity entity) async {
    await dio.post('${Api.model18}${entity.id}/decision/',
        data: entity.toJson());
  }

  @override
  Future<void> sendModel20Decision(ManagerDecisionEntity entity) async {
    await dio.post('${Api.model20}${entity.id}/decision/',
        data: entity.toJson());
  }

  @override
  Future<PageinationModel<StudentModel>> getStudents(
      PaginationEntity entity) async {
    var url = '${Api.studentsPage}?page=${entity.page}';
    if (entity.classId != null) {
      url += '&&class_id=${entity.classId!}';
    }
    final response = await dio.get(url);
    return PageinationModel.fromJson(response.data, StudentModel.fromJson);
  }

  @override
  Future<List<Classroom>> getClassRooms() async {
    final response = await dio.get(Api.classRoom);
    return AppUtils.generateList(response.data, Classroom.fromMap);
  }

  @override
  Future<void> addClass(ClassEntity student) async {
    await dio.post(Api.classes, data: student.toJson());
  }

  @override
  Future<void> deleteClass(DeleteEntity student) async {
    await dio.delete("${Api.classes}${student.id}/");
  }

  @override
  Future<void> deleteStudent(DeleteEntity student) async {
    await dio.delete("${Api.students}${student.id}/");
  }

  @override
  Future<void> updateClass(ClassEntity student) async {
    await dio.patch("${Api.classes}${student.id}/", data: student.toJson());
  }

  @override
  Future<void> updatestudent(StudentEntity student) async {
    await dio.patch("${Api.students}${student.id}/", data: student.toJson());
  }

  @override
  Future<PageinationModel<VisitModel>> getVisits(
      PaginationEntity entity) async {
    final response = await dio.get("${Api.visits}?page=${entity.page}");

    return PageinationModel.fromJson(response.data, VisitModel.fromJson);
  }

  @override
  Future<void> addVisit(BaseEnity entity) async {
    await dio.post(Api.visits, data: entity.toJson());
  }

  @override
  Future<void> deleteVisit(DeleteEntity entity) async {
    await dio.delete("${Api.visits}${entity.id}/");
  }

  @override
  Future<void> updateVisit(VisitEntity entity) async {
    await dio.patch("${Api.visits}${entity.id}/", data: entity.toJson());
  }

  @override
  Future<void> addHealths(BaseEnity entity) async {
    await dio.post(Api.healths, data: entity.toJson());
  }

  @override
  Future<void> deketeHealth(DeleteEntity entity) async {
    await dio.delete("${Api.healths}${entity.id}/");
  }

  @override
  Future<PageinationModel<HealthCondition>> gethealths(
      PaginationEntity entity) async {
    final response = await dio
        .get("${Api.healths}?page=${entity.page}&class_id=${entity.classId}");

    return PageinationModel.fromJson(response.data, HealthCondition.fromJson);
  }

  @override
  Future<void> updateHealth(HealthEntity entity) async {
    await dio.patch("${Api.healths}${entity.id}/", data: entity.toJson());
  }

  @override
  Future<List<ClassHealth>> classsHealth() async {
    final response = await dio.get(Api.classsHealth);
    return AppUtils.generateList(response.data, ClassHealth.fromMap);
  }

  @override
  Future<void> addNore(BaseEnity entity) async {
    await dio.post(Api.notes, data: entity.toJson());
  }

  @override
  Future<PageinationModel<NoteModel>> notes(PaginationEntity entity) async {
    final response = await dio.get("${Api.notes}?page=${entity.page}");

    return PageinationModel.fromJson(response.data, NoteModel.fromJson);
  }

  @override
  Future<PageinationModel<NotesTeacher>> noteTeacher(
      PaginationEntity entity) async {
    final response = await dio.get(
        "${Api.ceateNotTeachers}?page=${entity.page}&created_at_after=${entity.startDate}&created_at_before=${entity.endDate}&teacher=${entity.teacher}&monitor_note_note=${entity.note}");

    return PageinationModel.fromJson(response.data, NotesTeacher.fromJson);
  }

  @override
  Future<void> deleteNote(DeleteEntity entity) async {
    await dio.delete(
      "${Api.notes}${entity.id}/",
    );
  }

  @override
  Future<void> deleteNoteTeacher(DeleteEntity entity) async {
    await dio.delete(
      "${Api.ceateNotTeachers}${entity.id}/",
    );
  }

  @override
  Future<void> updateNote(NoteEntity entity) async {
    await dio.patch("${Api.notes}${entity.id}/", data: entity.toJson());
  }

  @override
  Future<PageinationModel<AdministrativeCircular>> circulars(
      PaginationEntity entity) async {
    final response = await dio.get("${Api.circulars}?page=${entity.page}");

    return PageinationModel.fromJson(
        response.data, AdministrativeCircular.fromJson);
  }

  @override
  Future<void> deleteCircular(DeleteEntity entity) async {
    await dio.delete(
      "${Api.circulars}${entity.id}/",
    );
  }

  @override
  Future<void> updateCircular(CircularEntity entity) async {
    final response = await dio.patch("${Api.circulars}${entity.id}/",
        data: await entity.getform());
    if (!entity.selectAll) {
      List<Map<String, dynamic>> jsonList = entity.teachers
          .map((teacher) => TeacherCircularEntity(
                  administrativeCirculars: response.data['id'],
                  isSignature: false,
                  teacher: teacher.id)
              .toJson())
          .toList();

      await dio.post(
          '${Api.circulars + response.data['id'].toString()}/teacher-circulars/',
          data: jsonEncode(jsonList));
    }
  }

  @override
  Future<PageinationModel<TeacherCircular>> teachersCirculars(
      PaginationEntity entity) async {
    final response = await dio.get(
        "${Api.circulars}${entity.classId}/teacher-circulars/?page=${entity.page}");

    return PageinationModel.fromJson(response.data, TeacherCircular.fromJson);
  }

  @override
  Future<List<TeacherCircular>> getAllTeachers(PaginationEntity entity) async {
    final response = await dio
        .get("${Api.circulars}${entity.classId}/teacher-circulars/list_all/");
    return AppUtils.generateList(response.data, TeacherCircular.fromJson);
  }

  @override
  Future<PageinationModel<Plan>> getWeekPan(PaginationEntity entity) async {
// &created_at_afte=${entity.startDate}&created_at_before=${entity.endDate}&teacher=${entity.classId}
    final response = await dio.get(
        "api/weekly-plan/week-info/${entity.classId}/?page=${entity.page}");

    return PageinationModel.fromJson(response.data, Plan.fromJson);
  }

  @override
  Future<void> deletePlan(DeleteEntity entity) async {
    await dio.delete(
      "api/weekly-plan/plan/delete/${entity.id}/",
    );
  }

  @override
  Future<void> exportPdfTeacherNote(PaginationEntity entity) async {
    EasyLoading.show();
    await dio.download(
        "${Api.ceateNotTeacher}export-pdf/?created_at_after=${entity.startDate}&created_at_before=${entity.endDate}&teacher=${entity.teacher}&monitor_note_note=${entity.note}",
        entity.savePath);
  }

  @override
  Future<void> exportPdfHealthsNote(FileDownloadEneity entity) async {
    EasyLoading.show();
    await dio.download("${Api.healths}/export-pdf/", entity.pathDownload);
  }

  @override
  Future<void> exportPdfVisitssNote(FileDownloadEneity entity) async {
    EasyLoading.show();
    await dio.download("${Api.visits}/export-pdf/", entity.pathDownload);
  }

  @override
  Future<void> exportPdfCirculersNote(FileDownloadEneity entity) async {
    EasyLoading.show();
    await dio.download("${Api.circulars}/export-pdf/", entity.pathDownload);
  }

  @override
  Future<void> login(LoginEntity entity) async {
    // await AppUtils.instance.login(entity);
    final respone = await dio.post(Api.login, data: entity.toJson());
    if (respone.data['success']) {
      AppUtils.instance.setcredinal(entity);
      await AppUtils.instance.login(LoginEntity(
          username: respone.data['data']['username'],
          password: respone.data['data']['app-key'],
          permissions: List<String>.from(respone.data['data']['permissions'])));

      final response = await dio.get(Api.me);
      await AppUtils.instance.setUser(AppUser.fromJson({
        ...response.data['data'],
        'app-key': respone.data['data']['app-key'],
      }, password: entity.password));
    }

    // await AppUtils.instance.setUser(AppUser.fromJson(respone.data['data']));
  }

  @override
  Future<PageinationModel<DailyTaskModel>> taskTeacher(
      PaginationEntity entity) async {
    final response = await dio
        .get('${Api.dellayTask}?page=${entity.page}&filter=${entity.endDate}');
    return PageinationModel.fromJson(response.data, DailyTaskModel.fromJson);
  }

  @override
  Future<List<TaskModel>> getTadks() async {
    final response = await dio.get(Api.taskList);
    return AppUtils.generateList(response.data['results'], TaskModel.fromJson);
  }

  @override
  Future<void> addTaskTeacher(BaseEnity entity) async {
    await dio.post(Api.createTask, data: entity.toJson());
  }

  @override
  Future<void> addtask(BaseEnity entity) async {
    await dio.post(Api.taskList, data: entity.toJson());
  }

  @override
  Future<void> removeTask(DeleteEntity entity) async {
    await dio.delete(
      "${Api.taskList}${entity.id}/",
    );
  }

  @override
  Future<void> removeTaskTeacher(DeleteEntity entity) async {
    await dio.delete(
      "${Api.dellayTask}${entity.id}/",
    );
  }

  @override
  Future<void> updateTask(BaseEnity entity) async {
    await dio.patch("${Api.taskList}${(entity as TaskEntity).id}/",
        data: entity.toJson());
  }

  @override
  Future<void> updateTaskTeacher(BaseEnity entity) async {
    await dio.patch("${Api.dellayTask}${(entity as TeacherTask).id}/",
        data: entity.toJson());
  }

  @override
  Future<void> me() async {
    final response = await dio.get(Api.me);

    AppUtils.instance
        .setUser(AppUser.fromJsom2(AppUtils.appUser!, response.data['data']));
  }

  @override
  Future<void> loadCalendart() async {
    final year = [2025, 2026];
    const url = "https://api.aladhan.com/v1/gToHCalendar/";
    for (var i = 0; i < 2; i++) {
      for (var month = 1; month <= 12; month++) {
        final http.Response response;
        try {
          response = await http.get(Uri.parse('$url$month/${year[i]}'));
        } catch (e) {
          // انقطاع الشبكة يُفشل الأربعة والعشرين نداءً جميعًا، فالإصرار عليها
          // يعني انتظار أربع وعشرين مهلة بلا فائدة. يُحفظ ما حُمّل ويُخرج.
          AppUtils.log('تعذّر تحميل التقويم الهجري: $e');
          AppUtils.instance.saveDatesMapToStorage();
          return;
        }
        // AppUtils.log(response.statusCode.toString());
        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          if (data['status'] == 'OK' && data['data'] != null) {
            for (var entry in data['data']) {
              String gregorianDate = entry['gregorian']['date'] ?? '';
              String hijriDate = entry['hijri']['date'] ?? '';

              if (gregorianDate.isNotEmpty && hijriDate.isNotEmpty) {
                AppUtils.datesMap[gregorianDate] = {
                  "day": hijriDate,
                  "month": entry['hijri']['month']['ar']
                };
              }
            }
          }
        } else {
          print('Failed to load data for month $month');
        }
      }
    }
    AppUtils.instance.saveDatesMapToStorage();
  }

  @override
  Future<PageinationModel<WeeklyPan>> getWeeks(PaginationEntity entity) async {
    final response = await dio.get(
        '${Api.weekly}?page=${entity.page}&teacher_id=${entity.teacher}&start_date=${entity.startDate ?? ''}&end_date=${entity.endDate ?? ''}');
    return PageinationModel.fromJson(response.data, WeeklyPan.fromJson);
  }

  @override
  Future<PageinationModel<StudentPer>> filterPer(FilterPer entity) async {
    final response =
        await dio.get(Api.attendnce, queryParameters: entity.toJson());

    return PageinationModel.fromJson(response.data, StudentPer.fromJson);
  }

  @override
  Future<PageinationModel<StudentInfo>> filterstudents(FilterPer entity) async {
    final response =
        await dio.get(Api.studentList, queryParameters: entity.toJson());

    return PageinationModel.fromJson(response.data, StudentInfo.fromJson);
  }

  @override
  Future<void> registerStudemt(List<BaseEnity> date) async {
    AppUtils.log("sendPost");
    final response = await dio.post(
      Api.attendnce,
      data: date.map((a) => a.toJson()).toList(),
    );
  }

  @override
  Future<PageinationModel<StudentBehavior>> filterbehavoir(
      FilterPer entity) async {
    final response =
        await dio.get(Api.behavoir, queryParameters: entity.toJson());

    return PageinationModel.fromJson(response.data, StudentBehavior.fromJson);
  }

  @override
  Future<void> addBehavoir(List<BaseEnity> date) async {
    AppUtils.log("sendPost");
    final response = await dio.post(
      Api.behavoir,
      data: date
          .where((test) => (test as BehavoirRecordEntity).submit)
          .map((a) => a.toJson())
          .toList(),
    );
  }

  @override
  Future<List<BehaviorNote>> getNotesBehavoir() async {
    final response = await dio.get(Api.behavoir_note,
        queryParameters: {"school": AppUtils.appUser!.id});
    return AppUtils.generateList(response.data, BehaviorNote.fromJson);
  }

  @override
  Future<void> addBehavoirNote(BaseEnity entity) async {
    await dio.post(Api.behavoir_note, data: entity.toJson());
  }

  @override
  Future<PageinationModel<Exam>> getExames(PaginationEntity entity) async {
    final response = await dio.get('${Api.exam}?page=${entity.page}');
    return PageinationModel.fromJson(response.data, Exam.fromJson);
  }

  @override
  Future<PageinationModel<ExamDay>> getExamesDays(
      PaginationEntity entity) async {
    final response = await dio.get(
        '${Api.exam}${entity.classId}${Api.examByDay}?page=${entity.page}');
    return PageinationModel.fromJson(response.data, ExamDay.fromJson);
  }

  @override
  Future<void> addExam(BaseEnity entity) async {
    final response = await dio.post(Api.exam, data: entity.toJson());
  }

  @override
  Future<EvaluationModel> getIdEvaluationVisit(int visitId) async {
    final response = await dio.get('${Api.evaluation}${visitId}/');
    return EvaluationModel.fromJson(response.data);
  }

  @override
  Future<void> updateEvaluationImplementation(Implementation entity) async {
    await dio.post("${Api.evaluationImplementation}${entity.id}/",
        data: entity.toJson());
  }

  @override
  Future<void> updateEvaluationInteraction(Interaction entity) async {
    await dio.post("${Api.evaluationInteraction}${entity.id}/",
        data: entity.toJson());
  }

  @override
  Future<void> updateEvaluationManagment(Managment entity) async {
    await dio.post("${Api.evaluationManagment}${entity.id}/",
        data: entity.toJson());
  }

  @override
  Future<void> updateEvaluationPlanning(Planning entity) async {
    await dio.post("${Api.evaluationPlanning}${entity.id}/",
        data: entity.toJson());
  }

  @override
  Future<List<EvidenceCategoryModel>> getEvidenceCategories() async {
    final response = await dio.get(Api.evidenceCategories);
    return AppUtils.generateList(response.data, EvidenceCategoryModel.fromJson);
  }

  @override
  Future<PageinationModel<EvidenceTeacherModel>> getEvidences(
      EvidencePaginationEntity entity) async {
    final response =
        await dio.get(Api.evidencesSchool, queryParameters: entity.toJson());
    return PageinationModel.fromJson(
        response.data, EvidenceTeacherModel.fromJson);
  }

  @override
  Future<void> addCategoryEveidence(EvidenceCategoryModel entity) async {
    if (entity.add == 'a') {
      await dio.post(Api.evidenceCategories, data: entity.toJson());
    } else if (entity.add == 'd') {
      await dio.delete("${Api.evidenceCategories}${entity.id}/");
    } else if (entity.add == 'u') {
      await dio.patch("${Api.evidenceCategories}${entity.id}/",
          data: entity.toJson());
    }
  }

  @override
  Future<void> addWeekGroup(BaseEnity entity) async {
    await dio.post(Api.weekGroup, data: entity.toJson());
  }

  @override
  Future<void> deleteWeekGroup(DeleteEntity entity) async {
    await dio.delete("${Api.weekGroup}${entity.id}/");
  }

  @override
  Future<void> updateWeekGroup(WeekGroupModel entity) async {
    await dio.patch("${Api.weekGroup}${entity.id}/", data: entity.toJson());
  }

  @override
  Future<List<WeekGroupModel>> getWeekkGroup() async {
    final response = await dio
        .get(Api.weekGroup, queryParameters: {"school": AppUtils.appUser?.id});
    return AppUtils.generateList(response.data, WeekGroupModel.fromJson);
  }

  @override
  Future<AttendanceStatisticsModel> getAttendanceStatistics() async {
    final response = await dio.get(Api.attendanceStatistics);
    return AttendanceStatisticsModel.fromJson(response.data);
  }

  @override
  Future<List<BehaviorStatisticsModel>> getBehaviorStatistics() async {
    final response = await dio.get(Api.behaviorStatistics);
    return BehaviorStatisticsModel.fromList(response.data);
  }

  @override
  Future<void> rateFile(EvidenceTeacherModel entity) async {
    await dio.patch("${Api.evidencesSchool}${entity.id}/",
        data: entity.toJson());
  }

  @override
  Future<void> downloadReport(FilterReportEntity entity) async {
    await dio.download(Api.downloadReport, entity.Path, data: entity.toJson());
  }

  @override
  Future<PageinationModel<LeaveRequestModel>> getRequests(
      PaginationEntity status) async {
    final response = await dio.get(Api.requests,
        queryParameters: {"status": status.teacher, "page": status.page});
    return PageinationModel.fromJson(response.data, LeaveRequestModel.fromJson);
  }

  @override
  Future<void> chanageStatus(ChangeStatusEntity entity) async {
    await dio.post("${Api.changeStatus}${entity.id}/action/",
        data: entity.toJson());
  }

  @override
  Future<DutyScheduleResponse> getDutySchedule(DutyFilterEntity entity) async {
    final response = await dio.get(Api.dutySchedule,
        queryParameters:
            entity.teacherId == null ? null : {"teacher_id": entity.teacherId});
    return DutyScheduleResponse.fromJson(response.data);
  }

  @override
  Future<PageinationModel<WishTeacherModel>> getWishTeachers(
      WishTeachersEntity entity) async {
    final response =
        await dio.get(Api.wishTeachers, queryParameters: entity.toJson());
    return PageinationModel.fromJson(response.data, WishTeacherModel.fromJson);
  }

  @override
  Future<TeacherWishesResponse> getTeacherWishes(
      TeacherWishesEntity entity) async {
    final response = await dio.get('${Api.wishTeachers}${entity.teacherId}/');
    return TeacherWishesResponse.fromJson(response.data);
  }

  @override
  Future<StudentAttendanceRecord> getStudentAttendanceRecord(
      StudentRecordEntity entity) async {
    final response = await dio.get(
        Api.studentAttendanceRecord(entity.studentId),
        queryParameters: {"period": entity.period});
    return StudentAttendanceRecord.fromJson(response.data);
  }

  @override
  Future<StudentBehaviorRecord> getStudentBehaviorRecord(
      StudentRecordEntity entity) async {
    final response = await dio.get(Api.studentBehaviorRecord(entity.studentId),
        queryParameters: {"period": entity.period});
    return StudentBehaviorRecord.fromJson(response.data);
  }

  @override
  Future<PageinationModel<StudentProcedure>> getStudentProcedures(
      ProceduresFilterEntity entity) async {
    final response = await dio.get(Api.studentProcedures, queryParameters: {
      "period": entity.period,
      if (entity.studentId != null) "student": entity.studentId,
      if (entity.source != null) "source": entity.source,
    });
    return PageinationModel.fromJson(response.data, StudentProcedure.fromJson);
  }

  @override
  Future<void> addStudentProcedures(List<Map<String, dynamic>> payload) async {
    await dio.post(Api.studentProcedures, data: payload);
  }
}
