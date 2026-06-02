import 'package:flutter/material.dart';

class NoteCard extends StatelessWidget {
  final String title;
  final String type;
  final int count;
  final Color color;
  final IconData icon;
  final int number;

  const NoteCard({
    super.key,
    required this.title,
    required this.type,
    required this.count,
    required this.color,
    required this.icon,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Stack(
        children: [
          // Main Card

          Container(
            padding: const EdgeInsets.fromLTRB(12, 12, 60, 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Left icons (delete + edit)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: Colors.orange),
                ),
                const SizedBox(
                  width: 10,
                ),

                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red.shade400),
                              const SizedBox(width: 10),
                              Icon(Icons.edit, color: Colors.teal),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          // Type badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: type == "إيجابي"
                                  ? Colors.teal.shade50
                                  : Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              type,
                              style: TextStyle(
                                color: type == "إيجابي"
                                    ? Colors.teal
                                    : Colors.orange,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),

                          Text("($count) نقاط"),
                        ],
                      ),
                    ],
                  ),
                ),

                // Icon box (emoji)
              ],
            ),
          ),

          // Right colored strip with number
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 40,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(14),
                  bottomRight: Radius.circular(14),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                number.toString(),
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
