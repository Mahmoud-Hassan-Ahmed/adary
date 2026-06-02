import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../controller/teacher_page_controller.dart';
import '../../../../data/model/response/teacher_name.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/images.dart';
import '../../../../utils/style.dart';
import '../../../base/app_main_loader.dart';
import 'package:easy_localization/easy_localization.dart' as easy;

class InstructorDropDown extends StatelessWidget {
  const InstructorDropDown({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TeacherPageController>(builder: (teacherPageController) {
      return teacherPageController.isLoading
          ? _dropDownLoader()
          : Row(
              children: [
                Expanded(
                  child: Container(
                    width: context.width,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.SECONDERYCOLOR),
                    ),
                    child: DropdownMenu<teacherNamesModel>(
                      inputDecorationTheme: const InputDecorationTheme(
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                          outlineBorder: BorderSide.none,
                          border: UnderlineInputBorder(
                              borderSide: BorderSide.none)),
                      trailingIcon: SvgPicture.asset(
                        Images.DROP_DOWN_ICON,
                        color: AppColors.SECONDERYCOLOR,
                      ),
                      width: context.width / 1.1,
                      menuHeight: 200,
                      textStyle: AlMaraiaBold.copyWith(
                          fontSize: 16, color: AppColors.GREYCOLOR),
                      menuStyle: const MenuStyle(
                        side: MaterialStatePropertyAll(
                            BorderSide(style: BorderStyle.none)),
                        backgroundColor:
                            MaterialStatePropertyAll(AppColors.GREYCOLOR),
                      ),
                      initialSelection:
                          teacherPageController.selectedTeacherModel,
                      requestFocusOnTap: false,
                      onSelected: (value) {
                        teacherPageController.changeSelectedInstructorId(
                            teacherModel: value!);
                        teacherPageController.FilterTeacherTableList();
                      },
                      dropdownMenuEntries: teacherPageController.teacherList
                          .map<DropdownMenuEntry<teacherNamesModel>>(
                              (teacherNamesModel tmodel) {
                        return DropdownMenuEntry<teacherNamesModel>(
                            value: tmodel,
                            label: easy.tr("${tmodel.teacherName}"),
                            enabled: true,
                            style: ButtonStyle(
                                textStyle: MaterialStatePropertyAll(
                                    AlMaraiaBold.copyWith(
                              fontSize: 16,
                            ))));
                      }).toList(),
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      "assets/icons/filter_icon.svg",
                      height: 50,
                    )),
              ],
            );
    });
  }

  Widget _dropDownLoader() {
    return AppLoader(
        loaderView: Container(
      width: Get.context!.width / 1.1,
      height: Get.context!.height / 15,
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
    ));
  }
}
