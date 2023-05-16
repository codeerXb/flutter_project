import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:wifi_info_plugin_plus/wifi_info_plugin_plus.dart';

class TestSignal extends StatefulWidget {
  const TestSignal({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<TestSignal> {
  WifiInfoWrapper? _wifiObject;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    WifiInfoWrapper? wifiObject;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      wifiObject = await WifiInfoPlugin.wifiDetails;
    } on PlatformException {}
    if (!mounted) return;

    setState(() {
      _wifiObject = wifiObject;
    });
  }

  @override
  Widget build(BuildContext context) {
    String ipAddress =
        _wifiObject != null ? _wifiObject!.ipAddress.toString() : "...";

    String signalStrength =
        _wifiObject != null ? _wifiObject!.signalStrength.toString() : '...';
    String connectionType = _wifiObject != null
        ? _wifiObject!.connectionType.toString()
        : 'unknown';

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // 返回按钮逻辑
              Get.offNamed('/signal_cover');
            },
          ),
          title: const Text('Test Signal Strength'),
        ),
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Center(
            child: Text('Running on IP:$ipAddress'),
          ),
          Center(
            child: Text('Running on Mac:$signalStrength'),
          ),
          Center(
            child: Text('Connection type:$connectionType'),
          ),
          const ArcProgresssBar(),
        ]),
        // body: LALPageNews(),
      ),
    );
  }
}

class ArcProgresssBar extends StatefulWidget {
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
  State<ArcProgresssBar> createState() => _ArcProgresssBarState();
}

class _ArcProgresssBarState extends State<ArcProgresssBar> {
  ui.Image? _assetImageFrame; //本地图片

  @override
  void initState() {
    super.initState();
    _getAssetImage();
  }

  //获取本地图片
  _getAssetImage() async {
    ui.Image imageFrame = await getAssetImage(
        'assets/images/icon_homepage_route.png',
        width: 20,
        height: 20);
    setState(() {
      _assetImageFrame = imageFrame;
    });
  }

  @override
  Widget build(BuildContext context) => AspectRatio(
      aspectRatio: 1,
      child: CustomPaint(
        size: Size(widget.width, widget.height),
        painter: MyPainter(_assetImageFrame!, 32.sp, widget.progress,
            min: widget.min, max: widget.max),
      ));
}

class MyPainter extends CustomPainter {
  ui.Image aPattern;

  MyPainter(this.aPattern, double sp, double progress,
      {required double min, required double max})
      : super();

  @override
  void paint(Canvas canvas, Size size) {
    var paint2 = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke
      ..color = Colors.green
      ..invertColors = false;
    var paint3 = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke
      ..color = const Color.fromARGB(255, 95, 95, 95)
      ..invertColors = false;
    var paint4 = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 1
      ..style = PaintingStyle.fill
      ..invertColors = false;
    Paint selfPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.butt
      ..strokeWidth = 30.0;
    // 画布起点移到屏幕中心
    Rect a = Rect.fromCircle(center: const Offset(0, 0), radius: 150);
    canvas.translate(size.width / 2, size.height / 2);
    _drawBottomRight(canvas, size);
    const rect = Rect.fromLTWH(-100, -100, 200, 220);
    final centerX = rect.left + rect.width / 2;
    final centerY = rect.top + rect.height / 2;
    final radius = min(rect.width, rect.height);

    const gradient =
        RadialGradient(center: Alignment.center, radius: 2, colors: [
      Color.fromRGBO(26, 188, 156, .7),
      Color.fromRGBO(241, 196, 15, .7),
      Color.fromRGBO(231, 76, 60, .7),
    ]);
    final paint = Paint()..shader = gradient.createShader(rect);

    // canvas.drawCircle(Offset(centerX, centerY), radius, paint);
    canvas.drawRect(rect, paint);
    canvas.drawRect(a, paint2);
    canvas.drawImage(aPattern, const Offset(-10, -20), selfPaint);

    _box(canvas, paint3, '客厅', -100.0, -100.0, 200.0, 100.0);
    _box(canvas, paint3, '厨房', -100.0, 0.0, 80.0, 120.0);
    _box(canvas, paint3, '卧室', -20.0, 0.0, 120.0, 120.0);
  }

  //在实际场景中正确利用此回调可以避免重绘开销，本示例我们简单的返回true
  @override
  bool shouldRepaint(MyPainter oldDelegate) {
    return true;
  }
}

//图片
void _img(Canvas canvas, Size size) async {
  Future<ui.Codec> _loadImage(AssetBundleImageKey key) async {
    final ByteData data = await key.bundle.load(key.name);
    if (data == null) throw 'Unable to read data';
    return await ui.instantiateImageCodec(data.buffer.asUint8List());
  }

  final Paint paint = Paint()
    ..color = Colors.yellow
    ..strokeWidth = 2.0
    ..strokeCap = StrokeCap.butt
    ..style = PaintingStyle.stroke;

  // sunImage
  //     .obtainKey(const ImageConfiguration())
  //     .then((AssetBundleImageKey key) {
  //   _loadImage(key).then((ui.Codec codec) {
  //     print("frameCount: ${codec.frameCount.toString()}");
  //     codec.getNextFrame().then((info) {
  //       print("image: ${info.image.toString()}");
  //       print("duration: ${info.duration.toString()}");
  //     });
  //   });
  // });
  // if (sunImage != null) {
  //   canvas.drawImage(sunImage!, size.center(Offset.fromDirection(1)), paint);
  // }
}

// 盒子
void _box(Canvas canvas, Paint paint, text, x, y, w, h) {
  Rect d = Rect.fromLTWH(x, y, w, h);

  canvas.drawRect(d, paint);

  ui.ParagraphBuilder pb = ui.ParagraphBuilder(ui.ParagraphStyle(
    textAlign: TextAlign.center,
    fontWeight: FontWeight.w300,
    fontStyle: FontStyle.normal,
    fontSize: 15.0,
  ));
  pb.pushStyle(
      ui.TextStyle(color: const ui.Color.fromARGB(255, 116, 116, 116)));
  pb.addText(text);

  ui.ParagraphConstraints pc = ui.ParagraphConstraints(
    width: w,
  );
//这里需要先layout, 后面才能获取到文字高度
  ui.Paragraph paragraph = pb.build()..layout(pc);
//文字居中显示
  Offset offset = Offset(x, y - 7.5 + h / 2);
  canvas.drawParagraph(paragraph, offset);
}

// 通过移动画布的方式来绘制网格线
void _drawBottomRight(Canvas canvas, Size size) {
  // 保持画布状态
  canvas.save();
  // 循环绘制横向网格线
  const int count = 12;
  var step = 2 * pi / count;
  Paint paint = Paint();
  paint
    ..color = const Color.fromARGB(255, 214, 214, 214)
    ..strokeWidth = 1
    ..style = PaintingStyle.stroke;
  for (double i = 0; i < 30; i += 1) {
    // 画线，设置线的起点为0，终点为容器高度的1/2,用刚刚自定义好的画笔来画
    canvas.drawLine(const Offset(-150, -150), const Offset(150, -150), paint);
    // 设置网格往下方平移step距离
    canvas.translate(0, 10.0);
  }
  // 回复网格状态
  canvas.restore();
  // 保持当前画布状态
  canvas.save();
  // 于上方相同
  for (double i = 0; i < 30; i += 1) {
    canvas.drawLine(const Offset(-150, 150), const Offset(-150, -150), paint);
    canvas.translate(10.0, 0);
  }
  // 回复画布状态
  canvas.restore();
}

//方法1：获取网络图片 返回ui.Image
Future<ui.Image> getNetImage(String url, {width, height}) async {
  ByteData data = await NetworkAssetBundle(Uri.parse(url)).load(url);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetWidth: width, targetHeight: height);
  ui.FrameInfo fi = await codec.getNextFrame();
  return fi.image;
}

//方法2.2：获取本地图片 返回ui.Image 不需要传入BuildContext context
Future<ui.Image> getAssetImage(String asset, {width, height}) async {
  ByteData data = await rootBundle.load(asset);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetWidth: width, targetHeight: height);
  ui.FrameInfo fi = await codec.getNextFrame();
  return fi.image;
}
