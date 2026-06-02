import 'package:adary/core/conts/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ExamItemWidget extends StatelessWidget {
  final String title;
  final String date;
  final String description;
  final int committeesCount;
  final int index;

  const ExamItemWidget({
    super.key,
    required this.title,
    required this.date,
    required this.description,
    required this.committeesCount,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF4CB5AE)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Color(0xFF4CB5AE),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SvgPicture.asset(
                      "assets/icons/arrow.svg",
                      color: AppColors.APP_COLOR,
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    SvgPicture.asset("assets/icons/calendar-06.svg"),
                    const SizedBox(width: 4),
                    Text(
                      date,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                // 🔹 Left badge
                // Container(
                //   padding:
                //       const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                //   decoration: BoxDecoration(
                //     color: const Color(0xFF4CB5AE),
                //     borderRadius: BorderRadius.circular(8),
                //   ),
                //   child: Column(
                //     children: [
                //       const Text(
                //         "عدد اللجان",
                //         style: TextStyle(
                //           color: Colors.white,
                //           fontSize: 12,
                //         ),
                //       ),
                //       Text(
                //         committeesCount.toString(),
                //         style: const TextStyle(
                //           color: Colors.white,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),

                // const SizedBox(width: 10),

                // // 🔹 Content
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        description,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CB5AE),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "عدد اللجان",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            committeesCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // date

                // description
              ],
            ),
          ),

          // 🔹 Top number
          Positioned(
            top: -15,
            right: 20,
            width: 70,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: const BoxDecoration(
                color: Color(0xFF4CB5AE),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
              ),
              child: Center(
                child: Text(
                  index.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
