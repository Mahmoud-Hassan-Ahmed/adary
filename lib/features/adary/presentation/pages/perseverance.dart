import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/conts/style.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/presentation/pages/audience.dart';
import 'package:adary/features/adary/presentation/pages/behavior.dart';
import 'package:adary/features/adary/presentation/pages/behavioral_notes_list.dart';
import 'package:adary/features/adary/presentation/pages/reports_statistics.dart';
import 'package:adary/features/adary/presentation/widgets/perseverance/attendance_reports.dart';
import 'package:adary/features/adary/presentation/widgets/perseverance/filter.dart';
import 'package:adary/features/adary/presentation/widgets/perseverance/filter2.dart';
import 'package:adary/features/adary/presentation/widgets/task/add_task_teacher.dart';
import 'package:adary/features/adary/presentation/widgets/task/current.dart';
import 'package:adary/features/adary/presentation/widgets/task/finsh.dart';
import 'package:adary/features/adary/presentation/widgets/task/next.dart';
import 'package:adary/features/adary/presentation/widgets/text/label_main_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Perseverance extends StatefulWidget {
  const Perseverance({super.key});

  @override
  State<Perseverance> createState() => _PerseveranceState();
}

class _PerseveranceState extends State<Perseverance> {
  bool isView = true;
  int? classId;
  String? date;
  int? session;
  DateTime? dateTime;
  String? className, sessionName;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Builder(
        builder: (context) {
          final TabController tabController = DefaultTabController.of(context)!;

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
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isView = true;
                                });
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/octicon_checklist-16.svg',
                                    color: isView
                                        ? AppColors.APP_COLOR
                                        : Colors.grey,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  LabelMainText(
                                    text: 'قائمة الحضور  ',
                                    fontSize: 14,
                                    color: isView
                                        ? AppColors.APP_COLOR
                                        : Colors.grey,
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isView = false;
                                });
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/mingcute_user-add-line.svg',
                                    color: !isView
                                        ? AppColors.APP_COLOR
                                        : Colors.grey,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  LabelMainText(
                                    text: 'تسجيل الحضور ',
                                    fontSize: 14,
                                    color: !isView
                                        ? AppColors.APP_COLOR
                                        : Colors.grey,
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset("assets/icons/icon-search.svg"))
                ],
              ),
              appBar: AppBar(
                centerTitle: true,
                iconTheme: const IconThemeData(color: AppColors.APP_COLOR),
                actions: [
                  IconButton(
                    onPressed: () {
                      if (tabController.index == 0 ||
                          tabController.index == 1) {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return FilterWidget(
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
                            );
                          },
                        );
                      } else {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return const FilterWidget2();
                          },
                        );
                      }
                    },
                    icon: SvgPicture.asset(
                      'assets/icons/icon-filter.svg',
                    ),
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
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                      tabs: const [
                        Tab(text: 'الحضور'),
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
                        // AttendanceStatsPage(),
                        Audience(
                          key: ValueKey(
                              '$date-$classId-$session-${dateTime?.toIso8601String()}'),
                          isView: isView,
                          classId: classId,
                          className: className,
                          sessionName: sessionName,
                          date: date,
                          dateTime: dateTime,
                          session: session,
                        ),
                        Behavior(
                          key: ValueKey(
                              '$date-$classId-$session-${dateTime?.toIso8601String()}'),
                          isView: isView,
                          classId: classId,
                          className: className,
                          sessionName: sessionName,
                          date: date,
                          dateTime: dateTime,
                          session: session,
                        ),
                        ReportsStatistics(
                          isView: isView,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
