import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/conts/dimensions.dart';
import 'package:adary/core/conts/images.dart';
import 'package:adary/core/conts/style.dart';
import 'package:adary/core/share/widgets/custom_text_field.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/domain/entities/login_entity.dart';
import 'package:adary/features/adary/presentation/bloc/login/login_bloc.dart';
import 'package:adary/features/adary/presentation/pages/start_page.dart';
import 'package:adary/features/adary/presentation/widgets/btns/default_btn.dart';
import 'package:adary/features/adary/presentation/widgets/text/label_main_text.dart';
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Form(
                    key: keyForm,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                            child: Column(
                          children: [
                            FractionallySizedBox(
                              widthFactor: 0.3,
                              child: Image.asset(
                                Images.APP_LOGO_LOGIN,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomButton(
                              label: "manager app".tr(),
                              widthPercentage: 0.4,
                              onPressed: () {},
                            )
                          ],
                        )),
                        const SizedBox(
                          height: 10,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            LabelMainText(
                              text: "hello_txt".tr(),
                              fontSize: 20,
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 15,
                        ),
                        LabelMainText(
                            text: "user_name".tr(),
                            fontSize: 15,
                            color: AppColors.HINT_COLOR),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextField(
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
                        ),
                        // end of user name
                        const SizedBox(
                          height: 10,
                        ),

                        LabelMainText(
                          text: "password".tr(),
                          fontSize: 15,
                          color: AppColors.HINT_COLOR,
                        ),
                        const SizedBox(
                          height: 10,
                        ),

                        CustomTextField(
                          controller: pass,

                          hintText: "password_key".tr(),
                          isPassword: true,

                          // focusNode: passwordFocus,
                          validate: (value) {
                            if (value == null || value.isEmpty) {
                              return "required".tr();
                            }
                            return null;
                          },
                        ),
                        //end of password
                        const SizedBox(
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
                        const SizedBox(
                          height: 30,
                        ),
                        CustomButton(
                          widthPercentage: 1.0,
                          label: "log_in".tr(),
                          fontSize: 16,
                          onPressed: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            BaseBloc.get<LoginBloc>(context).add(LoginUserEvent(
                                entity: LoginEntity(
                                    username: username.text,
                                    password: pass.text)));
                          },
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
