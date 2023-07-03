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
import '../../config/base_config.dart';
import '../../core/http/http_app.dart';
import '../../core/request/request.dart';
import '../../core/utils/shared_preferences_util.dart';
import '../../generated/l10n.dart';
import 'package:network_info_plus/network_info_plus.dart';

var roomInfo = []; //画的房屋信息
var allRoomInfo = []; //所有房屋信息
Offset offSetValue = Offset.zero;
Offset nextetValue = Offset.zero;

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
      allRoomInfo = json.decode(Get.arguments['roomInfo']);

      //过滤出当前楼层
      roomInfo = allRoomInfo
          .where((item) => item['floorId'] == Get.arguments['curFloorId'])
          .toList();
      //清空当前的snr
      for (var element in roomInfo) {
        element['snr'] = '';
      }
      if (roomInfo.isNotEmpty) {
        // offSetValue = Offset(
        //     roomInfo[0]['offsetX'] - 1300, roomInfo[0]['offsetY'] - 1300);
        nextetValue = const Offset(1999, 1999);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_left),
          onPressed: () {
            Get.offNamed('/signal_cover', arguments: {'homepage': false});
          },
        ),
        title: Text(S.current.TestSignal),
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
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
  ui.Image? _nextImage; //本地图片

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
    ui.Image nextImage =
        await getAssetImage('assets/images/people.png', width: 20, height: 20);
    setState(() {
      _assetImageFrame = imageFrame;
      _nextImage = nextImage;
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
                  painter: MyPainter(
                      _assetImageFrame!, 32.sp, widget.progress, _nextImage!,
                      min: widget.min, max: widget.max),
                ),
              ),
              if (btnText == S.current.startTesting)
                Positioned(
                  left: routerPos.dx + 100,
                  top: routerPos.dy + 100,
                  child: SizedBox(
                    width: 40, // 添加一个具体的宽度
                    height: 40, // 添加一个具体的高度
                    child: GestureDetector(
                      //滑动router
                      onPanUpdate: (details) {
                        setState(() {
                          // 计算新的偏移量
                          routerPos += details.delta;

                          // 限制偏移量不超出边框区域
                          double clampedX = routerPos.dx.clamp(-102, 287);
                          double clampedY = routerPos.dy.clamp(-102, 523);
                          routerPos = Offset(clampedX, clampedY);
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
  ui.Image bPattern;
  MyPainter(this.aPattern, double sp, double progress, this.bPattern,
      {required double min, required double max})
      : super();

  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..color = const ui.Color.fromARGB(255, 212, 215, 212)
      ..invertColors = false;

    Paint paint3 = Paint()
      ..color = const ui.Color.fromARGB(255, 6, 143, 255)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.butt
      ..strokeWidth = 30.0;

    Paint paint4 = Paint()
      ..color = const ui.Color.fromARGB(255, 255, 6, 6)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.butt
      ..strokeWidth = 30.0;

    Paint successPaint1 = Paint()
      ..color = const ui.Color.fromARGB(140, 128, 206, 128)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.butt
      ..strokeWidth = 30.0;

    Paint successPaint2 = Paint()
      ..color = const ui.Color.fromARGB(138, 234, 243, 236)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.butt
      ..strokeWidth = 30.0;
    // 画布起点移到屏幕中心
    canvas.translate(size.width / 2, size.height / 2);

    //router
    canvas.drawImage(aPattern, routerPos, paint3);
    canvas.drawImage(bPattern, nextetValue, paint4);

    // _box(canvas, paint1, 'abc', -100.0, -100.0, 200.0, 100.0);
    for (var item in roomInfo) {
      _box(canvas, paint1, item["name"], item['offsetX'] - 1300,
          item['offsetY'] - 1300, item["width"], item["height"]); // 要进行缩放的组件
      //完成的给蓝色
      if (item['snr'] != '') {
        _box(
            canvas,
            successPaint1,
            // item['snr'] > 60 ? successPaint1 : successPaint2,
            item["name"],
            item['offsetX'] - 1300,
            item['offsetY'] - 1300,
            item["width"],
            item["height"]); // 要进行缩放的组件
      }
    }
  }

  //避免重绘开销，返回true
  @override
  bool shouldRepaint(MyPainter oldDelegate) => true;
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
  var roomArea = json.decode(Get.arguments['roomArea']);
  dynamic sn;
  dynamic acsNode;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
  }

  //终端设备列表
  getSnrFn() async {
    setState(() {
      loading = true;
    });
    final info = NetworkInfo();

    try {
      String? wifiIP;
      try {
        wifiIP = await info.getWifiIP(); // 192.168.1.43
        printInfo(info: 'wifiIp$wifiIP');
      } catch (e) {
        printError(info: e.toString());
      }
      //终端设备列表
      sn = await sharedGetData('deviceSn', String);
      var response = await App.post(
          '${BaseConfig.cloudBaseUrl}/cpeMqtt/getDevicesTable',
          data: {'sn': sn.toString(), "type": "getDevicesTable"});

      var d = json.decode(response.toString());

      printInfo(info: d.toString());
      if (d['code'] == 200) {
        d['data']['wifiDevices'].addAll(d['data']['lanDevices']);
        deviceList = d['data']['wifiDevices'];
        // printInfo(info: 'deviceList$deviceList');

        // 终端设备列表过滤 获得SNR
        var snr = deviceList
            .where((item) => item['IPAddress'] == wifiIP)
            .toList()[0]['SNR'];

        var connection = deviceList
            .where((item) => item['IPAddress'] == wifiIP)
            .toList()[0]['connection'];

        // 判断是2.4G还是5G
        if (connection == '2.4GHz') {
          var parameterNames1 = [
            "InternetGatewayDevice.WEB_GUI.WiFi.WLANSettings.1.NoiseLevel",
            "InternetGatewayDevice.WEB_GUI.WiFi.WLANSettings.1.TxPower"
          ];
          var res = await Request().getACSNode(parameterNames1, sn);
          Map<String, dynamic> d = jsonDecode(res);
          acsNode = d['data']['InternetGatewayDevice']['WEB_GUI']['WiFi']
              ['WLANSettings']['1'];
        } else {
          var parameterNames2 = [
            "InternetGatewayDevice.WEB_GUI.WiFi.WLANSettings.2.NoiseLevel",
            "InternetGatewayDevice.WEB_GUI.WiFi.WLANSettings.2.TxPower"
          ];
          acsNode = await Request().getACSNode(parameterNames2, sn);
          var res = await Request().getACSNode(parameterNames2, sn);
          Map<String, dynamic> d = jsonDecode(res);
          acsNode = d['data']['InternetGatewayDevice']['WEB_GUI']['WiFi']
              ['WLANSettings']['2'];
        }
        //存到该房间对象
        if (currentIndex + 1 <= roomInfo.length) {
          roomInfo[currentIndex]['snr'] = snr;
          roomInfo[currentIndex]['roomArea'] = roomArea;
          roomInfo[currentIndex]['routerX'] = routerPos.dx;
          roomInfo[currentIndex]['routerY'] = routerPos.dy;
          roomInfo[currentIndex]['txPower'] = acsNode['TxPower']['_value'];
          roomInfo[currentIndex]['NoiseLevel'] =
              acsNode['NoiseLevel']['_value'];
        }
        nextFn();
      }

      print(roomInfo);
      // printInfo(info: 'roomInfo$roomInfo');
    } catch (e) {
      debugPrint(e.toString());
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(S.current.warningSnNotSame),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  void nextFn() {
    if (currentIndex < roomInfo.length - 1) {
      btnText = S.current.roomStrength;
      currentIndex++;
      //router位置中间
      // offSetValue = Offset(
      //   roomInfo[currentIndex]['offsetX'] -
      //       1307.5 +
      //       roomInfo[currentIndex]['width'] / 2,
      //   roomInfo[currentIndex]['offsetY'] -
      //       1307.5 +
      //       roomInfo[currentIndex]['height'] / 2,
      // );
      //下一步的图像
      nextetValue = Offset(
        roomInfo[currentIndex]['offsetX'] -
            1307.5 +
            roomInfo[currentIndex]['width'] / 2,
        roomInfo[currentIndex]['offsetY'] -
            1307.5 +
            roomInfo[currentIndex]['height'] / 2,
      );
    } else {
      setState(() {
        nextetValue = const Offset(1999, 1999);
        btnText = S.current.GenerateOverlay;
      });
    }
  }

  void successFn() async {
    allRoomInfo
        .removeWhere((item) => item["floorId"] == Get.arguments['curFloorId']);
    allRoomInfo.addAll(roomInfo);
    try {
      await App.post('/platform/wifiJson/wifi', data: {
        "sn": sn,
        "wifiJson": {"list": allRoomInfo}
      });
      ToastUtils.success(S.current.success);
      Get.offNamed("/test_edit");
    } catch (e) {
      ToastUtils.error(S.current.error);
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
          SizedBox(
            width: 1.sw - 104.w,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(255, 30, 104, 233)),
              ),
              onPressed: () {
                if (loading) return;

                //成功
                if (btnText == S.current.GenerateOverlay) {
                  successFn();
                } else {
                  getSnrFn();
                }
              },
              child: loading
                  ? const Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Text(
                      btnText,
                      style: TextStyle(
                          fontSize: 32.sp, color: const Color(0xffffffff)),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
