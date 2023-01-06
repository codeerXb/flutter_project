// ignore_for_file: library_private_types_in_public_api
import 'dart:async';
import 'dart:ui' as ui;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_template/pages/login/login_controller.dart';
import 'package:get/get.dart';

GlobalKey<_WaterRippleState> childKey = GlobalKey();

class WaterRipple extends StatefulWidget {
  final int count;
  final Color color;

  const WaterRipple(
      {super.key,
      this.count = 2,
      this.color = const ui.Color.fromARGB(255, 201, 201, 201)});

  // const WaterRipple(
  //     {Key key, this.count = 3, this.color = const Color(0xFF0080ff)})
  //     : super(key: key);

  @override
  _WaterRippleState createState() => _WaterRippleState();
}

class _WaterRippleState extends State<WaterRipple>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final LoginController loginController = Get.put(LoginController());
  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 6000));
    _animation = Tween(begin: .0, end: pi * 2).animate(_controller);
    controllerForward();
    super.initState();
  }

  late Timer timer;
  Future controllerForward() async {
    loginController.setLoading(true);

    _controller.repeat();
    timer = Timer(const Duration(milliseconds: 6000), () {
      _controller.stop();
      loginController.setLoading(false);
    });
  }

  void controllerStop() {
    _controller.stop();
  }

  @override
  void dispose() {
    if (timer.isActive) {
      timer.cancel();
    }
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: WaterRipplePainter(_controller.value, _animation.value,
              count: widget.count, color: widget.color),
        );
      },
    );
  }
}

class WaterRipplePainter extends CustomPainter {
  final double progress;
  final int count;
  final Color color;
  final double angle;
  final Paint _paint = Paint()..style = PaintingStyle.fill;

  WaterRipplePainter(this.progress, this.angle,
      {this.count = 2, this.color = const Color(0xFF0080ff)});

  @override
  void paint(Canvas canvas, Size size) {
    double radius = min(size.width / 1.5, size.height / 1.5);
    _paint.color = Colors.grey.shade200;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, _paint);
    for (int i = count; i >= 0; i--) {
      final double opacity = (1.0 - ((i + progress) / (count + 1)));
      final Color _color = color.withOpacity(opacity);
      _paint..color = _color;

      double _radius = radius * ((i + progress) / (count + 1));

      canvas.drawCircle(
          Offset(size.width / 2, size.height / 2), _radius, _paint);
    }
    _paint.shader = ui.Gradient.sweep(
        Offset(size.width / 2, size.height / 2),
        [
          const ui.Color.fromARGB(255, 19, 100, 250).withOpacity(.01),
          const ui.Color.fromARGB(255, 19, 100, 250).withOpacity(.5)
        ],
        [.0, 1.0],
        TileMode.clamp,
        .0,
        pi / 12);

    canvas.save();
    double r = sqrt(pow(size.width, 2) + pow(size.height, 2));
    double startAngle = atan(size.height / size.width);
    Point p0 = Point(r * cos(startAngle), r * sin(startAngle));
    Point px = Point(r * cos(angle + startAngle), r * sin(angle + startAngle));
    canvas.translate((p0.x - px.x) / 2, (p0.y - px.y) / 2);
    canvas.rotate(angle);

    canvas.drawArc(
        Rect.fromCircle(
            center: Offset(size.width / 2, size.height / 2), radius: radius),
        0,
        pi / 12,
        true,
        _paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
