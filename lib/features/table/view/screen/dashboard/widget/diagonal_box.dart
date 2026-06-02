import 'package:adary/core/conts/app_colors.dart';
import 'package:flutter/material.dart';

class DiagonalBox extends StatelessWidget {
  final String topText;
  final String bottomText;
  final double size;

  const DiagonalBox({
    super.key,
    required this.topText,
    required this.bottomText,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 95,
      decoration: BoxDecoration(
        color: AppColors.APP_COLOR,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // Diagonal line
          CustomPaint(
            size: const Size(120, 95),
            painter: DiagonalPainter(),
          ),

          // Top text (rotated)
          Positioned(
            top: 20,
            left: 12,
            child: Transform.rotate(
              angle: -0.8, // adjust rotation
              child: Text(
                topText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),

          // Bottom text (rotated)
          Positioned(
            bottom: 20,
            right: 12,
            child: Transform.rotate(
              angle: -0.8,
              child: Text(
                bottomText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DiagonalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2;

    canvas.drawLine(
      Offset(0, size.height),
      Offset(size.width, 0),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
