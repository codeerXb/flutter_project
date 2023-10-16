import 'dart:ui';
import 'package:dio/dio.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http_app.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:flutter_template/core/widget/water_loading.dart';
import 'package:get/get.dart';
import 'package:card_swiper/card_swiper.dart';

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

  List<Widget> layoutWidget = [];
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
      // 计算放置所有方块之后占用的宽高
      double left = double.infinity;
      double right = double.negativeInfinity;
      double top = double.infinity;
      double bottom = double.negativeInfinity;

      for (var block in layoutListTemp[i]) {
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

      /// 计算绘制缩放比例,用于“Dectection and Editing”页面展示，将原有图形放大或者缩小
      /// 但是这里的totalWidth和totalHeight并不是对应到实际的数值，而是绘制户型图时绘制的原始值
      /// *这里计算比例是为了绘制不出现偏差
      double scale = totalWidth / (1.sw - 40) > totalHeight / (600.w - 40)
          ? (1.sw - 40) / totalWidth
          : (600.w - 40) / totalHeight;
      debugPrint('文字的坐标$scale');
      layoutWidgetTemp
          .add(CoverChart(floorInfo: layoutListTemp, index: i, scale: scale));
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 渐变图例
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
                gradient: const LinearGradient(colors: [
                  Color.fromARGB(255, 247, 65, 41),
                  Color.fromARGB(255, 248, 244, 11),
                  Color.fromARGB(255, 118, 240, 4),
                  Color.fromARGB(255, 20, 255, 0),
                ], stops: [
                  0.2,
                  0.4,
                  0.6,
                  1
                ]),
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
        // 覆盖图
        Stack(
          children: [
            if (loading)
              const Center(
                child: SizedBox(
                  height: 80,
                  width: 80,
                  child: WaterLoading(
                    color: Color.fromARGB(255, 65, 167, 251),
                  ),
                ),
              )
            else
              SizedBox(
                width: 1.sw,
                height: 600.w,
                child: Swiper.children(
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
                  // pagination: const SwiperPagination(),
                  control: const SwiperControl(
                      size: 20,
                      color: Colors.black87,
                      disableColor: Colors.black38),
                  children: layoutWidget,
                ),
              ),
            // 编辑按钮
            Positioned(
              bottom: 22.5,
              right: 20,
              child: InkWell(
                onTap: () async {
                  var res = await Get.toNamed('/signal_cover',
                      arguments: {'homepage': true});
                  if (res == null) {
                    // 返回的都是null
                    // 那么只要返回就执行
                    getData();
                  }
                },
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: const Icon(
                    Icons.edit,
                    color: Color.fromRGBO(95, 141, 255, 1),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// --- 信号强度覆盖图（热力图） ---
class CoverChart extends StatefulWidget {
  const CoverChart(
      {Key? key,
      required this.floorInfo,
      required this.index,
      required this.scale})
      : super(key: key);
  final List floorInfo;
  final int index;
  final double scale;

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
          height: 600.w,
          width: 1.sw,
          child: CustomPaint(
            painter: Layout(data, widget.scale),
          ),
        ),
        // 设备位置
        Positioned(
          left: (data.isNotEmpty && data[0]['routerX'] != null)
              ? data[0]['routerX']
              : 0.5.sw - 20,
          top: (data.isNotEmpty && data[0]['routerY'] != null)
              ? data[0]['routerY']
              : 300.w - 20,
          child: Image.asset('assets/images/icon_homepage_route.png'),
        ),
      ],
    );
  }
}

// --- 房型图 ---
class Layout extends CustomPainter {
  Layout(this.floorInfo, this.scale) : super();
  final List<dynamic> floorInfo;
  double scale;

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

    for (var item in data) {
      // 绘制矩形
      // 最终偏移距离应该是（容器宽度-layout宽度*scale）/2
      canvas.save();
      final pathRect = Path();
      final x =
          (item['offsetX'] - 1200) * scale + (1.sw - totalWidth * scale) / 2;
      final y = (item['offsetY'] - 1200) * scale + 8;
      final width = item['width'] * scale;
      final height = item['height'] * scale;
      pathRect.moveTo(x, y);
      pathRect.lineTo(x + width, y);
      pathRect.lineTo(x + width, y + height);
      pathRect.lineTo(x, y + height);
      pathRect.lineTo(x, y);
      pathRect.close();

      // 绘制渐变
      // 以路由器位置作为圆心来绘制
      // 得出当前位置的信号强度：SNR+噪声
      // 接收信号强度 = 射频发射功率 + 发射端天线增益 - 路径损耗 - 障碍物衰减 + 接收端天线增益
      // 射频发射功率：txPower
      // 发射端天线增益：6
      // 路径损耗：2.4g:46+25lg(d) 5g:53+30lg(d),d:到达边缘距离
      // 单个房间绘制忽略障碍物衰减，接收端天线增益为0
      // 定义方块和圆形的参数

      // great: -40~-60,good:-60~-80,bad<-80
      // 再根据上面的分界点，-60，-80
      // 计算公式到-60的距离：a，-80的距离:b，-100的距离:c
      // [a/c,b/c,1]

      /// 由于路径损耗只和频率和距离相关
      /// 所以如果默认为2.4g路径损耗便只与距离相关
      /// 发射端天线增益为常量
      /// 接收端增益为0
      /// 这样未知的只有障碍物衰减
      /// *这里的距离要计算目前router位置和每个房间中心点的实际距离d
      /// 目前可以采用d=sqrt(pow(((item['offsetX'] - 1200+item['width'])-item['routerX']/2),2) + pow(((item['offsetY'] - 1200+item['height'])-item['routerY']/2),2))
      /// 障碍物衰减 = item['txPower'] + 6 - [46 + 25lg(d)] + 0 - (item['snr'] + item['NoiseLevel'])
      /// d = pow(10,(item['txPower']+6-障碍物衰减+0-(item['snr'] + item['NoiseLevel'])-46)/25)
      /// 得到障碍物衰减之后，我们就可以得出到不同评价节点的距离比，从而绘制出不一样的渐变圆
      bool condition = item['snr'] != '-' &&
          item['snr'] != null &&
          item['snr'] != '' &&
          item['txPower'] != '-' &&
          item['txPower'] != null &&
          item['txPower'] != '' &&
          item['NoiseLevel'] != '-' &&
          item['NoiseLevel'] != null &&
          item['NoiseLevel'] != '' &&
          item['routerX'] != null &&
          item['routerX'] != '';
      if (condition) {
        /// --- 计算实际面积对应宽高的缩放比例 ---
        /// 缩放比例=sqrt(面积 / 宽高乘积)
        /// 实际宽高=传入宽高 x 缩放比例
        /// *这里计算的是根据面积计算的根据原有绘制数据计算的比例
        /// 所以这个比例的使用要使用存储的原绘制数据
        double realScale = sqrt(item['roomArea'] / (totalWidth * totalHeight));

        /// 原始数据距离 = 实际辐射距离 / 缩放比例
        /// --- 设备与房间中心点距离,用于计算障碍物损耗 ---
        /// *这里使用原有数据计算，再乘以realScale得到对应真实的距离
        num reald = sqrt(pow(
                    ((item['offsetX'] - 1200 + item['width'] / 2) -
                        item['routerX']),
                    2) +
                pow(
                    ((item['offsetY'] - 1200 + item['height'] / 2) -
                        item['routerY']),
                    2)) *
            realScale;

        debugPrint(
            '测值和设备距离$reald,房间测量值：${int.parse(item['snr']) + int.parse(item['NoiseLevel'])},房屋大小${item['roomArea']},房间位置${item['offsetX']},${item['offsetY']},房间名字：${item['name']},缩放比例$realScale');
        // 障碍物衰减
        double obstacle = int.parse(item['txPower']) +
            6 -
            (46 + 25 * (log(reald) / log(10))) +
            0 -
            (int.parse(item['snr']) + int.parse(item['NoiseLevel']));

        /// --- 计算信号强度分别是-40，-60，-80，-100时候的距离 ---
        /// 根据-100时候的值作为最大距离
        /// *这里是套公式计算，距离对应实际中的n米
        num max100 = pow(10,
            (int.parse(item['txPower']) + 6 - obstacle + 0 - (-100) - 46) / 25);
        num max80 = pow(10,
            (int.parse(item['txPower']) + 6 - obstacle + 0 - (-80) - 46) / 25);
        num max60 = pow(10,
            (int.parse(item['txPower']) + 6 - obstacle + 0 - (-60) - 46) / 25);
        num max40 = pow(10,
            (int.parse(item['txPower']) + 6 - obstacle + 0 - (-40) - 46) / 25);
        double percent40 = max40 / max100;
        double percent60 = max60 / max100;
        double percent80 = max80 / max100;
        debugPrint(
            '衰减：$obstacle 比例：$percent40 $percent60 $percent80,实际距离：$max40 $max60 $max80 $max100');

        /// --- 衰减渐变图的半径 ---
        /// *这里已知实际距离，需要根据实际距离换算原始数值，再换算成应该绘制的距离
        num d = max100 / realScale * scale;

        /// --- 绘制衰减渐变图 ---
        // 圆心坐标
        // *这里是绘制，所以应该用原始值*scale，得到绘制的坐标值
        var center = item['routerX'] != null
            ? Offset(item['routerX'] / scale + 14, item['routerY'] / scale + 14)
            : Offset(0.5.sw + 14, 320.w + 14); // 中心始终是设备位置,14是28*28图标的一半大小
        debugPrint(
            '中心点${Offset((item['offsetX'] - 1200 + item['width'] / 2), (item['offsetY'] - 1200 + item['height'] / 2))},router位置${Offset(item['routerX'] + 14, item['routerY'] + 14)},画布宽高：${1.sw},${600.w},实际绘制距离：$d');
        // 定义渐变
        var gradient = RadialGradient(
          colors: const [
            Color.fromARGB(255, 20, 255, 0),
            Color.fromARGB(255, 118, 240, 4),
            Color.fromARGB(255, 248, 244, 11),
            Color.fromARGB(255, 247, 65, 41),
          ],
          stops: [percent40, percent60, percent80, 1],
        );
        final paintc = Paint()
          ..shader = gradient.createShader(
            Rect.fromCircle(
                center: center,
                radius:
                    double.parse(d.toString())), //radius是辐射范围：信号衰减到-100的时候距离
          )
          ..style = PaintingStyle.fill;

        canvas.clipPath(pathRect);
        canvas.drawCircle(center, double.parse(d.toString()), paintc);
      }

      canvas.drawPath(pathRect, paint);
      canvas.drawPath(pathRect, paintFill);
      canvas.restore();

      // 绘制文字
      var paragraphBuilder = ParagraphBuilder(ParagraphStyle(
        textAlign: TextAlign.center,
        fontSize: 12,
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
                (1.sw - totalWidth * scale) / 2 +
                item['width'] * scale / 2 -
                25,
            (item['offsetY'] - 1200) * scale + item['height'] * scale / 2 - 8),
      );
      debugPrint(
          '文字的坐标${Offset((item['offsetX'] - 1200) * scale + item['width'] * scale / 2 + (1.sw - totalWidth * scale) / 2 - 25, (item['offsetY'] - 1200) * scale + item['height'] * scale / 2 - 8)}');
    }
  }

  @override
  bool shouldRepaint(Layout oldDelegate) {
    return true;
  }
}

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
