import 'package:flutter/material.dart';
import 'dart:math';

class CirclePainter extends CustomPainter {
  final double progress;
  final bool isDarkMode;

  CirclePainter({required this.progress, required this.isDarkMode});

  @override
  void paint(Canvas canvas, Size size) {
    final baseCircle =
        Paint()
          ..strokeWidth = 12
          ..color = isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300
          ..style = PaintingStyle.stroke;

    final progressCircle =
        Paint()
          ..strokeWidth = 12
          ..color = const Color(0xFF00A693)
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    canvas.drawCircle(center, radius, baseCircle);

    final angle = 2 * pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      -angle,
      false,
      progressCircle,
    );
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.isDarkMode != isDarkMode;
}
