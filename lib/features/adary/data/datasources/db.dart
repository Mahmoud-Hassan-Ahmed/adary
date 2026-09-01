import 'package:adary/features/adary/domain/entities/student_conduct_entity.dart';
import 'package:adary/features/adary/data/models/app_notification.dart';
import 'package:adary/features/adary/data/models/student_conduct.dart';
import 'package:adary/features/adary/data/models/attendance_statistics_model.dart';
import 'package:adary/features/adary/data/models/behavior_statistics_model.dart';
import 'package:adary/features/adary/data/models/circular_model.dart';
import 'package:adary/features/adary/data/models/class_health.dart';
import 'package:adary/features/adary/data/models/class_room.dart';
import 'package:adary/features/adary/data/models/duty_model.dart';
import 'package:adary/features/adary/data/models/classes.dart';
import 'package:adary/features/adary/data/models/evaluation_model.dart';
import 'package:adary/features/adary/data/models/evidence_model.dart';
import 'package:adary/features/adary/data/models/exam_model.dart';
import 'package:adary/features/adary/data/models/health_model.dart';
import 'package:adary/features/adary/data/models/note_accountability_model.dart';
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
import 'package:adary/features/adary/data/models/circular_signature_model.dart';
import 'package:adary/features/adary/data/models/teacher_circular.dart';
import 'package:adary/features/adary/data/models/teacher_model.dart';
import 'package:adary/features/adary/data/models/visits_model.dart';
import 'package:adary/features/adary/data/models/week_group.dart';
import 'package:adary/features/adary/data/models/week_plan.dart';
import 'package:adary/features/adary/data/models/weekly_pan.dart';
import 'package:adary/features/adary/data/models/wishes_model.dart';
import 'package:adary/features/adary/domain/entities/base_enity.dart';
import 'package:adary/features/adary/domain/entities/manager_decision_entity.dart';
import 'package:adary/features/adary/domain/entities/change_status_entity.dart';
import 'package:adary/features/adary/domain/entities/circular_entity.dart';
import 'package:adary/features/adary/domain/entities/class_entity.dart';
import 'package:adary/features/adary/domain/entities/delay_entity.dart';
import 'package:adary/features/adary/domain/entities/delete_entity.dart';
import 'package:adary/features/adary/domain/entities/duty_filter_entity.dart';
import 'package:adary/features/adary/domain/entities/evidence_entity.dart';
import 'package:adary/features/adary/domain/entities/file_download_entity.dart';
import 'package:adary/features/adary/domain/entities/filter_per.dart'
    show FilterPer;
import 'package:adary/features/adary/domain/entities/filter_report_entity.dart';
import 'package:adary/features/adary/domain/entities/health_entity.dart';
import 'package:adary/features/adary/domain/entities/login_entity.dart';
import 'package:adary/features/adary/domain/entities/note_entity.dart';
import 'package:adary/features/adary/domain/entities/pagination_entity.dart';
import 'package:adary/features/adary/domain/entities/student_entity.dart';
import 'package:adary/features/adary/domain/entities/teachers_entity.dart';
import 'package:adary/features/adary/domain/entities/visits_entity.dart';
import 'package:adary/features/adary/domain/entities/wishes_entity.dart';

abstract class Db {
  Future<List<NoteModel>> getNotes();
  Future<List<Teacher>> getTeacher();
  Future<void> createNotTeacher(TeachersEntity data);
  Future<void> deleteNoteTeacher(DeleteEntity entity);
  Future<void> updateNote(NoteEntity entity);
  Future<void> deleteNote(DeleteEntity entity);
  Future<void> updateNoteTeacher(TeachersEntity dats);
  Future<void> createCircular(CircularEntity data);
  Future<List<Classes>> getClasses();
  Future<void> createStudent(BaseEnity entity);
  Future<void> crateModel18(BaseEnity entity);
  Future<PageinationModel<Model18Model>> getModel18(PaginationEntity entity);
  Future<void> doenlaodFileDelay(FileDownloadEneity entity);
  Future<void> deleteDelay(DeleteEntity entity);
  Future<void> updateDelay(Model18 enity);
  Future<PageinationModel<Model19Model>> getModel19(PaginationEntity entity);
  Future<void> deleteModel19(DeleteEntity entity);
  Future<void> updateModel19(Model19 enity);
  Future<void> doenlaodFileModel19(FileDownloadEneity entity);
  Future<void> crateModel19(BaseEnity entity);
  Future<PageinationModel<Model20Model>> getModel20(PaginationEntity entity);
  Future<void> deleteModel20(DeleteEntity entity);
  Future<void> updateModel20(Model20 enity);
  Future<void> doenlaodFileModel20(FileDownloadEneity entity);
  Future<void> crateModel20(BaseEnity entity);

  /// اعتماد رأي مدير المدرسة على الإجراء الإداري وإشعار المعلّم بالقنوات المختارة.
  Future<void> sendModel18Decision(ManagerDecisionEntity entity);

  /// مساءلات الملاحظات — قائمة، وإنشاء من ملاحظة، واعتماد رأي المدير.
  Future<PageinationModel<NoteAccountabilityModel>> getNoteAccountabilities(
      PaginationEntity entity);
  Future<void> sendNoteAccountabilityDecision(ManagerDecisionEntity entity);
  Future<void> sendModel20Decision(ManagerDecisionEntity entity);
  Future<List<Classroom>> getClassRooms();
  Future<PageinationModel<StudentModel>> getStudents(PaginationEntity entity);
  Future<void> updatestudent(StudentEntity student);
  Future<void> updateClass(ClassEntity student);
  Future<void> addClass(ClassEntity student);
  Future<void> deleteStudent(DeleteEntity student);
  Future<void> deleteClass(DeleteEntity student);
  Future<PageinationModel<VisitModel>> getVisits(PaginationEntity entity);
  Future<void> addVisit(BaseEnity entity);
  Future<void> deleteVisit(DeleteEntity entity);
  Future<void> updateVisit(VisitEntity entity);
  Future<PageinationModel<HealthCondition>> gethealths(PaginationEntity entity);
  Future<void> addHealths(BaseEnity entity);
  Future<void> deketeHealth(DeleteEntity entity);
  Future<void> updateHealth(HealthEntity entity);
  Future<List<ClassHealth>> classsHealth();
  /// إشعارات المدير. `notifications` تُعلّم المقروء في الخادم بمجرّد القراءة،
  /// فيُجلب `newNotificationsCount` قبلها لا بعدها.
  Future<List<AppNotification>> notifications(dynamic entity);
  Future<int> newNotificationsCount(dynamic entity);
  Future<void> deleteNotification(DeleteEntity entity);

  Future<void> addNore(BaseEnity entity);
  Future<PageinationModel<NoteModel>> notes(PaginationEntity entity);
  Future<PageinationModel<NotesTeacher>> noteTeacher(PaginationEntity entity);
  Future<PageinationModel<AdministrativeCircular>> circulars(
      PaginationEntity entity);
  Future<void> deleteCircular(DeleteEntity entity);
  Future<void> updateCircular(CircularEntity entity);

  Future<PageinationModel<TeacherCircular>> teachersCirculars(
      PaginationEntity entity);
  Future<List<TeacherCircular>> getAllTeachers(PaginationEntity entity);

  /// توقيعات المعلمين على تعميم واحد؛ `classId` هو معرّف التعميم.
  Future<CircularSignatures> circularSignatures(PaginationEntity entity);

  Future<PageinationModel<Plan>> getWeekPan(PaginationEntity entity);
  Future<void> deletePlan(DeleteEntity entity);

  Future<void> exportPdfTeacherNote(PaginationEntity entity);
  Future<void> exportPdfHealthsNote(FileDownloadEneity entity);
  Future<void> exportPdfVisitssNote(FileDownloadEneity entity);
  Future<void> exportPdfCirculersNote(FileDownloadEneity entity);
  Future<void> login(LoginEntity entity);
  Future<PageinationModel<DailyTaskModel>> taskTeacher(PaginationEntity entity);
  Future<List<TaskModel>> getTadks();
  Future<void> addTaskTeacher(BaseEnity entity);
  Future<void> updateTaskTeacher(BaseEnity entity);
  Future<void> addtask(BaseEnity entity);
  Future<void> updateTask(BaseEnity entity);
  Future<void> removeTask(DeleteEntity entity);
  Future<void> removeTaskTeacher(DeleteEntity entity);
  Future<void> me();
  Future<void> loadCalendart();
  Future<PageinationModel<WeeklyPan>> getWeeks(PaginationEntity entity);

  Future<PageinationModel<StudentPer>> filterPer(FilterPer entity);
  Future<PageinationModel<StudentBehavior>> filterbehavoir(FilterPer entity);
  Future<PageinationModel<StudentInfo>> filterstudents(FilterPer entity);
  Future<void> registerStudemt(List<BaseEnity> date);
  Future<void> addBehavoir(List<BaseEnity> date);
  Future<List<BehaviorNote>> getNotesBehavoir();
  Future<void> addBehavoirNote(BaseEnity entity);
  Future<void> addExam(BaseEnity entity);
  Future<PageinationModel<Exam>> getExames(PaginationEntity entity);
  Future<PageinationModel<ExamDay>> getExamesDays(PaginationEntity entity);

  Future<EvaluationModel> getIdEvaluationVisit(int visitId);
  Future<void> updateEvaluationPlanning(Planning entity);
  Future<void> updateEvaluationInteraction(Interaction entity);
  Future<void> updateEvaluationManagment(Managment entity);
  Future<void> updateEvaluationImplementation(Implementation entity);
  Future<PageinationModel<EvidenceTeacherModel>> getEvidences(
      EvidencePaginationEntity entity);
  Future<List<EvidenceCategoryModel>> getEvidenceCategories();
  Future<void> addCategoryEveidence(EvidenceCategoryModel entity);

  Future<List<WeekGroupModel>> getWeekkGroup();
  Future<void> addWeekGroup(BaseEnity entity);
  Future<void> deleteWeekGroup(DeleteEntity entity);
  Future<void> updateWeekGroup(WeekGroupModel entity);
  Future<AttendanceStatisticsModel> getAttendanceStatistics();
  Future<List<BehaviorStatisticsModel>> getBehaviorStatistics();

  Future<void> rateFile(EvidenceTeacherModel entity);
  Future<void> downloadReport(FilterReportEntity entity);
  Future<PageinationModel<LeaveRequestModel>> getRequests(
      PaginationEntity status);
  Future<void> chanageStatus(ChangeStatusEntity entity);
  Future<DutyScheduleResponse> getDutySchedule(DutyFilterEntity entity);
  Future<PageinationModel<WishTeacherModel>> getWishTeachers(
      WishTeachersEntity entity);
  Future<TeacherWishesResponse> getTeacherWishes(TeacherWishesEntity entity);

  /// المواظبة والسلوك — سجلّا الطالب والإجراءات المتخذة بحقّه (قسم 7).
  Future<StudentAttendanceRecord> getStudentAttendanceRecord(
      StudentRecordEntity entity);
  Future<StudentBehaviorRecord> getStudentBehaviorRecord(
      StudentRecordEntity entity);
  Future<PageinationModel<StudentProcedure>> getStudentProcedures(
      ProceduresFilterEntity entity);
  Future<void> addStudentProcedures(List<Map<String, dynamic>> payload);
}
