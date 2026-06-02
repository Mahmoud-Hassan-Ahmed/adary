import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/conts/style.dart';
import 'package:adary/core/share/widgets/my_app_bar.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/presentation/pages/delayed_alert.dart';
import 'package:adary/features/adary/presentation/pages/model19.dart';
import 'package:adary/features/adary/presentation/pages/model20.dart';
import 'package:adary/features/adary/presentation/widgets/admin_prepation/add_delayed_alert.dart';
import 'package:adary/features/adary/presentation/widgets/admin_prepation/add_model19.dart';
import 'package:adary/features/adary/presentation/widgets/admin_prepation/add_model20.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class AdminPrepation extends StatelessWidget {
  const AdminPrepation({super.key});

  static PagingController? pagingController;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Builder(builder: (context) {
          final TabController tabController = DefaultTabController.of(context)!;

          return Scaffold(
            appBar: MyAppBar(actions: [
              IconButton(
                onPressed: () {
                  if (tabController.index == 0) {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return AddDelayedAlert(
                          pagingController: pagingController!,
                        );
                      },
                    );
                  } else if (tabController.index == 1) {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return AddModel20(
                          pagingController: pagingController!,
                        );
                      },
                    );
                  } else {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return AddModel19(
                          pagingController: pagingController!,
                        );
                      },
                    );
                  }
                },
                icon: SvgPicture.asset(
                  'assets/icons/icon-add.svg',
                ),
              ),
            ], title: 'الإجراءات الإدارية'),
            body: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: AppColors.APP_COLOR),
                  ),
                  child: TabBar(
                    controller: tabController,
                    indicator: BoxDecoration(
                      color: AppColors.APP_COLOR,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: AppColors.APP_COLOR,
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    splashFactory: NoSplash.splashFactory,
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    tabs: [
                      // if (AppUtils.permissions.isNotEmpty &&
                      //         AppUtils.permissions.any(
                      //             (p) => p.contains('api/notes/model18/')) ||
                      //     AppUtils.permissions.isEmpty)
                      Tab(
                        child: Text(
                          'model18'.tr(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // if (AppUtils.permissions.isNotEmpty &&
                      //         AppUtils.permissions.any(
                      //             (p) => p.contains('api/notes/model19/')) ||
                      //     AppUtils.permissions.isEmpty)
                      Tab(
                        child: Text(
                          'model19'.tr(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // if (AppUtils.permissions.isNotEmpty &&
                      //         AppUtils.permissions.any(
                      //             (p) => p.contains('api/notes/model20/')) ||
                      //     AppUtils.permissions.isEmpty)
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
                Expanded(
                  child: TabBarView(
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
              ],
            ),
          );
        }),
      ),
    );
  }
}
