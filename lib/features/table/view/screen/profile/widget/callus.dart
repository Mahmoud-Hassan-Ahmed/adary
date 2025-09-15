import 'package:adary/features/table/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../controller/callus_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/style.dart';
import '../../../base/custom_snack_bar.dart';
import '../../../base/custom_text_field.dart';
import 'package:easy_localization/easy_localization.dart' as easy;

class CallUs extends StatelessWidget {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _msgController = TextEditingController();

  FocusNode _titleFocusController = FocusNode();
  FocusNode _messageFocusController = FocusNode();
  final GlobalKey<FormState> _contactformKey = GlobalKey<FormState>();

  CallUs({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Form(
            key: _contactformKey,
            child: Column(
              children: [
                SizedBox(
                  height: 74,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                    child: GestureDetector(
                      onTap: () => Get.back(),
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
                    )),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(
                        easy.tr("titel"),
                        style: AlMaraiaBold.copyWith(
                            color: AppColors.SECONDERYCOLOR, fontSize: 26),
                      )
                    ],
                  ),
                ),
                // end of title header
                SizedBox(
                  height: 10,
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: CustomTextField(
                      hintText: easy.tr("titel_hint_txt"),
                      controller: _titleController,
                      focusNode: _titleFocusController,
                      nextFocus: _messageFocusController,
                      validate: (value) {
                        if (value == null || value.isEmpty) {
                          return easy.tr("required");
                        }
                        return null;
                      },
                    )),
                // end of title text field
                SizedBox(
                  height: 60,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(
                        easy.tr("the_message"),
                        style: AlMaraiaBold.copyWith(
                            color: AppColors.SECONDERYCOLOR, fontSize: 26),
                      )
                    ],
                  ),
                ),
                //end of message header
                SizedBox(
                  height: 10,
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: CustomTextField(
                      maxLines: 8,
                      focusNode: _messageFocusController,
                      hintText: easy.tr("msg"),
                      controller: _msgController,
                      validate: (value) {
                        if (value == null || value.isEmpty) {
                          return easy.tr("required");
                        }
                        return null;
                      },
                    )),
                //end of message text field
                SizedBox(
                  height: 50,
                ),
                SizedBox(
                  height: 10,
                ),
                GetBuilder<CallUsController>(builder: (callUsController) {
                  return callUsController.isSendingMsg
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            width: 450,
                            height: 56,
                            decoration: BoxDecoration(
                                color: AppColors.SECONDERYCOLOR,
                                borderRadius: BorderRadius.circular(
                                    Dimensions.RADIUS_DEFAULT)),
                            child: const Center(
                                child: CircularProgressIndicator(
                              color: AppColors.MAINCOLOR,
                            )),
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: GestureDetector(
                            onTap: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              if (_contactformKey.currentState!.validate()) {
                                callUsController
                                    .sendMessage(
                                        title: _titleController.text.trim(),
                                        msg: _msgController.text.trim())
                                    .then((value) {
                                  if (value.isSuccess) {
                                    _titleController.clear();
                                    _msgController.clear();
                                    showCustomSnackBar(
                                        easy.tr("${value.message}"),
                                        isError: false);
                                  }
                                });
                              }
                            },
                            child: Container(
                              width: 450,
                              height: 60,
                              decoration: BoxDecoration(
                                  color: AppColors.SECONDERYCOLOR,
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.RADIUS_DEFAULT)),
                              child: Center(
                                child: Text(
                                  easy.tr("send"),
                                  style: AlMaraiaBold.copyWith(
                                      fontSize: 24, color: AppColors.MAINCOLOR),
                                ),
                              ),
                            ),
                          ),
                        );
                }),
                //end of send btn
              ],
            ),
          ),
        ),
      ),
    );
  }
}
