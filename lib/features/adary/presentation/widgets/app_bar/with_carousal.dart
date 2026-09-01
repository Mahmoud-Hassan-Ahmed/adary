import 'dart:math';
import 'package:adary/core/conts/api.dart';
import 'package:adary/core/conts/app_text_styles.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart'
    show StringTranslateExtension;
import 'package:adary/features/adary/presentation/widgets/dashboard/notifications_bell.dart';
import 'package:flutter/material.dart';
import 'package:adary/features/adary/presentation/widgets/text/label_main_text.dart';

/// Collapsing home header.
///
/// Its extents are derived from the viewport instead of being hard-coded, and
/// the status-bar inset is added on top so the content clears the notch on
/// iPhone without the page below having to pad for it a second time.
class WithCarousalBar extends SliverPersistentHeaderDelegate {
  WithCarousalBar({required this.topInset, required this.viewportHeight});

  /// `MediaQuery.paddingOf(context).top` — status bar / notch height.
  final double topInset;

  /// Full screen height, used to keep the header proportional on any device.
  final double viewportHeight;

  double get _contentMax => (viewportHeight * 0.21).clamp(150.0, 210.0);
  double get _contentMin => (_contentMax * 0.58).clamp(88.0, 120.0);

  @override
  double get maxExtent => _contentMax + topInset;

  @override
  double get minExtent => _contentMin + topInset;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    double progress = shrinkOffset / (maxExtent - minExtent);
    progress = progress.clamp(0.0, 1.0);

    final user = AppUtils.appUser;
    final logoSize = (_contentMax * 0.28).clamp(40.0, 56.0) * (1 - progress * 0.3);
    final horizontalPad = (_contentMax * 0.09).clamp(14.0, 22.0);

    return Container(
      height: max(maxExtent - shrinkOffset, minExtent),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg_home_bar.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          horizontalPad,
          topInset + 8 * (1 - progress),
          horizontalPad,
          12 * (1 - progress),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CachedNetworkImage(
                  imageUrl: '${Api.baseUrl}${user?.logo ?? ''}',
                  height: logoSize,
                  width: logoSize,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => SizedBox(
                    height: logoSize,
                    width: logoSize,
                    child: const Center(
                      child: SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/images/user.png',
                    height: logoSize,
                    width: logoSize,
                  ),
                ),
                Flexible(
                  child: Opacity(
                    opacity: 1 - progress,
                    child: LabelMainText(
                      text: 'main'.tr(),
                      fontSize: AppTextStyles.h2,
                      color: Colors.white,
                      bold: true,
                      maxLines: 1,
                    ),
                  ),
                ),
                // الشمال في الاتجاه العربي — كان فراغًا موازنًا للشعار.
                NotificationsBell(size: logoSize),
              ],
            ),
            const SizedBox(height: 10),
            Flexible(
              child: Opacity(
                opacity: 1 - progress,
                child: LabelMainText(
                  text: 'مرحباً بك',
                  fontSize: AppTextStyles.h4,
                  color: Colors.white,
                  bold: true,
                  maxLines: 1,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Flexible(
              child: Opacity(
                opacity: 1 - progress,
                child: LabelMainText(
                  text: user?.school ?? '',
                  fontSize: AppTextStyles.subtitle1,
                  color: Colors.white,
                  bold: true,
                  maxLines: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant WithCarousalBar oldDelegate) {
    return oldDelegate.topInset != topInset ||
        oldDelegate.viewportHeight != viewportHeight;
  }
}
