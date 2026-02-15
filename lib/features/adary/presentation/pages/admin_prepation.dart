import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/conts/style.dart';
import 'package:adary/core/utils/app_utils.dart';
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
        length: [
          'api/notes/model18/',
          'api/notes/model19/',
          'api/notes/model20/',
        ]
            .where((perm) => AppUtils.permissions.any((p) => p.contains(perm)))
            .length,
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
                if (AppUtils.permissions.isNotEmpty &&
                        AppUtils.permissions
                            .any((p) => p.contains('api/notes/model18/')) ||
                    AppUtils.permissions.isEmpty)
                  Tab(
                    child: Text(
                      'model18'.tr(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                if (AppUtils.permissions.isNotEmpty &&
                        AppUtils.permissions
                            .any((p) => p.contains('api/notes/model19/')) ||
                    AppUtils.permissions.isEmpty)
                  Tab(
                    child: Text(
                      'model19'.tr(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                if (AppUtils.permissions.isNotEmpty &&
                        AppUtils.permissions
                            .any((p) => p.contains('api/notes/model20/')) ||
                    AppUtils.permissions.isEmpty)
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
          body: TabBarView(
            children: [
              if (AppUtils.permissions.isNotEmpty &&
                      AppUtils.permissions.any((p) =>
                          p.contains('api/notes/model18/') ||
                          p.contains('api/notes/model18/add/') ||
                          p.contains('api/notes/model18/delete/') ||
                          p.contains('api/notes/model18/update') ||
                          p.contains('api/notes/model18/download/')) ||
                  AppUtils.permissions.isEmpty)
                const DelayedAlert(),
              if (AppUtils.permissions.isNotEmpty &&
                      AppUtils.permissions.any((p) =>
                          p.contains('api/notes/model19/') ||
                          p.contains('api/notes/model19/add/') ||
                          p.contains('api/notes/model19/delete/') ||
                          p.contains('api/notes/model19/update') ||
                          p.contains('api/notes/model19/download/')) ||
                  AppUtils.permissions.isEmpty)
                const Model20Page(),
              if (AppUtils.permissions.isNotEmpty &&
                      AppUtils.permissions.any((p) =>
                          p.contains('api/notes/model20/') ||
                          p.contains('api/notes/model20/add/') ||
                          p.contains('api/notes/model20/delete/') ||
                          p.contains('api/notes/model20/update') ||
                          p.contains('api/notes/model20/download/')) ||
                  AppUtils.permissions.isEmpty)
                const Model19Page(),
            ],
          ),
        ),
      ),
    );
  }
}
