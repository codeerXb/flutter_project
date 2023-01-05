import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/widget/steps_widget.dart';

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
  List<double> mapData = List.generate(36, (index) {
    return 0;
  });
  List<double> pointer = List.generate(36, (index) {
    return 0;
  });
  final List<IndicatorModel> legend = List.generate(36, (index) {
    if (index % 3 == 0) {
      return IndicatorModel("${index * 10}", 30);
    }
    return IndicatorModel("", 30);
  });
  var _timer;
  bool isShow = true;
  int _index = 0;
  double MaxNumber = 0;
  int CurrentAngle = 0;
  int currentIndex = -1;
  showTimer() {
    // print(123123);
    setState(() {
      currentIndex = -1;
    });
    isShow = false;
    _index = 0;
    MaxNumber = 0;
    CurrentAngle = 0;
    mapData = List.generate(36, (index) {
      return 0;
    });
    pointer = List.generate(36, (index) {
      return 0;
    });
    setState(() {
      currentIndex = 0;
    });
    _timer = Timer.periodic(const Duration(milliseconds: 300), (t) {
      //需要执行的内容
      setState(() {
        currentIndex = 1;
        if (_index < 36) {
          mapData[_index] = random(3, 28);
          if (mapData[_index] > MaxNumber) {
            pointer = List.generate(36, (index) {
              return 0;
            });

            MaxNumber = mapData[_index];
            CurrentAngle = _index * 10;
            pointer[_index] = MaxNumber;
          }
          _index++;

          // mapData = mapData;
        } else {
          isShow = true;

          currentIndex = 2;
          _timer?.cancel();
        }
      });
      //t.cancel();		//根据需要停止定时器
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('ODU'),
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
              padding: EdgeInsets.only(
            top: 40.w,
          )),
          StepsWidget(currentIndex: currentIndex),
          // Row(
          //   children: const [StepsWidget(currentIndex: 1)],
          // ),

          RadarWidget(
            skewing: 0,
            radarMap: RadarMapModel(
              legend: [
                LegendModel('实时数值', const Color(0XFF0EBD8D)),
                LegendModel('最大数值', const Color.fromARGB(255, 234, 104, 53)),
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
            dilogText: (IndicatorModel indicatorModel,
                List<LegendModel> legendModels, List<double> mapDataModels) {
              StringBuffer text = StringBuffer("");
              for (int i = 0; i < mapDataModels.length; i++) {
                text.write(
                    "${legendModels[i].name} : ${mapDataModels[i].toString()}");
                if (i != mapDataModels.length - 1) {
                  text.write("\n");
                }
              }
              return text.toString();
            },
            outLineText: (data, max) {
              return data > 0 ? "$data" : '';
            },
          ),
          Padding(
              padding: EdgeInsets.only(
            top: 20.w,
          )),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
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
                        child: Text(" ${(_index) * 10}°",
                            style: const TextStyle(color: Color(0XFF0EBD8D))),
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
                          style: const TextStyle(color: Color(0XFF0EBD8D)),
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
                      style:
                          TextStyle(color: Color.fromARGB(255, 234, 104, 53)),
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
                        child: Text(" ${isShow ? CurrentAngle : 0}°",
                            style: const TextStyle(
                                color: Color.fromARGB(255, 234, 104, 53))),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'MaxS',
                      style:
                          TextStyle(color: Color.fromARGB(255, 234, 104, 53)),
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
                          " ${isShow ? MaxNumber : 0.0} dB",
                          style: const TextStyle(
                              color: Color.fromARGB(255, 234, 104, 53)),
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
              onPressed: isShow ? showTimer : null,
              child: const Text('开始搜索'),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 70.w),
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
          //   children: [
          //     ElevatedButton(
          //       onPressed: isShow ? showTimer : null,
          //       child: Row(
          //         children: const [
          //           Text('开始搜索'),
          //           // if (isShow) const CircularProgressIndicator(value: 0.5),
          //           // const Icon(Icons.local_dining)
          //         ],
          //       ),
          //     ),

          //     ElevatedButton(
          //       onPressed: () {
          //         setState(() {
          //           isShow = true;
          //         });

          //         _timer?.cancel();
          //       },
          //       child: const Text('停止搜索'),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
