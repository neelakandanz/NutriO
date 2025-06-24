// lib/src/view/water_intake/widgets/water_glass_painter.dart

import 'dart:math' as math;
import 'package:flutter/material.dart';

class WaterGlassPainter extends CustomPainter {
  final double waterLevelPercent; // 0.0 to 1.0
  final Animation<double> waveAnimation;

  WaterGlassPainter({required this.waterLevelPercent, required this.waveAnimation})
      : super(repaint: waveAnimation);

  @override
  void paint(Canvas canvas, Size size) {
    // Define the glass shape
    final glassPath = Path()
      ..moveTo(size.width * 0.1, 0)
      ..lineTo(size.width * 0.9, 0)
      ..lineTo(size.width * 0.8, size.height)
      ..lineTo(size.width * 0.2, size.height)
      ..close();

    final glassPaint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Draw the glass outline
    canvas.drawPath(glassPath, glassPaint);

    // Only draw water if there is any
    if (waterLevelPercent > 0) {
      final waterPaint = Paint()
        ..color = const Color(0xFF2a9fed).withOpacity(0.7)
        ..style = PaintingStyle.fill;

      final waterPath = Path();
      final waveHeight = size.height * (1 - waterLevelPercent);

      waterPath.moveTo(size.width * 0.2, size.height);
      waterPath.lineTo(size.width * 0.8, size.height);
      waterPath.lineTo(size.width * 0.9, 0 + waveHeight); // Top right corner of water

      // Create the wave effect
      for (double x = size.width; x >= 0; x--) {
        waterPath.lineTo(
          x,
          waveHeight + math.sin((x / size.width * 2 * math.pi) + (waveAnimation.value * 2 * math.pi)) * 5, // 5 is amplitude
        );
      }

      waterPath.lineTo(size.width * 0.1, 0 + waveHeight); // Top left corner of water
      waterPath.close();

      // Clip the water path to the glass shape
      canvas.clipPath(glassPath);
      canvas.drawPath(waterPath, waterPaint);
    }
  }

  @override
  bool shouldRepaint(covariant WaterGlassPainter oldDelegate) {
    return oldDelegate.waterLevelPercent != waterLevelPercent ||
           oldDelegate.waveAnimation.value != waveAnimation.value;
  }
}