import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/conts/style.dart';
import 'package:adary/features/adary/presentation/pages/delayed_alert.dart';
import 'package:adary/features/adary/presentation/pages/model19.dart';
import 'package:adary/features/adary/presentation/pages/model20.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AdminPrepation extends StatelessWidget {
  const AdminPrepation({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'adminstrative'.tr(),
              style: AbhayaLibre.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
            bottom: TabBar(
              indicatorColor: AppColors.checkbox,
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
                    'model18'.tr(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Tab(
                  child: Text(
                    'model19'.tr(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Tab(
                  child: Text(
                    'model20'.tr(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              DelayedAlert(),
              Model20Page(),
              Model19Page(),
            ],
          ),
        ),
      ),
    );
  }
}
