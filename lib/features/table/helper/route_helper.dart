import 'package:adary/features/table/view/screen/instructors/instructor.dart';
import 'package:adary/features/table/view/screen/laps/laps.dart';
import 'package:adary/features/table/view/screen/profile/profile.dart';
import 'package:adary/features/table/view/screen/profile/widget/about.dart';
import 'package:adary/features/table/view/screen/profile/widget/callus.dart';
import 'package:adary/features/table/view/screen/profile/widget/notification.dart';
import 'package:adary/features/table/view/screen/profile/widget/privacyScreen.dart';
import 'package:adary/features/table/view/screen/profile/widget/shareApp.dart';
import 'package:adary/features/table/view/screen/waiting/waiting.dart';
import 'package:adary/features/table/view/screen/waiting/widget/add_up_use.dart';
import 'package:get/get.dart';

import '../view/screen/dashboard/dashboardScreen.dart';
import '../view/screen/laps/widget/all_days_table.dart';
import '../view/screen/login/login_screen.dart';
import '../view/screen/profile/widget/settings.dart';
import '../view/screen/splash/splashScreen.dart';
import '../view/screen/waiting/widget/add_waiting.dart';

class RouteHelper {
  static const String _splash = '/';
  static const String _dashboard = '/dashboard';
  static const String _login = '/login';
  static const String _privacy = '/privacy';
  static const String _notification = '/notificaion';
  static const String _callUs = '/callus';
  static const String _about = '/about';
  static const String _shareApp = '/shareapp';
  static const String _awaiting = '/awaiting';
  static const String _upuse = '/upuse';
  static const String _allTable = '/allTable';
  static const String _logout = '/logout';
  static const String _instructor = '${_dashboard}/instructor';
  static const String _laps = '${_dashboard}/laps';
  static const String _waititng = '${_dashboard}/waiting';
  static const String _profile = '${_dashboard}/profile';
  static const String _allClassesTabels = '${_dashboard}/allClassesTabels';
  static const String _instructorFullTable =
      '${_dashboard}/instructorFullTable';
  static const String _settings = '${_dashboard}/settings';

  static String getSplashRoute() => _splash;
  static String geDashBoardRoute() => _dashboard;
  static String geLoginRoute() => _login;
  static String gePrivacyRoute() => _privacy;
  static String geNotificationRoute() => _notification;
  static String geCallUsRoute() => _callUs;
  static String getAboutRoute() => _about;
  static String getSahreAppRoute() => _shareApp;
  static String getAwaitingRoute({required String dayNum}) =>
      "$_awaiting?dayNum=$dayNum";
  static String getUpUseRoute({
    required String cellId,
    required String teacherNAme,
    required String materialName,
    required String className,
  }) =>
      "$_upuse?cellId=$cellId&teacherNAme=$teacherNAme&materialName=$materialName&className=$className";
  static String getAllTableRoute() => _allTable;
  static String getInstructorRoute() => _instructor;
  static String getLapsRoute() => _laps;
  static String getWaitingRoute() => _waititng;
  static String getProfileRoute() => _profile;
  static String getAllClassesTAbleRoute() => _allClassesTabels;
  static String getinstructorFullTableRoute() => _instructorFullTable;
  static String getSettingRoute() => _settings;
  static String getLogOutRoute() => _logout;

  // end of drawer routes

  static List<GetPage> routes = [
    // GetPage(
    //     name: _splash,
    //     page: () => SplashScreen(),
    //     transition: Transition.cupertino),
    GetPage(
      name: _dashboard,
      preventDuplicates: false,
      page: () => DashBoardScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: _instructor,
      page: () => Instructor(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: _waititng,
      page: () => Waiting(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: _laps,
      page: () => Laps(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: _profile,
      page: () => Profile(),
      transition: Transition.cupertino,
    ),
    GetPage(
        name: _login,
        page: () => LoginScreen(),
        transition: Transition.cupertino),
    GetPage(
        name: _privacy,
        page: () => PrivacyScreen(),
        transition: Transition.cupertino),
    GetPage(
        name: _notification,
        page: () => Notification(),
        transition: Transition.cupertino),
    GetPage(
      name: _callUs,
      page: () => CallUs(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: _about,
      page: () => About(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: _shareApp,
      page: () => ShareApp(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: _awaiting,
      page: () {
        return Get.arguments ??
            AddWaititng(day: Get.parameters['dayNum'].toString());
      },
      transition: Transition.cupertino,
    ),
    GetPage(
      name: _upuse,
      page: () {
        return Get.arguments ??
            Upuse(
              cellId: Get.parameters['cellId'].toString(),
              teacherName: Get.parameters['teacherNAme'].toString(),
              materialName: Get.parameters['materialName'].toString(),
              className: Get.parameters['className'].toString(),
            );
      },
      transition: Transition.cupertino,
    ),
    // GetPage(
    //   name: _allTable,
    //   page: () => AllTable(),
    //   transition: Transition.cupertino,
    // ),

    GetPage(
      name: _allClassesTabels,
      page: () => const AllDaysTable(),
      transition: Transition.cupertino,
    ),

    GetPage(
      name: _settings,
      page: () => AppSettings(),
      transition: Transition.cupertino,
    ),

    GetPage(
      name: _logout,
      page: () => LoginScreen(),
      transition: Transition.cupertino,
    ),
  ];
}
