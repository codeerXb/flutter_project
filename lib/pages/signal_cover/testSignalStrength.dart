import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:get/get.dart';
import 'package:mac_address/mac_address.dart';
import 'dart:async';
import 'package:wifi_info_plugin_plus/wifi_info_plugin_plus.dart';

import '../../config/base_config.dart';
import '../../core/http/http_app.dart';
import '../../core/utils/shared_preferences_util.dart';
import '../../core/widget/custom_app_bar.dart';
import '../../generated/l10n.dart';

var roomInfo = json.decode(Get.arguments['roomInfo']);
Offset offSetValue = Offset.zero;
Offset routerPos = Offset.zero;
String btnText = S.current.startTesting;

class TestSignal extends StatefulWidget {
  const TestSignal({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<TestSignal> {
  //获取到户型数据
  @override
  void initState() {
    super.initState();
    setState(() {
      btnText = S.current.startTesting;
      roomInfo = json.decode(Get.arguments['roomInfo']);
      if (roomInfo.length > 0) {
        offSetValue = Offset(
            roomInfo[0]['offsetX'] - 1300, roomInfo[0]['offsetY'] - 1300);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Test Signal Strength
      appBar: customAppbar(context: context, title: S.current.TestSignal),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            //  Text('Romm Area:$roomArea ㎡'),
            ArcProgresssBar(),

            //按钮
            ProcessButton(),
          ]),
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
  Widget build(BuildContext context) {
    if (_assetImageFrame == null) {
      // 处理异步加载尚未完成的情况，返回一个加载指示器或其他占位符
      return const CircularProgressIndicator();
    } else {
      return Expanded(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black, // 边框颜色
              width: 2.0, // 边框宽度
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: CustomPaint(
                  size: Size(widget.width, widget.height),
                  painter: MyPainter(_assetImageFrame!, 32.sp, widget.progress,
                      min: widget.min, max: widget.max),
                ),
              ),
              if (btnText == S.current.startTesting)
                Positioned(
                  left: offSetValue.dx + 100,
                  top: offSetValue.dy + 100,
                  child: SizedBox(
                    width: 40, // 添加一个具体的宽度
                    height: 40, // 添加一个具体的高度
                    child: GestureDetector(
                      // 手指滑动
                      onPanUpdate: (details) {
                        setState(() {
                          offSetValue += details.delta;
                          routerPos += details.delta;
                        });
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }
  }
}

class MyPainter extends CustomPainter {
  ui.Image aPattern;
  MyPainter(this.aPattern, double sp, double progress,
      {required double min, required double max})
      : super();

  @override
  void paint(Canvas canvas, Size size) {
    var paint3 = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke
      ..color = const Color.fromARGB(255, 95, 95, 95)
      ..invertColors = false;

    Paint selfPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.butt
      ..strokeWidth = 30.0;
    // 画布起点移到屏幕中心
    canvas.translate(size.width / 2, size.height / 2);

    //router
    canvas.drawImage(aPattern, offSetValue, selfPaint);

    //   _box(canvas, paint3, 'abc', -100.0, -100.0, 200.0, 100.0);
    roomInfo.forEach((item) {
      _box(canvas, paint3, item["name"], item['offsetX'] - 1300,
          item['offsetY'] - 1300, item["width"], item["height"]); // 要进行缩放的组件
    });
  }

  //在实际场景中正确利用此回调可以避免重绘开销，本示例我们简单的返回true
  @override
  bool shouldRepaint(MyPainter oldDelegate) {
    return true;
  }
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

//方法2.2：获取本地图片 返回ui.Image 不需要传入BuildContext context
Future<ui.Image> getAssetImage(String asset, {width, height}) async {
  ByteData data = await rootBundle.load(asset);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetWidth: width, targetHeight: height);
  ui.FrameInfo fi = await codec.getNextFrame();
  return fi.image;
}

//底部按钮
class ProcessButton extends StatefulWidget {
  const ProcessButton({super.key});
  @override
  State<StatefulWidget> createState() => _ProcessButtonState();
}

class _ProcessButtonState extends State<ProcessButton> {
  bool loading = false;
  List deviceList = []; //设备列表
  int currentIndex = -1;
  var roomArea = json.decode(Get.arguments['roomArea']);

  @override
  void initState() {
    super.initState();
    currentIndex = -1;
  }

  //终端设备列表
  getSnrFn(currentIndex) async {
    try {
      setState(() {
        loading = true;
      });
      //先请求本地接口  获取信息 如果不通 提示请连接设备WIFL后操作
      await XHttp.get('/pub/pub_data.html', {
        'method': 'obj_get',
        'param': '["systemProductModel"]',
      });

      // 获取本地mac地址
      var mac = await GetMac.macAddress;

      //终端设备列表
      var sn = await sharedGetData('deviceSn', String);
      var response = await App.post(
          '${BaseConfig.cloudBaseUrl}/cpeMqtt/getDevicesTable',
          data: {'sn': sn.toString(), "type": "getDevicesTable"});

      var d = json.decode(response.toString());
      if (d['code'] == 200) {
        d['data']['wifiDevices'].addAll(d['data']['lanDevices']);
        deviceList = d['data']['wifiDevices'];
        // printInfo(info: 'deviceList$deviceList');

        // 终端设备列表过滤 获得SNR
        var snr = deviceList
            .where((item) => item['MACAddress'] == mac)
            .toList()[0]['SNR'];

        nextFn();

        //snr存到该房间对象
        if (currentIndex < roomInfo.length - 1) {
          roomInfo[currentIndex + 1]['snr'] = snr;
          roomInfo[currentIndex + 1]['roomArea'] = roomArea;
          roomInfo[currentIndex + 1]['routerPos'] = routerPos;
        }

        print(roomInfo);
      }
      // printInfo(info: 'roomInfo$roomInfo');
    } catch (e) {
      debugPrint(e.toString());
      ToastUtils.error(S.current.warningSnNotSame);
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  void nextFn() {
    if (currentIndex < roomInfo.length - 1) {
      currentIndex++;
      btnText = S.current.roomStrength;
      //router位置中间
      offSetValue = Offset(
        roomInfo[currentIndex]['offsetX'] -
            1307.5 +
            roomInfo[currentIndex]['width'] / 2,
        roomInfo[currentIndex]['offsetY'] -
            1307.5 +
            roomInfo[currentIndex]['height'] / 2,
      );
    } else {
      setState(() {
        btnText = S.current.GenerateOverlay;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        children: [
          btnText == S.current.startTesting
              ? Text(S.current.coverageMap)
              : const Text(''),
          loading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () {
                    //成功
                    if (btnText == S.current.GenerateOverlay) {
                      print('成功....');
                    } else {
                      // nextFn();
                      getSnrFn(currentIndex);
                    }
                  },
                  child: Text(btnText),
                ),
        ],
      ),
    );
  }
}
