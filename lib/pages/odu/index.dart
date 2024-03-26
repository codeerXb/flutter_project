import 'dart:convert';
import 'dart:developer' as logPrint;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/steps_widget%20copy%202.dart';
import 'package:flutter_template/generated/l10n.dart';
import 'package:flutter_template/pages/odu/model/odu_data.dart';
import 'package:get/get.dart';
import 'radar_map_model.dart';
import 'radar_widget.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'dart:convert' as convert;

class ODU extends StatefulWidget {
  const ODU({super.key});
  @override
  State<ODU> createState() => _ODUState();
}

random(min, max) {
  // + min  表示生成一个最小数 min 到最大数之间的是数字
  var num = Random().nextInt(max) + min;
  return num.toDouble();
}

class _ODUState extends State<ODU> {
  ODUData oduData = ODUData();
  List<Map<String, dynamic>> mapData = [];
  List<double> mapDataPoint = List.generate(360, (index) {
    return 0;
  });
  List<double> pointer = List.generate(360, (index) {
    return 0;
  });
  final List<IndicatorModel> legend = List.generate(360, (index) {
    if (index % 30 == 0) {
      return IndicatorModel("$index°", 30);
    }
    return IndicatorModel("", 30);
  });
  bool isShow = true;
  int _index = 0;
  double maxNumber = 0;
  int currentAngle = 0;
  int currentIndex = -1;
  // 记录终止状态
  int endStatus = 0;
  // 记录是否get获得数据
  bool getStat = true;
  // 记录get数据的次数
  int quest = 0;
  int curA = 0;
  double curS = 0;
  @override
  void initState() {
    //初始化的时候使用一下，避免在销毁的时候出错

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // 组件销毁时关闭ws
    channel?.sink.close();
  }

  WebSocketChannel? channel;
  Map mapData1 = {
    "cmd": 2,
    "param1": 0,
    "param2": 1,
    "param3": 0,
    "param4": 0,
    "param5": 0,
    "param6": 0,
    "param7": 0,
    "data_table": [{}]
  };
  onData(msg) {
    Map<String, dynamic> transmission = jsonDecode(msg);
    if (transmission['code'] != null && transmission['code'] == 500) {
      ToastUtils.error(S.current.timeout);
      setState(() {
        isShow = true;
      });
      return;
    }
    var message = ODUData.fromJson(transmission);
    printInfo(info: "res -----> $msg");

    if (message.param2 == 4) {
      // 自检
      printInfo(info: message.dataTable![0].degree.toString());
      if (message.dataTable != null && message.dataTable![0].degree != null) {
        if (mounted) {
          setState(() {
            endStatus = 0;
            currentIndex = 0;
            mapData = [];
            // 度数/100舍弃小数部分,取最后一个数显示
            _index =
                (message.dataTable![message.dataTable!.length - 1].degree! /
                            100)
                        .truncate() %
                    360;
            curA = _index;
            mapDataPoint[_index] = 30;

            for (int i = 340; i >= _index; i--) {
              mapDataPoint[i] = 30;
            }
          });
        }
      }
    } else if (message.param2 == 2 || message.param2 == 1) {
      //搜索
      if (message.dataTable != null &&
          message.dataTable![0].degree != null &&
          mounted) {
        setState(() {
          endStatus = 0;
          currentIndex = 1;
          // mapData[_index] = random(3, 28);

          pointer = List.generate(360, (index) {
            return 0;
          });
          mapDataPoint = List.generate(360, (index) {
            return 0;
          });
          int len = message.dataTable!.length;
          for (var i = 0; i < len; i++) {
            if (message.dataTable![i].degree != null) {
              int degIndex =
                  ((message.dataTable![i].degree! / 100).truncate() % 360);
              mapData.add({
                'deg': ((message.dataTable![i].degree! / 100).truncate() % 360),
                'val': message.dataTable![i].sinr! / 100
              });
              curS = message.dataTable![i].sinr! / 100;
              mapDataPoint[degIndex] = 30;
              curA = degIndex;
            }
          }
          // mapData = mapData;
        });
      }
    } else if (message.param2 == 6) {
      // 结束
      if (mounted) {
        setState(() {
          isShow = true;
          endStatus = 6;
          pointer = List.generate(360, (index) {
            return 0;
          });
          mapDataPoint = List.generate(360, (index) {
            return 0;
          });
          currentIndex = 2;
          if (message.dataTable != null &&
              message.dataTable![0].degree != null) {
            int lastAngle =
                ((message.dataTable![message.dataTable!.length - 1].degree! /
                            100)
                        .truncate() %
                    360);
            curA = lastAngle;
            logPrint.log(mapData.toString());
            for (var e in mapData) {
              if (e['deg'] == lastAngle) {
                curS = e['val'];
                currentAngle = e['deg'];
                maxNumber = e['val'];
                mapDataPoint[e['deg']] = 30;
              }
            }
          }
        });
        //  关闭ws
        channel?.sink.close();
        ToastUtils.toast(S.current.stopSerch);
      }
    } else if (message.param2 == 3) {
      // 复位
      if (mounted) {
        setState(() {
          currentIndex = -2;
          endStatus = 0;
        });
      }
    } else if (message.param2 == 5) {
      // 定位
      if (message.dataTable![0].degree != null) {
        if (mounted) {
          setState(() {
            mapDataPoint = List.generate(360, (index) {
              return 0;
            });
            // 每次只画最后一个数
            int endIndex = message.dataTable!.length - 1;
            int degIndex =
                ((message.dataTable![endIndex].degree! / 100).truncate() % 360);
            mapDataPoint[degIndex] = 30;
            curA = degIndex;
            for (var e in mapData) {
              if (e['deg'] == degIndex) {
                curS = e['val'];
              }
            }
          });
        }
      }
    } else {
      if (mounted) {
        printInfo(info: 'param2:${message.param2}');
        // setState(() {
        //   endStatus = 0;
        // });
      }
    }
  }

  wsConnect() {
    final wsUrl = Uri.parse('ws://192.168.225.10:4321');
    channel = WebSocketChannel.connect(wsUrl);
    // channel.sink.add(convert.jsonEncode(mapData));
    channel?.stream.listen(onData, onDone: (() {
      debugPrint("onDone");
    }), onError: (error) {
      debugPrint("连接ws 错误");
      ToastUtils.error(S.current.error);
      if (mounted) {
        setState(() {
          isShow = true;
        });
      }
    });
  }

//初始化
  init() {
    setState(() {
      currentIndex = -1;
      isShow = true;
      _index = 0;
      maxNumber = 0;
      currentAngle = 0;
      pointer = List.generate(360, (index) {
        return 0;
      });
      mapData = [];
      mapDataPoint = List.generate(360, (index) {
        return 0;
      });
      curA = 0;
      curS = 0;
    });
  }

//连接并接受数据
  connectReceiveData() {
    if (isShow) {
      init();
      wsConnect();
      channel?.sink.add(convert.jsonEncode(mapData1));
      setState(() {
        isShow = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(color: Color(0xfff5f6fa)),
        ),
        Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  alignment: Alignment.topCenter,
                  image: AssetImage('assets/images/topbj.png'),
                  fit: BoxFit.cover)),
          child: Scaffold(
            appBar: AppBar(
              foregroundColor: Colors.black,
              backgroundColor: Colors.transparent, //设置为白色字体
              centerTitle: true,
              title: const Text('ODU'),
              elevation: 0,
              systemOverlayStyle: const SystemUiOverlayStyle(
                //设置状态栏的背景颜色
                statusBarColor: Colors.transparent,
                //状态栏的文字的颜色
                statusBarIconBrightness: Brightness.dark,
              ),
            ),
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding: EdgeInsets.only(
                        bottom: 20.w,
                        top: 10.w,
                      ),
                      child: StepsWidget(currentIndex: currentIndex)),

                  // Row(
                  //   children: const [StepsWidget(currentIndex: 1)],
                  // ),

                  RadarWidget(
                    skewing: 0,
                    radarMap: RadarMapModel(
                      legend: [
                        LegendModel(S.of(context).currentValue,
                            const Color.fromARGB(255, 34, 177, 16)),
                        LegendModel(S.of(context).maxValue,
                            const Color.fromARGB(255, 234, 65, 53)),
                        LegendModel(S.of(context).currentOrientation,
                            const Color.fromARGB(255, 255, 166, 1)),
                      ],
                      indicator: legend,
                      data: [
                        //   MapDataModel([48,32.04,1.00,94.5,19,60,50,30,19,60,50]),
                        //   MapDataModel([42.59,34.04,1.10,68,99,30,19,60,50,19,30]),

                        mapData,
                        MapDataModel(pointer),
                        MapDataModel(mapDataPoint)
                      ],
                      radius: 200.w,
                      duration: 500,
                      shape: Shape.circle,
                      maxWidth: 50.w,
                      paintStatus: endStatus,
                      line: LineModel(3,
                          color: const Color.fromARGB(255, 255, 255, 255)),
                    ),
                    textStyle:
                        const TextStyle(color: Colors.black, fontSize: 10),
                    isNeedDrawLegend: true,
                    lineText: (p, length) => "${(p * 30 ~/ length)}dB",
                    // dilogText: (IndicatorModel indicatorModel,
                    //     List<LegendModel> legendModels, List<double> mapDataModels) {
                    //   StringBuffer text = StringBuffer("");
                    //   for (int i = 0; i < mapDataModels.length; i++) {
                    //     text.write(
                    //         "${legendModels[i].name} : ${mapDataModels[i].toString()}");
                    //     if (i != mapDataModels.length - 1) {
                    //       text.write("\n");
                    //     }
                    //   }
                    //   return text.toString();
                    // },
                    // outLineText: (data, max) {
                    //   return data > 0 && selfInspection ? "$data" : '';
                    // },
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                    top: 20.w,
                  )),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'CurA',
                                  style: TextStyle(
                                      color: Color.fromARGB(178, 35, 177, 16)),
                                ),
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.w),
                                    side: const BorderSide(
                                      color: Color.fromARGB(255, 218, 218, 218),
                                      width: 1,
                                    ),
                                  ),
                                  child: Container(
                                    width: 150.w,
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.all(5.w),
                                    child: Text(" $curA°",
                                        style: TextStyle(
                                            fontSize: 30.sp,
                                            color: const Color.fromARGB(
                                                255, 34, 177, 16))),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  'CurS',
                                  style: TextStyle(
                                      color: Color.fromARGB(178, 34, 177, 16)),
                                ),
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.w),
                                    side: const BorderSide(
                                      color: Color.fromARGB(255, 218, 218, 218),
                                      width: 1,
                                    ),
                                  ),
                                  child: Container(
                                    width: 150.w,
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.all(5.w),
                                    child: Text(
                                      " $curS dB",
                                      style: TextStyle(
                                          fontSize: 30.sp,
                                          color: const Color.fromARGB(
                                              255, 34, 177, 16)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'MaxA',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 189, 56, 46)),
                                ),
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.w),
                                    side: const BorderSide(
                                      color: Color.fromARGB(255, 218, 218, 218),
                                      width: 1,
                                    ),
                                  ),
                                  child: Container(
                                    width: 150.w,
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.all(5.w),
                                    child: Text(
                                      " ${isShow ? currentAngle : 0}°",
                                      style: TextStyle(
                                          fontSize: 30.sp,
                                          color: const Color.fromARGB(
                                              255, 234, 65, 53)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  'MaxS',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 189, 56, 46)),
                                ),
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.w),
                                    side: const BorderSide(
                                      color: Color.fromARGB(255, 218, 218, 218),
                                      width: 1,
                                    ),
                                  ),
                                  child: Container(
                                    width: 150.w,
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.all(5.w),
                                    child: Text(
                                      " ${isShow ? maxNumber : 0.0} dB",
                                      style: TextStyle(
                                          fontSize: 30.sp,
                                          color: const Color.fromARGB(
                                              255, 234, 104, 53)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ]),
                  // Text(
                  //     '当前旋转(角度/dB)${(_index) * 10}° / ${mapData[_index == 0 ? 0 : _index - 1]}dB'),
                  // Text('信号最大值-旋转角度$MaxNumber dB - $CurrentAngle°'),
                  Padding(
                    padding: EdgeInsets.only(top: 110.w),
                  ),
                  SizedBox(
                    height: 70.sp,
                    width: 410.sp,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(isShow
                              ? const Color.fromARGB(255, 48, 118, 250)
                              : Colors.white)),
                      onPressed: connectReceiveData,
                      child: Text(
                        S.of(context).startSearch,
                        style: TextStyle(
                            color: isShow ? Colors.white : Colors.grey),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 70.w),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
