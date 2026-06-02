import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/presentation/pages/dialy_tasks.dart';
import 'package:adary/features/adary/presentation/pages/tasks_page.dart';
import 'package:adary/features/adary/presentation/widgets/dashboard/bottom_nav_bar.dart';
import 'package:adary/features/adary/presentation/widgets/text/label_main_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DialyTask extends StatefulWidget {
  const DialyTask({super.key});

  @override
  State<DialyTask> createState() => _DialyTaskState();
}

class _DialyTaskState extends State<DialyTask> {
  int startPage = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border:
                          Border.all(color: AppColors.APP_COLOR, width: 1.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        if (AppUtils.checkPermission([
                          '/daily-supervision/',
                        ]))
                          InkWell(
                            onTap: () {
                              setState(() {
                                startPage = 0;
                              });
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/tasks.svg",
                                  width: 30,
                                  height: 30,
                                  color: startPage == 0
                                      ? AppColors.APP_COLOR
                                      : Colors.grey,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                LabelMainText(
                                  text: "notes_techers".tr(),
                                  fontSize: 14,
                                  color: startPage == 0
                                      ? AppColors.APP_COLOR
                                      : Colors.grey,
                                )
                              ],
                            ),
                          ),
                        if (AppUtils.checkPermission([
                          '/daily-supervision/add-task/',
                        ]))
                          InkWell(
                            onTap: () {
                              setState(() {
                                startPage = 1;
                              });
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/messions.svg",
                                  color: startPage == 1
                                      ? AppColors.APP_COLOR
                                      : Colors.grey,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                LabelMainText(
                                  text: "missions".tr(),
                                  fontSize: 14,
                                  color: startPage == 1
                                      ? AppColors.APP_COLOR
                                      : Colors.grey,
                                )
                              ],
                            ),
                          )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                IconButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: () {},
                    icon: SvgPicture.asset("assets/icons/icon-search.svg")),
              ],
            ),
          ),
          body: startPage == 0 ? const DialyTasks() : const TasksPage()),
    );
  }
}
