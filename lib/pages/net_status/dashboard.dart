import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/pages/net_status/model/flow_statistics.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'arc_progress_bar.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final double _progress = 80;
  double _usedFlow = 0;
  // 舍弃当前变量的小数部分，结果为 33。返回值为 int 类型。
  int get usedFlowInt {
    return _usedFlow.truncate();
  }

  // 获取小数部分，通过.分割，返回值为String类型
  String get usedFlowDecimals {
    return _usedFlow.toString().split('.')[1].substring(0, 1);
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
        });
      }
      return _usedFlow;
    } catch (e) {
      debugPrint(e.toString());
    }
    return _usedFlow;
  }
  // 请求获取上下行速度

// 获取实时在线数量
  @override
  Widget build(BuildContext context) {
    debugPrint('flowValue=$_usedFlow');
    return FutureBuilder<Object>(
        future: getUsedFlow(),
        builder: (context, snapshot) {
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
                                '.$usedFlowDecimals MB',
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
                                  fontWeight: FontWeight.w800,
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
                        children: const [
                          UploadSpeed(),
                          DownloadSpeed(),
                          OnlineCount(),
                        ],
                      )),
                )
              ],
            ),
          );
        });
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
                fontWeight: FontWeight.w700,
                fontSize: 50.sp,
              ),
            ),
            const Text(
              '台',
              style: TextStyle(height: 2.2),
            ),
          ],
        ),
        Row(
          children: const [
            Text('实时在线'),
          ],
        ),
      ],
    );
  }
}

// 展示下行速度
class DownloadSpeed extends StatelessWidget {
  const DownloadSpeed({
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
              '1.0',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 50.sp,
              ),
            ),
            const Text(
              'KB/s',
              style: TextStyle(height: 2.2),
            ),
          ],
        ),
        Row(
          children: const [
            Text('下行速度'),
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
              '1.0',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 50.sp,
              ),
            ),
            const Text(
              'KB/s',
              style: TextStyle(height: 2.2),
            ),
          ],
        ),
        Row(
          children: const [
            Text('上行速度'),
          ],
        ),
      ],
    );
  }
}
