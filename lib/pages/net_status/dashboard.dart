import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/pages/net_status/model/flow_statistics.dart';
import 'package:flutter_template/pages/net_status/model/net_connect_status.dart';
import 'package:flutter_template/pages/net_status/model/online_device.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'arc_progress_bar.dart';

class Dashboard extends StatefulWidget {
  const Dashboard(
      {Key? key,
      this.comboType = 0,
      this.totalComboData = 0,
      required this.downRate,
      required this.upRate})
      : super(key: key);
  // 定义套餐类型
  final int comboType;
  // 定义套餐总量
  final double totalComboData;
  // 上行速率
  final double upRate;
  // 下行速率
  final double downRate;

  @override
  State<StatefulWidget> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Timer? timer;

  // 剩余流量百分比
  double _progress = 0;

  // 已经使用的流量
  double _usedFlow = 0;

  // 已经使用的时长
  double _usedTime = 0;

  // 展示的百分比值
  double get _progressLabel {
    if (widget.comboType == 0) {
      // 接口未请求，也没有设置套餐总量
      if (widget.totalComboData == 0 && _usedFlow == 0) return 0;
      // 接口未请求，但设置了套餐总量
      if (widget.totalComboData != 0 && _usedFlow == 0) return 100;
    } else {
      // 接口未请求，也没有设置套餐总量
      if (widget.totalComboData == 0 && _usedTime == 0) return 0;
      // 接口未请求，但设置了套餐总量
      if (widget.totalComboData != 0 && _usedTime == 0) return 100;
    }
    // 其他情况按照接口请求的数据来更新
    return _progress;
  }

  // 实时在线设备数量
  int _onlineCount = 0;

  /// 舍弃当前变量的小数部分，结果为 33。返回值为 int 类型。
  int get usedFlowInt {
    if (widget.comboType == 0) {
      return (_usedFlow >= 1024)
          ? (_usedFlow / 1024).truncate()
          : _usedFlow.truncate();
    } else {
      // 已使用时间
      return _usedTime.truncate();
    }
  }

  /// 获取小数部分，通过.分割，返回值为String类型
  String get usedFlowDecimals {
    if (widget.comboType == 0) {
      return (_usedFlow >= 1024)
          ? '${(_usedFlow / 1024).toStringAsFixed(2).toString().split('.')[1].substring(0, 2)}GB'
          : '${_usedFlow.toStringAsFixed(2).toString().split('.')[1].substring(0, 1)}MB';
    } else {
      // 已使用时间小数
      return '${_usedTime.toStringAsFixed(1).split('.')[1]}h';
    }
  }

  /// 请求获取已用流量
  Future<double> getUsedFlow() async {
    Map<String, dynamic> flowStatistics = {
      'method': 'tab_dump',
      'param': '["FlowTable"]',
    };
    try {
      var obj = await XHttp.get('/data.html', flowStatistics);
      // 以 { 或者 [ 开头的
      RegExp exp = RegExp('^[{[]');
      if (!exp.hasMatch(obj) && mounted) {
        setState(() {
          _usedFlow = 0;
          _progress = 0;
        });
        debugPrint('flowStatistics得到数据不是json');
      }
      var jsonObj = json.decode(obj);
      var flowTable = FlowStatistics.fromJson(jsonObj).flowTable?[4];
      if (flowTable != null && mounted) {
        var usedFlowBytes = double.parse(flowTable.recvBytes!) +
            double.parse(flowTable.sendBytes!);
        setState(() {
          _usedFlow = usedFlowBytes / 1048576;
          _progress = (1 -
                  (usedFlowBytes /
                      (widget.totalComboData * 1024 * 1024 * 1024))) *
              100;
        });
      }
      return _usedFlow;
    } catch (e) {
      debugPrint('获取流量信息错误：${e.toString()}');
    }
    return _usedFlow;
  }

// 请求获取在线时长并更新_usedTime
  void updateOnlineTime() async {
    try {
      Map<String, dynamic> queryOnlineTime = {
        'method': 'obj_get',
        'param': '["systemOnlineTime"]'
      };
      var res = await XHttp.get('/data.html', queryOnlineTime);
      var time = json.decode(res)['systemOnlineTime'];
      debugPrint('获取的时长${double.parse(time) / 3600}');
      if (mounted) {
        setState(() {
          _usedTime = (double.parse(time) / 3600);
          _progress = (1 - (_usedTime / widget.totalComboData)) * 100;
        });
      }
    } catch (err) {
      debugPrint('获取在线时长错误$err');
    }
  }

  /// 获取设备列表并更新在线数量
  void updateOnlineCount() async {
    try {
      Map<String, dynamic> queryOnlineDevice = {
        'method': 'tab_dump',
        'param': '["OnlineDeviceTable"]'
      };
      var res = await XHttp.get('/data.html', queryOnlineDevice);
      // 以 { 或者 [ 开头的
      RegExp exp = RegExp('^[{[]');
      if (!exp.hasMatch(res) && mounted) {
        setState(() {
          _onlineCount = 0;
        });
        debugPrint('queryOnlineDevice得到数据不是json');
      }
      var onlineDevice =
          OnlineDevice.fromJson(jsonDecode(res)).onlineDeviceTable;
      if (onlineDevice != null && mounted) {
        setState(() {
          _onlineCount = onlineDevice.length;
        });
      }
      debugPrint('在线设备数量：${onlineDevice?.length}');
    } catch (e) {
      debugPrint("获取设备列表错误：${e.toString()}");
    }
  }

  /// 初始化状态
  @override
  void initState() {
    super.initState();
    debugPrint('初始化dashboard');
    widget.comboType == 0 ? getUsedFlow() : updateOnlineTime();
    updateOnlineCount();
    timer = Timer.periodic(const Duration(milliseconds: 2000), (t) async {
      if (mounted) {
        widget.comboType == 0 ? getUsedFlow() : updateOnlineTime();
        updateOnlineCount();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('flowValue=$_usedFlow');
    debugPrint('total=${widget.totalComboData},progress=$_progressLabel');
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
                    width: 1.sw, height: 1.sw, progress: _progressLabel),
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
                        child: Image(
                            image: AssetImage(widget.comboType == 0
                                ? 'assets/images/icon_homepage_flow.png'
                                : 'assets/images/icon_homepage_time.png')),
                      ),
                      Text(
                        widget.comboType == 0 ? '已用流量' : '已用时长',
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
                    OnlineCount(
                      count: _onlineCount,
                    ),
                  ],
                )),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint('销毁');
    timer?.cancel();
    timer = null;
  }
}

// 展示实时在线数量
class OnlineCount extends StatelessWidget {
  const OnlineCount({
    Key? key,
    this.count = 0,
  }) : super(key: key);
  final int count;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '$count',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 50.sp,
                height: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 4.sp),
              child: const Text(
                '台',
                style: TextStyle(
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
    var kb = (rate * 8) / 1000;
    if (kb >= 1000 * 1000) {
      // gb/s
      return (kb / 1000 / 1000).toStringAsFixed(2);
    } else if (kb >= 1000) {
      // mb/s
      return (kb / 1000).toStringAsFixed(2);
    }
    return kb.toStringAsFixed(2);
  }

  String get _unit {
    var kb = rate / 1000;
    if (kb >= 1000 * 1000) {
      // gb/s
      return 'Gbit/s';
    } else if (kb >= 1000) {
      // mb/s
      return 'Mbit/s';
    }
    return 'Kbit/s';
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
    var kb = (rate * 8) / 1000;
    if (kb >= 1000 * 1000) {
      // gb/s
      return (kb / 1000 / 1000).toStringAsFixed(2);
    } else if (kb >= 1000) {
      // mb/s
      return (kb / 1000).toStringAsFixed(2);
    }
    return kb.toStringAsFixed(2);
  }

  String get _unit {
    var kb = (rate * 8) / 1000;
    if (kb >= 1000 * 1000) {
      // gb/s
      return 'Gbit/s';
    } else if (kb >= 1000) {
      // mb/s
      return 'Mbit/s';
    }
    return 'Kbit/s';
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
