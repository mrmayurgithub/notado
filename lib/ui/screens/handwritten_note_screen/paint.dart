import 'package:flutter/material.dart';
import 'package:notado/ui/screens/handwritten_note_screen/handwritten_note.dart';

class Draw extends CustomPainter {
  List<Offset> points;
  Draw({this.points});
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = brushColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = brushWidth;
    for (int i = 0; i < points.length; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(Draw oldDelegate) => oldDelegate.points != points;
}
