import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/steps_widget%20copy%202.dart';

import 'package:flutter_template/pages/odu/model/odu_data.dart';
import 'package:get/get.dart';
import 'radar_map_model.dart';
import 'radar_widget.dart';

class ODU extends StatefulWidget {
  const ODU({super.key});
  @override
  State<ODU> createState() => _ODUState();
}

random(min, max) {
  // + min  表示生成一个最小数 min 到最大数之间的是数字
  var num = Random().nextInt(max) + min;
  // floor() 返回的是一个整数。
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
  late Timer? _timer;
  late Timer? selfInspectionTimer;
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
  double curS = 0;
  @override
  void initState() {
    //初始化的时候使用一下，避免在销毁的时候出错
    _timer = Timer.periodic(const Duration(milliseconds: 0), (timer) {});
    selfInspectionTimer =
        Timer.periodic(const Duration(milliseconds: 0), (timer) {});
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // 组件销毁时判断Timer是否仍然处于激活状态，是则取消
    _timer?.cancel();
    _timer = null;
    selfInspectionTimer?.cancel();
    selfInspectionTimer = null;
  }

  //自检
  selfInspectionFn() async {
    init();
    // 自检
    Map<String, dynamic> data1 = {
      'method': 'obj_set',
      'param': '{"ODUTransmission":"2,0,0,0,0"}',
    };
    // 搜索
    Map<String, dynamic> data2 = {
      'method': 'obj_set',
      'param': '{"ODUTransmission":"9,0,0,0,0"}',
    };
    var res1 = await XHttp.get('/data.html', data1);
    printInfo(info: 'res1$res1');
    if (res1 != null) {
      selfInspectionTimer =
          Timer.periodic(const Duration(milliseconds: 100), (t) async {
        if (mounted) {
          try {
            dynamic res2;
            if (getStat && mounted) {
              setState(() {
                quest = 0;
              });
              res2 = await XHttp.get('/data.html', data2);
              if (res2 != null && mounted) {
                setState(() {
                  getStat = false;
                });
                getODUData();
              }
            }
          } on DioError catch (e) {
            if (e.type == DioErrorType.receiveTimeout ||
                e.type == DioErrorType.connectTimeout) {
              debugPrint('接收错误');
            } else {
              if (mounted) {
                setState(() {
                  currentIndex = -1;
                });
              }
            }
          }
        }
      });
    }
  }

//初始化
  init() {
    setState(() {
      currentIndex = -1;
      isShow = false;
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
      curS = 0;
      selfInspectionTimer?.cancel();
      _timer?.cancel();
    });
  }

  //搜索
  // showTimer() {
  //   mapData = List.generate(360, (index) {
  //     return 0;
  //   });
  //   _timer = Timer.periodic(const Duration(milliseconds: 300), (t) {
  //     getODUData(2);
  //     //需要执行的内容

  //     //t.cancel();		//根据需要停止定时器
  //   });
  // }

  //获取数据
  Future getODUData() async {
    Map<String, dynamic> data = {
      'method': 'obj_get',
      'param': '["ODUTransmission"]',
    };
    return XHttp.get('/data.html', data).then((res) {
      try {
        if (mounted) {
          setState(() {
            getStat = true;
          });
        }
        debugPrint("\n================== oduoduodu ==========================");
        Map<String, dynamic> transmission = {"ODUTransmission": ''};
        String jsonData = res.replaceAll('\\u0002', '');
        transmission['ODUTransmission'] =
            json.decode(json.decode(jsonData)['ODUTransmission']);
        debugPrint("json数据$transmission");
        oduData = ODUData.fromJson(transmission);
        debugPrint(
            "oduoduodu${oduData.oDUTransmission!.dataTable![0].degree}length${oduData.oDUTransmission!.dataTable!.length}");
        // 自检
        if (oduData.oDUTransmission!.param2 == 4) {
          if (oduData.oDUTransmission?.dataTable != null &&
              oduData.oDUTransmission!.dataTable![0].degree != null &&
              mounted) {
            setState(() {
              endStatus = 0;
              currentIndex = 0;
              mapData = [];
              // 度数/100舍弃小数部分,取最后一个数显示
              _index = (oduData
                              .oDUTransmission!
                              .dataTable![
                                  oduData.oDUTransmission!.dataTable!.length -
                                      1]
                              .degree! /
                          100)
                      .truncate() %
                  360;
              // oduData.oDUTransmission!.dataTable!.map((item) {
              //   mapData[((item.degree! / 100).truncate() % 360)] = 30;
              // });
              mapDataPoint[_index] = 30;
              printInfo(
                  info:
                      '自检开始的角度${(oduData.oDUTransmission!.dataTable![0].degree! / 100).truncate() % 360}终止角度${(oduData.oDUTransmission!.dataTable![oduData.oDUTransmission!.dataTable!.length - 1].degree! / 100).truncate() % 360}');
              for (int i = 340; i >= _index; i--) {
                mapDataPoint[i] = 30;
              }
              // if (_index != 0 && oduData.oDUTransmission!.param2 == 4) {
              //   _index -= 1;
              //   mapData[_index] = 30;
              //   selfInspection = false;
              // } else {
              //   _index = 0;
              //   selfInspection = true;
              //   selfInspectionTimer?.cancel();
              //   showTimer();
              // }
            });
          }
        } else if (oduData.oDUTransmission!.param2 == 1 ||
            oduData.oDUTransmission!.param2 == 2) {
          //搜索
          if (oduData.oDUTransmission?.dataTable != null &&
              oduData.oDUTransmission!.dataTable![0].degree != null &&
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
              int len = oduData.oDUTransmission!.dataTable!.length;
              int degIndex =
                  ((oduData.oDUTransmission!.dataTable![len - 1].degree! / 100)
                          .truncate() %
                      360);
              for (var i = 0; i < len; i++) {
                mapData.add({
                  'deg': ((oduData.oDUTransmission!.dataTable![i].degree! / 100)
                          .truncate() %
                      360),
                  'val': oduData.oDUTransmission!.dataTable![i].sinr! / 100
                });
                curS = oduData.oDUTransmission!.dataTable![i].sinr! / 100;
              }

              if (mapData[mapData.length - 1]['val'] > maxNumber) {
                maxNumber = mapData[mapData.length - 1]['val'];
                currentAngle = degIndex;
              }
              mapDataPoint[degIndex] = 30;
              _index = degIndex;
              debugPrint('degIndex:$degIndex');
              // mapData = mapData;
            });
            // oduData.oDUTransmission!.dataTable!.map((item) {
            //   setState(() {
            //     mapData[((item.degree! / 100).truncate() % 360)] =
            //         oduData.oDUTransmission!.dataTable![0].sinr! / 100;
            //     if (mapData[((item.degree! / 100).truncate() % 360)] >
            //         maxNumber) {
            //       maxNumber = mapData[((item.degree! / 100).truncate() % 360)];
            //       currentAngle =
            //           ((item.degree! / 100).truncate() % 360).truncate();
            //     }
            //     printInfo(info: 'mapData的值${mapData.toString()}');
            //   });
            // });
          }
        } else if (oduData.oDUTransmission!.param2 == 6) {
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
              pointer[currentAngle] = maxNumber;
              currentIndex = 2;
              _timer?.cancel();
              selfInspectionTimer?.cancel();
              selfInspectionTimer = null;
            });
            ToastUtils.toast('终止搜索');
          }
        } else if (oduData.oDUTransmission!.param2 == 3) {
          if (mounted) {
            setState(() {
              currentIndex = -2;
              endStatus = 0;
            });
          }
        } else if (oduData.oDUTransmission!.param2 == 5) {
          if (oduData.oDUTransmission!.dataTable![0].degree != null) {
            if (mounted) {
              setState(() {
                mapDataPoint = List.generate(360, (index) {
                  return 0;
                });
                // 每次只画最后一个数
                int endIndex = oduData.oDUTransmission!.dataTable!.length - 1;
                int degIndex =
                    ((oduData.oDUTransmission!.dataTable![endIndex].degree! /
                                100)
                            .truncate() %
                        360);
                mapDataPoint[degIndex] = 30;
                _index = endIndex;
                mapData.map((e) {
                  if (e['deg'] == endIndex) {
                    curS = e['val'];
                  }
                });
              });
            }
          }
        } else {
          if (mounted) {
            printInfo(info: 'param2:${oduData.oDUTransmission!.param2}');
            setState(() {
              endStatus = 0;
            });
          }
        }
      } on FormatException catch (e) {
        // setState(() {
        //   endStatus = 0;
        //   isShow = true;
        //   currentIndex = -1;
        // });
        // selfInspectionTimer?.cancel();
        // _timer?.cancel();
        // ToastUtils.toast('执行失败');
        debugPrint(e.toString());
      }
    }).catchError((e) {
      // init();
      if (mounted) {
        setState(() {
          getStat = false;
        });
      }
      if (e is DioError &&
          (e.type == DioErrorType.receiveTimeout ||
              e.type == DioErrorType.connectTimeout) &&
          mounted) {
        setState(() {
          quest++;
        });
        if (quest < 3) {
          debugPrint('重新请求');
          getODUData();
        }
      } else {
        if (mounted) {
          ToastUtils.toast('执行失败');
          setState(() {
            endStatus = 0;
            isShow = true;
            currentIndex = -1;
          });
          selfInspectionTimer?.cancel();
        }
      }
      debugPrint('失败：${e.message.toString()}');
    });
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
            body: Column(
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
                      LegendModel('实时数值', const Color(0XFF0EBD8D)),
                      LegendModel(
                          '最大数值', const Color.fromARGB(255, 234, 104, 53)),
                      LegendModel(
                          '当前指向', const Color.fromARGB(255, 14, 14, 189)),
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
                        color: const Color.fromARGB(255, 98, 98, 98)),
                  ),
                  textStyle: const TextStyle(color: Colors.black, fontSize: 10),
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
                                style: TextStyle(color: Color(0XFF0EBD8D)),
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
                                  child: Text(" $_index°",
                                      style: TextStyle(
                                          fontSize: 30.sp,
                                          color: const Color(0XFF0EBD8D))),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                'CurS',
                                style: TextStyle(color: Color(0XFF0EBD8D)),
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
                                        color: const Color(0XFF0EBD8D)),
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
                                    color: Color.fromARGB(255, 234, 104, 53)),
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
                                            255, 234, 104, 53)),
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
                                    color: Color.fromARGB(255, 234, 104, 53)),
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
                    onPressed: isShow ? selfInspectionFn : null,
                    child: const Text('开始搜索'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 70.w),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
