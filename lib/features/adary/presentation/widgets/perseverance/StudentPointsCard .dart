import 'package:adary/features/adary/data/models/student_per.dart';
import 'package:flutter/material.dart';

class StudentPointsCard extends StatelessWidget {
  final StudentBehavior studentBehavior;
  final String className;
  const StudentPointsCard(
      {super.key, required this.studentBehavior, required this.className});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Stack(
        children: [
          /// Main Card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Top Row (name + avatar)
                Row(
                  children: [
                    /// Avatar
                    const CircleAvatar(
                      radius: 24,
                      backgroundImage: AssetImage("assets/images/student.jpg"),
                    ),

                    const SizedBox(
                      width: 10,
                    ),

                    /// Name + info
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          studentBehavior.student.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(className.toString(),
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.blue)),
                            const SizedBox(width: 12),
                            const Icon(
                              Icons.circle,
                              size: 5,
                              color: Colors.blue,
                            ),
                            Text(studentBehavior.date_hijri,
                                style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                /// Add Note Button
                Wrap(
                    children: studentBehavior.notes
                        .map(
                          (e) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(0.1), // shadow color
                                  blurRadius: 6, // softness
                                  spreadRadius: 1, // size
                                  offset: const Offset(0, 2), // position (x, y)
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.sentiment_satisfied, color: e.color),
                                const SizedBox(width: 6),
                                Text(e.title ?? ''),
                              ],
                            ),
                          ),
                        )
                        .toList()),

                const SizedBox(height: 8),

                /// Notes Text
                if (studentBehavior.additional_notes.isNotEmpty)
                  Text(
                    studentBehavior.additional_notes,
                    style: const TextStyle(fontSize: 13),
                  ),
                if (studentBehavior.additional_notes.isNotEmpty)
                  const SizedBox(height: 10),

                /// Bottom Row
                Row(
                  children: [
                    /// Delete
                    /// Total
                    Text(
                      "الإجمالي : ${studentBehavior.total_points} نقطة",
                      style: TextStyle(
                        color: studentBehavior.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),

                    // Icon(Icons.delete, color: Colors.red[400]),

                    // const SizedBox(width: 12),

                    // /// Edit
                    // const Icon(Icons.edit, color: Colors.cyan),
                  ],
                )
              ],
            ),
          ),

          /// Corner Badge
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: studentBehavior.color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomRight: Radius.circular(30),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                "${studentBehavior.total_points}",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
