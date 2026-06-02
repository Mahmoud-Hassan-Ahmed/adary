import 'package:adary/features/adary/data/models/exam_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CommitteeCard extends StatelessWidget {
  const CommitteeCard(
      {super.key,
      required this.examDay,
      required this.exam,
      required this.hall});
  final ExamDay examDay;
  final Exam exam;
  final Hall hall;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const BoxDecoration(
                  color: Color(0xFF4CB5AE),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Day
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/icons/calendar-06.svg",
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('EEEE').format(examDay.day),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // Date
                    Text(
                      examDay.dateDisplay,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 🔹 Left Content
            Expanded(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F7F7),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                  border: Border.all(color: const Color(0xFF4CB5AE)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      hall.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D3557),
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Name
                    Wrap(
                        children: hall.teachers
                            .map((e) => Row(
                                  children: [
                                    const Icon(Icons.person_outline,
                                        size: 16, color: Color(0xFF4CB5AE)),
                                    const SizedBox(width: 6),
                                    Text(
                                      e.name,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ))
                            .toList()),

                    const SizedBox(height: 6),

                    // Time
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.access_time,
                            size: 16, color: Color(0xFF4CB5AE)),
                        const SizedBox(width: 6),
                        Text(
                          "${hall.period.name} (${hall.period.startTime}  الى ${hall.period.endTime}) ",
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 🔹 Right Date Panel
          ],
        ),
      ),
    );
  }
}
