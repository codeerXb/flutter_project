import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/steps_widget%20copy%202.dart';

import 'package:flutter_template/pages/odu/model/odu_data.dart';
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
  bool selfInspection = true;
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
    // Map<String, dynamic> data = {
    //   'method': 'obj_set',
    //   'param': '["ODUTransmission":"7,0,0,0"]',
    // };
    // XHttp.get('/data.html', data).then((res) {

    // });
    selfInspectionTimer =
        Timer.periodic(const Duration(milliseconds: 1000), (t) {
      getODUData(1).then((value) => {
            print('vvvvvvv$value'),
            if (value != 4)
              {
                selfInspectionTimer?.cancel(),
              }
          });
    });
  }

//初始化
  init() {
    setState(() {
      currentIndex = -1;
      isShow = false;
      _index = 0;
      selfInspection = true;
      maxNumber = 0;
      currentAngle = 0;
      pointer = List.generate(360, (index) {
        return 0;
      });
    });
    selfInspectionTimer?.cancel();
    _timer?.cancel();
  }

  //搜索
  showTimer() {
    mapData = List.generate(360, (index) {
      return 0;
    });
    _timer = Timer.periodic(const Duration(milliseconds: 300), (t) {
      getODUData(2);
      //需要执行的内容

      //t.cancel();		//根据需要停止定时器
    });
  }

  //获取数据
  Future getODUData(num) async {
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
        print("json数据${Transmission}");
        oduData = ODUData.fromJson(Transmission);
        print("oduoduodu${oduData.oDUTransmission!.dataTable![0].degree}");
        // 自检
        if (num == 1) {
          setState(() {
            currentIndex = 0;
            mapData = List.generate(360, (index) {
              return 0;
            });
            _index = oduData.oDUTransmission!.dataTable![0].degree!;
            if (_index != 0 && oduData.oDUTransmission!.param2 == 4) {
              _index -= 1;
              mapData[_index] = 30;
              selfInspection = false;
            } else {
              _index = 0;
              selfInspection = true;
              selfInspectionTimer?.cancel();
              showTimer();
            }
          });
        } else {
          //搜索
          setState(() {
            currentIndex = 1;
            if (_index < 360) {
              mapData[_index] =
                  oduData.oDUTransmission!.dataTable![0].sinr!.toDouble() / 100;
              // mapData[_index] = random(3, 28);
              pointer = List.generate(360, (index) {
                return 0;
              });
              if (mapData[_index] > maxNumber) {
                maxNumber = mapData[_index];
                currentAngle = _index;
              }
              pointer[_index] = 30;
              _index++;

              // mapData = mapData;
            } else {
              pointer = List.generate(360, (index) {
                return 0;
              });
              pointer[currentAngle] = maxNumber;

              isShow = true;
              currentIndex = 2;
              _timer?.cancel();
            }
          });
        }
        return oduData.oDUTransmission!.param2;
      } on FormatException catch (e) {
        setState(() {
          isShow = true;
        });
        selfInspectionTimer?.cancel();
        _timer?.cancel();
        ToastUtils.toast('执行失败');
        print(e);
      }
    }).catchError((onError) {
      // init();
      ToastUtils.toast('执行失败');
      setState(() {
        isShow = true;
      });
      debugPrint('失败：${onError.toString()}');
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
                      bottom: 10.w,
                      top: 40.w,
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
                    ],
                    indicator: legend,
                    data: [
                      //   MapDataModel([48,32.04,1.00,94.5,19,60,50,30,19,60,50]),
                      //   MapDataModel([42.59,34.04,1.10,68,99,30,19,60,50,19,30]),

                      MapDataModel(mapData),
                      MapDataModel(pointer),
                    ],
                    radius: 200.w,
                    duration: 500,
                    shape: Shape.circle,
                    maxWidth: 50.w,
                    line: LineModel(3),
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
                                      style: const TextStyle(
                                          color: Color(0XFF0EBD8D))),
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
                                    " ${mapData[_index == 0 ? 0 : _index - 1]} dB",
                                    style: const TextStyle(
                                        color: Color(0XFF0EBD8D)),
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
                                  child: Text(" ${isShow ? currentAngle : 0}°",
                                      style: const TextStyle(
                                          color: Color.fromARGB(
                                              255, 234, 104, 53))),
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
                                    style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 234, 104, 53)),
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
                  padding: EdgeInsets.only(top: 120.w),
                ),
                SizedBox(
                  height: 70.sp,
                  width: 410.sp,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 48, 118, 250))),
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
