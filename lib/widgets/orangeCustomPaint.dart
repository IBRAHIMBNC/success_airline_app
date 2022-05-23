import 'package:flutter/material.dart';

class OrangeCustomPaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Color(0xffff8800).withOpacity(1.0);
    canvas.drawRRect(
        RRect.fromRectAndCorners(
            Rect.fromLTWH(
                0, 0, size.width * 0.9413681, size.height * 0.9452888),
            bottomRight: Radius.circular(size.width * 0.1172638),
            bottomLeft: Radius.circular(size.width * 0.1172638),
            topLeft: Radius.circular(size.width * 0.1172638),
            topRight: Radius.circular(size.width * 0.1172638)),
        paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
