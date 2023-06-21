import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http_app.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:get/get.dart';
import '../../core/widget/custom_app_bar.dart';
import '../../generated/l10n.dart';
import 'package:card_swiper/card_swiper.dart';

class TestEdit extends StatefulWidget {
  const TestEdit({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TestEditState();
}

class _TestEditState extends State<TestEdit> {
  int currentSwiperIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(
          context: context,
          title: S.current.DetectionAndEdit,
          backgroundColor: Colors.blue,
          titleColor: Colors.white,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(padding: EdgeInsets.only(top: 20.w)),

            SizedBox(
              width: 1.sw,
              height: 640.w,
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  // 返回一个widget,传入index
                  // 根据索引值查询不同楼层数据并绘制
                  // 这个类需要筛选所有需要的数据，绘制layout
                  // 绘制路由器
                  // 根据snr和噪声按照衰减公式绘制图形
                  // return Image.asset(
                  //   'assets/images/signalcover.jpg',
                  // );
                  return Center(
                    child: Container(
                      width: 1.sw - 80.w,
                      height: 640.w,
                      // 圆角
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 250, 250, 250),
                      ),
                      child: CoverChart(
                        floorIndex: index + 1,
                      ),
                    ),
                  );
                },
                itemCount: 3,
                onIndexChanged: (int index) {
                  // print("当前索引: ${index + 1}");
                  setState(() {
                    currentSwiperIndex = index + 1;
                  });
                },
                control: const SwiperControl(
                    size: 20,
                    color: Colors.black87,
                    disableColor: Colors.black38),
              ),
            ),

            Padding(padding: EdgeInsets.only(top: 20.w)),

            Center(
              child: TextButton(
                onPressed: () {
                  Get.offNamed("/signal_cover", arguments: {'homepage': false});
                },
                child: Text(
                  S.current.EditUnit,
                  style: const TextStyle(
                    color: Colors.blue, // 将文字颜色设置为蓝色
                  ),
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('     low  '),
                Container(
                  height: 10.w,
                  width: 150.w,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(200, 240, 64, 64),
                        Color.fromARGB(249, 248, 244, 11),
                        Color.fromARGB(235, 118, 240, 4),
                        Color.fromARGB(235, 118, 240, 4)
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const Text('  Strong'),
              ],
            ),

            Padding(padding: EdgeInsets.only(top: 20.w)),
            Center(
              child: Text(S.current.Blueprint),
            ),
            Padding(padding: EdgeInsets.only(top: 20.w)),

            //按钮
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        
                      },
                      child: Text(
                          '${S.current.RetestF}  $currentSwiperIndex F'),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}


// 获取对应楼层房屋信号数据
Future<dynamic> getData(floorIndex) async {
  try {
    var sn = await sharedGetData('deviceSn', String);
    var data = await App.get('/platform/wifiJson/getOne/$sn');
    List<dynamic> filteredList = List.from(data['wifiJson']['list'])
        .where((item) => item['floorId'] == floorIndex.toString())
        .toList();
    return filteredList;
  } catch (err) {
    debugPrint(err.toString());
  }
  return null;
}

// --- 信号强度覆盖图（热力图） ---
class CoverChart extends StatefulWidget {
  const CoverChart({Key? key, required this.floorIndex}) : super(key: key);
  final int floorIndex;

  @override
  State<StatefulWidget> createState() => _CoverChartState();
}

class _CoverChartState extends State<CoverChart> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // 绘制layout、router
    return FutureBuilder(
      future: getData(widget.floorIndex),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            var data = snapshot.data;
            // 在这里使用数据进行绘图
            return Stack(
              children: [
                Positioned(
                  left: (data != null &&
                          data.isNotEmpty &&
                          data[0]['routerX'] != null)
                      ? data[0]['routerX']
                      : 0.5.sw,
                  top: (data != null &&
                          data.isNotEmpty &&
                          data[0]['routerY'] != null)
                      ? data[0]['routerY']
                      : 320.w,
                  child: Image.asset('assets/images/icon_homepage_route.png'),
                ),
                SizedBox(
                  height: 640.w,
                  width: 1.sw - 20.w,
                  child: CustomPaint(
                    painter: Layout(data ?? []),
                  ),
                ),
              ],
            );
          }
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

// --- 房型图 ---
class Layout extends CustomPainter {
  Layout(this.floorInfo) : super();
  final List<dynamic> floorInfo;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 2
      ..color = const Color.fromARGB(255, 49, 49, 49)
      ..style = PaintingStyle.stroke;
    List<dynamic> data = floorInfo.isNotEmpty
        ? floorInfo
        : [
            {
              "offsetX": 0.0,
              "offsetY": 0.0,
              "width": 100.0,
              "height": 100.0,
              "name": "",
            }
          ];

    // 计算放置所有方块之后占用的宽高
    double left = double.infinity;
    double right = double.negativeInfinity;
    double top = double.infinity;
    double bottom = double.negativeInfinity;

    for (var block in data) {
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
    printInfo(info: 'width${size.width}height${size.height}');
    // 计算缩放比例
    double scale = totalWidth / 1.sw > totalHeight / 640.w
        ? 1.sw / totalWidth
        : 640.w / totalHeight;
    for (var item in data) {
      // 绘制矩形
      final rect = Rect.fromLTWH(
        (item['offsetX'] - 1200) * scale,
        (item['offsetY'] - 1200) * scale,
        item['width'] * scale,
        item['height'] * scale,
      );

      canvas.drawRect(rect, paint);

      // 绘制文字
      final text = TextSpan(
        text: item['name'].toString(),
        style: const TextStyle(color: Color.fromARGB(255, 100, 100, 100)),
      );
      final textPainter = TextPainter(
        text: text,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset((item['offsetX'] - 1200) * scale + item['width'] * scale / 2 - 4,
            (item['offsetY'] - 1200) * scale + item['height'] * scale / 2 - 8),
      );
    }
  }

  @override
  bool shouldRepaint(Layout oldDelegate) {
    return false;
  }
}
