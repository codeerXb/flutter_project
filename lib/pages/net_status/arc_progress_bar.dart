import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'dart:math' as Math;
import 'dart:ui' as UI;

import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ArcProgresssBar extends StatelessWidget {
  final double width;
  final double height;
  final double min;
  final double max;
  final double progress;

  const ArcProgresssBar({
    Key? key,
    this.width = 200,
    this.height = 200,
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
  double _strokeSize = 4.sp;
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
    double radius = size.width / 2 - 80.sp;
    double cx = size.width / 2;
    double cy = size.width / 2;
    _drawProgressArc(canvas, size);
    _drawArcProgressPoint(canvas, cx, cy, radius);
    _drawArcPointLine(canvas, cx, cy, radius);
  }

// 进度条的绘制
  void _drawProgressArc(Canvas canvas, Size size) {
    // 外层圈
    Rect rectOut = Rect.fromLTWH(0 + _strokeSize / 2, 0 + _strokeSize / 2,
        size.width - _strokeSize, size.height - _strokeSize);
    _paint
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt
      ..strokeWidth = _strokeSize;
    _paint.shader = const SweepGradient(
      colors: [Color(0xff49bcf6), Color(0xff49deb2)],
    ).createShader(rectOut);
    canvas.drawArc(rectOut, _toRadius(0),
        progress * _toRadius(360 / (max - min)), false, _paint);
    _paint.shader =
        SweepGradient(colors: [Colors.grey.shade300, Colors.grey.shade300])
            .createShader(rectOut);
    canvas.drawArc(
        rectOut,
        progress * _toRadius(360 / (max - min)),
        _toRadius(360) - progress * _toRadius(360 / (max - min)),
        false,
        _paint);
    // 绘制背景
    // 白色底大圆
    Rect bgRectOutter = Rect.fromLTWH(
        _strokeSize + 20.sp,
        _strokeSize + 20.sp,
        size.width - _strokeSize * 2 - 40.sp,
        size.height - _strokeSize * 2 - 40.sp);
    _paint
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.butt
      ..strokeWidth = 2.sp
      ..color = const Color(0xff000000)
      ..shader = const SweepGradient(colors: [Colors.white, Colors.white])
          .createShader(bgRectOutter);
    canvas.drawArc(bgRectOutter, _toRadius(0), _toRadius(360), false, _paint);
    // 淡色底小圆
    Rect bgRectInner = Rect.fromLTWH(size.width / 4 + 20.sp,
        size.width / 4 + 20.sp, size.width / 2 - 40.sp, size.width / 2 - 40.sp);
    _paint
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.butt
      ..strokeWidth = 2.sp
      ..color = const Color(0xff000000)
      ..shader = const SweepGradient(colors: [
        Color(0x2f49bcf6),
        Color(0x2f49bcf6),
      ]).createShader(bgRectInner);
    canvas.drawArc(bgRectInner, _toRadius(0), _toRadius(360), false, _paint);
    // 画内层装饰圈
    // 装饰圆1，外层
    Rect rectInner1 = Rect.fromLTWH(
        size.width / 4 - 25.sp,
        size.height / 4 - 25.sp,
        size.width / 2 + 50.sp,
        size.height / 2 + 50.sp);
    _paint
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt
      ..strokeWidth = 1.sp
      ..color = const Color(0xff000000)
      ..shader = const SweepGradient(colors: [Colors.grey, Colors.grey])
          .createShader(rectInner1);
    canvas.drawArc(rectInner1, _toRadius(0), _toRadius(360), false, _paint);
    // 装饰圆2，内层
    Rect rectInner2 = Rect.fromLTWH(size.width / 4 - 0.sp,
        size.width / 4 - 0.sp, size.width / 2 + 0.sp, size.width / 2 + 0.sp);
    _paint
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt
      ..strokeWidth = 2.sp
      ..color = const Color(0xff000000)
      ..shader = const SweepGradient(colors: [Colors.black, Colors.black])
          .createShader(rectInner2);
    canvas.drawArc(rectInner2, _toRadius(0), _toRadius(360), false, _paint);
  }

// 绘制刻度
  void _drawArcProgressPoint(
      Canvas canvas, double cx, double cy, double radius) {
    final Paint paintProgress = Paint();
    paintProgress.strokeWidth = 4.sp;
    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(_toRadius(0));
    canvas.translate(-cx, -cy);
    for (int i = 0; i <= (max - min); i++) {
      if (i <= progress) {
        paintProgress.color = Colors.black;
      } else {
        paintProgress.color = Colors.grey;
      }
      double evaDegree = i * _toRadius(360 / (max - min));
      double b = i % 10 == 0 ? -8.sp : 0;
      double x = cx + (radius - 12.sp + b) * Math.cos(evaDegree);
      double y = cy + (radius - 12.sp + b) * Math.sin(evaDegree);
      double x1 = cx + (radius - 4.sp) * Math.cos(evaDegree);
      double y1 = cx + (radius - 4.sp) * Math.sin(evaDegree);
      canvas.drawLine(Offset(x, y), Offset(x1, y1), paintProgress);
    }
    canvas.translate(cx, cy);
    canvas.rotate(_toRadius(360));
    canvas.translate(-cx, -cy);
    canvas.restore();
  }

// 绘制指针
  void _drawArcPointLine(
      UI.Canvas canvas, double cx, double cy, double radius) {
    final Paint paintPoint = Paint();
    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(_toRadius(0));
    canvas.translate(-cx, -cy);
    // 0%对应位置left:338,top:189,right:382,bottom:195
    paintPoint
      ..style = PaintingStyle.fill
      ..strokeWidth = 100.sp
      ..color = Colors.black;
    double degree = _toRadius(360 / (max - min)) * progress;
    double x = cx + radius * Math.cos(degree);
    double y = cy + radius * Math.sin(degree);
    // 指针斜边长度
    const pointLen = 20;
    // 指针三角形顶角角度
    const pointDeg = Math.pi / 10;
    double tx = x + pointLen * Math.cos(pointDeg / 2 + degree);
    double ty = y + pointLen * Math.sin(pointDeg / 2 + degree);
    double bx = x + pointLen * Math.cos(degree - pointDeg / 2);
    double by = y + pointLen * Math.sin(degree - pointDeg / 2);
    // 绘制三角形指针
    Path pointPath = Path();
    // canvas.drawLine(Offset(cx, cy), Offset(x, y), paintPoint);
    pointPath.moveTo(x, y);
    pointPath.lineTo(tx, ty);
    pointPath.lineTo(bx, by);
    pointPath.lineTo(x, y);
    pointPath.close();
    canvas.drawPath(pointPath, paintPoint);
    // canvas.drawCircle(Offset(cx, cy), 12, paintPoint);
    canvas.restore();
  }

  double _toRadius(double degree) => degree * Math.pi / 180;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
