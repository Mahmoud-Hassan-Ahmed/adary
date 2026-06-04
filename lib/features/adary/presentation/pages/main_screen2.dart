import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/conts/style.dart';
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
import 'package:adary/injections/injection_main.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MainScreen2 extends StatelessWidget {
  const MainScreen2({super.key});

  Widget _Custom_Box(
      {required String subTitle,
      required String imagePath,
      String des = '',
      Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                imagePath,
                width: 60,
                height: 60,
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                subTitle.tr(),
                style: AbhayaLibre.copyWith(fontSize: 14),
              ),
              if (des.isNotEmpty)
                Text(
                  des.tr(),
                  style: AbhayaLibre.copyWith(
                      fontSize: 12, color: AppColors.GREYFONTCOLOR),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget _header({required String title}) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Text(
              title.tr(),
              style: AbhayaLibreBold.copyWith(fontSize: 10),
            )
          ],
        ));
  }

  _showNotSubsription(context, {String des = 'not_sub_des'}) {
    AwesomeDialog(
      dialogType: DialogType.warning,
      context: context,
      title: 'not_subscription'.tr(),
      desc: des.tr(),
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    sl<MeUseCase>().call();
    return SafeArea(
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (AppUtils.checkPermission([
                      '/notes/notes-teacher-list/',
                      '/notes/monitor-note/',
                      '/notes/new/'
                    ]))
                      Expanded(
                        child: _Custom_Box(
                            subTitle: 'notes_admin'.tr(),
                            des: "Teacher'sNotes".tr(),
                            imagePath: "assets/icons/icon-note.svg",
                            onTap: () {
                              if (AppUtils.appUser != null &&
                                  AppUtils.appUser!.isFollowerActive) {
                                AppUtils.go(const TeacherNotePage());
                              } else {
                                _showNotSubsription(context);
                              }
                            }),
                      ),
                    const SizedBox(
                      width: 20,
                    ),
                    if (AppUtils.checkPermission([
                      '/circular/list/',
                      '/circular/add-circular/',
                      '/circular/edit-circular/'
                    ]))
                      Expanded(
                        child: _Custom_Box(
                            subTitle: 'circulars'.tr(),
                            des: "circulars".tr(),
                            imagePath: "assets/icons/icon-circular.svg",
                            onTap: () {
                              if (AppUtils.appUser != null &&
                                  AppUtils.appUser!.isFollowerActive) {
                                AppUtils.go(const CircularPage());
                              } else {
                                _showNotSubsription(context);
                              }
                            }),
                      ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (AppUtils.checkPermission([
                      '/health/healths/',
                    ]))
                      Expanded(
                        child: _Custom_Box(
                            subTitle: 'HealthStatus'.tr(),
                            des: "HealthStatus".tr(),
                            imagePath: "assets/icons/icon-health.svg",
                            onTap: () {
                              if (AppUtils.appUser != null &&
                                  AppUtils.appUser!.isFollowerActive) {
                                AppUtils.go(const ClassHealthPage());
                              } else {
                                _showNotSubsription(context);
                              }
                            }),
                      ),
                    const SizedBox(
                      width: 20,
                    ),
                    if (AppUtils.checkPermission([
                      '/visits/visits/',
                    ]))
                      Expanded(
                        child: _Custom_Box(
                            subTitle: 'Visits'.tr(),
                            des: "Visits".tr(),
                            imagePath: "assets/icons/icon-visit.svg",
                            onTap: () {
                              if (AppUtils.appUser != null &&
                                  AppUtils.appUser!.isFollowerActive) {
                                AppUtils.go(const VisitsPage());
                              } else {
                                _showNotSubsription(context);
                              }
                            }),
                      ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (AppUtils.checkPermission([
                      '/notes/model18/',
                      '/notes/model10/',
                      '/notes/model20/',
                    ]))
                      Expanded(
                        child: _Custom_Box(
                            onTap: () {
                              if (AppUtils.appUser != null &&
                                  AppUtils.appUser!.isFollowerActive) {
                                AppUtils.go(const AdminPrepation());
                              } else {
                                _showNotSubsription(context);
                              }
                            },
                            subTitle: "ChainOfCommand".tr(),
                            des: "ChainOfCommand".tr(),
                            imagePath: "assets/icons/manage.svg"),
                      ),
                    const SizedBox(
                      width: 20,
                    ),
                    if (AppUtils.checkPermission([
                      '/notes/social/',
                      '/notes/add_social/',
                      '/notes/socials/download/',
                      '/notes/social/update/',
                      '/notes/social/delete/'
                    ]))
                      Expanded(
                        child: _Custom_Box(
                            subTitle: 'MaritalStatus'.tr(),
                            des: "MaritalStatus".tr(),
                            imagePath: "assets/icons/icon-social.svg",
                            onTap: () {
                              if (AppUtils.appUser != null &&
                                  AppUtils.appUser!.isFollowerActive) {
                                AppUtils.go(const ClassesList());
                              } else {
                                _showNotSubsription(context);
                              }
                            }),
                      ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (AppUtils.checkPermission([
                      '/notes/week_plane/',
                      '/notes/add_week_plane/',
                      '/notes/week_plane/download/',
                      '/notes/week_plane/update/',
                      '/notes/week_plane/delete/'
                    ]))
                      Expanded(
                        child: _Custom_Box(
                            subTitle: 'week_plan'.tr(),
                            des: "week_plan".tr(),
                            imagePath: "assets/icons/icon-week.svg",
                            onTap: () {
                              if (AppUtils.appUser != null &&
                                  AppUtils.appUser!.isFollowerActive) {
                                AppUtils.go(const WeeksPage());
                              } else {
                                _showNotSubsription(context);
                              }
                            }),
                      ),
                    const SizedBox(
                      width: 20,
                    ),
                    if (AppUtils.checkPermission([
                      '/notes/laps/',
                      '/notes/add_laps/',
                      '/notes/laps/download/',
                      '/notes/laps/update/',
                      '/notes/laps/delete/'
                    ]))
                      Expanded(
                        child: _Custom_Box(
                            subTitle: "laps".tr(),
                            des: "laps".tr(),
                            imagePath: "assets/icons/icon-class.svg",
                            onTap: () {
                              if (AppUtils.appUser != null &&
                                  AppUtils.appUser!.isFollowerActive) {
                                AppUtils.go(const ClassRoomPage());
                              } else {
                                _showNotSubsription(context);
                              }
                            }),
                      ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (AppUtils.checkPermission([
                      '/notes/indicators/',
                      '/notes/add_indicators/',
                      '/notes/indicators/download/',
                      '/notes/indicators/update/',
                      '/notes/indicators/delete/'
                    ]))
                      Expanded(
                        child: _Custom_Box(
                            subTitle: 'performance_indicators'.tr(),
                            des: "performance_indicators".tr(),
                            imagePath: "assets/icons/icon-sh.svg",
                            onTap: () {
                              if (AppUtils.appUser != null &&
                                  AppUtils.appUser!.isFollowerActive) {
                                AppUtils.go(const PerformanceIndicators());
                              } else {
                                _showNotSubsription(context);
                              }
                            }),
                      ),
                    const SizedBox(
                      width: 20,
                    ),
                    if (AppUtils.checkPermission([
                      '/notes/laps/',
                      '/notes/add_laps/',
                      '/notes/laps/download/',
                      '/notes/laps/update/',
                      '/notes/laps/delete/'
                    ]))
                      Expanded(
                        child: _Custom_Box(
                            subTitle: "perseverance".tr(),
                            des: "perseverance".tr(),
                            imagePath: "assets/icons/icon-prev.svg",
                            onTap: () {
                              if (AppUtils.appUser != null &&
                                  AppUtils.appUser!.isFollowerActive) {
                                AppUtils.go(const Perseverance());
                              } else {
                                _showNotSubsription(context);
                              }
                            }),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
