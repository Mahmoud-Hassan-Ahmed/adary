import 'package:adary/features/table/view/base/app_main_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../controller/class_room_controller.dart';
import '../../data/model/response/classes_meta.dart';
import '../../utils/app_colors.dart';
import '../../utils/dimensions.dart';
import '../../utils/images.dart';
import '../../utils/style.dart';

class CustomDropDown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClassRoomController>(builder: (classRoomController) {
      return classRoomController.isLoading
          ? _dropDownLoader()
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: GetBuilder<ClassRoomController>(
                  builder: (classRoomController) {
                return Container(
                  width: context.width,
                  height: 63,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.GREYCOLOR.withOpacity(0.6)),
                  child: DropdownMenu<ClassesMeta>(
                    inputDecorationTheme: InputDecorationTheme(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        outlineBorder: BorderSide.none,
                        border: const UnderlineInputBorder(
                            borderSide: BorderSide.none)),
                    trailingIcon: SvgPicture.asset(Images.DROP_DOWN_ICON),
                    width: context.width / 1.1,
                    menuHeight: 200,
                    textStyle: AlMaraiaBold.copyWith(fontSize: 20),
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
                          label: meta.ClassName.toString(),
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
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.GREYCOLOR.withOpacity(0.6)),
              child: ExpansionTile(
                  trailing: Container(
                    width: 2,
                  ),
                  title: Container(
                    child: Row(
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
                  ),
                  children: []),
            )));
  }
}
