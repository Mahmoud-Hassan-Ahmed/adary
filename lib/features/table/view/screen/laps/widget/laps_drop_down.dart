import 'package:adary/features/table/view/base/app_main_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../controller/class_room_controller.dart';
import '../../../../data/model/response/classes_meta.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/dimensions.dart';
import '../../../../utils/images.dart';
import '../../../../utils/style.dart';
import 'package:easy_localization/easy_localization.dart' as easy;

class LapsDropDown extends StatelessWidget {
  const LapsDropDown({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClassRoomController>(builder: (classRoomController) {
      return classRoomController.isLoading
          ? _dropDownLoader()
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GetBuilder<ClassRoomController>(
                  builder: (classRoomController) {
                return Container(
                  width: context.width,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.GREYCOLOR.withOpacity(0.6)),
                  child: DropdownMenu<ClassesMeta>(
                    inputDecorationTheme: const InputDecorationTheme(
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        outlineBorder: BorderSide.none,
                        border:
                            UnderlineInputBorder(borderSide: BorderSide.none)),
                    trailingIcon: SvgPicture.asset(Images.DROP_DOWN_ICON),
                    width: context.width / 1.1,
                    menuHeight: 200,
                    textStyle: AlMaraiaBold.copyWith(fontSize: 16),
                    menuStyle: const MenuStyle(
                      side: MaterialStatePropertyAll(
                          BorderSide(style: BorderStyle.none)),
                      backgroundColor:
                          MaterialStatePropertyAll(AppColors.GREYCOLOR),
                    ),
                    initialSelection: classRoomController.selectedClassModel,
                    requestFocusOnTap: false,
                    onSelected: (value) {
                      classRoomController.changeDropDownSelector(
                          selectedClassModel: value!);
                      classRoomController.FilterTeacherTableList();
                    },
                    dropdownMenuEntries: classRoomController.classesNames
                        .map<DropdownMenuEntry<ClassesMeta>>(
                            (ClassesMeta meta) {
                      return DropdownMenuEntry<ClassesMeta>(
                          value: meta,
                          label: easy.tr("${meta.ClassName}"),
                          enabled: true,
                          style: ButtonStyle(
                              textStyle: MaterialStatePropertyAll(
                                  AlMaraiaBold.copyWith(
                            fontSize: 16,
                          ))));
                    }).toList(),
                  ),
                );
              }),
            );
    });
  }

  Widget _dropDownLoader() {
    return AppLoader(
        loaderView: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.PADDING_SIZE_DEFAULT),
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.GREYCOLOR.withOpacity(0.6)),
              child: ExpansionTile(
                  trailing: Container(
                    width: 2,
                  ),
                  title: Row(
                    children: [
                      SvgPicture.asset(Images.DROP_DOWN_ICON),
                      const SizedBox(
                        width: 24,
                      ),
                      Text(
                        " ",
                        style: AlMaraiaBold.copyWith(
                            fontSize: 18, color: Colors.black),
                      ),
                    ],
                  ),
                  children: []),
            )));
  }
}
