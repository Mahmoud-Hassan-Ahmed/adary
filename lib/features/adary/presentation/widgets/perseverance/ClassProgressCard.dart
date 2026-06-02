import 'package:adary/features/adary/data/models/attendance_statistics_model.dart';
import 'package:flutter/material.dart';

class ClassProgressCard extends StatelessWidget {
  const ClassProgressCard({super.key, required this.classStatistics});
  final ClassStatistics classStatistics;

  @override
  Widget build(BuildContext context) {
    int present = classStatistics.present.count;
    int absent = classStatistics.absent.count;
    int late = classStatistics.late.count;

    int total = present + absent + late;

    double presentRatio = present / total;
    double absentRatio = absent / total;
    double lateRatio = late / total;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            classStatistics.className,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          /// Multi Color Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Row(
              children: [
                Expanded(
                  flex: (lateRatio * 100).toInt(),
                  child: Container(height: 8, color: Colors.orange),
                ),
                Expanded(
                  flex: (absentRatio * 100).toInt(),
                  child: Container(height: 8, color: Colors.red),
                ),
                Expanded(
                  flex: (presentRatio * 100).toInt(),
                  child: Container(height: 8, color: Colors.green),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          /// Numbers Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("حضور $present",
                  style: const TextStyle(color: Colors.green)),
              Text("غياب $absent", style: const TextStyle(color: Colors.red)),
              Text("تأخر $late", style: const TextStyle(color: Colors.orange)),
            ],
          )
        ],
      ),
    );
  }
}
