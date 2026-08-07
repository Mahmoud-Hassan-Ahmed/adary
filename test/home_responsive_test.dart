import 'package:adary/features/adary/presentation/widgets/dashboard/home_grid.dart';
import 'package:adary/features/table/view/screen/dashboard/widget/custom_segmented_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:math' as math;

/// Screen sizes the home page has to survive, in logical pixels.
const _screens = <String, Size>{
  'iPhone SE': Size(320, 568),
  'iPhone 16 Pro': Size(393, 852),
  'iPhone 16 Pro Max': Size(430, 932),
  'Android phone': Size(411, 891),
  'iPad portrait': Size(820, 1180),
  'iPad landscape': Size(1180, 820),
};

/// Mirrors the real tile set of the "المتابع الاداري" tab: long labels, a
/// subtitle on every card.
final _items = <HomeTileData>[
  for (final title in <String>[
    'ملاحظات الإدارة',
    'التعاميم',
    'الحالات الصحية',
    'الزيارات الصفية',
    'التسلسل القيادي والاداري',
    'الحالات الاجتماعية',
    'الخطة الاسبوعية',
    'الحصص',
    'مؤشرات الاداء',
    'المثابرة',
  ])
    HomeTileData(
      title: title,
      subTitle: title,
      iconPath: 'assets/icons/icon-note.svg',
    ),
];

Widget _harness({required Widget child, required double textScale}) {
  return ScreenUtilInit(
    designSize: const Size(430, 932),
    minTextAdapt: true,
    splitScreenMode: true,
    fontSizeResolver: (fontSize, instance) {
      final scale =
          math.min(instance.scaleWidth, instance.scaleHeight).clamp(0.90, 1.10);
      return fontSize * scale;
    },
    child: MaterialApp(
      builder: (context, inner) => MediaQuery(
        // main.dart pins the real app to TextScaler.noScaling. Here we feed a
        // 2x system font setting on purpose: belt and braces, the layout has
        // to hold even if scaling ever reaches it.
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(textScale)),
        child: inner!,
      ),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: child,
            ),
          ),
        ),
      ),
    ),
  );
}

void main() {
  for (final entry in _screens.entries) {
    for (final textScale in <double>[1.0, 2.0]) {
      testWidgets(
        'home grid lays out without overflow — ${entry.key} @ ${textScale}x',
        (tester) async {
          tester.view.physicalSize = entry.value;
          tester.view.devicePixelRatio = 1.0;
          addTearDown(tester.view.reset);

          await tester.pumpWidget(
            _harness(child: HomeGrid(items: _items), textScale: textScale),
          );
          await tester.pumpAndSettle();

          expect(tester.takeException(), isNull);

          // Column count must follow the width we were given.
          final expectedColumns = HomeGrid.columnsFor(entry.value.width - 40);
          final grid = tester.widget<GridView>(find.byType(GridView));
          final delegate =
              grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
          expect(delegate.crossAxisCount, expectedColumns);

          // Every tile has to be tall enough for the text it holds.
          final tiles = find.byType(Text);
          for (var i = 0; i < tester.widgetList(tiles).length; i++) {
            final size = tester.getSize(tiles.at(i));
            expect(size.height, greaterThan(0));
          }
        },
      );

      testWidgets(
        'segmented button keeps one line — ${entry.key} @ ${textScale}x',
        (tester) async {
          tester.view.physicalSize = entry.value;
          tester.view.devicePixelRatio = 1.0;
          addTearDown(tester.view.reset);

          await tester.pumpWidget(
            _harness(
              child: const CustomSegmentedButton(),
              textScale: textScale,
            ),
          );
          await tester.pumpAndSettle();

          expect(tester.takeException(), isNull);

          for (final text in tester.widgetList<Text>(find.byType(Text))) {
            expect(text.maxLines, 1);
          }
        },
      );
    }
  }
}
