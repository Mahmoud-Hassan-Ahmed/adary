import 'package:flutter/material.dart';

class PercentCard extends StatelessWidget {
  final int percent;
  final Color color;
  final String label;

  const PercentCard({
    super.key,
    required this.percent,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: percent / 100,
                  strokeWidth: 6,
                  backgroundColor: Colors.grey[200],
                  color: color,
                ),
                Text("%$percent"),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }
}
