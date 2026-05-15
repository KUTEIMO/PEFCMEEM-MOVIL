import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

/// Fondo de splash: gradiente marca + rejilla y trayectorias sutiles (tema matemático).
class EulerSplashBackground extends StatelessWidget {
  const EulerSplashBackground({super.key, required this.child});

  final Widget child;

  static const _gradient = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment(-0.9, -1),
      end: Alignment(1.1, 1.2),
      stops: [0.0, 0.42, 0.78, 1.0],
      colors: [
        Color(0xFF04161C),
        Color(0xFF0A2B35),
        Color(0xFF0F4C5C),
        Color(0xFF1F7A8C),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: _gradient,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(painter: _EulerSplashPatternPainter()),
          Positioned(
            top: -80,
            right: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.reward.withValues(alpha: 0.07),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -70,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.success.withValues(alpha: 0.08),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _EulerSplashPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final grid = Paint()
      ..color = Colors.white.withValues(alpha: 0.04)
      ..strokeWidth = 1;
    const step = 28.0;
    for (var x = 0.0; x < w; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, h), grid);
    }
    for (var y = 0.0; y < h; y += step) {
      canvas.drawLine(Offset(0, y), Offset(w, y), grid);
    }

    final curve = Paint()
      ..color = AppColors.success.withValues(alpha: 0.14)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, h * 0.72);
    path.quadraticBezierTo(w * 0.35, h * 0.52, w * 0.55, h * 0.62);
    path.quadraticBezierTo(w * 0.78, h * 0.74, w, h * 0.58);
    canvas.drawPath(path, curve);

    final arc = Paint()
      ..color = AppColors.reward.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(w * 0.82, h * 0.18), radius: 48),
      math.pi * 0.2,
      math.pi * 1.1,
      false,
      arc,
    );

    final dot = Paint()..color = Colors.white.withValues(alpha: 0.18);
    for (var i = 0; i < 5; i++) {
      final t = i / 4.0;
      final px = w * (0.12 + t * 0.76);
      final py = h * (0.22 + math.sin(t * math.pi * 2) * 0.04);
      canvas.drawCircle(Offset(px, py), 2.2, dot);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
