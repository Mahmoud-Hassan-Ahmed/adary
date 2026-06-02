import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ExpansionWidget extends StatefulWidget {
  const ExpansionWidget(
      {super.key,
      required this.title,
      required this.body,
      this.color,
      this.ispadding = true,
      this.isSelect = false});
  final List<Widget> title;
  final List<Widget> body;
  final bool isSelect;
  final bool ispadding;
  final Color? color;

  @override
  State<ExpansionWidget> createState() => _ExpansionWidgetState();
}

class _ExpansionWidgetState extends State<ExpansionWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _rotationAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      childrenPadding:
          widget.ispadding ? const EdgeInsets.all(20) : EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      onExpansionChanged: (isExpanded) {
        if (isExpanded) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      },
      backgroundColor: widget.color ?? Colors.white,
      collapsedBackgroundColor: widget.isSelect ? Colors.yellow.shade200 : null,
      trailing: AnimatedBuilder(
        animation: _rotationAnimation,
        builder: (context, child) {
          return Transform.rotate(
            angle: _rotationAnimation.value * 3.14,
            child: SvgPicture.asset(
              "assets/icons/arrow-down-contained.svg",
              width: 30,
              height: 30,
            ),
          );
        },
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: widget.title,
      ),
      children: widget.body,
    );
  }
}
