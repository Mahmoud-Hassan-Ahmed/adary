import 'package:flutter/material.dart';

class RatingView extends StatelessWidget {
  final double rating; // مثال: 3.5
  final int maxStars;

  const RatingView({
    super.key,
    required this.rating,
    this.maxStars = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxStars, (index) {
        if (index < rating.floor()) {
          // نجمة كاملة
          return const Icon(Icons.star, color: Colors.amber);
        } else if (index < rating) {
          // نصف نجمة
          return const Icon(Icons.star_half, color: Colors.amber);
        } else {
          // نجمة فاضية
          return const Icon(Icons.star_border, color: Colors.grey);
        }
      }),
    );
  }
}
