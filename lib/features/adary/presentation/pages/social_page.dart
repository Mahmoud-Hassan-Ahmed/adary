import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/conts/app_text_styles.dart';
import 'package:adary/features/adary/presentation/pages/class_room_page.dart';
import 'package:adary/features/adary/presentation/pages/classes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SocialPage extends StatelessWidget {
  const SocialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'soial_page'.tr(),
              style: AppTextStyles.pageTitle.copyWith(color: Colors.grey),  // 24sp bold
            ),
            bottom: TabBar(
              labelStyle: AppTextStyles.tabActive.copyWith(             // 16sp bold
                color: AppColors.checkbox,
              ),
              unselectedLabelStyle: AppTextStyles.tabInactive,         // 14sp regular
              tabs: [
                Tab(
                  child: Text(
                    'classes'.tr(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Tab(
                  child: Text(
                    'students'.tr(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              ClassRoomPage(),
              ClassesList(),
            ],
          ),
        ),
      ),
    );
  }
}
