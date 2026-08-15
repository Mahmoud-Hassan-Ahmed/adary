class Api {
  static String domain = 'https://www.smartble.net/';
  static String baseUrl = '$domain';
  static String notes = 'api/notes/note/';
  static String teachers = 'api/notes/teachers/';
  // static String ceateNotTeacher = 'api/notes/teachers-notes/bulk_create/';
  static String ceateNotTeacher = 'api/notes/teachers-notes/';
  static String ceateNotTeachers = 'api/notes/teachers-notes/';
  static String monitorNote = 'api/notes/monitor-note/';
  static String classes = 'api/notes/classes/';
  static String students = 'api/notes/students/';
  static String studentsPage = 'api/notes/students_pgae/';
  static String studentList = 'api/notes/studentList/';
  static String circulars = 'api/notes/circulars/';
  static String managerSignature = 'dashboard-mobile/manager-signature/';
  static String updateManagerSignature =
      'dashboard-mobile/manager-signature/update/';
  static String deleteManagerSignature =
      'dashboard-mobile/manager-signature/delete/';
  static String model18 = 'api/notes/model18/';
  static String weekly = 'api/weekly-plan/week-info/';
  static String model19 = 'api/notes/model19/';
  static String model20 = 'api/notes/model20/';
  static String classRoom = 'api/notes/classs_group/';
  static String visits = 'api/notes/visits/';
  static String healths = 'api/notes/healths/';
  static String classsHealth = 'api/notes/classs_health/';
  static String login = 'dashboard-mobile/login/';
  static String dellayTask = 'daily-supervision/api/daily-tasks/';
  static String taskList = 'daily-supervision/api/tasks/';
  static String createTask = 'daily-supervision/api/daily-tasks/create/';
  static String me = 'dashboard-mobile/my-account/';
  static String attendnce = 'api/notes/attendance/';
  static String behavoir = 'api/notes/behavior_record/';
  static String behavoir_note = 'api/notes/behavior_note/';
  static String exam = '/daily-supervision/api/exam-hall-groups/';
  static String examByDay = '/halls-by-day/';
  static String evaluation = '/api/notes/evaluation/';
  static String evaluationPlanning = '/api/notes/planning/create/';
  static String evaluationInteraction = '/api/notes/interaction/create/';
  static String evaluationManagment = '/api/notes/management/create/';
  static String evaluationImplementation = '/api/notes/implementation/create/';
  static String evidenceCategories = '/api/notes/evi-categories/';
  static String evidencesSchool = '/api/notes/evidence-school/';
  static String weekGroup = '/api/notes/week-groups/';
  static String attendanceStatistics = 'api/notes/attendance/statistics/';
  static String behaviorStatistics = 'api/notes/behavior/statistics/';
  static String downloadReport = 'api/notes/reports/generate/';
  static String requests = '/daily-supervision/secure-class/requests/';
  static String changeStatus = '/daily-supervision/secure-class/requests/';

  /// تسجيل جهاز المدير لدى الخادم ليصله إشعار تأمين الحصة (dashboard_mobile/api.py).
  static String fcmTokenUpdate = 'dashboard-mobile/fcm-token-update/';

  /// المناوبة والإشراف — قراءة فقط، حلّت محل المهام.
  static String dutySchedule = 'pro/pro_duty_roster/api/teachers-schedule/';

  /// الرغبات — قراءة المدير لما سجّله معلّموه في تطبيق المعلم.
  /// `wishTeachers` قائمة المعلمين وعدد رغبات كلٍّ، ويُلحق بها معرّف المعلم
  /// للحصول على بطاقاته.
  static String wishTeachers = 'daily-supervision/wishes/teachers/';
}
