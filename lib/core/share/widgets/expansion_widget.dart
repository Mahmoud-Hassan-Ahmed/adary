import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExpansionWidget extends StatefulWidget {
  const ExpansionWidget(
      {super.key,
      required this.title,
      required this.body,
      this.isSelect = false});
  final List<Widget> title;
  final List<Widget> body;
  final bool isSelect;

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
      childrenPadding: const EdgeInsets.all(20),
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
      backgroundColor: Colors.yellow.shade200,
      collapsedBackgroundColor: widget.isSelect ? Colors.yellow.shade200 : null,
      trailing: AnimatedBuilder(
        animation: _rotationAnimation,
        builder: (context, child) {
          return Transform.rotate(
            angle: _rotationAnimation.value * 3.14,
            child: CircleAvatar(
              radius: 15,
              backgroundColor: _rotationAnimation.value > 0.5
                  ? Colors.blueGrey
                  : Colors.grey.shade300,
              child: Icon(
                Icons.keyboard_arrow_down,
                color: _rotationAnimation.value > 0.5
                    ? Colors.white
                    : Colors.black,
              ),
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
