import 'package:adary/features/adary/data/models/behavior_statistics_model.dart';
import 'package:flutter/material.dart';

class ClassProgressCard2 extends StatelessWidget {
  const ClassProgressCard2({super.key, required this.classStatistics});
  final BehaviorStatisticsModel classStatistics;

  @override
  Widget build(BuildContext context) {
    int excellent = classStatistics.excellent;
    int veryGood = classStatistics.veryGood;
    int good = classStatistics.good;
    int acceptable = classStatistics.acceptable;
    int poor = classStatistics.weak;

    int total = excellent + veryGood + good + acceptable + poor;

    double excellentRatio = total == 0 ? 0 : excellent / total;
    double veryGoodRatio = total == 0 ? 0 : veryGood / total;
    double goodRatio = total == 0 ? 0 : good / total;
    double acceptableRatio = total == 0 ? 0 : acceptable / total;
    double poorRatio = total == 0 ? 0 : poor / total;
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
                  flex: (excellentRatio * 100).toInt(),
                  child: Container(height: 8, color: Colors.green),
                ),
                Expanded(
                  flex: (veryGoodRatio * 100).toInt(),
                  child: Container(height: 8, color: Colors.lightGreen),
                ),
                Expanded(
                  flex: (goodRatio * 100).toInt(),
                  child: Container(height: 8, color: Colors.yellow),
                ),
                Expanded(
                  flex: (acceptableRatio * 100).toInt(),
                  child: Container(height: 8, color: Colors.orange),
                ),
                Expanded(
                  flex: (poorRatio * 100).toInt(),
                  child: Container(height: 8, color: Colors.red),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          /// Numbers Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("ممتاز $excellent",
                  style: const TextStyle(color: Colors.green)),
              Text("جيد جدا $veryGood",
                  style: const TextStyle(color: Colors.lightGreen)),
              Text("جيد $good", style: const TextStyle(color: Colors.yellow)),
              Text("مقبول $acceptable",
                  style: const TextStyle(color: Colors.orange)),
              Text("ضعيف $poor", style: const TextStyle(color: Colors.red)),
            ],
          )
        ],
      ),
    );
  }
}
