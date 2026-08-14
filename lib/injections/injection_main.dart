import 'package:adary/core/conts/api.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/core/utils/app_utils_imp.dart';
import 'package:adary/core/utils/calling.dart';
import 'package:adary/core/utils/check_internet.dart';
import 'package:adary/core/utils/dio.dart';
import 'package:adary/features/adary/data/datasources/db.dart';
import 'package:adary/features/adary/data/datasources/db_imp.dart';
import 'package:adary/features/adary/data/repositories/repo_imp.dart';
import 'package:adary/features/adary/domain/repositories/repo.dart';
import 'package:adary/features/adary/domain/usecases/add_behavoir_use_case.dart';
import 'package:adary/features/adary/domain/usecases/add_circular_use_case.dart';
import 'package:adary/features/adary/domain/usecases/add_class_use_case.dart';
import 'package:adary/features/adary/domain/usecases/add_exam_use_case.dart';
import 'package:adary/features/adary/domain/usecases/add_healths_use_case.dart';
import 'package:adary/features/adary/domain/usecases/add_note_use_case.dart';
import 'package:adary/features/adary/domain/usecases/add_visit_use_case.dart';
import 'package:adary/features/adary/domain/usecases/add_week_group_use_case.dart';
import 'package:adary/features/adary/domain/usecases/change_status_use_case.dart';
import 'package:adary/features/adary/domain/usecases/create_category_evi_use_case.dart';
import 'package:adary/features/adary/domain/usecases/create_implementation_use_case.dart';
import 'package:adary/features/adary/domain/usecases/create_intraction_user_case.dart';
import 'package:adary/features/adary/domain/usecases/create_management_user_case.dart';
import 'package:adary/features/adary/domain/usecases/create_model18_use_case.dart';
import 'package:adary/features/adary/domain/usecases/create_model19_use_case.dart';
import 'package:adary/features/adary/domain/usecases/create_model20_use_case.dart';
import 'package:adary/features/adary/domain/usecases/create_note_teachers_use_case.dart';
import 'package:adary/features/adary/domain/usecases/create_palnning_evaluation_use_case.dart';
import 'package:adary/features/adary/domain/usecases/create_student_use_case.dart';
import 'package:adary/features/adary/domain/usecases/create_task_teacher.dart';
import 'package:adary/features/adary/domain/usecases/create_task_use_case.dart';
import 'package:adary/features/adary/domain/usecases/delete_circular_use_case.dart';
import 'package:adary/features/adary/domain/usecases/delete_class_use_case.dart';
import 'package:adary/features/adary/domain/usecases/delete_healths_use_case.dart';
import 'package:adary/features/adary/domain/usecases/delete_model18_use_case.dart';
import 'package:adary/features/adary/domain/usecases/delete_model19_use_case.dart';
import 'package:adary/features/adary/domain/usecases/delete_model20_use_case.dart';
import 'package:adary/features/adary/domain/usecases/delete_note_teacher_use_case.dart';
import 'package:adary/features/adary/domain/usecases/delete_note_use_case.dart';
import 'package:adary/features/adary/domain/usecases/delete_plan_use_case.dart';
import 'package:adary/features/adary/domain/usecases/delete_student_use_case.dart';
import 'package:adary/features/adary/domain/usecases/delete_visit_use_case.dart';
import 'package:adary/features/adary/domain/usecases/delete_week_group_use_case.dart';
import 'package:adary/features/adary/domain/usecases/download_file_20_use_case%20.dart';
import 'package:adary/features/adary/domain/usecases/download_file_use_case.dart';
import 'package:adary/features/adary/domain/usecases/download_teacher_note_pdf_use_case.dart';
import 'package:adary/features/adary/domain/usecases/download_use_case.dart';
import 'package:adary/features/adary/domain/usecases/export_circulars_pdf_use_case.dart';
import 'package:adary/features/adary/domain/usecases/export_healths_to_pdf_use_case.dart';
import 'package:adary/features/adary/domain/usecases/export_visitis_use_case.dart';
import 'package:adary/features/adary/domain/usecases/file_download_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_all_teachers_circular_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_attendence_statistics_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_behavoir_static_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_circulars_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_class_healths_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_class_room_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_classes_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_evaluation_by_visit.dart';
import 'package:adary/features/adary/domain/usecases/get_evidences_caregories.dart';
import 'package:adary/features/adary/domain/usecases/get_evidences_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_exam_by_day_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_exams_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_healths_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_hijri_date.dart';
import 'package:adary/features/adary/domain/usecases/get_list_behavoir_notes.dart';
import 'package:adary/features/adary/domain/usecases/get_model19_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_model20_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_models18_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_notes_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_requests_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_student_attendnce.dart';
import 'package:adary/features/adary/domain/usecases/get_student_calss_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_students_behavoir.dart';
import 'package:adary/features/adary/domain/usecases/get_students_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_duty_schedule_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_teacher_wishes_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_wish_teachers_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_task_teacher_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_tasks_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_teachers_circular_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_teachers_notes_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_teachers_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_visits_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_week_palnes_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_weekly_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_weeks_group.dart';
import 'package:adary/features/adary/domain/usecases/login_use_case.dart';
import 'package:adary/features/adary/domain/usecases/me_use_case.dart';
import 'package:adary/features/adary/domain/usecases/note_use_case.dart';
import 'package:adary/features/adary/domain/usecases/rate_file_use_case.dart';
import 'package:adary/features/adary/domain/usecases/register_students_use_case.dart';
import 'package:adary/features/adary/domain/usecases/remove_task_teacher_use_case.dart';
import 'package:adary/features/adary/domain/usecases/remove_task_use_case.dart';
import 'package:adary/features/adary/domain/usecases/send_model18_decision_use_case.dart';
import 'package:adary/features/adary/domain/usecases/send_model20_decision_use_case.dart';
import 'package:adary/features/adary/domain/usecases/updat_model18_use_case.dart';
import 'package:adary/features/adary/domain/usecases/updat_model20_use_case.dart';
import 'package:adary/features/adary/domain/usecases/update_circular_use_case.dart';
import 'package:adary/features/adary/domain/usecases/update_class_use_case.dart';
import 'package:adary/features/adary/domain/usecases/update_healths_use_case.dart';
import 'package:adary/features/adary/domain/usecases/update_model19_use_case.dart';
import 'package:adary/features/adary/domain/usecases/update_note_teacher_use_case.dart';
import 'package:adary/features/adary/domain/usecases/update_note_use_case.dart';
import 'package:adary/features/adary/domain/usecases/update_student_use_case.dart';
import 'package:adary/features/adary/domain/usecases/update_task_teacher.dart';
import 'package:adary/features/adary/domain/usecases/update_task_use_case.dart';
import 'package:adary/features/adary/domain/usecases/update_visit_use_case.dart';
import 'package:adary/features/adary/domain/usecases/update_week_groups_user_case.dart';
import 'package:adary/features/adary/presentation/bloc/behavoir_notes/behavoir_notes_bloc.dart';
import 'package:adary/features/adary/presentation/bloc/circular/circular_bloc.dart';
import 'package:adary/features/adary/presentation/bloc/class_visit/class_visit_bloc.dart';
import 'package:adary/features/adary/presentation/bloc/delay/delay_bloc.dart';
import 'package:adary/features/adary/presentation/bloc/delay_task/delay_task_bloc.dart';
import 'package:adary/features/adary/presentation/bloc/duty/duty_bloc.dart';
import 'package:adary/features/adary/presentation/bloc/wishes/wishes_bloc.dart';
import 'package:adary/features/adary/presentation/bloc/evaluations/evaluations_bloc.dart';
import 'package:adary/features/adary/presentation/bloc/evidence/evidence_bloc.dart';
import 'package:adary/features/adary/presentation/bloc/exam/exam_bloc.dart';
import 'package:adary/features/adary/presentation/bloc/health/health_bloc.dart';
import 'package:adary/features/adary/presentation/bloc/login/login_bloc.dart';
import 'package:adary/features/adary/presentation/bloc/model19/model19_bloc.dart';
import 'package:adary/features/adary/presentation/bloc/model20/model20_bloc.dart';
import 'package:adary/features/adary/presentation/bloc/note/note_bloc.dart';
import 'package:adary/features/adary/presentation/bloc/perseverance/perseverance_bloc.dart';
import 'package:adary/features/adary/presentation/bloc/scure_session.dart/secure_session_bloc.dart';
import 'package:adary/features/adary/presentation/bloc/social/social_bloc.dart';
import 'package:adary/features/adary/presentation/bloc/students/students_bloc.dart';
import 'package:adary/features/adary/presentation/bloc/task/task_bloc.dart';
import 'package:adary/features/adary/presentation/bloc/teacher_note/teacher_notes_bloc.dart';
import 'package:adary/features/adary/presentation/bloc/week_plan/week_plan_bloc.dart';
import 'package:dio/dio.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = AppUtils.sl;
Future<void> init() async {
  sl.registerFactory<AppUtils>(() => AppUtilsImp(
        dio: sl<Dio>(instanceName: 'dioConfig'),
        // checkServer: sl<CheckInternetConnection>(instanceName: 'check_server'),
        checkinternet:
            sl<CheckInternetConnection>(instanceName: 'check_internet'),
        prefs: sl(),
      ));

  sl.registerSingleton<Dio>(
      Dio(BaseOptions(
        baseUrl: Api.baseUrl,
        connectTimeout: const Duration(milliseconds: 20000),
        receiveTimeout: const Duration(milliseconds: 20000),
      )),
      instanceName: 'dio');
  sl.registerSingleton<Dio>(DioConfig(dio: sl(instanceName: 'dio')).config(),
      instanceName: 'dioConfig');
  sl.registerSingleton<InternetConnection>(InternetConnection(),
      instanceName: 'internet');
  sl.registerSingleton<CheckInternetConnection>(
      CheckInternetConnection(internetConnection: sl(instanceName: 'internet'))
        ..listener(
            messageConnect: 'internet return connected',
            messageDisconnect: 'internet is disconnected'),
      instanceName: 'check_internet');
  // sl.registerSingleton<CheckInternetConnection>(
  //     CheckInternetConnection(internetConnection: sl(instanceName: 'internet'))
  //       ..listener(
  //           messageConnect: 'internet return connected',
  //           messageDisconnect: 'internet is disconnected'),
  //     instanceName: 'check_server');

  sl.registerSingleton<Calling>(Calling());
  sl.registerSingletonAsync<SharedPreferences>(
    () async => await SharedPreferences.getInstance(),
  );

  sl.registerLazySingleton<Db>(
    () => DbImp(dio: sl(instanceName: 'dio')),
  );
  sl.registerLazySingleton<Repo>(
    () => RepoImp(call: sl()),
  );

  //#### blocs
  sl.registerFactory(
    () => TeacherNotesBloc(
        getNotesUseCase: sl(),
        downloadTeacherNotePdfUseCase: sl(),
        updateNoteTeacherUseCase: sl(),
        teachersUseCase: sl(),
        createNoteTeachersUseCase: sl(),
        deleteNoteTeacherUseCase: sl()),
  );
  sl.registerFactory(() => DelayBloc(
      getTeachersUseCase: sl(),
      fileDownloadUseCase: sl(),
      deleteModel18UseCase: sl(),
      createModel18UseCase: sl(),
      updatModel18UseCase: sl()));
  sl.registerFactory(
    () => Model20Bloc(
        getTeachersUseCase: sl(),
        createModel20UseCase: sl(),
        deleteModel20UseCase: sl(),
        downloadFile20UseCase: sl(),
        updatModel20UseCase: sl()),
  );
  sl.registerFactory(() => Model19Bloc(
      getTeachersUseCase: sl(),
      createModel19UseCase: sl(),
      fileDownloadUseCase: sl(),
      deleteModel19UseCase: sl(),
      updateModel19UseCase: sl()));
  sl.registerFactory(
    () => ClassVisitBloc(
        getClassesUseCase: sl(),
        getTeachersUseCase: sl(),
        addVisitUseCase: sl(),
        deleteStudentUseCase: sl(),
        deleteVisitUseCase: sl(),
        exportVisitisUseCase: sl(),
        getEvaluationByVisit: sl(),
        updateVisitUseCase: sl()),
  );
  sl.registerFactory(() => PerseveranceBloc(
      getClassesUseCase: sl(),
      getStudentsUseCase: sl(),
      downloadUseCase: sl()));
  sl.registerFactory(
    () => StudentsBloc(
        getClassRoomUseCase: sl(),
        addClassUseCase: sl(),
        deleteClassUseCase: sl(),
        getClassesUseCase: sl(),
        deleteStudentUseCase: sl(),
        updateClassUseCase: sl()),
  );

  sl.registerFactory(() => EvidenceBloc(
        getEvidencesCaregories: sl(),
        createCategoryEvidenceUseCase: sl(),
        getEvidencesUseCase: sl(),
        getTechersUseCase: sl(),
        rateFileUseCase: sl(),
      ));
  sl.registerFactory(() => EvaluationsBloc(
      createImplementationUseCase: sl(),
      createInteractionEvaluationUseCase: sl(),
      createManagementEvaluationUseCase: sl(),
      createPlanningEvaluationUseCase: sl()));
  sl.registerFactory(() => DutyBloc(getDutyScheduleUseCase: sl()));
  sl.registerFactory(
    () => TaskBloc(
        createTaskUseCase: sl(),
        getTasksUseCase: sl(),
        removeTaskUseCase: sl(),
        updateTaskUseCase: sl()),
  );
  sl.registerFactory(
    () => DelayTaskBloc(
        getTasksUseCase: sl(),
        createTaskTeacher: sl(),
        getTeachersUseCase: sl(),
        removeTaskTeacherUseCase: sl(),
        updateTaskTeacher: sl()),
  );
  sl.registerFactory(() => NoteBloc(
      addNoteUseCase: sl(), deleteNoteUseCase: sl(), updateNoteUseCase: sl()));
  sl.registerFactory(
    () => HealthBloc(
      addHealthsUseCase: sl(),
      deleteHealthsUseCase: sl(),
      getClassHealthsUseCase: sl(),
      exportHealthsToPdfUseCase: sl(),
      getClassesUseCase: sl(),
      updateHealthsUseCase: sl(),
    ),
  );
  sl.registerFactory(() => SocialBloc(
        getClassesUseCase: sl(),
        createStudentUseCase: sl(),
        updateStudentUseCase: sl(),
      ));
  sl.registerFactory(() => ExamBloc(addExamUseCase: sl()));
  sl.registerFactory(
    () => CircularBloc(
        getTeachersUseCase: sl(),
        addCircularUseCase: sl(),
        deleteCircularUseCase: sl(),
        updateCircularUseCase: sl(),
        exportCircularsPdfUseCase: sl(),
        getAllTeachersCircularUseCase: sl()),
  );
  sl.registerFactory(
    () => BehavoirNotesBloc(
        getListBehavoirNotes: sl(),
        getAttendenceStatisticsUseCase: sl(),
        getBehavoirStaticUseCase: sl()),
  );
  sl.registerFactory(
    () => WeekPlanBloc(
        deletePlanUseCase: sl(),
        getTeachersUseCase: sl(),
        addWeekGroupUseCase: sl(),
        getWeeksGroup: sl(),
        updateWeekGroupUseCase: sl(),
        deleteWeekGroupUseCase: sl()),
  );
  sl.registerFactory(() => SecureSessionBloc(
        getRequestsUseCase: sl(),
        changeStatusUseCase: sl(),
      ));
  sl.registerFactory(() => WishesBloc(
        getWishTeachersUseCase: sl(),
        getTeacherWishesUseCase: sl(),
      ));
  sl.registerFactory(
    () => LoginBloc(loginUseCase: sl()),
  );

  //### usecase
  sl.registerLazySingleton(
    () => GetNotesUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => ChangeStatusUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => GetRequestsUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => DownloadUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => GetExamByDayUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => GetAttendenceStatisticsUseCase(
      repo: sl(),
      db: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => AddBehavoirUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => GetBehavoirStaticUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => AddExamUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => GetEvidencesUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => RateFileUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => GetWeeksGroup(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => AddWeekGroupUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => UpdateWeekGroupUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => DeleteWeekGroupUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => GetEvidencesCaregories(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => CreateCategoryEvidenceUseCase(
      repo: sl(),
      db: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => GetExamsUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => GetListBehavoirNotes(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => GetTeachersUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => CreateNoteTeachersUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => CreatePlanningEvaluationUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => CreateInteractionEvaluationUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => CreateManagementEvaluationUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => CreateImplementationUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => AddCircularUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => GetClassesUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => GetEvaluationByVisit(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => CreateStudentUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => RegisterStudentsUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => GetStudentAttendnce(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => GetStudentCalssUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => GetStudentsBehavoir(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => GetModels18UseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => FileDownloadUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => DeleteModel18UseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => UpdatModel18UseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => DeleteHealthsUseCase(
      repo: sl(),
      db: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => CreateModel18UseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => SendModel18DecisionUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => SendModel20DecisionUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => CreateModel19UseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => DeleteModel19UseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => UpdateModel19UseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => DownloadFileUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => GetModel19UseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => CreateModel20UseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => DeleteModel20UseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => UpdatModel20UseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => DownloadFile20UseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => GetModel20UseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => GetClassRoomUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => GetStudentsUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => AddClassUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => DeleteClassUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => DeleteStudentUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => UpdateClassUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => UpdateStudentUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => GetVisitsUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => DeleteVisitUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => UpdateVisitUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => AddVisitUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => GetHealthsUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => UpdateHealthsUseCase(
      repo: sl(),
      db: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => AddHealthsUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => GetClassHealthsUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => AddNoteUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => NoteUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => GetTeachersNotesUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => UpdateNoteTeacherUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => UpdateNoteUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => DeleteNoteTeacherUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => DeleteNoteUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => UpdateCircularUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => DeleteCircularUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => GetCircularsUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => GetTeachersCircularUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => GetAllTeachersCircularUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => GetWeekPalnesUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => DeletePlanUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => DownloadTeacherNotePdfUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => ExportHealthsToPdfUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => ExportVisitisUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => ExportCircularsPdfUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => LoginUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => GetTaskTeacherUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => CreateTaskUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => CreateTaskTeacher(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => UpdateTaskUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => UpdateTaskTeacher(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => RemoveTaskTeacherUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => RemoveTaskUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => GetTasksUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => MeUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => GetHijriDate(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => GetWeeklyUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => GetDutyScheduleUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => GetWishTeachersUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => GetTeacherWishesUseCase(
      repo: sl(),
      db: sl(),
    ),
  );
}
