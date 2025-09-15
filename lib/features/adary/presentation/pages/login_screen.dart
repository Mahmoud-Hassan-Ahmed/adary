import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/conts/dimensions.dart';
import 'package:adary/core/conts/images.dart';
import 'package:adary/core/conts/style.dart';
import 'package:adary/core/share/widgets/custom_text_field.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/domain/entities/login_entity.dart';
import 'package:adary/features/adary/presentation/bloc/login/login_bloc.dart';
import 'package:adary/features/adary/presentation/pages/start_page.dart';
import 'package:adary/features/table/view/screen/profile/widget/privacyScreen.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/conts/app_colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final keyForm = GlobalKey<FormState>();
    final username = TextEditingController();
    final pass = TextEditingController();
    return BlocProvider(
      create: (context) => sl<LoginBloc>(),
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (state is DoneLoginState) {
            WidgetsBinding.instance.addPostFrameCallback((callback) {
              AppUtils.goAndReplace(const DashboardScreen());
            });
          }
          return SafeArea(
            child: Scaffold(
                body: Center(
              child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Form(
                    key: keyForm,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Center(
                          child: Image.asset(
                            Images.APP_LOGO,
                            width: MediaQuery.of(context).size.width / 1.4,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "hello_txt".tr(),
                                style: AbhayaLibre.copyWith(fontSize: 18),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                          child: Wrap(
                            children: [
                              Text(
                                "sign_in_smart_table".tr(),
                                style: AbhayaLibre.copyWith(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300,
                                    color: AppColors.GREYFONTCOLOR),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                            child: CustomTextField(
                              prefixIcon: Icons.person_2_outlined,
                              hintText: "user_name".tr(),
                              // focusNode: usernameFocus,
                              controller: username,
                              showBorder: true,
                              validate: (value) {
                                if (value == null || value.isEmpty) {
                                  return "required".tr();
                                }
                                return null;
                              },
                            )),
                        // end of user name
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                            child: CustomTextField(
                              controller: pass,
                              prefixIcon: Icons.lock_outline,
                              hintText: "password_key".tr(),
                              isPassword: true,

                              // focusNode: passwordFocus,
                              validate: (value) {
                                if (value == null || value.isEmpty) {
                                  return "required".tr();
                                }
                                return null;
                              },
                            )),
                        //end of password
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        "privacy_policy".tr(),
                                        style: AbhayaLibre.copyWith(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300,
                                            color: AppColors.GREYFONTCOLOR),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          AppUtils.go(PrivacyScreen());
                                        },
                                        child: Text(
                                          "privacy".tr(),
                                          style: AbhayaLibre.copyWith(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w300,
                                              color: AppColors.FONTCOLOR,
                                              decoration:
                                                  TextDecoration.underline),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "special_app".tr(),
                                          style: AbhayaLibre.copyWith(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w300,
                                              color: AppColors.GREYFONTCOLOR),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )),
                        ),
                        // end of privacy policy
                        SizedBox(
                          height: 30,
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal:
                                    Dimensions.PADDING_SIZE_EXTRA_LARGE),
                            child: GestureDetector(
                              onTap: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                BaseBloc.get<LoginBloc>(context).add(
                                    LoginUserEvent(
                                        entity: LoginEntity(
                                            username: username.text,
                                            password: pass.text)));
                              },
                              child: Container(
                                width: 350,
                                height: 60,
                                decoration: BoxDecoration(
                                    color: AppColors.SECONDERYCOLOR,
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.RADIUS_DEFAULT)),
                                child: Center(
                                  child: Text(
                                    "log_in".tr(),
                                    style: AbhayaLibre.copyWith(
                                        fontSize: 18,
                                        color: AppColors.MAINCOLOR),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        //end of log in btn
                      ],
                    ),
                  )),
            )),
          );
        },
      ),
    );
  }
}
