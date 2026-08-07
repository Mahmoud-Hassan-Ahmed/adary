import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/domain/usecases/me_use_case.dart';
import 'package:adary/features/adary/presentation/pages/admin_prepation.dart';
import 'package:adary/features/adary/presentation/pages/circular_page.dart';
import 'package:adary/features/adary/presentation/pages/class_health_page.dart';
import 'package:adary/features/adary/presentation/pages/class_room_page.dart';
import 'package:adary/features/adary/presentation/pages/classes.dart';
import 'package:adary/features/adary/presentation/pages/performance%20_indicators.dart';
import 'package:adary/features/adary/presentation/pages/perseverance.dart';
import 'package:adary/features/adary/presentation/pages/teacher_note_page.dart';
import 'package:adary/features/adary/presentation/pages/visits_page.dart';
import 'package:adary/features/adary/presentation/pages/weeks_page.dart';
import 'package:adary/features/adary/presentation/widgets/dashboard/home_grid.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// "المتابع الاداري" tab of the home screen.
///
/// Sizes itself to its content — the surrounding [CustomScrollView] owns the
/// scrolling, so this must never introduce a scroll view of its own.
class MainScreen2 extends StatelessWidget {
  const MainScreen2({super.key});

  void _showNotSubsription(BuildContext context, {String des = 'not_sub_des'}) {
    AwesomeDialog(
      dialogType: DialogType.warning,
      context: context,
      title: 'not_subscription'.tr(),
      desc: des.tr(),
    ).show();
  }

  bool get _followerActive =>
      AppUtils.appUser != null && AppUtils.appUser!.isFollowerActive;

  @override
  Widget build(BuildContext context) {
    sl<MeUseCase>().call();

    final items = <HomeTileData>[
      if (AppUtils.checkPermission([
        '/notes/notes-teacher-list/',
        '/notes/monitor-note/',
        '/notes/new/'
      ]))
        HomeTileData(
          title: 'notes_admin',
          subTitle: "Teacher'sNotes",
          iconPath: "assets/icons/icon-note.svg",
          onTap: () {
            if (_followerActive) {
              AppUtils.go(const TeacherNotePage());
            } else {
              _showNotSubsription(context);
            }
          },
        ),
      if (AppUtils.checkPermission([
        '/circular/list/',
        '/circular/add-circular/',
        '/circular/edit-circular/'
      ]))
        HomeTileData(
          title: 'circulars',
          subTitle: "circulars",
          iconPath: "assets/icons/icon-circular.svg",
          onTap: () {
            if (_followerActive) {
              AppUtils.go(const CircularPage());
            } else {
              _showNotSubsription(context);
            }
          },
        ),
      if (AppUtils.checkPermission(['/health/healths/']))
        HomeTileData(
          title: 'HealthStatus',
          subTitle: "HealthStatus",
          iconPath: "assets/icons/icon-health.svg",
          onTap: () {
            if (_followerActive) {
              AppUtils.go(const ClassHealthPage());
            } else {
              _showNotSubsription(context);
            }
          },
        ),
      if (AppUtils.checkPermission(['/visits/visits/']))
        HomeTileData(
          title: 'Visits',
          subTitle: "Visits",
          iconPath: "assets/icons/icon-visit.svg",
          onTap: () {
            if (_followerActive) {
              AppUtils.go(const VisitsPage());
            } else {
              _showNotSubsription(context);
            }
          },
        ),
      if (AppUtils.checkPermission([
        '/notes/model18/',
        '/notes/model10/',
        '/notes/model20/',
      ]))
        HomeTileData(
          title: "ChainOfCommand",
          subTitle: "ChainOfCommand",
          iconPath: "assets/icons/manage.svg",
          onTap: () {
            if (_followerActive) {
              AppUtils.go(const AdminPrepation());
            } else {
              _showNotSubsription(context);
            }
          },
        ),
      if (AppUtils.checkPermission([
        '/notes/social/',
        '/notes/add_social/',
        '/notes/socials/download/',
        '/notes/social/update/',
        '/notes/social/delete/'
      ]))
        HomeTileData(
          title: 'MaritalStatus',
          subTitle: "MaritalStatus",
          iconPath: "assets/icons/icon-social.svg",
          onTap: () {
            if (_followerActive) {
              AppUtils.go(const ClassesList());
            } else {
              _showNotSubsription(context);
            }
          },
        ),
      if (AppUtils.checkPermission([
        '/notes/week_plane/',
        '/notes/add_week_plane/',
        '/notes/week_plane/download/',
        '/notes/week_plane/update/',
        '/notes/week_plane/delete/'
      ]))
        HomeTileData(
          title: 'week_plan',
          subTitle: "week_plan",
          iconPath: "assets/icons/icon-week.svg",
          onTap: () {
            if (_followerActive) {
              AppUtils.go(const WeeksPage());
            } else {
              _showNotSubsription(context);
            }
          },
        ),
      if (AppUtils.checkPermission([
        '/notes/laps/',
        '/notes/add_laps/',
        '/notes/laps/download/',
        '/notes/laps/update/',
        '/notes/laps/delete/'
      ]))
        HomeTileData(
          title: "laps",
          subTitle: "laps",
          iconPath: "assets/icons/icon-class.svg",
          onTap: () {
            if (_followerActive) {
              AppUtils.go(const ClassRoomPage());
            } else {
              _showNotSubsription(context);
            }
          },
        ),
      if (AppUtils.checkPermission([
        '/notes/indicators/',
        '/notes/add_indicators/',
        '/notes/indicators/download/',
        '/notes/indicators/update/',
        '/notes/indicators/delete/'
      ]))
        HomeTileData(
          title: 'performance_indicators',
          subTitle: "performance_indicators",
          iconPath: "assets/icons/icon-sh.svg",
          onTap: () {
            if (_followerActive) {
              AppUtils.go(const PerformanceIndicators());
            } else {
              _showNotSubsription(context);
            }
          },
        ),
      if (AppUtils.checkPermission([
        '/notes/laps/',
        '/notes/add_laps/',
        '/notes/laps/download/',
        '/notes/laps/update/',
        '/notes/laps/delete/'
      ]))
        HomeTileData(
          title: "perseverance",
          subTitle: "perseverance",
          iconPath: "assets/icons/icon-prev.svg",
          onTap: () {
            if (_followerActive) {
              AppUtils.go(const Perseverance());
            } else {
              _showNotSubsription(context);
            }
          },
        ),
    ];

    return HomeGrid(items: items);
  }
}
