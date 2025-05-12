import 'package:flutter/material.dart';
import 'dart:math';

class HalfPieChart extends StatelessWidget {
  const HalfPieChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CustomPaint(
          size: Size(250, 125), // Full width, half height
          painter: HalfCirclePainter(),
        ),
      ),
    );
  }
}

class HalfCirclePainter extends CustomPainter {
  final List<double> values = [80, 20, 40];
  final List<Color> colors = [Colors.pink, Colors.grey.shade300, Colors.blue];

  @override
  void paint(Canvas canvas, Size size) {
    final total = values.reduce((a, b) => a + b);
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2;

    final strokeWidth = 40.0;
    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.butt;

    double startAngle = pi;

    for (int i = 0; i < values.length; i++) {
      final sweepAngle = pi * (values[i] / total);

      // Draw arc
      paint.color = colors[i];
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      // Draw label
      final textPainter = TextPainter(
        text: TextSpan(
          text: '${values[i].toInt()}%',
          style: TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      // Calculate label position (middle of arc)
      final labelAngle = startAngle + sweepAngle / 2;
      final labelRadius = radius - strokeWidth / 2;
      final labelOffset = Offset(
        center.dx + labelRadius * cos(labelAngle) - textPainter.width / 2,
        center.dy + labelRadius * sin(labelAngle) - textPainter.height / 2,
      );

      textPainter.paint(canvas, labelOffset);

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
