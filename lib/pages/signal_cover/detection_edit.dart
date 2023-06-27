import 'dart:ui';

import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http_app.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:flutter_template/core/widget/water_loading.dart';
import 'package:get/get.dart';
import '../../core/widget/custom_app_bar.dart';
import '../../generated/l10n.dart';
import 'package:card_swiper/card_swiper.dart';

// 获取房屋信号数据
Future<List> getDataAPI(CancelToken cancelToken) async {
  try {
    var sn = await sharedGetData('deviceSn', String);
    var data = await App.get(
        '/platform/wifiJson/getOne/$sn', {"cancelToken": cancelToken});
    List list = List.from(data['wifiJson']['list']).toList();
    return list;
  } catch (err) {
    debugPrint(err.toString());
  }
  // 没有数据的时候返回默认的户型图
  return [
    {
      "offsetX": 1198.0,
      "offsetY": 1200.0,
      "width": 100.0,
      "height": 100.0,
      "name": "living room",
      "floor": "1F",
      "id": 0,
    }
  ];
}

class TestEdit extends StatefulWidget {
  const TestEdit({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TestEditState();
}

class _TestEditState extends State<TestEdit> {
  int currentSwiperIndex = 0;
  int swiperCount = 1;
  String floorName = '';
  CancelToken cancelToken = CancelToken();
  // 定义布局List: 根据floorId来进行分类
  List layoutList = [
    [
      {
        "offsetX": 1198.0,
        "offsetY": 1200.0,
        "width": 100.0,
        "height": 100.0,
        "name": "living room",
        "floorId": '1',
        "floor": "1F",
      },
    ]
  ];
  List<Widget> layoutWidget = [
    const CoverChart(floorInfo: [
      [
        {
          "offsetX": 1198.0,
          "offsetY": 1200.0,
          "width": 100.0,
          "height": 100.0,
          "name": "living room",
          "floorId": '1',
          "floor": "1F",
        },
      ]
    ], index: 0)
  ];
  bool loading = false;

  // 初始化请求时调用异步获取数据
  getData() async {
    setState(() {
      loading = true;
    });
    List<dynamic> res = await getDataAPI(cancelToken);
    // 构建List，需要添加一个id让它始终对应swiper的索引
    // 1、将不同floorId的Map分组
    List<List> layoutListTemp = [];
    Set floorIdSet = res.map((item) => item['floorId']).toSet();
    for (String id in floorIdSet) {
      layoutListTemp
          .add(res.where((element) => element['floorId'] == id).toList());
    }
    // 2、按照floorId从小到大排序
    layoutListTemp
        .sort((a, b) => a.first['floorId'].compareTo(b.first['floorId']));
    // 清空默认数据
    List<Widget> layoutWidgetTemp = [];
    for (var i = 0; i < layoutListTemp.length; i++) {
      layoutWidgetTemp.add(CoverChart(floorInfo: layoutListTemp, index: i));
    }
    setState(() {
      layoutList = layoutListTemp;
      // 过滤不同floorId的数组,取长度赋值
      swiperCount = floorIdSet.length;
      floorName = layoutListTemp[currentSwiperIndex][0]['floor'];
      layoutWidget = layoutWidgetTemp;
    });
    setState(() {
      loading = false;
    });
  }

  // 一次性绘制所有
  @override
  void initState() {
    getData();
    super.initState();
  }

  // 销毁前终止异步
  @override
  void dispose() {
    cancelToken.cancel();
    super.dispose();
  }

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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'Low',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color.fromARGB(255, 68, 68, 68),
                  ),
                ),
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
                const Text(
                  'Strong',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color.fromARGB(255, 68, 68, 68),
                  ),
                ),
              ],
            ),
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
                  return loading
                      ? const Center(
                          child: SizedBox(
                            height: 80,
                            width: 80,
                            child: WaterLoading(
                              color: Color.fromARGB(255, 65, 167, 251),
                            ),
                          ),
                        )
                      : layoutWidget[currentSwiperIndex];
                },
                itemCount: layoutWidget.length,
                onIndexChanged: (int index) {
                  // print("当前索引: ${index + 1}");
                  setState(() {
                    currentSwiperIndex = index;

                    // 过滤出floorId等于当前索引的数据并取floorName
                    if (layoutList.isNotEmpty) {
                      floorName = layoutList[currentSwiperIndex][0]['floor'];
                    }
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
                      onPressed: () {},
                      child: Text('${S.current.RetestF}  $floorName'),
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
  const CoverChart({Key? key, required this.floorInfo, required this.index})
      : super(key: key);
  final List floorInfo;
  final int index;

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
    var data = widget.floorInfo[widget.index];
    // 在这里使用数据进行绘图
    return Stack(
      children: [
        Positioned(
          left: 10,
          top: 0,
          child: Text(
            '${data[0]['floor']}',
            style: const TextStyle(color: Colors.grey),
          ),
        ),
        SizedBox(
          height: 640.w,
          width: 1.sw,
          child: CustomPaint(
            painter: Layout(data),
          ),
        ),
        Positioned(
          left: (data.isNotEmpty && data[0]['routerX'] != null)
              ? data[0]['routerX']
              : 0.5.sw,
          top: (data.isNotEmpty && data[0]['routerY'] != null)
              ? data[0]['routerY']
              : 320.w,
          child: Image.asset('assets/images/icon_homepage_route.png'),
        ),
      ],
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
    final paintFill = Paint()
      ..strokeWidth = 2
      ..color = const Color.fromARGB(112, 237, 237, 237)
      ..style = PaintingStyle.fill;
    List<dynamic> data = floorInfo;

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
    // 计算缩放比例
    double scale = totalWidth / 1.sw > totalHeight / (640.w - 20)
        ? 1.sw / totalWidth
        : (640.w - 20) / totalHeight;
    printInfo(info: 'width${size.width}height${size.height}缩放比例$scale');
    for (var item in data) {
      // 绘制矩形
      // 最终偏移距离应该是（容器宽度-layout宽度*scale）/2
      final rect = Rect.fromLTWH(
        (item['offsetX'] - 1200) * scale + (1.sw - totalWidth * scale) / 2,
        (item['offsetY'] - 1200) * scale + 8,
        item['width'] * scale,
        item['height'] * scale,
      );

      canvas.drawRect(rect, paint);
      canvas.drawRect(rect, paintFill);

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

      // 绘制渐变
      // 以路由器位置作为圆心来绘制
      // 得出当前位置的信号强度：SNR+噪声
      // 接收信号强度 = 射频发射功率 + 发射端天线增益 - 路径损耗 - 障碍物衰减 + 接收端天线增益
      // 射频发射功率：txPower
      // 发射端天线增益：6
      // 路径损耗：53+30lg(d),d:到达边缘距离
      // 单个房间绘制忽略障碍物衰减，接收端天线增益为0
    }
  }

  @override
  bool shouldRepaint(Layout oldDelegate) {
    return true;
  }
}
