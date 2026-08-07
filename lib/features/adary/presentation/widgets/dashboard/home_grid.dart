import 'dart:math';

import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/conts/app_text_styles.dart';
import 'package:easy_localization/easy_localization.dart'
    show StringTranslateExtension;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// A single shortcut on the home screen.
class HomeTileData {
  final String title;
  final String subTitle;
  final String iconPath;
  final VoidCallback? onTap;

  const HomeTileData({
    required this.title,
    required this.iconPath,
    this.subTitle = '',
    this.onTap,
  });
}

/// Responsive, non-scrolling grid of home shortcuts.
///
/// It measures itself against the width it is actually given, so it can live
/// inside a parent scroll view without competing with it for vertical space.
/// Column count and tile size follow the available width, and the tile height
/// is measured from the real labels — so every row lines up and nothing clips,
/// on a small iPhone or on an iPad.
class HomeGrid extends StatelessWidget {
  const HomeGrid({super.key, required this.items});

  final List<HomeTileData> items;

  /// Column count for the width we actually got — phone, big phone, tablet.
  static int columnsFor(double width) {
    if (width >= 1100) return 4;
    if (width >= 720) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    final titleStyle = AppTextStyles.secondaryBold
        .copyWith(color: AppColors.triblethree, height: 1.4);
    final subStyle = AppTextStyles.captionText
        .copyWith(color: AppColors.GREYFONTCOLOR, height: 1.3);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = columnsFor(width);
        const spacing = 15.0;

        final tileWidth = (width - spacing * (columns - 1)) / columns;
        final iconSize = (tileWidth * 0.32).clamp(42.0, 68.0);
        final padding = (tileWidth * 0.07).clamp(10.0, 18.0);
        const iconToText = 8.0;

        // Measure the real labels instead of guessing a childAspectRatio: a
        // fixed ratio is what makes tiles clip once the device, the language
        // or the font metrics differ from the one it was tuned on.
        final textWidth = tileWidth - padding * 2;
        final scaler = MediaQuery.textScalerOf(context);
        final direction = Directionality.of(context);

        double measure(String text, TextStyle style, int maxLines) {
          final painter = TextPainter(
            text: TextSpan(text: text, style: style),
            maxLines: maxLines,
            textDirection: direction,
            textScaler: scaler,
          )..layout(maxWidth: max(textWidth, 0));
          return painter.height;
        }

        var titleHeight = 0.0;
        var subHeight = 0.0;
        for (final item in items) {
          titleHeight = max(titleHeight, measure(item.title.tr(), titleStyle, 2));
          if (item.subTitle.isNotEmpty) {
            subHeight = max(subHeight, measure(item.subTitle.tr(), subStyle, 1));
          }
        }

        final contentHeight =
            padding * 2 + iconSize + iconToText + titleHeight + subHeight;
        // Slightly shorter than a square, and never shorter than the text
        // inside — a long label grows the tile instead of getting clipped.
        final tileHeight = max(tileWidth * 0.85, contentHeight);

        return GridView.builder(
          shrinkWrap: true,
          primary: false,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            mainAxisExtent: tileHeight,
          ),
          itemBuilder: (context, index) => _HomeTile(
            data: items[index],
            iconSize: iconSize,
            padding: padding,
            gap: iconToText,
            titleStyle: titleStyle,
            subStyle: subStyle,
          ),
        );
      },
    );
  }
}

class _HomeTile extends StatelessWidget {
  const _HomeTile({
    required this.data,
    required this.iconSize,
    required this.padding,
    required this.gap,
    required this.titleStyle,
    required this.subStyle,
  });

  final HomeTileData data;
  final double iconSize;
  final double padding;
  final double gap;
  final TextStyle titleStyle;
  final TextStyle subStyle;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 7,
          ),
        ],
      ),
      // Shadow lives on the box outside, ripple is clipped inside it.
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: data.onTap,
          child: Padding(
            padding: EdgeInsets.all(padding),
            // Icon and labels ride together at the start side (right in RTL),
            // vertically centred — the tile's slack splits above and below.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  data.iconPath,
                  width: iconSize,
                  height: iconSize,
                ),
                SizedBox(height: gap),
                Text(
                  data.title.tr(),
                  style: titleStyle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (data.subTitle.isNotEmpty)
                  Text(
                    data.subTitle.tr(),
                    style: subStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
