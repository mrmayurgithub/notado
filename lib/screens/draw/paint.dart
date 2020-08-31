// import 'package:flutter/material.dart';
// import 'package:notado/screens/draw/draw_screen.dart';

// class Draw extends CustomPainter {
//   List<Offset> points;
//   // List<List<Offset>> points;
//   Draw({this.points});

//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()
//       ..color = brushColor
//       ..strokeCap = StrokeCap.round
//       ..strokeWidth = brushWidth;

//     // for (int i = 0; i < points.length; i++)
//     //   for (int j = 0; j < points[i].length - 1; j++)
//     //     if (points[i][j] != null && points[i][j + 1] != null) {
//     //       canvas.drawLine(points[i][j], points[i][j], paint);
//     //     }

//     for (int i = 0; i < points.length - 1; i++) {
//       if (points[i] != null && points[i + 1] != null) {
//         canvas.drawLine(points[i], points[i + 1], paint);
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(Draw oldDelegate) => oldDelegate.points != points;
// }
