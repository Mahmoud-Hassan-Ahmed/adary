import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/presentation/pages/dialy_tasks.dart';
import 'package:adary/features/adary/presentation/pages/tasks_page.dart';
import 'package:adary/features/adary/presentation/widgets/dashboard/bottom_nav_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

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
          bottomNavigationBar: Container(
              decoration:
                  BoxDecoration(border: Border.all(color: AppColors.GREYCOLOR)),
              height: 70,
              width: double.infinity,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (AppUtils.permissions.isNotEmpty &&
                            AppUtils.permissions.any(
                                (p) => p.contains('/api/daily-tasks/list/')) ||
                        AppUtils.permissions.isEmpty)
                      BottomNavItem(
                        iconPath: null,
                        isSelected: startPage == 0,
                        onTap: () {
                          setState(() {
                            startPage = 0;
                          });
                        },
                        pageName: "notes_techers".tr(),
                      ),
                    if (AppUtils.permissions.isNotEmpty &&
                            AppUtils.permissions
                                .any((p) => p.contains("/api/daily-tasks/")) ||
                        AppUtils.permissions.isEmpty)
                      BottomNavItem(
                        iconPath: null,
                        isSelected: startPage == 1,
                        onTap: () {
                          setState(() {
                            startPage = 1;
                          });
                        },
                        pageName: "missions".tr(),
                      ),
                  ])),
          body: startPage == 0 ? const DialyTasks() : const TasksPage()),
    );
  }
}
