import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kg_charts/kg_charts.dart';

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
  final List<IndicatorModel> legend = List.generate(36, (index) {
    if (index % 3 == 0) {
      return IndicatorModel("${index * 10}", 30);
    }
    return IndicatorModel("", 30);
  });
  var _timer;
  int _index = 0;
  showTimer() {
    // print(123123);
    _timer = Timer.periodic(const Duration(milliseconds: 300), (t) {
      //需要执行的内容
      setState(() {
        _index++;
        if (_index <= 36) {
          mapData[_index - 1] = random(3, 28);
          // mapData = mapData;
        } else {
          _timer?.cancel();
        }
        print(123123);
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
        children: [
          RadarWidget(
            skewing: 0,
            radarMap: RadarMapModel(
              legend: [
                LegendModel('信号强度', const Color(0XFF0EBD8D)),
                // LegendModel('10/11', const Color(0XFFEAA035)),
              ],
              indicator: legend,
              data: [
                //   MapDataModel([48,32.04,1.00,94.5,19,60,50,30,19,60,50]),
                //   MapDataModel([42.59,34.04,1.10,68,99,30,19,60,50,19,30]),
                // MapDataModel([100, 90, 90, 90, 10, 20, 10]),
                MapDataModel(mapData),
              ],
              radius: 130,
              duration: 2000,
              shape: Shape.circle,
              maxWidth: 70,
              line: LineModel(3),
            ),
            textStyle: const TextStyle(color: Colors.black, fontSize: 14),
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
          ElevatedButton(
            onPressed: () {
              showTimer();
            },
            child: const Text('开始搜索'),
          ),
          ElevatedButton(
            onPressed: () {
              // setState(() {
              //   _index = 0;
              // });
              _timer?.cancel();
            },
            child: const Text('停止搜索'),
          ),
          Text('$_index')
        ],
      ),
    );
  }
}