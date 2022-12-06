import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'dart:math' as Math;
import 'dart:ui' as UI;

class ArcProgresssBar extends StatelessWidget {
  final double width;
  final double height;
  final double min;
  final double max;
  final double progress;

  const ArcProgresssBar({
    Key? key,
    this.width = 408,
    this.height = 408,
    this.min = 0,
    this.max = 100,
    this.progress = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => AspectRatio(
      aspectRatio: 1,
      child: CustomPaint(
        size: Size(width, height),
        painter: _ArcProgressBarPainter(20, progress, min: min, max: max),
      ));
}

class _ArcProgressBarPainter extends CustomPainter {
  final Paint _paint = Paint();
  double _strokeSize = 8;
  double get _margin => _strokeSize / 2;
  num progress = 0;
  num min;
  num max;

  _ArcProgressBarPainter(double strokeSize, this.progress,
      {this.min = 0, this.max = 100}) {
    _strokeSize = strokeSize;
    if (progress < min) progress = 0;
    if (progress > max) progress = max;
    if (min <= 0) min = 0;
    if (max <= min) max = 100;
  }
  @override
  void paint(Canvas canvas, Size size) {
    double radius = size.width / 2;
    double cx = radius;
    double cy = radius;
    _drawProgressArc(canvas, size);
    _drawArcProgressPoint(canvas, cx, cy, radius);
    _drawArcPointLine(canvas, cx, cy, radius);
  }

  // 进度条的绘制
  void _drawProgressArc(Canvas canvas, Size size) {
    // 外层圈
    Rect rectOut = Rect.fromLTWH(_strokeSize, _strokeSize,
        size.width - _strokeSize * 2, size.height - _strokeSize * 2);
    _paint
      ..isAntiAlias = true
      // ..color = const Color.fromARGB(121, 4, 92, 255)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt
      ..strokeWidth = _strokeSize
      ..shader = SweepGradient(
              startAngle: _toRadius(0),
              endAngle: _toRadius(360),
              colors: <Color>[Colors.blue.shade900, Colors.blue.shade500])
          .createShader(rectOut);
    canvas.drawArc(rectOut, _toRadius(0),
        progress * _toRadius(360 / (max - min)), false, _paint);
  }

  void _drawArcProgressPoint(
      Canvas canvas, double cx, double cy, double radius) {
    _paint.strokeWidth = 1;
    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(_toRadius(0));
    canvas.translate(-cx, -cy);
    for (int i = 0; i <= (max - min); i++) {
      double evaDegree = i * _toRadius(360 / (max - min));
      double b = i % 10 == 0 ? -5 : 0;
      double x = cx + (radius - 20 + b) * Math.cos(evaDegree);
      double y = cy + (radius - 20 + b) * Math.sin(evaDegree);
      double x1 = cx + (radius - 12) * Math.cos(evaDegree);
      double y1 = cx + (radius - 12) * Math.sin(evaDegree);
      canvas.drawLine(Offset(x, y), Offset(x1, y1), _paint);
    }
    canvas.translate(cx, cy);
    canvas.rotate(_toRadius(360));
    canvas.translate(-cx, -cy);
    canvas.restore();
  }

  void _drawArcPointLine(UI.Canvas canvas, double cx, double cy, num radius) {
    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(_toRadius(0));
    canvas.translate(-cx, -cy);
    // 0%对应位置left:338,top:189,right:382,bottom:195
    _paint
      ..style = PaintingStyle.fill
      ..strokeWidth = 100
      ..color = Colors.grey.shade600;
    num degree = _toRadius(360 / (max - min)) * progress;
    double x = cx + radius * 3 / 5 * Math.cos(degree);
    double y = cy + radius * 3 / 5 * Math.sin(degree);
    Path pointPath = Path();
    // canvas.drawLine(Offset(cx, cy), Offset(x, y), _paint);
    var pointStart = const Rect.fromLTWH(3000, 189, 38, 6);
    pointPath.addRect(pointStart);
    var point = RRect.fromLTRBR(338, 189, 382, 195, const Radius.circular(10));
    pointPath.addRRect(point);
    canvas.drawPath(pointPath, _paint);
    // canvas.drawCircle(Offset(cx, cy), 12, _paint);
    canvas.restore();
  }

  double _toRadius(double degree) => degree * Math.pi / 180;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
