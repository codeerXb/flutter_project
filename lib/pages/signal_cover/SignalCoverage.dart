import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:get/get.dart';
import 'dart:async';
import '../../config/base_config.dart';
import '../../core/http/http_app.dart';
import '../../core/request/request.dart';
import '../../core/utils/shared_preferences_util.dart';
import '../../generated/l10n.dart';
import 'package:network_info_plus/network_info_plus.dart';

import '../toolbar/toolbar_controller.dart';

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
  final ToolbarController toolbarController = Get.put(ToolbarController());

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
      //清空当前的snr&NoiseLevel
      for (var element in roomInfo) {
        element['snr'] = '';
        element['NoiseLevel'] = '';
      }
      if (roomInfo.isNotEmpty) {
        nextetValue = const Offset(1999, 1999);
      }
      // router位置
      routerPos =
          Offset(roomInfo[0]['routerX'] ?? 0, roomInfo[0]['routerY'] ?? 0);
      print('roomInfo${roomInfo}');
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
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text('Current detection floor:${roomInfo[0]['floorId']}F'),
          Row(
            children: [
              Icon(
                Icons.directions_walk_rounded,
                color: const Color.fromRGBO(144, 147, 153, 1),
                size: 30.w,
              ),
              Obx(
                () => Text(
                    '${toolbarController.currentNoiselevel.value} dBm signal '),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 30),
              ),
              Text(
                toolbarController.currentNoiselevel.value > -50
                    ? 'Great'
                    : toolbarController.currentNoiselevel.value > -70
                        ? 'Good'
                        : 'Bad',
                style: const TextStyle(color: Colors.blue),
              )
            ],
          ),
          // const Padding(
          //   padding: EdgeInsets.only(top: 50),
          // ),
          const ArcProgresssBar(),

          //按钮
          ProcessButton(toolbarController: toolbarController),
        ]),
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
      return SizedBox(
        height: 640.w,
        width: 1.sw,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white, // 边框颜色
              width: 0, // 边框宽度
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                child: CustomPaint(
                  size: Size(widget.width, widget.height),
                  painter: MyPainter(
                      _assetImageFrame!, 32.sp, widget.progress, _nextImage!,
                      min: widget.min, max: widget.max),
                ),
              ),
              // CustomPaint(
              //   painter: MyPainter(
              //       _assetImageFrame!, 32.sp, widget.progress, _nextImage!,
              //       min: widget.min, max: widget.max),
              // ),
              if (btnText == S.current.startTesting)
                Positioned(
                  left: routerPos.dx,
                  top: routerPos.dy,
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
                          double clampedX = routerPos.dx.clamp(0, 355);
                          double clampedY = routerPos.dy.clamp(0, 330);
                          routerPos = Offset(clampedX, clampedY);
                          // print(routerPos);
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
      ..strokeWidth = 2.5
      ..color = const Color.fromARGB(255, 49, 49, 49)
      ..style = PaintingStyle.stroke;

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
    // 画布起点移到屏幕中心
    // canvas.translate(size.width / 0, size.height / 0);

    //router
    canvas.drawImage(aPattern, routerPos, paint3);
    canvas.drawImage(bPattern, nextetValue, paint4);

    // 计算放置所有方块之后占用的宽高
    double left = double.infinity;
    double right = double.negativeInfinity;
    double top = double.infinity;
    double bottom = double.negativeInfinity;
    for (var block in roomInfo) {
      if (block['offsetX'] - 1200 < left) {
        left = block['offsetX'] - 1200;
      }
      if (block['offsetX'] - 1200 + block['width'] > right) {
        right = block['offsetX'] - 1200 + block['width'];
      }
      if (block['offsetY'] - 1200 < top) {
        top = block['offsetY'] - 1200;
      }
      if (block['offsetY'] - 1200 + block['height'] > bottom) {
        bottom = block['offsetY'] - 1200 + block['height'];
      }
    }
    double totalWidth = right - left;
    double totalHeight = bottom - top;
    // 计算缩放比例
    double scale = totalWidth / 1.sw > totalHeight / (640.w - 20)
        ? 1.sw / totalWidth
        : (640.w - 20) / totalHeight;
    for (var item in roomInfo) {
      // 绘制矩形
      // 最终偏移距离应该是（容器宽度-layout宽度*scale）/2
      final rect = Rect.fromLTWH(
        (item['offsetX'] - 1200) * scale + (1.sw - totalWidth * scale) / 2,
        (item['offsetY'] - 1200) * scale + 8,
        item['width'] * scale,
        item['height'] * scale,
      );
      canvas.drawRect(rect, paint1);

      // 绘制文字
      var paragraphBuilder = ParagraphBuilder(ParagraphStyle(
        textAlign: TextAlign.center,
        fontSize: 16,
        textDirection: TextDirection.ltr,
      ))
        ..pushStyle(
          ui.TextStyle(color: const Color.fromARGB(255, 100, 100, 100)),
        )
        ..addText(item['name'].toString());

      var paragraph = paragraphBuilder.build();

      var constraints = const ParagraphConstraints(width: 50);

      paragraph.layout(constraints);

      canvas.drawParagraph(
        paragraph,
        Offset(
            (item['offsetX'] - 1200) * scale +
                item['width'] * scale / 2 +
                (1.sw - totalWidth * scale) / 2 -
                25,
            (item['offsetY'] - 1200) * scale + item['height'] * scale / 2 - 8),
      );
      //完成的给颜色
      if (item['NoiseLevel'] != '') {
        canvas.drawRect(rect, successPaint1);
      }
    }
  }

  //避免重绘开销，返回true
  @override
  bool shouldRepaint(MyPainter oldDelegate) => true;
}

// // 盒子
// void _box(Canvas canvas, Paint paint, text, x, y, w, h) {
//   Rect d = Rect.fromLTWH(x, y, w, h);

//   canvas.drawRect(d, paint);
//   ui.ParagraphBuilder pb = ui.ParagraphBuilder(ui.ParagraphStyle(
//     textAlign: TextAlign.center,
//     fontWeight: FontWeight.w300,
//     fontStyle: FontStyle.normal,
//     fontSize: 15.0,
//   ));
//   pb.pushStyle(
//       ui.TextStyle(color: const ui.Color.fromARGB(255, 116, 116, 116)));
//   pb.addText(text);

//   ui.ParagraphConstraints pc = ui.ParagraphConstraints(
//     width: w,
//   );
// //这里需要先layout, 后面才能获取到文字高度
//   ui.Paragraph paragraph = pb.build()..layout(pc);
// //文字居中显示
//   Offset offset = Offset(x, y - 7.5 + h / 2);
//   canvas.drawParagraph(paragraph, offset);
// }

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
  ProcessButton({super.key, required this.toolbarController});
  var toolbarController;
  @override
  State<StatefulWidget> createState() => _ProcessButtonState();
}

class _ProcessButtonState extends State<ProcessButton> {
  bool loading = false;
  List deviceList = []; //设备列表
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
          roomInfo[currentIndex]['routerX'] = routerPos.dx;
          roomInfo[currentIndex]['routerY'] = routerPos.dy;
          roomInfo[currentIndex]['txPower'] = acsNode['TxPower']['_value'];
          roomInfo[currentIndex]['NoiseLevel'] =
              acsNode['NoiseLevel']['_value'].split(' ')[0];
          var val = int.parse(
                  acsNode['NoiseLevel']['_value'].split('d')[0].toString()) +
              int.parse(snr);
          widget.toolbarController.setCurrentNoiselevel(val);
        }
        nextFn();
      }
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
    double left = double.infinity;
    double right = double.negativeInfinity;
    double top = double.infinity;
    double bottom = double.negativeInfinity;
    for (var block in roomInfo) {
      if (block['offsetX'] - 1200 < left) {
        left = block['offsetX'] - 1200;
      }
      if (block['offsetX'] - 1200 + block['width'] > right) {
        right = block['offsetX'] - 1200 + block['width'];
      }
      if (block['offsetY'] - 1200 < top) {
        top = block['offsetY'] - 1200;
      }
      if (block['offsetY'] - 1200 + block['height'] > bottom) {
        bottom = block['offsetY'] - 1200 + block['height'];
      }
    }
    double totalWidth = right - left;
    double totalHeight = bottom - top;
    double scale = totalWidth / 1.sw > totalHeight / (640.w - 20)
        ? 1.sw / totalWidth
        : (640.w - 20) / totalHeight;

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
        (roomInfo[currentIndex]['offsetX'] - 1200) * scale +
            (1.sw - totalWidth * scale) / 2 +
            roomInfo[currentIndex]['width'] * scale / 2,
        (roomInfo[currentIndex]['offsetY'] - 1200) * scale +
            8 +
            roomInfo[currentIndex]['height'] * scale / 2,
      );
    } else {
      setState(() {
        nextetValue = const Offset(1999, 1999);
        btnText = S.current.GenerateOverlay;
      });
    }
  }

  //第一步人头的位置
  void firstOffset() {
    double left = double.infinity;
    double right = double.negativeInfinity;
    double top = double.infinity;
    double bottom = double.negativeInfinity;
    for (var block in roomInfo) {
      if (block['offsetX'] - 1200 < left) {
        left = block['offsetX'] - 1200;
      }
      if (block['offsetX'] - 1200 + block['width'] > right) {
        right = block['offsetX'] - 1200 + block['width'];
      }
      if (block['offsetY'] - 1200 < top) {
        top = block['offsetY'] - 1200;
      }
      if (block['offsetY'] - 1200 + block['height'] > bottom) {
        bottom = block['offsetY'] - 1200 + block['height'];
      }
    }
    double totalWidth = right - left;
    double totalHeight = bottom - top;
    double scale = totalWidth / 1.sw > totalHeight / (640.w - 20)
        ? 1.sw / totalWidth
        : (640.w - 20) / totalHeight;

    nextetValue = Offset(
      (roomInfo[0]['offsetX'] - 1200) * scale +
          (1.sw - totalWidth * scale) / 2 +
          roomInfo[0]['width'] * scale / 2,
      (roomInfo[0]['offsetY'] - 1200) * scale +
          8 +
          roomInfo[0]['height'] * scale / 2,
    );
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

  String hintText = S.current.coverageMap; //按钮上方提示文字
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        children: [
          btnText == S.current.startTesting ? Text(hintText) : const Text(''),
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
                }
                //第一步人头位置
                else if (hintText == S.current.coverageMap) {
                  setState(() {
                    hintText = S.current.moveCurrentRoom;
                  });
                  firstOffset();
                }
                //第一步完成 开始下一步
                else {
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
