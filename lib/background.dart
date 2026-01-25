import 'package:flutter/material.dart';
import 'dart:math' as math;

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFF1697D1)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height * 1.4);
    final radius = size.width * 2;
    
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;    
}