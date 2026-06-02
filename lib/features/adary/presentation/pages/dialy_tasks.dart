import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/conts/style.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/presentation/widgets/task/add_task_teacher.dart';
import 'package:adary/features/adary/presentation/widgets/task/current.dart';
import 'package:adary/features/adary/presentation/widgets/task/finsh.dart';
import 'package:adary/features/adary/presentation/widgets/task/next.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DialyTasks extends StatelessWidget {
  const DialyTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            iconTheme: const IconThemeData(color: AppColors.APP_COLOR),
            actions: [
              if (AppUtils.checkPermission([
                '/daily-supervision/edit/',
              ]))
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return const AddTeacherTask();
                      },
                    );
                  },
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.APP_COLOR,
                    ),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ),
            ],
            title: Text(
              'dialy_missions'.tr(),
              style: AbhayaLibre.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.APP_COLOR,
              ),
            ),
          ),
          body: Column(
            children: [
              /// 🔹 Segmented TabBar
              Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppColors.APP_COLOR),
                ),
                child: TabBar(
                  indicator: BoxDecoration(
                    color: AppColors.APP_COLOR,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: AppColors.APP_COLOR,
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,

                  /// 🔥 إزالة تأثير الضغط
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: MaterialStateProperty.all(Colors.transparent),

                  tabs: [
                    Tab(text: 'current'.tr()),
                    Tab(text: 'nexted'.tr()),
                    Tab(text: 'finished'.tr()),
                  ],
                ),
              ),

              /// 🔹 المحتوى
              const Expanded(
                child: TabBarView(
                  children: [
                    CurrentTask(),
                    NextTask(),
                    FinishTask(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
