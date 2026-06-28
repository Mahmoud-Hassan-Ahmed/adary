import 'package:adary/features/table/controller/authintication_controller.dart';
import 'package:adary/features/table/helper/route_helper.dart';
import 'package:adary/features/table/utils/app_colors.dart';
import 'package:adary/features/table/utils/dimensions.dart';
import 'package:adary/features/table/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:adary/core/conts/app_text_styles.dart';
import '../../../utils/style.dart';
import '../../base/custom_snack_bar.dart';
import '../../base/custom_text_field.dart';
import 'package:easy_localization/easy_localization.dart' as easy;

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child:
              GetBuilder<AuthenticationController>(builder: (authController) {
            return Form(
              key: authController.formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: context.height / 5,
                  ),
                  Center(
                    child: Image.asset(
                      Images.APP_LOGO,
                      width: context.width / 1.4,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_EXTRA_LARGE.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          easy.tr("hello_txt"),
                          style: AlMaraiaBold.copyWith(fontSize: AppTextStyles.h3),  // 20sp
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_EXTRA_LARGE.w),
                    child: Wrap(
                      children: [
                        Text(
                          easy.tr("sign_in_smart_table"),
                          style: AlMaraiaRegular.copyWith(
                              fontSize: AppTextStyles.bodySm,      // 14sp
                              fontWeight: FontWeight.w300,
                              color: AppColors.GREYFONTCOLOR),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 36.h),
                  Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
                      child: CustomTextField(
                        prefixIcon: Icons.person_2_outlined,
                        hintText: easy.tr("user_name"),
                        focusNode: authController.userNameFocus,
                        nextFocus: authController.passwordFocus,
                        showBorder: true,
                        controller: authController.userNameController,
                        validate: (value) {
                          if (value == null || value.isEmpty) {
                            return easy.tr("required");
                          }
                          return null;
                        },
                      )),
                  // end of user name
                  SizedBox(height: 12.h),
                  Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
                      child: CustomTextField(
                        prefixIcon: Icons.lock_outline,
                        hintText: easy.tr("password_key"),
                        isPassword: true,
                        controller: authController.passwordController,
                        focusNode: authController.passwordFocus,
                        validate: (value) {
                          if (value == null || value.isEmpty) {
                            return easy.tr("required");
                          }
                          return null;
                        },
                      )),
                  //end of password
                  SizedBox(height: 32.h),
                  GetBuilder<AuthenticationController>(
                      builder: (authenticationController) {
                    return authenticationController.isLoading
                        ? Container(
                            width: double.infinity,
                            height: 52.h,
                            margin: EdgeInsets.symmetric(
                                horizontal: Dimensions.PADDING_SIZE_EXTRA_LARGE.w),
                            decoration: BoxDecoration(
                                color: AppColors.SECONDERYCOLOR,
                                borderRadius: BorderRadius.circular(
                                    Dimensions.RADIUS_DEFAULT)),
                            child: const Center(
                                child: CircularProgressIndicator(
                              color: AppColors.MAINCOLOR,
                            )),
                          )
                        : Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    Dimensions.PADDING_SIZE_EXTRA_LARGE.w),
                            child: GestureDetector(
                              onTap: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                if (authController.formkey.currentState!
                                    .validate()) {
                                  _login(
                                    authController,
                                  );
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                height: 52.h,
                                decoration: BoxDecoration(
                                    color: AppColors.SECONDERYCOLOR,
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.RADIUS_DEFAULT)),
                                child: Center(
                                  child: Text(
                                    easy.tr("log_in"),
                                    style: AlMaraiaBold.copyWith(
                                        fontSize: AppTextStyles.subtitle1,  // 16sp
                                        color: AppColors.MAINCOLOR),
                                  ),
                                ),
                              ),
                            ),
                          );
                  }),
                  //end of log in btn
                  SizedBox(height: 40.h),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: (Dimensions.PADDING_SIZE_EXTRA_LARGE - 10).w),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              easy.tr("privacy_policy"),
                              style: AlMaraiaRegular.copyWith(
                                  fontSize: AppTextStyles.caption,    // 12sp
                                  fontWeight: FontWeight.w300,
                                  color: AppColors.GREYFONTCOLOR),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.toNamed(RouteHelper.gePrivacyRoute());
                              },
                              child: Text(
                                easy.tr("privacy_policy2"),
                                style: AlMaraiaRegular.copyWith(
                                    fontSize: AppTextStyles.caption,  // 12sp
                                    fontWeight: FontWeight.w300,
                                    color: AppColors.FONTCOLOR,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          ],
                        ),
                        Center(
                          child: Text(
                            easy.tr("special_app"),
                            style: AlMaraiaRegular.copyWith(
                                fontSize: AppTextStyles.caption,  // 12sp
                                fontWeight: FontWeight.w300,
                                color: AppColors.GREYFONTCOLOR),
                          ),
                        )
                      ],
                    ),
                  ),
                  // end of privacy policy
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  void _login(AuthenticationController authController) async {
    String _username = authController.userNameController.text.trim();
    String _appkey = authController.passwordController.text.trim();

    authController
        .login(userName: _username, appKey: _appkey)
        .then((status) async {
      if (status.isSuccess) {
        showCustomSnackBar(status.message, isError: false);
      } else {
        showCustomSnackBar(status.message);
      }
    });
  }
}


//smt0040
//t83iuath