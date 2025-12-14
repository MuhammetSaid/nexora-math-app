import 'package:flutter/material.dart';

import '../../theme/colors.dart';

class NexoraBackground extends StatelessWidget {
  const NexoraBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
      child: CustomPaint(
        painter: _LinePatternPainter(),
        child: child,
      ),
    );
  }
}

class _LinePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = AppColors.overlay
      ..strokeWidth = 0.8;

    const double gap = 56;
    for (double x = -size.height; x < size.width + size.height; x += gap) {
      canvas.drawLine(
        Offset(x, size.height),
        Offset(x + size.height * 0.8, 0),
        paint,
      );
    }

    for (double y = 0; y < size.height + gap; y += gap * 1.2) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y + gap * 0.4),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
