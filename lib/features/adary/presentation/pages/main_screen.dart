import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/conts/images.dart';
import 'package:adary/core/conts/style.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/domain/usecases/me_use_case.dart';
import 'package:adary/features/adary/presentation/pages/duty_roster_page.dart';
import 'package:adary/features/adary/presentation/pages/examination.dart';
import 'package:adary/features/adary/presentation/pages/secure_sessions.dart';
import 'package:adary/features/table/view/screen/dashboard/dashboardScreen.dart';
import 'package:adary/features/table/view/screen/waiting/waiting.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  // ignore: non_constant_identifier_names
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
                height: 8,
              ),
              Text(
                subTitle.tr(),
                style: AbhayaLibre.copyWith(fontSize: 15),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (AppUtils.checkPermission([
                      '/dashboard/table-by-teachers/',
                      '/dashboard/table-by-classroom/'
                    ]))
                      Expanded(
                        child: _Custom_Box(
                            onTap: () {
                              if (AppUtils.appUser != null &&
                                  AppUtils.appUser!.isSmartbleActive) {
                                AppUtils.go(const DashBoardScreen());
                              } else {
                                _showNotSubsription(context, des: 'table_sub');
                              }
                            },
                            subTitle: "SchoolTable".tr(),
                            imagePath: Images.SCHOOL_TABLE_ICON),
                      ),
                    const SizedBox(
                      width: 20,
                    ),
                    if (AppUtils.checkPermission(
                        ['/waiting-classes/edit-wc-table/']))
                      Expanded(
                        child: _Custom_Box(
                            onTap: () {
                              if (AppUtils.appUser != null &&
                                  AppUtils.appUser!.isSmartbleActive) {
                                AppUtils.go(const Waiting());
                              } else {
                                _showNotSubsription(context, des: 'table_sub');
                              }
                            },
                            subTitle: "waitingSessions".tr(),
                            imagePath: Images.ALARM),
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
                    // المناوبة والإشراف — حلّت محل "المهام" التي أُلغيت.
                    if (AppUtils.checkPermission(['/pro/pro_duty_roster/']))
                      Expanded(
                        child: _Custom_Box(
                            subTitle: "duty_supervision".tr(),
                            imagePath: 'assets/icons/instructor.svg',
                            onTap: () {
                              if (AppUtils.appUser != null &&
                                  AppUtils.appUser!.isSmartbleActive) {
                                AppUtils.go(const DutyRosterPage());
                              } else {
                                _showNotSubsription(context);
                              }
                            }),
                      ),
                    const SizedBox(
                      width: 20,
                    ),
                    if (AppUtils.checkPermission(['/exams_management/']))
                      Expanded(
                        child: _Custom_Box(
                            subTitle: "exams_halls".tr(),
                            imagePath: "assets/icons/test.svg",
                            onTap: () {
                              if (AppUtils.appUser != null &&
                                  AppUtils.appUser!.isFollowerActive) {
                                AppUtils.go(Examination());
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
                    Expanded(
                      child: _Custom_Box(
                          subTitle: "secure_sessions".tr(),
                          imagePath: "assets/icons/scure_session.svg",
                          onTap: () {
                            if (AppUtils.appUser != null &&
                                AppUtils.appUser!.isFollowerActive) {
                              AppUtils.go(const SecureSessions());
                            } else {
                              _showNotSubsription(context);
                            }
                          }),
                    ),
                    Expanded(
                      child: Container(),
                    )
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
