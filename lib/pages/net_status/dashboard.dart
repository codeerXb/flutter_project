import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/pages/net_status/model/flow_statistics.dart';
import 'package:flutter_template/pages/net_status/model/net_connect_status.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'arc_progress_bar.dart';

class Dashboard extends StatefulWidget {
  Dashboard(
      {Key? key,
      this.totalFlowData = 0,
      required this.downRate,
      required this.upRate})
      : super(key: key);
  // 定义套餐总量，单位GB
  final double totalFlowData;

  // 上行速率
  final double upRate;
  // 下行速率
  final double downRate;

  @override
  State<StatefulWidget> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  double _totalFlowData = 0;
  var timer;
  @override
  void initState() {
    super.initState();

    /// 初始化状态
    _totalFlowData = widget.totalFlowData;
    getUsedFlow();
    timer = Timer.periodic(const Duration(milliseconds: 2000), (t) async {
      getUsedFlow();
    });
  }

  // 剩余流量百分比
  double _progress = 0;

  // 已经使用的流量
  double _usedFlow = 0;

  /// 舍弃当前变量的小数部分，结果为 33。返回值为 int 类型。
  int get usedFlowInt {
    return (_usedFlow >= 1024)
        ? (_usedFlow / 1024).truncate()
        : _usedFlow.truncate();
  }

  /// 获取小数部分，通过.分割，返回值为String类型
  String get usedFlowDecimals {
    return (_usedFlow >= 1024)
        ? '${(_usedFlow / 1024).toStringAsFixed(2).toString().split('.')[1].substring(0, 2)}GB'
        : '${_usedFlow.toStringAsFixed(2).toString().split('.')[1].substring(0, 1)}MB';
  }

  /// 请求获取已用流量
  Future<double> getUsedFlow() async {
    Map<String, dynamic> flowStatistics = {
      'method': 'tab_dump',
      'param': '["FlowTable"]',
    };
    try {
      var obj = await XHttp.get('', flowStatistics);
      var jsonObj = json.decode(obj);
      var flowTable = FlowStatistics.fromJson(jsonObj).flowTable?[4];
      if (flowTable != null) {
        var usedFlowBytes = double.parse(flowTable.recvBytes!);
        setState(() {
          _usedFlow = usedFlowBytes / 1048576;
          _progress =
              (1 - (usedFlowBytes / (_totalFlowData * 1024 * 1024 * 1024))) *
                  100;
        });
      }
      debugPrint('请求用过的');
      return _usedFlow;
    } catch (e) {
      debugPrint(e.toString());
    }
    return _usedFlow;
  }

  /// 获取实时在线数量

  @override
  Widget build(BuildContext context) {
    debugPrint('flowValue=$_usedFlow');
    debugPrint('total=$_totalFlowData');
    return Container(
      margin: EdgeInsets.zero,
      color: const Color(0xFFF8F8F8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              SizedBox(
                width: 526.w,
                height: 526.w,
                child: ArcProgresssBar(
                    width: 1.sw, height: 1.sw, progress: _progress),
              ),
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 14.sp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('$usedFlowInt',
                            style: TextStyle(
                              fontSize: 56.sp,
                              fontWeight: FontWeight.w700,
                              height: 1.sp,
                            )),
                        Text(
                          '.$usedFlowDecimals',
                          style: TextStyle(
                            fontSize: 28.sp,
                            height: 2.sp,
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 6.sp),
                        child: const Image(
                            image: AssetImage(
                                'assets/images/icon_homepage_flow.png')),
                      ),
                      Text(
                        '已用流量',
                        style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                            color: const Color(0xFF2F5AF5)),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
          Center(
            child: Container(
                margin: const EdgeInsets.only(right: 15, left: 15),
                padding: const EdgeInsets.only(top: 15, bottom: 15),
                width: 1.sw - 30,
                decoration: const BoxDecoration(
                  // 背景色
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    UploadSpeed(
                      rate: widget.upRate,
                    ),
                    DownloadSpeed(
                      rate: widget.downRate,
                    ),
                    const OnlineCount(),
                  ],
                )),
          )
        ],
      ),
    );
  }
}

// 展示实时在线数量
class OnlineCount extends StatelessWidget {
  const OnlineCount({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '0',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 50.sp,
              ),
            ),
            const Text(
              '台',
              style: TextStyle(
                  height: 2.2,
                  color: Color(0xFF87868E),
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
        Row(
          children: const [
            Text(
              '实时在线',
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ],
    );
  }
}

// 展示下行速度
class DownloadSpeed extends StatelessWidget {
  const DownloadSpeed({Key? key, this.rate = 0}) : super(key: key);
  final double rate;

  String get _downRate {
    var kb = rate / 1024;
    if (kb >= 1024 * 1000) {
      // gb/s
      return (kb / 1024 / 1024).toStringAsFixed(2);
    } else if (kb >= 1000) {
      // mb/s
      return (kb / 1024).toStringAsFixed(2);
    }
    return kb.toStringAsFixed(2);
  }

  String get _unit {
    var kb = rate / 1024;
    if (kb >= 1024 * 1000) {
      // gb/s
      return 'GB/s';
    } else if (kb >= 1000) {
      // mb/s
      return 'MB/s';
    }
    return 'KB/s';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _downRate,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 50.sp,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 4.sp),
              child: Text(
                _unit,
                style: const TextStyle(
                    height: 2.2,
                    color: Color(0xFF87868E),
                    fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
        Row(
          children: const [
            Text(
              '下行速度',
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ],
    );
  }
}

// 展示上行速度
class UploadSpeed extends StatelessWidget {
  const UploadSpeed({
    Key? key,
    this.rate = 0,
  }) : super(key: key);
  final double rate;
  String get _upRate {
    var kb = rate / 1024;
    if (kb >= 1024 * 1000) {
      // gb/s
      return (kb / 1024 / 1024).toStringAsFixed(2);
    } else if (kb >= 1000) {
      // mb/s
      return (kb / 1024).toStringAsFixed(2);
    }
    return kb.toStringAsFixed(2);
  }

  String get _unit {
    var kb = rate / 1024;
    if (kb >= 1024 * 1000) {
      // gb/s
      return 'GB/s';
    } else if (kb >= 1000) {
      // mb/s
      return 'MB/s';
    }
    return 'KB/s';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _upRate,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 50.sp,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 4.0.sp),
              child: Text(
                _unit,
                style: const TextStyle(
                    height: 2.2,
                    color: Color(0xFF87868E),
                    fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
        Row(
          children: const [
            Text(
              '上行速度',
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ],
    );
  }
}
