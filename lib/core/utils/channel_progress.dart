import 'dart:math';

import 'package:flutter/material.dart';

class CirclePercentProgress extends StatefulWidget {
  final double progress;

  final bool isGreat;
  const CirclePercentProgress({Key? key, required this.progress,required this.isGreat}) : super(key: key);

  @override
  _CirclePercentProgressState createState() => _CirclePercentProgressState();
}

class _CirclePercentProgressState extends State<CirclePercentProgress> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CircleProgressPaint(min(1, max(0, widget.progress)),widget.isGreat,),
    );
  }
}

class _CircleProgressPaint extends CustomPainter {
  final double progress;
  final bool isGreat;
  _CircleProgressPaint(this.progress,this.isGreat);

  final Paint circlePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 20;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = min(size.width, size.height) / 2 - circlePaint.strokeWidth / 2;
    final rect = Rect.fromCircle(radius: radius, center: Offset(size.width / 2, size.height / 2));
    circlePaint.shader = null;
    circlePaint.color = Colors.grey;
    canvas.drawArc(rect, 0, pi * 2, false, circlePaint);
    circlePaint.shader = SweepGradient(colors: isGreat ? [const Color.fromARGB(255, 175, 234, 173), Colors.green] : [const Color.fromARGB(255, 218, 211, 142), Colors.yellow]).createShader(rect);
    canvas.drawArc(rect, 0, pi * 2 * progress, false, circlePaint);
  }

  @override
  bool shouldRepaint(covariant _CircleProgressPaint oldDelegate) {
    return true;
  }
}