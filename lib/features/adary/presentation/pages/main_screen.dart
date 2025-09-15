import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/conts/images.dart';
import 'package:adary/core/conts/style.dart';
import 'package:adary/core/share/widgets/navBar.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/domain/usecases/me_use_case.dart';
import 'package:adary/features/adary/presentation/pages/admin_prepation.dart';
import 'package:adary/features/adary/presentation/pages/circular_page.dart';
import 'package:adary/features/adary/presentation/pages/class_health_page.dart';
import 'package:adary/features/adary/presentation/pages/class_room_page.dart';
import 'package:adary/features/adary/presentation/pages/classes.dart';
import 'package:adary/features/adary/presentation/pages/dialy_task.dart';
import 'package:adary/features/adary/presentation/pages/teacher_note_page.dart';
import 'package:adary/features/adary/presentation/pages/visits_page.dart';
import 'package:adary/features/adary/presentation/pages/week_planing.dart';
import 'package:adary/features/table/view/screen/dashboard/dashboardScreen.dart';
import 'package:adary/features/table/view/screen/waiting/waiting.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  Widget _Custom_Box(
      {required String subTitle,
      required String imagePath,
      Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 85,
            height: 85,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.CONTAINERSCOLOR),
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: Image.asset(
                    imagePath,
                    width: 67,
                    height: 67,
                  ),
                )),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            subTitle.tr(),
            textAlign: TextAlign.center,
            style: AbhayaLibre.copyWith(fontSize: 16),
          )
        ],
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
              style: AbhayaLibreBold.copyWith(fontSize: 19),
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
                const SizedBox(
                  height: 17.5,
                ),
                AppNavBar(
                  imagePath: Images.APP_ICON,
                  headerTxt: 'admin_title'.tr(),
                ),
                const SizedBox(
                  height: 20,
                ),
                _header(title: "Table".tr()),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _Custom_Box(
                              onTap: () {
                                if (AppUtils.appUser != null &&
                                    AppUtils.appUser!.isSmartbleActive) {
                                  AppUtils.go(const DashBoardScreen());
                                } else {
                                  _showNotSubsription(context,
                                      des: 'table_sub');
                                }
                              },
                              subTitle: "SchoolTable".tr(),
                              imagePath: Images.SCHOOL_TABLE_ICON),
                        ),
                        Expanded(
                          child: _Custom_Box(
                              onTap: () {
                                if (AppUtils.appUser != null &&
                                    AppUtils.appUser!.isSmartbleActive) {
                                  AppUtils.go(const Waiting());
                                } else {
                                  _showNotSubsription(context,
                                      des: 'table_sub');
                                }
                              },
                              subTitle: "waitingSessions".tr(),
                              imagePath: Images.ALARM),
                        ),
                        Expanded(
                          child: _Custom_Box(
                              onTap: () {
                                if (AppUtils.appUser != null &&
                                    AppUtils.appUser!.isSmartbleActive) {
                                  AppUtils.go(const DialyTask());
                                } else {
                                  _showNotSubsription(context);
                                }
                              },
                              subTitle: "SchedualedTasks".tr(),
                              imagePath: Images.SCHEDUALEDTASKS),
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 10,
                ),
                _header(title: "Examiner".tr()),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _Custom_Box(
                              subTitle: "Teacher'sNotes".tr(),
                              imagePath: Images.TEACHERNOTE,
                              onTap: () {
                                if (AppUtils.appUser != null &&
                                    AppUtils.appUser!.isFollowerActive) {
                                  AppUtils.go(const TeacherNotePage());
                                } else {
                                  _showNotSubsription(context);
                                }
                              }),
                        ),
                        Expanded(
                          child: _Custom_Box(
                              subTitle: "circulars".tr(),
                              imagePath: Images.EXAMINER,
                              onTap: () {
                                if (AppUtils.appUser != null &&
                                    AppUtils.appUser!.isFollowerActive) {
                                  AppUtils.go(const CircularPage());
                                } else {
                                  _showNotSubsription(context);
                                }
                              }),
                        ),
                        Expanded(
                          child: _Custom_Box(
                              subTitle: "HealthStatus".tr(),
                              imagePath: Images.STATUS,
                              onTap: () {
                                if (AppUtils.appUser != null &&
                                    AppUtils.appUser!.isFollowerActive) {
                                  AppUtils.go(const ClassHealthPage());
                                } else {
                                  _showNotSubsription(context);
                                }
                              }),
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 19,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _Custom_Box(
                              subTitle: "Visits".tr(),
                              imagePath: Images.VISITS,
                              onTap: () {
                                if (AppUtils.appUser != null &&
                                    AppUtils.appUser!.isFollowerActive) {
                                  AppUtils.go(const VisitsPage());
                                } else {
                                  _showNotSubsription(context);
                                }
                              }),
                        ),
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
                              imagePath: Images.EXAMINER),
                        ),
                        Expanded(
                          child: _Custom_Box(
                              subTitle: "MaritalStatus".tr(),
                              imagePath: Images.FAMILY,
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
                    )),
                const SizedBox(
                  height: 19,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _Custom_Box(
                              subTitle: "week_plan".tr(),
                              imagePath: Images.VISITS,
                              onTap: () {
                                if (AppUtils.appUser != null &&
                                    AppUtils.appUser!.isFollowerActive) {
                                  AppUtils.go(const WeekPlaning());
                                } else {
                                  _showNotSubsription(context);
                                }
                              }),
                        ),
                        Expanded(
                          child: _Custom_Box(
                              subTitle: "laps".tr(),
                              imagePath: Images.VISITS,
                              onTap: () {
                                if (AppUtils.appUser != null &&
                                    AppUtils.appUser!.isFollowerActive) {
                                  AppUtils.go(const ClassRoomPage());
                                } else {
                                  _showNotSubsription(context);
                                }
                              }),
                        ),
                        const Expanded(
                          child: SizedBox(),
                        )
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
