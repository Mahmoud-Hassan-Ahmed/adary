import 'dart:convert';
import 'package:adary/features/table/utils/app_colors.dart';
import 'package:adary/features/table/utils/app_constants.dart';
import 'package:adary/features/table/utils/dimensions.dart';
import 'package:adary/features/table/view/base/app_main_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart' as easy;

import '../../../../utils/style.dart';

class PrivacyScreen extends StatefulWidget {
  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  Map<String, dynamic> data = {};
  bool _isloding = true;
  @override
  initState() {
    super.initState();
    readJson();
  }

  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString(AppConstants.privacy_policy);
    data = await json.decode(response);
    setState(() {
      _isloding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: _isloding
              ? _loader()
              : Column(
                  children: [
                    SizedBox(
                      height: 74,
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                        child: Container(
                          child: Row(
                            children: [
                              const Icon(Icons.arrow_back_ios),
                              Text(
                                easy.tr("back"),
                                style: AlMaraiaRegular.copyWith(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 47,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                      child: Row(
                        children: [
                          Text(
                            data["header_txt"],
                            style: AlMaraiaBold.copyWith(fontSize: 19),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                      child: Row(
                        children: [
                          Text(
                            data["intro_header"],
                            style: AlMaraiaBold.copyWith(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                      child: Wrap(
                        children: [
                          Text(
                            data["intro_txt"],
                            style: AlMaraiaRegular.copyWith(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    _txt(header: data["cond_a"], txt: data["cond_a_txt"]),
                    _txt(header: data["cond_b"], txt: data["cond_b_txt"]),
                    _txt(header: data["cond_c"], txt: data["cond_c_txt"]),
                    _txt(header: data["cond_d"], txt: data["cond_d_txt"]),
                    _txt(header: data["cond_e"], txt: data["cond_e_txt"]),
                    _txt(header: data["cond_f"], txt: data["cond_f_txt"]),
                    _txt(header: data["cond_g"], txt: data["cond_g_txt"]),
                    _txt(header: data["cond_h"], txt: data["cond_h_txt"]),
                    _txt(header: data["cond_i"], txt: data["cond_i_txt"]),
                    _txt(header: data["cond_j"], txt: data["cond_j_txt"]),
                    _txt(header: data["sig"], txt: data["sig_txt"]),
                    _txt(
                        header: data["strat_date"],
                        txt: data["strat_date_txt"]),
                    _txt(
                        header: data["barg_change"],
                        txt: data["barg_change_txt"]),
                    _txt(header: data["communication"], txt: data["com_txt"]),
                    _txt(header: "", txt: "smartble.net@gmail.com"),
                    const SizedBox(
                      height: 30,
                    )
                  ],
                ),
        ),
      ),
    );
  }

  Widget _txt({required String header, required String txt}) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
          child: Row(
            children: [
              Text(
                header,
                style: AlMaraiaBold.copyWith(fontSize: 18),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
          child: Wrap(
            children: [
              Text(
                txt,
                style: AlMaraiaRegular.copyWith(fontSize: 18),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _loader() {
    return AppLoader(
        loaderView: Column(
      children: [
        SizedBox(
          height: 100,
        ),
        for (int i = 0; i < 5; i++)
          Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                child: Row(
                  children: [
                    Container(
                      width: 90,
                      height: 8,
                      decoration: BoxDecoration(
                          color: AppColors.GREYCOLOR,
                          borderRadius: BorderRadius.circular(10)),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                  child: Row(
                    children: [
                      Container(
                        width: context.width - 60,
                        height: 8,
                        decoration: BoxDecoration(
                            color: AppColors.GREYCOLOR,
                            borderRadius: BorderRadius.circular(10)),
                      )
                    ],
                  )),
            ],
          )
      ],
    ));
  }
}
