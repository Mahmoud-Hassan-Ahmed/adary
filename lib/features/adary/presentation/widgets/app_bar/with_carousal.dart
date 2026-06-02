import 'dart:math';
import 'package:adary/core/conts/api.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart'
    show StringTranslateExtension;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:adary/features/adary/presentation/widgets/text/label_main_text.dart';

class WithCarousalBar extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final screenHeight = MediaQuery.of(context).size.height;

    final maxHeight = screenHeight / 3;
    final minHeight = screenHeight / 6;

    // نسبة الانكماش
    double progress = shrinkOffset / (maxExtent - minExtent);
    progress = progress.clamp(0.0, 1.0);

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
        padding: EdgeInsets.all(16.0 * (1 - progress)), // يقل مع السكرول
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CachedNetworkImage(
                  imageUrl: '${Api.baseUrl}${AppUtils.appUser!.logo}',
                  height: 50 * (1 - progress * 0.3),
                  width: 50 * (1 - progress * 0.3),
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Image.asset(
                      'assets/images/user.png',
                      height: 50 * (1 - progress * 0.3)),
                ),
                Opacity(
                  opacity: 1 - progress,
                  child: LabelMainText(
                    text: 'main'.tr(),
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                SizedBox()
                // IconButton(
                //   onPressed: () {},
                //   icon: SvgPicture.asset(
                //     'assets/icons/notification.svg',
                //     height: 24,
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 10),
            Opacity(
              opacity: 1 - progress,
              child: const LabelMainText(
                  text: 'مرحباً بك  ', fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Opacity(
              opacity: 1 - progress,
              child: LabelMainText(
                  text: AppUtils.appUser!.school,
                  fontSize: 16,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => 200;

  @override
  double get minExtent => 120;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
