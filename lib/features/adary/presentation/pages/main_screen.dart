import 'package:adary/core/conts/images.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/domain/usecases/me_use_case.dart';
import 'package:adary/features/adary/presentation/pages/duty_roster_page.dart';
import 'package:adary/features/adary/presentation/pages/examination.dart';
import 'package:adary/features/adary/presentation/pages/secure_sessions.dart';
import 'package:adary/features/adary/presentation/widgets/dashboard/home_grid.dart';
import 'package:adary/features/table/view/screen/dashboard/dashboardScreen.dart';
import 'package:adary/features/table/view/screen/waiting/waiting.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// "الجدول الذكي" tab of the home screen.
///
/// Sizes itself to its content — the surrounding [CustomScrollView] owns the
/// scrolling, so this must never introduce a scroll view of its own.
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  void _showNotSubsription(BuildContext context, {String des = 'not_sub_des'}) {
    AwesomeDialog(
      dialogType: DialogType.warning,
      context: context,
      title: 'not_subscription'.tr(),
      desc: des.tr(),
    ).show();
  }

  bool get _smartTableActive =>
      AppUtils.appUser != null && AppUtils.appUser!.isSmartbleActive;

  bool get _followerActive =>
      AppUtils.appUser != null && AppUtils.appUser!.isFollowerActive;

  @override
  Widget build(BuildContext context) {
    sl<MeUseCase>().call();

    final items = <HomeTileData>[
      if (AppUtils.checkPermission([
        '/dashboard/table-by-teachers/',
        '/dashboard/table-by-classroom/'
      ]))
        HomeTileData(
          title: "SchoolTable",
          iconPath: Images.SCHOOL_TABLE_ICON,
          onTap: () {
            if (_smartTableActive) {
              AppUtils.go(const DashBoardScreen());
            } else {
              _showNotSubsription(context, des: 'table_sub');
            }
          },
        ),
      if (AppUtils.checkPermission(['/waiting-classes/edit-wc-table/']))
        HomeTileData(
          title: "waitingSessions",
          iconPath: Images.ALARM,
          onTap: () {
            if (_smartTableActive) {
              AppUtils.go(const Waiting());
            } else {
              _showNotSubsription(context, des: 'table_sub');
            }
          },
        ),
      // المناوبة والإشراف — حلّت محل "المهام" التي أُلغيت.
      if (AppUtils.checkPermission(['/pro/pro_duty_roster/']))
        HomeTileData(
          title: "duty_supervision",
          iconPath: 'assets/icons/duty_supervision.svg',
          onTap: () {
            if (_smartTableActive) {
              AppUtils.go(const DutyRosterPage());
            } else {
              _showNotSubsription(context);
            }
          },
        ),
      if (AppUtils.checkPermission(['/exams_management/']))
        HomeTileData(
          title: "exams_halls",
          iconPath: "assets/icons/test.svg",
          onTap: () {
            if (_followerActive) {
              AppUtils.go(Examination());
            } else {
              _showNotSubsription(context);
            }
          },
        ),
      HomeTileData(
        title: "secure_sessions",
        iconPath: "assets/icons/scure_session.svg",
        onTap: () {
          if (_followerActive) {
            AppUtils.go(const SecureSessions());
          } else {
            _showNotSubsription(context);
          }
        },
      ),
    ];

    return HomeGrid(items: items);
  }
}
