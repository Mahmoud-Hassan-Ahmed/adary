import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/exam_model.dart';
import 'package:adary/features/adary/presentation/pages/exam_details.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ExamCard extends StatelessWidget {
  const ExamCard({super.key, required this.exam});
  final Exam exam;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppUtils.go(ExamDetails(exam: exam));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.black.withOpacity(0.08),
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // 🔹 Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: const BoxDecoration(
                color: Color(0xFF4CB5AE),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      exam.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SvgPicture.asset("assets/icons/arrow.svg"),
                ],
              ),
            ),

            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                SvgPicture.asset("assets/icons/calendar-06.svg"),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    "تاريخ اللجنة من ${DateFormat('dd/MM/yyyy').format(exam.startDate)} حتى ${DateFormat('dd/MM/yyyy').format(exam.endDate)}",
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
            // 🔹 Body
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date row

                        if (exam.description != null) const SizedBox(height: 8),

                        // Description
                        if (exam.description != null)
                          Text(
                            exam.description ?? '',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                      ],
                    ),
                  ),

                  // 🔹 Left badge

                  const SizedBox(width: 12),
                  Container(
                    width: 80,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CB5AE),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "عدد اللجان",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          exam.numberOfHalls.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 🔹 Right content
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
