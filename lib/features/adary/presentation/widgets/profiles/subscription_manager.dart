import 'package:adary/core/conts/images.dart';
import 'package:adary/core/conts/style.dart';
import 'package:adary/core/share/widgets/custom_text_field.dart';
import 'package:adary/core/share/widgets/my_app_bar.dart';
import 'package:adary/core/share/widgets/navBar.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/presentation/widgets/note_teacher/titile.dart';
import 'package:adary/features/adary/presentation/widgets/profiles/customBtn.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubscriptionManager extends StatelessWidget {
  const SubscriptionManager({super.key});

  Widget _customBox({required String txt}) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  txt.tr(),
                  style: AbhayaLibreMedium.copyWith(fontSize: 17),
                ))
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: CustomTextField(
              hintText: "اكتب هنا",
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(title: 'subscription_manager'.tr()),
        body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "school_system".tr(),
                        style: AbhayaLibreMedium.copyWith(
                            color: const Color(0xffAC1515),
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                      Text(
                        AppUtils.appUser?.schoolSystem ?? '',
                        style: AbhayaLibreBold.copyWith(
                            color: const Color(0xff060606), fontSize: 18),
                      ),
                    ],
                  ),
                  // const Divider(
                  //   height: 20,
                  // ),
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(
                  //       "date_system".tr(),
                  //       style: AbhayaLibreMedium.copyWith(
                  //           color: const Color(0xffAC1515),
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: 17),
                  //     ),
                  //     Text(
                  //       'هجري',
                  //       style: AbhayaLibreBold.copyWith(
                  //           color: const Color(0xff060606), fontSize: 18),
                  //     ),
                  //   ],
                  // ),
                  const Divider(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "is_smartble_active".tr(),
                        style: AbhayaLibreMedium.copyWith(
                            color: const Color(0xffAC1515),
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                      Text(
                        AppUtils.appUser!.isSmartbleActive
                            ? "is_active".tr()
                            : 'not_active'.tr(),
                        style: AbhayaLibreBold.copyWith(
                            color: const Color(0xff060606), fontSize: 18),
                      ),
                    ],
                  ),
                  const Divider(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "is_follower_active".tr(),
                        style: AbhayaLibreMedium.copyWith(
                            color: const Color(0xffAC1515),
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                      Text(
                        AppUtils.appUser!.isFollowerActive
                            ? "is_active".tr()
                            : 'not_active'.tr(),
                        style: AbhayaLibreBold.copyWith(
                            color: const Color(0xff060606), fontSize: 18),
                      ),
                    ],
                  ),
                  const Divider(
                    height: 20,
                  ),
                  Titile(label: 'is_smartble_active'.tr()),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "is_active".tr(),
                        style: AbhayaLibreMedium.copyWith(
                            color: const Color(0xffAC1515),
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                      Text(
                        AppUtils.appUser!.smartblePlanInfo.isActive
                            ? "is_active".tr()
                            : 'not_active'.tr(),
                        style: AbhayaLibreBold.copyWith(
                            color: const Color(0xff060606), fontSize: 18),
                      ),
                    ],
                  ),
                  const Divider(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "plan_name".tr(),
                        style: AbhayaLibreMedium.copyWith(
                            color: const Color(0xffAC1515),
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                      Text(
                        AppUtils.appUser?.smartblePlanInfo.planName ?? '',
                        style: AbhayaLibreBold.copyWith(
                            color: const Color(0xff060606), fontSize: 18),
                      ),
                    ],
                  ),
                  // const Divider(
                  //   height: 20,
                  // ),
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(
                  //       "is_trial".tr(),
                  //       style: AbhayaLibreMedium.copyWith(
                  //           color: const Color(0xffAC1515),
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: 17),
                  //     ),
                  //     Text(
                  //       AppUtils.appUser!.smartblePlanInfo.isTrial
                  //           ? "yes".tr()
                  //           : 'no'.tr(),
                  //       style: AbhayaLibreBold.copyWith(
                  //           color: const Color(0xff060606), fontSize: 18),
                  //     ),
                  //   ],
                  // ),
                  const Divider(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "expire_at".tr(),
                        style: AbhayaLibreMedium.copyWith(
                            color: const Color(0xffAC1515),
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                      Text(
                        AppUtils.appUser?.smartblePlanInfo.expireAt != null
                            ? DateFormat('yyyy-MM-dd').format(DateTime.parse(
                                AppUtils.appUser!.smartblePlanInfo.expireAt!))
                            : '',
                        style: AbhayaLibreBold.copyWith(
                            color: const Color(0xff060606), fontSize: 18),
                      ),
                    ],
                  ),
                  const Divider(
                    height: 20,
                    //
                    //
                  ),
                  Titile(label: 'is_follower_active'.tr()),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "is_active".tr(),
                        style: AbhayaLibreMedium.copyWith(
                            color: const Color(0xffAC1515),
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                      Text(
                        AppUtils.appUser!.followerPlanInfo.isActive
                            ? "is_active".tr()
                            : 'not_active'.tr(),
                        style: AbhayaLibreBold.copyWith(
                            color: const Color(0xff060606), fontSize: 18),
                      ),
                    ],
                  ),
                  const Divider(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "plan_name".tr(),
                        style: AbhayaLibreMedium.copyWith(
                            color: const Color(0xffAC1515),
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                      Text(
                        AppUtils.appUser?.followerPlanInfo.planName ?? '',
                        style: AbhayaLibreBold.copyWith(
                            color: const Color(0xff060606), fontSize: 18),
                      ),
                    ],
                  ),
                  // const Divider(height: 20),
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(
                  //       "is_trial".tr(),
                  //       style: AbhayaLibreMedium.copyWith(
                  //           color: const Color(0xffAC1515),
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: 17),
                  //     ),
                  //     Text(
                  //       AppUtils.appUser!.followerPlanInfo.isTrial
                  //           ? "yes".tr()
                  //           : 'no'.tr(),
                  //       style: AbhayaLibreBold.copyWith(
                  //           color: const Color(0xff060606), fontSize: 18),
                  //     ),
                  //   ],
                  // ),
                  const Divider(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "expire_at".tr(),
                        style: AbhayaLibreMedium.copyWith(
                            color: const Color(0xffAC1515),
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                      Text(
                        AppUtils.appUser?.followerPlanInfo.expireAt != null
                            ? DateFormat('yyyy-MM-dd').format(DateTime.parse(
                                AppUtils.appUser!.followerPlanInfo.expireAt!))
                            : '',
                        style: AbhayaLibreBold.copyWith(
                            color: const Color(0xff060606), fontSize: 18),
                      ),
                    ],
                  ),
                  const Divider(
                    height: 20,
                    //
                    //
                  ),
                  Titile(label: 'whatsapp_service'.tr()),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "is_active".tr(),
                        style: AbhayaLibreMedium.copyWith(
                            color: const Color(0xffAC1515),
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                      Text(
                        AppUtils.appUser!.whatsappService.isActive
                            ? "is_active".tr()
                            : 'not_active'.tr(),
                        style: AbhayaLibreBold.copyWith(
                            color: const Color(0xff060606), fontSize: 18),
                      ),
                    ],
                  ),
                  const Divider(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "remaining".tr(),
                        style: AbhayaLibreMedium.copyWith(
                            color: const Color(0xffAC1515),
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                      Text(
                        AppUtils.appUser!.whatsappService.remaining.toString(),
                        style: AbhayaLibreBold.copyWith(
                            color: const Color(0xff060606), fontSize: 18),
                      ),
                    ],
                  ),
                  //     SizedBox(
                  //       height: 71.h,
                  //     ),
                  //     Container(
                  //       width: 338,
                  //       height: 170,
                  //       child: Center(
                  //           child: Column(
                  //         children: [
                  //           Text(
                  //             "قيمة الاشتراك",
                  //             style: AbhayaLibreMedium.copyWith(
                  //                 color: Color(0xff000000), fontSize: 17),
                  //           ),
                  //           Text(
                  //             "222",
                  //             style: AbhayaLibreBold.copyWith(
                  //                 color: Color(0xff060606), fontSize: 60),
                  //           ),
                  //           Text(
                  //             "ريال لمدة سنة",
                  //             style: AbhayaLibreMedium.copyWith(
                  //                 color: Color(0xff000000), fontSize: 17),
                  //           ),
                  //         ],
                  //       )),
                  //     ),
                  //     SizedBox(
                  //       height: 57,
                  //     ),
                  //     Center(
                  //       child: Container(
                  //         width: 400,
                  //         height: 95,
                  //         decoration: BoxDecoration(
                  //             color: Color(0xffF3EBB4),
                  //             borderRadius: BorderRadius.circular(15)),
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           children: [
                  //             SizedBox(
                  //               width: 16,
                  //             ),
                  //             Container(
                  //               width: 25,
                  //               height: 25,
                  //               decoration: BoxDecoration(
                  //                   borderRadius: BorderRadius.circular(15),
                  //                   color: Color(0xff1A6A7D)),
                  //             ),
                  //             Container(
                  //               child: Column(
                  //                 children: [
                  //                   SizedBox(
                  //                     height: 16,
                  //                   ),
                  //                   Row(
                  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //                     children: [
                  //                       Image.asset(
                  //                         Images.MADA,
                  //                         width: 69,
                  //                         height: 33,
                  //                       ),
                  //                       Image.asset(
                  //                         Images.VISA,
                  //                         width: 69,
                  //                         height: 33,
                  //                       ),
                  //                       SizedBox(
                  //                         width: 200,
                  //                       )
                  //                     ],
                  //                   ),
                  //                   Text(
                  //                     "اشترك بواسطة بطاقة مداو أو البطاقات الائتمانية",
                  //                     style: AbhayaLibreMedium.copyWith(fontSize: 18),
                  //                   )
                  //                 ],
                  //               ),
                  //             )
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //     SizedBox(
                  //       height: 16,
                  //     ),
                  //     Center(
                  //       child: Container(
                  //         width: 400,
                  //         height: 95,
                  //         decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(
                  //               15,
                  //             ),
                  //             border: Border.all(color: Color(0xff707070))),
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.start,
                  //           children: [
                  //             SizedBox(
                  //               width: 16,
                  //             ),
                  //             Container(
                  //               width: 25,
                  //               height: 25,
                  //               decoration: BoxDecoration(
                  //                   borderRadius: BorderRadius.circular(15),
                  //                   border: Border.all(color: Color(0xff707070))),
                  //             ),
                  //             SizedBox(
                  //               width: 16,
                  //             ),
                  //             Container(
                  //               child: Column(
                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                 children: [
                  //                   SizedBox(
                  //                     height: 16,
                  //                   ),
                  //                   Image.asset(
                  //                     Images.PAYBAL,
                  //                     width: 67,
                  //                     height: 33,
                  //                   ),
                  //                   Row(children: [
                  //                     Text(
                  //                       "اشترك بواسطة باي بل paypal",
                  //                       style: AbhayaLibreMedium.copyWith(fontSize: 18),
                  //                     )
                  //                   ])
                  //                 ],
                  //               ),
                  //             )
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //     SizedBox(
                  //       height: 16,
                  //     ),
                  //     Padding(
                  //       padding: EdgeInsets.symmetric(horizontal: 70),
                  //       child: Container(
                  //         height: 100,
                  //         child: Center(
                  //           child: Row(
                  //             crossAxisAlignment: CrossAxisAlignment.center,
                  //             children: [
                  //               Container(
                  //                   width: 216,
                  //                   height: 100,
                  //                   child: _customBox(txt: "استخدم كود الخصم")),
                  //               Container(
                  //                 height: 90,
                  //                 padding: EdgeInsets.only(top: 30),
                  //                 child: Center(
                  //                   child: Container(
                  //                     width: 60,
                  //                     height: 90,
                  //                     decoration: BoxDecoration(
                  //                         borderRadius: BorderRadius.circular(15),
                  //                         border: Border.all(color: Color(0xff95989A))),
                  //                     child: Center(
                  //                         child: Text(
                  //                       "تفعيل",
                  //                       style: AbhayaLibreBold.copyWith(
                  //                           color: Color(0xff060606), fontSize: 17),
                  //                     )),
                  //                   ),
                  //                 ),
                  //               )
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     SizedBox(
                  //       height: 16,
                  //     ),
                  //   ],
                  // ),
                ])),
        // bottomNavigationBar: Container(
        //   height: 90,
        //   child: Column(
        //     children: [
        //       Divider(
        //         color: Colors.grey.withOpacity(0.2),
        //       ),
        //       Center(child: btn(btnTitle: "دفع".tr())),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
