import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/conts/style.dart';
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
            title: Text('dialy_missions'.tr(),
                style: AbhayaLibre.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54)),
            bottom: TabBar(
              labelStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.checkbox),
              unselectedLabelStyle: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 14),
              tabs: [
                Tab(
                  child: Text(
                    'current'.tr(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Tab(
                  child: Text(
                    'nexted'.tr(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Tab(
                  child: Text(
                    'finished'.tr(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          body: const TabBarView(
            children: [CurrentTask(), NextTask(), FinishTask()],
          ),
        ),
      ),
    );
  }
}
