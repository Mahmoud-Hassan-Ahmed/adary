import 'package:adary/features/table/controller/calender_controller.dart';
import 'package:adary/features/table/controller/teacher_page_controller.dart';
import 'package:adary/features/table/utils/app_colors.dart';
import 'package:adary/features/table/utils/style.dart';
import 'package:adary/features/table/view/base/table.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart' as easy;

class InstructorFullTable extends StatefulWidget {
  final Map<String, dynamic> table;
  const InstructorFullTable({super.key, required this.table});

  @override
  State<InstructorFullTable> createState() => _InstructorFullTableState();
}

class _InstructorFullTableState extends State<InstructorFullTable> {
  bool _showTime = true;
  bool _forcedFull = false;

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
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

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      final showFull =
          _forcedFull || orientation == Orientation.landscape;

      return Scaffold(
        backgroundColor: const Color(0xFFF8FAFB),
        appBar: showFull ? null : _buildAppBar(),
        body: showFull
            ? _buildFitView(context)
            : SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderCard(),
                    Expanded(child: _buildScrollableTable()),
                  ],
                ),
              ),
      );
    });
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.SECONDERYCOLOR,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: Text(
        easy.tr('back'),
        style: AlMaraiaBold.copyWith(color: Colors.white, fontSize: 18),
      ),
      actions: [
        IconButton(
          tooltip: _showTime ? 'إخفاء الوقت' : 'إظهار الوقت',
          onPressed: () => setState(() => _showTime = !_showTime),
          icon: Icon(
            _showTime
                ? Icons.access_time_rounded
                : Icons.access_time_filled_outlined,
            color: Colors.white,
          ),
        ),
        IconButton(
          tooltip: 'ملء الشاشة',
          onPressed: _enterFull,
          icon: const Icon(Icons.fullscreen_rounded, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.SECONDERYCOLOR, Color(0xFF9ED3D7)],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.SECONDERYCOLOR.withValues(alpha: 0.35),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white.withValues(alpha: 0.25),
            radius: 26,
            child: const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  easy.tr('teacher_name'),
                  style: AlMaraia.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.table["teacher_name"]?.toString() ?? '',
                  style: AlMaraiaBold.copyWith(
                      color: Colors.white, fontSize: 20),
                ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.table_chart_rounded,
                    color: Colors.white, size: 14),
                const SizedBox(width: 4),
                Text(
                  'جدول',
                  style:
                      AlMaraia.copyWith(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScrollableTable() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 12),
          AppTable(
            table: widget.table,
            isInstructor: true,
            showTime: _showTime,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Full-screen: FittedBox scales the table to fill the screen with no AppBar.
  Widget _buildFitView(BuildContext context) {
    final classesCount =
        Get.find<TeacherPageController>().classesNamesAndNumbers.length;
    final daysCount =
        Get.find<CalednerController>().workDaysList.length;

    final topPad = MediaQuery.of(context).padding.top;

    if (classesCount == 0 || daysCount == 0) {
      return Stack(children: [
        const Center(
            child: CircularProgressIndicator(
                color: AppColors.SECONDERYCOLOR)),
        _exitOverlay(topPad),
      ]);
    }

    const double sessionColW = 180.0;
    const double daysColW = 140.0;
    final double virtualW = daysColW + classesCount * sessionColW;
    final double renderH = (daysCount + 1) * 100.0;
    final double virtualH = renderH * 1.2;

    return Stack(children: [
      // Scaled table
      MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(size: Size(virtualW, virtualH)),
        child: FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
            width: virtualW,
            height: renderH,
            child: AppTable(
              table: widget.table,
              isInstructor: true,
              showTime: _showTime,
            ),
          ),
        ),
      ),

      // Overlay controls
      Positioned(
        top: topPad + 6,
        left: 8,
        right: 8,
        child: Row(
          children: [
            // Exit fullscreen
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

            // Teacher name badge
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
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
                        widget.table["teacher_name"]?.toString() ?? '',
                        style: AlMaraiaBold.copyWith(
                            color: Colors.white, fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Time toggle
            GestureDetector(
              onTap: () => setState(() => _showTime = !_showTime),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.SECONDERYCOLOR.withValues(alpha: 0.88),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 3)
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _showTime
                          ? Icons.access_time_rounded
                          : Icons.access_time_filled_outlined,
                      color: Colors.white,
                      size: 15,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _showTime ? 'إخفاء الوقت' : 'إظهار الوقت',
                      style: AlMaraia.copyWith(
                          color: Colors.white, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ]);
  }

  Widget _exitOverlay(double topPad) {
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
}
