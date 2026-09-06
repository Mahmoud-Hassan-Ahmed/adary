import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/conts/style.dart';
import 'package:adary/features/adary/presentation/pages/audience.dart';
import 'package:adary/features/adary/presentation/pages/behavior.dart';
import 'package:adary/features/adary/presentation/pages/reports_statistics.dart';
import 'package:adary/features/adary/presentation/widgets/perseverance/filter.dart';
import 'package:adary/features/adary/presentation/widgets/perseverance/filter2.dart';
import 'package:adary/features/adary/presentation/widgets/text/label_main_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// أوضاع الشريط السفلي. تبويب المواظبة يضم الثلاثة، وبقية التبويبات وضعين.
class ConductMode {
  static const list = 0;
  static const registerAttendance = 1;
  static const registerNote = 2;
}

/// خيار واحد في الشريط السفلي.
class _BottomOption {
  const _BottomOption(this.mode, this.label, this.icon);

  final int mode;
  final String label;
  final String icon;
}

/// «المواظبة والسلوك» — الشاشة الجامعة لتبويبات القسم الثلاثة.
class Perseverance extends StatefulWidget {
  const Perseverance({super.key});

  @override
  State<Perseverance> createState() => _PerseveranceState();
}

class _PerseveranceState extends State<Perseverance>
    with SingleTickerProviderStateMixin {
  late final TabController tabController =
      TabController(length: 3, vsync: this)..addListener(_onTabChanged);

  int mode = ConductMode.list;
  int? classId;
  String? date;
  int? session;
  DateTime? dateTime;
  String? className, sessionName;

  static const _listIcon = 'assets/icons/octicon_checklist-16.svg';
  static const _registerIcon = 'assets/icons/mingcute_user-add-line.svg';

  void _onTabChanged() {
    if (!tabController.indexIsChanging) return;
    // كل تبويب يبدأ من العرض، فوضع التسجيل سياق مستقل لكلٍّ منها.
    setState(() => mode = ConductMode.list);
  }

  @override
  void dispose() {
    tabController
      ..removeListener(_onTabChanged)
      ..dispose();
    super.dispose();
  }

  /// خيارات الشريط السفلي بترتيب القراءة: الأول يمينًا كما في التصميم.
  List<_BottomOption> get _options {
    switch (tabController.index) {
      case 1:
        return const [
          _BottomOption(ConductMode.list, 'سلوك الطلاب', _listIcon),
          _BottomOption(ConductMode.registerNote, 'تسجيل السلوك', _registerIcon),
        ];
      case 2:
        return const [
          _BottomOption(ConductMode.list, 'تقارير الحضور', _listIcon),
          _BottomOption(
              ConductMode.registerNote, 'تقارير السلوك', _registerIcon),
        ];
      default:
        // «تسجيل ملاحظة» ليس من المواظبة: مكانه تبويب السلوك، ووجوده هنا
        // كان يفتح شاشة ملاحظات داخل تبويب الحضور.
        return const [
          _BottomOption(ConductMode.list, 'قائمة الطلاب', _listIcon),
          _BottomOption(
              ConductMode.registerAttendance, 'تسجيل حضور', _registerIcon),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.APP_COLOR),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: _options
                      .map((option) => Expanded(child: _bottomItem(option)))
                      .toList(),
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset("assets/icons/icon-search.svg"),
            )
          ],
        ),
        appBar: AppBar(
          centerTitle: true,
          iconTheme: const IconThemeData(color: AppColors.APP_COLOR),
          actions: [
            IconButton(
              onPressed: _openFilter,
              icon: SvgPicture.asset('assets/icons/icon-filter.svg'),
            ),
          ],
          title: Text(
            'المواظبة والسلوك ',
            style: AbhayaLibre.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.APP_COLOR,
            ),
          ),
        ),
        body: Column(
          children: [
            /// 🔹 Segmented TabBar
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
                tabs: const [
                  Tab(text: 'المواظبة'),
                  Tab(text: 'السلوك'),
                  Tab(text: 'التقارير والاحصائيات'),
                ],
              ),
            ),

            /// 🔹 المحتوى
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  Audience(
                    key: ValueKey(
                        '$date-$classId-$session-${dateTime?.toIso8601String()}-$mode'),
                    mode: mode,
                    classId: classId,
                    className: className,
                    sessionName: sessionName,
                    date: date,
                    dateTime: dateTime,
                    session: session,
                  ),
                  Behavior(
                    key: ValueKey(
                        '$date-$classId-$session-${dateTime?.toIso8601String()}-$mode'),
                    isView: mode == ConductMode.list,
                    classId: classId,
                    className: className,
                    sessionName: sessionName,
                    date: date,
                    dateTime: dateTime,
                    session: session,
                  ),
                  ReportsStatistics(isView: mode == ConductMode.list),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomItem(_BottomOption option) {
    final selected = mode == option.mode;
    final color = selected ? AppColors.APP_COLOR : Colors.grey;
    return GestureDetector(
      onTap: () => setState(() => mode = option.mode),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            option.icon,
            // ignore: deprecated_member_use
            color: color,
          ),
          const SizedBox(height: 5),
          LabelMainText(
            text: option.label,
            fontSize: 13,
            color: color,
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  void _openFilter() {
    // تبويب التقارير له فلتره الخاص (نوع التقرير والصيغة).
    final isReports = tabController.index == 2;
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => isReports
          ? const FilterWidget2()
          : FilterWidget(
              date: (value) {
                setState(() {
                  date = value.$1;
                  dateTime = value.$2;
                  classId = value.$3;
                  session = value.$4;
                  className = value.$5;
                  sessionName = value.$6;
                });
              },
            ),
    );
  }
}
