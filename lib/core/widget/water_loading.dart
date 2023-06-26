import 'dart:math';

import 'package:flutter/material.dart';

class CirclePainter extends CustomPainter {
  final double progress;

  final double strokeWidth;
  final Color color;

  final Paint _paint = Paint();

  CirclePainter(
      {this.progress = 0.0, this.strokeWidth = 1.0, this.color = Colors.blue});

  @override
  void paint(Canvas canvas, Size size) {
    _paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = color;

    double radius = min(size.width, size.height) / 2;
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), radius * progress, _paint);
  }

  @override
  bool shouldRepaint(covariant CirclePainter oldDelegate) {
    return progress != oldDelegate.progress ||
        strokeWidth != oldDelegate.strokeWidth ||
        color != oldDelegate.color;
  }
}

class WaterLoading extends StatefulWidget {
  final Color color;
  final Duration duration;
  final Curve curve;

  const WaterLoading(
      {Key? key,
      this.color = Colors.blue,
      this.duration = const Duration(milliseconds: 800),
      this.curve = Curves.linear})
      : super(key: key);

  @override
  State<WaterLoading> createState() => _WaterCircleLoadingState();
}

class _WaterCircleLoadingState extends State<WaterLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation _widthAnimation, _opacityAnimation;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();

    _widthAnimation = Tween(begin: 1.0, end: 3.0)
        .animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    _opacityAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: CirclePainter(
                progress: _controller.value,
                strokeWidth: _widthAnimation.value,
                color: widget.color.withOpacity(_opacityAnimation.value)),
          );
        });
  }
}
