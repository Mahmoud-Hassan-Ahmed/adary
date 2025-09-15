import 'package:adary/core/share/widgets/my_app_bar.dart';
import 'package:adary/features/table/controller/class_room_controller.dart';
import 'package:adary/features/table/view/base/app_bar.dart';
import 'package:adary/features/table/view/base/table.dart';
import 'package:adary/features/table/view/screen/laps/widget/laps_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/dimensions.dart';
import '../../../../utils/style.dart';
import 'package:easy_localization/easy_localization.dart' as easy;

class AllDaysTable extends StatefulWidget {
  const AllDaysTable({super.key});

  @override
  State<AllDaysTable> createState() => _AllTableState();
}

class _AllTableState extends State<AllDaysTable> {
  @override
  void initState() {
    super.initState();
    //Get.find<ClassRoomController>().FilterAllDaysTAble();
  }

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;

    return RefreshIndicator(
      onRefresh: () async {},
      color: AppColors.SECONDERYCOLOR,
      child: SafeArea(
        child: Scaffold(
          appBar: MyAppBar(title: easy.tr('back')),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // const SizedBox(
                //   height: 60,
                // ),
                // MainAppBar(),
                const SizedBox(
                  height: 20,
                ),
                const LapsDropDown(),
                // end of drop down
                const SizedBox(
                  height: 20,
                ),

                SizedBox(
                  height: orientation == Orientation.portrait
                      ? context.height / 1.12
                      : context.width / 1.12,
                  width: context.width,
                  child: GetBuilder<ClassRoomController>(
                      builder: (classRoomController) {
                    return Center(
                      child: PageView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: classRoomController.tablesList.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return UnconstrainedBox(
                              child: SizedBox(
                                  height: orientation == Orientation.portrait
                                      ? context.height / 1.12
                                      : context.width / 1.12,
                                  width: context.width,
                                  child: Column(
                                    children: [
                                      _header(
                                          classTabel: easy.tr("class_table"),
                                          grade: classRoomController
                                                  .tablesList[index]
                                              ['classroom_name']),
                                      AppTable(
                                        table: classRoomController
                                            .tablesList[index],
                                        isInstructor: false,
                                      )
                                    ],
                                  )),
                            );
                          }),
                    );
                  }),
                ),
                // end of table
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header({required String classTabel, required String grade}) {
    return Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.PADDING_SIZE_DEFAULT),
        child: Row(
          children: [
            Text(
              "$classTabel: ",
              style: AlMaraiaBold.copyWith(
                  fontSize: 20, color: const Color(0xFF9ED3D7)),
            ),
            Text(
              grade,
              style: AlMaraiaBold.copyWith(
                  fontSize: 19, color: AppColors.SECONDERYCOLOR),
            ),
          ],
        ));
  }
}
