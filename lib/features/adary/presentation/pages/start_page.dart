import 'package:adary/core/conts/images.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/presentation/pages/main_screen.dart';
import 'package:adary/features/adary/presentation/pages/main_screen2.dart';
import 'package:adary/features/adary/presentation/pages/profile_screen.dart';
import 'package:adary/features/adary/presentation/widgets/app_bar/with_carousal.dart';
import 'package:adary/features/adary/presentation/widgets/dashboard/bottom_nav_bar.dart';
import 'package:adary/features/table/view/screen/dashboard/widget/custom_segmented_button.dart';
// import 'package:adary/features/table/view/screen/profile/profile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  var startPage = 0;
  int profile = 0;

  @override
  Widget build(BuildContext context) {
    AppUtils.contextApp = context;

    final media = MediaQuery.of(context);
    // Side margin grows on wide screens so tiles don't stretch across a tablet.
    final horizontalPad = (media.size.width * 0.05).clamp(15.0, 40.0);
    // The tab pill reaches closer to the screen edges than the grid does.
    final pillPad = horizontalPad * 0.55;

    return Scaffold(
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BottomNavItem(
                iconPath: Images.HOME_SCREEN_ICON,
                isSelected: profile == 0,
                onTap: () => setState(() => profile = 0),
                pageName: "main".tr(),
              ),
              BottomNavItem(
                iconPath: Images.USER_SQUARE,
                isSelected: profile == 1,
                onTap: () => setState(() => profile = 1),
                pageName: "profile".tr(),
              ),
            ],
          ),
        ),
      ),
      body: profile == 0
          // One scroll view owns the whole page: the header collapses and
          // scrolls away with the content instead of pinning a fixed block on
          // top of a second, nested scroll view.
          ? CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                SliverPersistentHeader(
                  pinned: false,
                  floating: true,
                  delegate: WithCarousalBar(
                    topInset: media.padding.top,
                    viewportHeight: media.size.height,
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(pillPad, 25, pillPad, 25),
                  sliver: SliverToBoxAdapter(
                    child: CustomSegmentedButton(
                      selectedIndex: startPage,
                      onChanged: (value) => setState(() => startPage = value),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                      horizontalPad, 0, horizontalPad, 24),
                  sliver: SliverToBoxAdapter(
                    child: startPage == 0
                        ? const MainScreen()
                        : const MainScreen2(),
                  ),
                ),
              ],
            )
          : Profile(),
    );
  }
}
