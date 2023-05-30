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
  final List progress;

  const ArcProgresssBar({
    Key? key,
    this.width = 200,
    this.height = 200,
    this.min = 0,
    this.max = 120,
    required this.progress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => AspectRatio(
      aspectRatio: 1,
      child: CustomPaint(
        size: Size(width, height),
        painter: _ArcProgressBarPainter(32.sp, progress, min: min, max: max),
      ));
}

class _ArcProgressBarPainter extends CustomPainter {
  final Paint _paint = Paint();
  double _strokeSize = 0;
  List progress = [];
  num min;
  num max;

  /// 转换成开始的格子索引和扫过格子数的List
  /// @params {List} progress [{"TimeStart": "12:00","TimeStop":"13:00"}]
  /// @return {List} [{'start': 1, 'duration': 7.5}] {开始的格子索引，扫过的格子数}
  List transformProgressList(List progress) {
    // 一小格为12min
    int unit = 12;
    List list = [];
    for (var timeMap in progress) {
      var startTime = timeMap['TimeStart'].split(':');
      var endTime = timeMap['TimeStop'].split(':');
      var start = Duration(
          hours: int.parse(startTime[0]), minutes: int.parse(startTime[1]));
      var end = Duration(
          hours: int.parse(endTime[0]), minutes: int.parse(endTime[1]));
      var difference = end - start;
      var minutes = difference.inMinutes;
      var startTotalMinutes =
          int.parse(startTime[0]) * 60 + int.parse(startTime[1]);
      if (startTotalMinutes <= 360 && startTotalMinutes >= 0) {
        var startGap = (360 - startTotalMinutes) / unit;
        list.add({'start': startGap, 'duration': minutes / unit});
      } else if (startTotalMinutes < 1440 && startTotalMinutes > 360) {
        var startGap = (1800 - startTotalMinutes) / unit;
        list.add({'start': startGap, 'duration': minutes / unit});
      }
    }
    return list;
  }

  _ArcProgressBarPainter(double strokeSize, this.progress,
      {this.min = 0, this.max = 120}) {
    _strokeSize = strokeSize;
    if (min <= 0) min = 0;
    if (max <= min) max = 120;
  }
  @override
  void paint(Canvas canvas, Size size) {
    double radius = size.width / 2 - 80.w;
    double cx = size.width / 2;
    double cy = size.width / 2;
    _drawProgressArc(canvas, size);
    _drawArcProgressPoint(canvas, cx, cy, radius);
  }

// 进度条的绘制
  void _drawProgressArc(Canvas canvas, Size size) {
    // 外层圈
    Rect rectOut = Rect.fromLTWH(0 + _strokeSize / 2, 0 + _strokeSize / 2,
        size.width - _strokeSize, size.height - _strokeSize);
    _paint
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = _strokeSize;

    _paint.shader = const LinearGradient(
      begin: Alignment.bottomRight,
      end: Alignment.topRight,
      colors: [Color(0xFFE0E8FD), Color(0xFFE0E8FD)],
    ).createShader(rectOut);

    canvas.drawArc(rectOut, _toRadius(0), _toRadius(360), false, _paint);
    // 绘制空白的外层圈
    _paint.shader =
        const SweepGradient(colors: [Color(0xFF2F5AF5), Color(0xFF2F5AF5)])
            .createShader(rectOut);
    // 将传入的时间片段转换成外层圈
    for (var item in transformProgressList(progress)) {
      // 顺时针绘制
      canvas.drawArc(
          rectOut,
          _toRadius(360) - item['start'] * _toRadius(360 / (max - min)),
          _toRadius(360) -
              (120 - item['duration']) * _toRadius(360 / (max - min)),
          false,
          _paint);
    }
    // 绘制白色大圆和色彩圈的空隙
    Rect rectOutGap = Rect.fromLTWH(0 + _strokeSize, 0 + _strokeSize,
        size.width - _strokeSize * 2, size.height - _strokeSize * 2);
    _paint.style = PaintingStyle.fill;
    _paint.shader = const LinearGradient(
      begin: Alignment.bottomRight,
      end: Alignment.topRight,
      colors: [
        Color.fromARGB(255, 198, 214, 255),
        Color.fromARGB(255, 197, 214, 255)
      ],
    ).createShader(rectOutGap);
    canvas.drawArc(rectOutGap, _toRadius(0), _toRadius(360), false, _paint);
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
    Rect bgRectInner = Rect.fromLTWH(size.width / 4 + 9.sp,
        size.width / 4 + 9.sp, size.width / 2 - 18.sp, size.width / 2 - 18.sp);
    _paint
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.butt
      ..strokeWidth = 2.sp
      ..color = const Color(0xff000000)
      ..shader = const SweepGradient(colors: [
        Color(0xFFE0E8FD),
        Color(0xFFE0E8FD),
      ]).createShader(bgRectInner);
    canvas.drawArc(bgRectInner, _toRadius(0), _toRadius(360), false, _paint);
    // 画内层装饰圈
    // 装饰圆2，内层
    Rect rectInner2 = Rect.fromLTWH(
        size.width / 4, size.width / 4, size.width / 2, size.width / 2);
    _paint
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt
      ..strokeWidth = 2.sp
      ..color = const Color(0xff000000)
      ..shader = const SweepGradient(colors: [
        Color(0xFF2F5AF5),
        Color(0xFF2F5AF5),
      ]).createShader(rectInner2);
    canvas.drawArc(rectInner2, _toRadius(0), _toRadius(360), false, _paint);
  }

// 绘制刻度
  void _drawArcProgressPoint(
      Canvas canvas, double cx, double cy, double radius) {
    final Paint paintProgress = Paint();
    paintProgress
      ..strokeWidth = 2.sp
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFFD8D8D8);
    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(_toRadius(0));
    canvas.translate(-cx, -cy);
    // 1、将所有时间进行合并，得出最终的并集
    List getRange(progress) {
      List range = [];
      for (var item in transformProgressList(progress)) {
        var start = item['start'];
        var duration = item['duration'];

        var rangeStart = 120 - start;
        var rangeEnd = (start > duration) ? (rangeStart + duration) : 120;

        if (start > duration) {
          // [120-start,120-start+duration]
          rangeEnd = rangeStart + duration;
          range.add([rangeStart, rangeEnd]);
        } else {
          // [120-start,120]U[0,duration-start]
          rangeEnd = 120;
          range.add([rangeStart, rangeEnd]);
          rangeStart = 0;
          rangeEnd = duration - start;
          range.add([rangeStart, rangeEnd]);
        }
      }
      return range;
    }

    // 2、判断数据是否在这个并集之中
    bool isInRange(value, range) {
      for (int i = 0; i < range.length; i++) {
        var rangeStart = range[i][0];
        var rangeEnd = range[i][1];

        if (value >= rangeStart && value <= rangeEnd) {
          return true;
        }
      }

      return false;
    }

    for (int i = 0; i <= (max - min); i++) {
      // 3、绘制并集，根据遍历的值切换画笔颜色
      if (isInRange(i, getRange(progress))) {
        // 4、设定时间段颜色加深
        paintProgress.color = const Color(0xFF2F5AF5);
        paintProgress.strokeWidth = 3.sp;
      } else {
        paintProgress.color = const Color(0xFFD8D8D8);
      }

      double evaDegree = i * _toRadius(360 / (max - min));
      double b = i % 10 == 0 ? 6.sp : 0;
      double x = cx + (radius + 12.sp) * Math.cos(evaDegree);
      double y = cy + (radius + 12.sp) * Math.sin(evaDegree);
      double x1 = cx + (radius + 4.sp - b) * Math.cos(evaDegree);
      double y1 = cx + (radius + 4.sp - b) * Math.sin(evaDegree);
      canvas.drawLine(Offset(x, y), Offset(x1, y1), paintProgress);
      // 表盘数字
      if (i % 10 == 0 && i != 0) {
        const textStyle = TextStyle(
          color: Color.fromARGB(255, 105, 105, 105),
          fontSize: 12,
        );
        var textSpan = TextSpan(
          text:
              '${((((i / 10) + 3) % 12) * 2).truncate() == 0 ? 0 : ((((i / 10) + 3) % 12) * 2).truncate()}',
          style: textStyle,
        );
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        final offset = Offset(
            cx + (radius - 40.sp) * Math.cos(evaDegree) - 8.sp,
            cy + (radius - 40.sp) * Math.sin(evaDegree) - 16.sp);
        textPainter.paint(canvas, offset);
      }
    }
    canvas.translate(cx, cy);
    canvas.rotate(_toRadius(360));
    canvas.translate(-cx, -cy);
    canvas.restore();
  }

  double _toRadius(double degree) => degree * Math.pi / 180;

  @override
  bool shouldRepaint(covariant _ArcProgressBarPainter oldDelegate) {
    return progress != oldDelegate.progress;
  }
}
