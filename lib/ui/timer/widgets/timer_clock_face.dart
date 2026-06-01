import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:track_dev/ui/timer/timer_format.dart';

class TimerClockFace extends StatelessWidget {
  const TimerClockFace({
    super.key,
    required this.elapsed,
    this.size = 260,
  });

  final Duration elapsed;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _ClockFacePainter(
          secondAngle: _secondHandAngle(elapsed),
          dialColor: colorScheme.outline.withValues(alpha: 0.35),
          tickColor: colorScheme.outline.withValues(alpha: 0.55),
          handColor: colorScheme.primary,
          hubColor: colorScheme.primary,
        ),
        child: Center(
          child: Text(
            formatTimerDuration(elapsed),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w300,
                  letterSpacing: 3,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
          ),
        ),
      ),
    );
  }

  static double _secondHandAngle(Duration elapsed) {
    final seconds = elapsed.inSeconds % 60;
    return (seconds / 60) * 2 * math.pi - math.pi / 2;
  }
}

class _ClockFacePainter extends CustomPainter {
  _ClockFacePainter({
    required this.secondAngle,
    required this.dialColor,
    required this.tickColor,
    required this.handColor,
    required this.hubColor,
  });

  final double secondAngle;
  final Color dialColor;
  final Color tickColor;
  final Color handColor;
  final Color hubColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide / 2;

    _drawDial(canvas, center, radius);
    _drawTicks(canvas, center, radius);
    _drawSecondHand(canvas, center, radius * 0.78);
    _drawHub(canvas, center);
  }

  void _drawDial(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..color = dialColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, radius - 1, paint);
  }

  void _drawTicks(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..color = tickColor
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < 12; i++) {
      final angle = (i / 12) * 2 * math.pi - math.pi / 2;
      final outer = Offset(
        center.dx + math.cos(angle) * (radius - 6),
        center.dy + math.sin(angle) * (radius - 6),
      );
      final inner = Offset(
        center.dx + math.cos(angle) * (radius - (i % 3 == 0 ? 18 : 12)),
        center.dy + math.sin(angle) * (radius - (i % 3 == 0 ? 18 : 12)),
      );
      paint.strokeWidth = i % 3 == 0 ? 2 : 1;
      canvas.drawLine(inner, outer, paint);
    }
  }

  void _drawSecondHand(Canvas canvas, Offset center, double length) {
    final tip = Offset(
      center.dx + math.cos(secondAngle) * length,
      center.dy + math.sin(secondAngle) * length,
    );

    final handPaint = Paint()
      ..color = handColor
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(center, tip, handPaint);

    final tail = Offset(
      center.dx - math.cos(secondAngle) * (length * 0.18),
      center.dy - math.sin(secondAngle) * (length * 0.18),
    );
    handPaint.strokeWidth = 1.5;
    canvas.drawLine(center, tail, handPaint);
  }

  void _drawHub(Canvas canvas, Offset center) {
    canvas.drawCircle(
      center,
      4,
      Paint()..color = hubColor,
    );
    canvas.drawCircle(
      center,
      4,
      Paint()
        ..color = hubColor.withValues(alpha: 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6,
    );
  }

  @override
  bool shouldRepaint(covariant _ClockFacePainter oldDelegate) {
    return oldDelegate.secondAngle != secondAngle ||
        oldDelegate.handColor != handColor;
  }
}
