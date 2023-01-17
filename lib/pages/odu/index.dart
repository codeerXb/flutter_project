import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
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
  List<double> mapData = List.generate(360, (index) {
    return 0;
  });
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
  selfInspectionFn() {
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
    XHttp.get('/data.html', data1).then((res) {
      selfInspectionTimer =
          Timer.periodic(const Duration(milliseconds: 500), (t) {
        XHttp.get('/data.html', data2).then((res) {
          debugPrint('obj_setODU${res.toString()}');
        }).then((value) {
          // sleep(const Duration(seconds: 1));
          getODUData().then((value) {
            debugPrint('getODUdata$value');
          });
        }).catchError((err) {
          setState(() {
            currentIndex = -1;
          });
          debugPrint('setoduerr${err.toString()}');
        });
      });
    }).catchError((err) {
      setState(() {
        currentIndex = -1;
      });
      debugPrint('查询odu信息失败${err.toString()}');
    });
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
      mapData = List.generate(360, (index) {
        return 0;
      });
      mapDataPoint = List.generate(360, (index) {
        return 0;
      });
    });
    selfInspectionTimer?.cancel();
    _timer?.cancel();
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
        debugPrint("\n================== oduoduodu ==========================");
        Map<String, dynamic> Transmission = {"ODUTransmission": ''};
        String jsonData = res.replaceAll('\\u0002', '');
        Transmission['ODUTransmission'] =
            json.decode(json.decode(jsonData)['ODUTransmission']);
        debugPrint("json数据${Transmission}");
        oduData = ODUData.fromJson(Transmission);
        debugPrint(
            "oduoduodu${oduData.oDUTransmission!.dataTable![0].degree}length${oduData.oDUTransmission!.dataTable!.length}");
        // 自检
        if (oduData.oDUTransmission!.param2 == 4) {
          if (oduData.oDUTransmission!.dataTable![0].degree != null) {
            setState(() {
              currentIndex = 0;
              mapData = List.generate(360, (index) {
                return 0;
              });
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
          if (oduData.oDUTransmission!.dataTable![0].degree != null) {
            setState(() {
              currentIndex = 1;
              // mapData[_index] = random(3, 28);

              pointer = List.generate(360, (index) {
                return 0;
              });
              mapDataPoint = List.generate(360, (index) {
                return 0;
              });
              int degIndex =
                  ((oduData.oDUTransmission!.dataTable![0].degree! / 100)
                          .truncate() %
                      360);
              mapData[degIndex] =
                  oduData.oDUTransmission!.dataTable![0].sinr! / 100;
              if (mapData[degIndex] > maxNumber) {
                maxNumber = mapData[degIndex];
                currentAngle = degIndex;
              }
              mapDataPoint[degIndex] = 30;
              _index = degIndex;
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
          setState(() {
            isShow = true;
          });
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
          ToastUtils.toast('终止搜索');
        } else if (oduData.oDUTransmission!.param2 == 3) {
          setState(() {
            currentIndex = -2;
          });
        } else {
          printInfo(info: 'param2:${oduData.oDUTransmission!.param2}');
        }
        return oduData.oDUTransmission!.param2;
      } on FormatException catch (e) {
        setState(() {
          isShow = true;
          currentIndex = -1;
        });
        selfInspectionTimer?.cancel();
        _timer?.cancel();
        ToastUtils.toast('执行失败');
        debugPrint(e.toString());
      }
    }).catchError((onError) {
      // init();
      if (mounted) {
        ToastUtils.toast('执行失败');
        setState(() {
          isShow = true;
          currentIndex = -1;
        });
        selfInspectionTimer?.cancel();
        debugPrint('失败：${onError.toString()}');
      }
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

                      MapDataModel(mapData),
                      MapDataModel(pointer),
                      MapDataModel(mapDataPoint)
                    ],
                    radius: 200.w,
                    duration: 500,
                    shape: Shape.circle,
                    maxWidth: 50.w,
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
                                    " ${mapData[_index]} dB",
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
