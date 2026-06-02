import 'package:adary/features/adary/data/models/weekly_pan.dart';
import 'package:flutter/material.dart';

class WeekItem extends StatelessWidget {
  const WeekItem({super.key, required this.weeklyPan});
  final WeeklyPan weeklyPan;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      // padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF4DB6AC)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Left arrow
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
            decoration: const BoxDecoration(
              color: Color(0xFF4DB6AC),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(11),
                bottomRight: Radius.circular(11),
              ),
            ),
            width: 50,
            height: 60,
            child: Center(
              child: Text(
                weeklyPan.weekNumber.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Middle text
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  weeklyPan.weekNumberText,
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(width: 10),
                Text(
                  "عدد الخطط ${weeklyPan.weeklyPlansCount}",
                  style: const TextStyle(fontSize: 12, color: Colors.red),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: const Icon(Icons.arrow_forward_ios, size: 16),
          ),

          // Right selected box
        ],
      ),
    );
  }
}
