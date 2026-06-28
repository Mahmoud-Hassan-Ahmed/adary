import 'package:adary/features/table/controller/calender_controller.dart';
import 'package:adary/features/table/controller/teacher_page_controller.dart';
import 'package:adary/features/table/utils/app_colors.dart';
import 'package:adary/features/table/utils/style.dart';
import 'package:adary/features/table/view/base/table.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart' as easy;

import 'widget/dropDownBtn.dart';

class InstructorsFullTable extends StatefulWidget {
  const InstructorsFullTable({super.key});

  @override
  State<InstructorsFullTable> createState() => _InstructorsFullTableState();
}

class _InstructorsFullTableState extends State<InstructorsFullTable> {
  bool _showTime = true;
  bool _forcedFull = false;

  final PageController _pageCtrl = PageController();
  int _currentPage = 0;
  int _prevTableCount = -1;

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    _pageCtrl.dispose();
    super.dispose();
  }

  void _enterFull() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    setState(() => _forcedFull = true);
  }

  void _exitFull() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    setState(() => _forcedFull = false);
  }

  void _onPageChanged(int idx) {
    setState(() => _currentPage = idx);
  }

  void _syncPageIfNeeded(int newCount) {
    if (newCount != _prevTableCount) {
      _prevTableCount = newCount;
      if (_currentPage != 0) {
        _currentPage = 0;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_pageCtrl.hasClients) _pageCtrl.jumpToPage(0);
        });
      }
    }
  }

  // ── Full-screen view ─────────────────────────────────────────────────────
  Widget _buildFullScreenView(BuildContext context) {
    final classesCount =
        Get.find<TeacherPageController>().classesNamesAndNumbers.length;
    final daysCount = Get.find<CalednerController>().workDaysList.length;
    final topPad = MediaQuery.of(context).padding.top;

    if (classesCount == 0 || daysCount == 0) {
      return Stack(children: [
        const Center(
            child:
                CircularProgressIndicator(color: AppColors.SECONDERYCOLOR)),
        _buildExitBtn(topPad),
      ]);
    }

    const double sessionColW = 180.0;
    const double daysColW = 140.0;
    final double virtualW = daysColW + classesCount * sessionColW;
    final double renderH = (daysCount + 1) * 100.0;
    final double virtualH = renderH * 1.2;

    return Stack(children: [
      // PageView — swipe up/down to switch teachers
      GetBuilder<TeacherPageController>(builder: (ctrl) {
        _syncPageIfNeeded(ctrl.teachersTableList.length);
        return PageView.builder(
          controller: _pageCtrl,
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          itemCount: ctrl.teachersTableList.length,
          onPageChanged: _onPageChanged,
          itemBuilder: (ctx, index) {
            // FittedBox inside each item so PageView swipes work freely.
            return MediaQuery(
              data: MediaQuery.of(ctx)
                  .copyWith(size: Size(virtualW, virtualH)),
              child: FittedBox(
                fit: BoxFit.contain,
                child: SizedBox(
                  width: virtualW,
                  height: renderH,
                  child: AppTable(
                    table: ctrl.teachersTableList[index],
                    isInstructor: true,
                    showTime: _showTime,
                  ),
                ),
              ),
            );
          },
        );
      }),

      // Overlay bar: exit + teacher badge + time toggle
      GetBuilder<TeacherPageController>(builder: (ctrl) {
        final idx = _currentPage.clamp(
            0, (ctrl.teachersTableList.length - 1).clamp(0, 9999));
        final name = ctrl.teachersTableList.isEmpty
            ? ''
            : ctrl.teachersTableList[idx]['teacher_name']?.toString() ?? '';
        final pageLabel = ctrl.teachersTableList.isEmpty
            ? ''
            : '${idx + 1} / ${ctrl.teachersTableList.length}';
        return _overlayBar(context, topPad, name, pageLabel);
      }),
    ]);
  }

  Widget _overlayBar(BuildContext context, double topPad, String teacherName,
      String pageLabel) {
    return Positioned(
      top: topPad + 6,
      left: 8,
      right: 8,
      child: Row(
        children: [
          // Exit button
          GestureDetector(
            onTap: _exitFull,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.SECONDERYCOLOR.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 4)
                ],
              ),
              child: const Icon(Icons.fullscreen_exit_rounded,
                  color: Colors.white, size: 22),
            ),
          ),
          const SizedBox(width: 8),

          // Teacher badge
          Expanded(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.SECONDERYCOLOR.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.person_rounded,
                      color: Colors.white, size: 15),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      teacherName,
                      style: AlMaraiaBold.copyWith(
                          color: Colors.white, fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (pageLabel.isNotEmpty) ...[
                    const SizedBox(width: 6),
                    Text(
                      pageLabel,
                      style: AlMaraia.copyWith(
                          color: Colors.white70, fontSize: 11),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Time toggle
          _TimeToggleBtn(
            showTime: _showTime,
            onToggle: () => setState(() => _showTime = !_showTime),
          ),
        ],
      ),
    );
  }

  Widget _buildExitBtn(double topPad) {
    return Positioned(
      top: topPad + 6,
      left: 8,
      child: GestureDetector(
        onTap: _exitFull,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.SECONDERYCOLOR.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.fullscreen_exit_rounded,
              color: Colors.white, size: 22),
        ),
      ),
    );
  }

  // ── Normal portrait view ─────────────────────────────────────────────────
  Widget _buildNormalView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ① Dropdown — always visible, pinned
        const Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: InstructorDropDown(),
        ),

        // ② Legend
        const Padding(
          padding: EdgeInsets.fromLTRB(14, 6, 14, 0),
          child: Row(
            children: [
              _LegendCircle(
                color: AppColors.TABLEBACKGROUNDCOLOR,
                label: 'اليوم الحالي',
                borderColor: AppColors.SECONDERYCOLOR,
              ),
              SizedBox(width: 16),
              _LegendCircle(
                color: Color(0xFFFFF8EE),
                label: 'حصة انتظار',
                borderColor: Color(0xFFF57C00),
              ),
            ],
          ),
        ),

        // ③ Teacher header — reactive
        GetBuilder<TeacherPageController>(builder: (ctrl) {
          if (ctrl.teachersTableList.isEmpty) return const SizedBox.shrink();
          final idx =
              _currentPage.clamp(0, ctrl.teachersTableList.length - 1);
          return _TeacherHeader(
            teacherName: ctrl.teachersTableList[idx]['teacher_name']
                    ?.toString() ??
                '',
            currentIndex: idx,
            total: ctrl.teachersTableList.length,
          );
        }),

        // ③ Table fills remaining space
        Expanded(
          child: GetBuilder<TeacherPageController>(
            builder: (ctrl) {
              _syncPageIfNeeded(ctrl.teachersTableList.length);

              if (ctrl.isLoadingTable) {
                return const Center(
                  child: CircularProgressIndicator(
                      color: AppColors.SECONDERYCOLOR),
                );
              }

              if (ctrl.teachersTableList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.table_chart_outlined,
                          size: 56,
                          color: AppColors.GREYFONTCOLOR
                              .withValues(alpha: 0.5)),
                      const SizedBox(height: 12),
                      Text(
                        'لا يوجد جدول',
                        style: AlMaraiaBold.copyWith(
                            fontSize: 16,
                            color: AppColors.GREYFONTCOLOR),
                      ),
                    ],
                  ),
                );
              }

              return PageView.builder(
                controller: _pageCtrl,
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                itemCount: ctrl.teachersTableList.length,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  return AppTable(
                    table: ctrl.teachersTableList[index],
                    isInstructor: true,
                    showTime: _showTime,
                  );
                },
              );
            },
          ),
        ),

        // ④ Page indicator
        GetBuilder<TeacherPageController>(builder: (ctrl) {
          return _PageDots(
              currentPage: _currentPage,
              total: ctrl.teachersTableList.length);
        }),
      ],
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.SECONDERYCOLOR,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: Text(
        easy.tr('الجدول المدرسي'),
        style: AlMaraiaBold.copyWith(color: Colors.white, fontSize: 18),
      ),
      actions: [
        _TimeToggleBtn(
          showTime: _showTime,
          onToggle: () => setState(() => _showTime = !_showTime),
        ),
        IconButton(
          tooltip: 'ملء الشاشة',
          onPressed: _enterFull,
          icon: const Icon(Icons.fullscreen_rounded, color: Colors.white),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      final showFull =
          _forcedFull || orientation == Orientation.landscape;

      return Scaffold(
        backgroundColor: const Color(0xFFF8FAFB),
        appBar: showFull ? null : _buildAppBar(),
        body: showFull
            ? _buildFullScreenView(context)
            : _buildNormalView(context),
      );
    });
  }
}

// ─── Sub-widgets ──────────────────────────────────────────────────────────────

class _TimeToggleBtn extends StatelessWidget {
  final bool showTime;
  final VoidCallback onToggle;
  const _TimeToggleBtn({required this.showTime, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.SECONDERYCOLOR.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              showTime
                  ? Icons.access_time_rounded
                  : Icons.access_time_filled_outlined,
              color: Colors.white,
              size: 15,
            ),
            const SizedBox(width: 4),
            Text(
              showTime ? 'إخفاء الوقت' : 'إظهار الوقت',
              style: AlMaraia.copyWith(color: Colors.white, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

class _TeacherHeader extends StatelessWidget {
  final String teacherName;
  final int currentIndex;
  final int total;
  const _TeacherHeader({
    required this.teacherName,
    required this.currentIndex,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 6, 10, 2),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.SECONDERYCOLOR, Color(0xFF9ED3D7)],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.SECONDERYCOLOR.withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.22),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person_rounded,
                color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  easy.tr('teacher_name'),
                  style: AlMaraia.copyWith(
                      color: Colors.white.withValues(alpha: 0.78),
                      fontSize: 10),
                ),
                Text(
                  teacherName,
                  style: AlMaraiaBold.copyWith(
                      color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${currentIndex + 1} / $total',
              style: AlMaraia.copyWith(color: Colors.white, fontSize: 12),
            ),
          ),
          const SizedBox(width: 6),
          const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.keyboard_arrow_up_rounded,
                  color: Colors.white70, size: 16),
              Icon(Icons.keyboard_arrow_down_rounded,
                  color: Colors.white70, size: 16),
            ],
          ),
        ],
      ),
    );
  }
}

class _PageDots extends StatelessWidget {
  final int currentPage;
  final int total;
  const _PageDots({required this.currentPage, required this.total});

  @override
  Widget build(BuildContext context) {
    if (total <= 1) return const SizedBox(height: 6);
    final dotCount = total.clamp(1, 10);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(dotCount, (i) {
          final isActive = total > 10
              ? (currentPage * dotCount ~/ total) == i
              : currentPage == i;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: isActive ? 20 : 7,
            height: 7,
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.SECONDERYCOLOR
                  : AppColors.SECONDERYCOLOR.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }),
      ),
    );
  }
}

class _LegendCircle extends StatelessWidget {
  final Color color;
  final String label;
  final Color borderColor;
  const _LegendCircle({
    required this.color,
    required this.label,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: borderColor, width: 1.5),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: AlMaraia.copyWith(
              fontSize: 11, color: AppColors.DARKENGREYFONTCOLOR),
        ),
      ],
    );
  }
}
