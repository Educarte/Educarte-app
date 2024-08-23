import 'package:educarte/core/base/constants.dart';
import 'package:flutter/material.dart';

class DashedLine extends StatelessWidget {
  const DashedLine({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(screenWidth(context), 1),
      painter: DashedLinePainter(context: context),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  const DashedLinePainter({required this.context});
  final BuildContext context;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = colorScheme(context).outline
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    double dashWidth = 1.5;
    double dashSpace = 4;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
