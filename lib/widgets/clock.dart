import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class ClockView extends StatefulWidget {
  @override
  _ClockViewState createState() => _ClockViewState();
}

class _ClockViewState extends State<ClockView> {
  DateTime dateTime = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 3,
      child: Container(
//        height: widget.size,
//        width: widget.size,
        child: CustomPaint(
          painter: Clock(),
        ),
      ),
    );
  }
}

class Clock extends CustomPainter {
  DateTime dateTime = DateTime.now();
  @override
  void paint(Canvas canvas, Size size) {
    double centerx = size.width / 2;
    double centery = size.height / 2;
    double radius = min(centerx, centery);
    Offset center = Offset(centerx, centery);

    canvas.drawCircle(center, radius * 0.80, Paint()..color = Colors.white);
//    hours calculation
    double hourHandX = centerx +
        radius *
            0.40 *
            cos((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    double hourHandy = centerx +
        radius *
            0.40 *
            sin((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    canvas.drawLine(
        center,
        Offset(hourHandX, hourHandy),
        Paint()
          ..color = Colors.black
          ..strokeWidth = radius * 0.10
          ..strokeCap = StrokeCap.round);

//    minutes calculation
    double minHandX =
        centerx + radius * 0.65 * cos(dateTime.minute * 6 * pi / 180);
    double minHandy =
        centerx + radius * 0.65 * sin(dateTime.minute * 6 * pi / 180);
    canvas.drawLine(
        center,
        Offset(minHandX, minHandy),
        Paint()
          ..strokeWidth = radius * 0.07
          ..shader =
              RadialGradient(colors: [Color(0xff748EF6), Color(0xFF77DD6)])
                  .createShader(Rect.fromCircle(center: center, radius: radius))
          ..strokeCap = StrokeCap.round);

    //    sec calculation
    double secHandX =
        centerx + radius * 0.80 * cos(dateTime.second * 6 * pi / 180);
    double secHandy =
        centerx + radius * 0.80 * sin(dateTime.second * 6 * pi / 180);
    canvas.drawLine(
        center,
        Offset(secHandX, secHandy),
        Paint()
          ..color = Colors.red
          ..strokeWidth = radius * 0.02
          ..strokeCap = StrokeCap.round);

    canvas.drawCircle(center, radius * 0.12, Paint()..color = Colors.black);
//    canvas.drawCircle(center, radius * 0.11, Paint()..color = Colors.white);
//    canvas.drawCircle(center, radius * 0.05, Paint()..color = Colors.black);

    var outer = radius * 0.95;
    var inner = radius * 0.88;

    for (int i = 0; i < 360; i += 30) {
      var x1 = centerx + outer * cos(i * pi / 180);
      var y1 = centerx + outer * sin(i * pi / 180);

      var x2 = centerx + inner * cos(i * pi / 180);
      var y2 = centerx + inner * sin(i * pi / 180);
      canvas.drawLine(
          Offset(x1, y1),
          Offset(x2, y2),
          Paint()
            ..color = Colors.black
            ..strokeWidth = radius * 0.02
            ..strokeCap = StrokeCap.round);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
