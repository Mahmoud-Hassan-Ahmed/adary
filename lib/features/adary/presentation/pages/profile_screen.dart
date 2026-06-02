import 'package:adary/core/conts/images.dart';
import 'package:adary/core/conts/style.dart';
import 'package:adary/core/share/widgets/btn_app.dart';
import 'package:adary/core/share/widgets/choose_lang.dart';
import 'package:adary/core/share/widgets/my_app_bar.dart';
import 'package:adary/core/share/widgets/navBar.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/presentation/pages/login_screen.dart';
import 'package:adary/features/adary/presentation/widgets/profiles/subscription_manager.dart';
import 'package:adary/features/table/utils/app_colors.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Profile extends StatelessWidget {
  Widget _customBox(
      {bool hasArrow = true,
      required String text,
      double fontSize = 17,
      FontWeight fwight = FontWeight.normal,
      Color fColor = const Color.fromARGB(255, 70, 69, 69),
      String? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (icon != null)
                SvgPicture.asset(
                  icon,
                  width: 25,
                  height: 25,
                ),
              const SizedBox(
                width: 10,
              ),
              Text(
                text.tr(),
                style: AbhayaLibreBold.copyWith(
                    fontSize: fontSize, color: fColor, fontWeight: fwight),
              ),
            ],
          ),
          hasArrow
              ? SizedBox(
                  height: 21, child: SvgPicture.asset(Images.FORWARD_ARROW))
              : const SizedBox()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(title: 'account'.tr()),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    ClipOval(
                        child: Image.asset(
                      Images.PROFILE_COVER,
                      width: 80,
                      height: 80,
                    )),
                    Text(
                      AppUtils.appUser?.school ?? '',
                      style: AbhayaLibreMedium.copyWith(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 8,
                    ),

                    Text(
                      "${"@".tr()}${AppUtils.appUser!.username}",
                      style: AbhayaLibre.copyWith(
                          fontSize: 18, color: AppColors.BORDERGREYCOLOR),
                    ),
                    const SizedBox(
                      height: 5,
                    ),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BtnApp(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 10),
                          label: 'تغير الصورة',
                          onTap: () {},
                          radius: 15,
                        ),
                      ],
                    ),
                    // GestureDetector(
                    //   onTap: () {
                    //     // Get.toNamed(RouteHelper.getEditProfileRoute());
                    //     AppUtils.go(EditProfile());
                    //   },
                    //   child: Container(
                    //     width: 230,
                    //     height: 50,
                    //     decoration: BoxDecoration(
                    //         color: const Color(0xffF5F6FA),
                    //         borderRadius: BorderRadius.circular(15),
                    //         border: Border.all(color: const Color(0xffB5B5B5))),
                    //     child: Center(
                    //       child: Text("edit_profile".tr()),
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    // GestureDetector(
                    //   onTap: () {
                    //     chooseLangDialog(context,
                    //             AppUtils.instance.getLocale().languageCode)
                    //         .show();
                    //   },
                    //   child: Container(
                    //     width: 230,
                    //     height: 50,
                    //     decoration: BoxDecoration(
                    //         color: const Color(0xffF5F6FA),
                    //         borderRadius: BorderRadius.circular(15),
                    //         border: Border.all(color: const Color(0xffB5B5B5))),
                    //     child: Center(
                    //       child: Text("language".tr()),
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    // GestureDetector(
                    //   onTap: () {
                    //     // Get.toNamed(RouteHelper.getEditProfileRoute());
                    //     AppUtils.instance.logout();
                    //     AppUtils.goAndReplace(const LoginScreen());
                    //   },
                    //   child: Container(
                    //     width: 230,
                    //     height: 50,
                    //     decoration: BoxDecoration(
                    //         color: const Color(0xffF5F6FA),
                    //         borderRadius: BorderRadius.circular(15),
                    //         border: Border.all(color: const Color(0xffB5B5B5))),
                    //     child: Center(
                    //       child: Text("logout".tr()),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // _customBox(
              //     hasArrow: false,
              //     text: "dashboard",
              //     fColor: const Color(0xff1A6A7D),
              //     fwight: FontWeight.w900,
              //     fontSize: 19),
              // const Divider(),
              // GestureDetector(
              //     onTap: () => AppUtils.go(EditPassword()),
              //     child: _customBox(text: "edit_password")),
              // const Divider(),
              // GestureDetector(
              //     onTap: () => AppUtils.go(Invoice()),
              //     child: _customBox(text: "invoices".tr())),
              // if (AppUtils.permissions.isNotEmpty &&
              //         AppUtils.permissions.any((p) =>
              //             p.contains("/daily-supervision/delete--bulk/")) ||
              //     AppUtils.permissions.isEmpty)
              InkWell(
                  onTap: () {
                    chooseLangDialog(
                            context, AppUtils.instance.getLocale().languageCode)
                        .show();
                  },
                  child: _customBox(
                      text: "language",
                      icon: "assets/icons/material-symbols_language.svg")),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                  onTap: () => AppUtils.go(const SubscriptionManager()),
                  child: _customBox(
                      text: "manage_subscribtion",
                      icon: "assets/icons/ep_list.svg")),

              const SizedBox(
                height: 10,
              ),
              InkWell(
                  onTap: () {},
                  child: _customBox(
                      text: "delete_account",
                      icon: "assets/icons/icomoon-free_bin.svg")),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                  onTap: () {
                    AppUtils.instance.logout();
                    AppUtils.goAndReplace(const LoginScreen());
                  },
                  child: _customBox(
                      text: "logout",
                      icon: "assets/icons/material-symbols_logout-sharp.svg")),

              // const Divider(),
              // GestureDetector(
              //     onTap: () {
              //       AwesomeDialog(
              //         context: context,
              //         dialogType: DialogType.warning,
              //         title: 'delete_account'.tr(),
              //         desc: 'are_you_sure'.tr(),
              //         btnCancelOnPress: () {},
              //         btnOkOnPress: () {
              //           // Add your delete account logic here
              //         },
              //       ).show();
              //     },
              //     child: _customBox(text: "delete_account")),
              // const Divider(),
              // GestureDetector(
              //     onTap: () => AppUtils.go(MarketeingCode()),
              //     child: _customBox(text: "get_your_code")),
              // const Divider(),
              // GestureDetector(
              //     onTap: () => AppUtils.go(RegionLanguage()),
              //     child: _customBox(text: "zone")),
              // const Divider(),
              // const SizedBox(
              //   height: 55,
              // ),
              // _customBox(
              //     hasArrow: false,
              //     text: "app_info",
              //     fColor: const Color(0xff1A6A7D),
              //     fwight: FontWeight.w900,
              //     fontSize: 19),
              // const Divider(),
              // GestureDetector(
              //     onTap: () => AppUtils.go(TermsConditions()),
              //     // Get.toNamed(RouteHelper.gettermsConditionsRoute()),
              //     child: _customBox(text: "terms-conditions")),
              // const Divider(),
              // GestureDetector(
              //     onTap: () => AppUtils.go(Faq()),
              //     child: _customBox(text: "faq")),
              // const Divider(),
              // GestureDetector(
              //     onTap: () => AppUtils.go(WhoWeAre()),
              //     child: _customBox(text: "wo_we_are")),
              // const Divider(),
              // GestureDetector(
              //     onTap: () => AppUtils.go(ContactUs()),
              //     child: _customBox(text: "contact_us")),
              // const Divider(),
              // const SizedBox(
              //   height: 154,
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     SvgPicture.asset(Images.SEND_TWO),
              //     const SizedBox(
              //       width: 20,
              //     ),
              //     Text(
              //       "شارك التطبيق مع زملائك",
              //       style: AbhayaLibre.copyWith(
              //           fontSize: 18, color: const Color(0xffA5910B)),
              //     ),
              //   ],
              // ),
              // Image.asset(
              //   Images.BOTTOM_GROUND,
              //   color: Colors.grey,
              // )
            ],
          ),
        ),
      ),
    );
  }
}
