import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/common_widget.dart';
import 'package:flutter_template/core/widget/custom_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter_template/pages/net_status/arc_progress_bar.dart';
import 'package:flutter_template/pages/net_status/model/net_connect_status.dart';
import 'package:flutter_template/pages/net_status/dashboard.dart';

import '../../core/http/http.dart';
import 'homepage_state_btn.dart';

/// 消息页面
class NetStatus extends StatefulWidget {
  const NetStatus(this.service, {Key? key}) : super(key: key);
  final String service;
  @override
  State<StatefulWidget> createState() => _NetStatusState();
}

class _NetStatusState extends State<NetStatus> {
  // 定义套餐类型
  int _comboType = 0;
  // 定义套餐总量
  double _totalComboData = 0;
  // 定义显示套餐状况
  String _comboLabel = '未设置';
  // 套餐周期
  List<String> comboCycleLabel = ['日', '月', '年'];
  // 有线连接状况：1:连通0：未连接
  String _wanStatus = '0';
  // wifi连接状况：1:连通0：未连接
  String _wifiStatus = '0';
  // sim卡连接状况：1:连通0：未连接
  String _simStatus = '0';
  // 上行速率
  double _upRate = 0;
  // 下行速率
  double _downRate = 0;

  String get vn => widget.service;

  /// 获取网络连接状态和上下行速率并更新
  void updateStatus() async {
    Map<String, dynamic> netStatus = {
      'method': 'obj_get',
      'param':
          '["ethernetConnectionStatus","systemDataRateDlCurrent","systemDataRateUlCurrent","wifiHaveOrNot","wifi5gHaveOrNot","wifiEnable","wifi5gEnable","lteRoam"]'
    };
    try {
      var response = await XHttp.get('/data.html', netStatus);
      // 以 { 或者 [ 开头的
      RegExp exp = RegExp('^[{[]');
      if (!exp.hasMatch(response)) {
        setState(() {
          _wanStatus = '0';
          _wifiStatus = '0';
          _simStatus = '0';
          _upRate = 0;
          _downRate = 0;
        });
        debugPrint('netStatus得到数据不是json');
      }
      var resObj = NetConnecStatus.fromJson(json.decode(response));
      String wanStatus = resObj.ethernetConnectionStatus == '1' ? '1' : '0';
      String wifiStatus =
          (resObj.wifiHaveOrNot == '1' || resObj.wifi5gHaveOrNot == '1')
              ? '1'
              : '0';
      String simStatus = resObj.lteRoam == '1' ? '1' : '0';
      double upRate = resObj.systemDataRateUlCurrent != null
          ? double.parse(resObj.systemDataRateUlCurrent!)
          : 0;
      double downRate = resObj.systemDataRateDlCurrent != null
          ? double.parse(resObj.systemDataRateDlCurrent!)
          : 0;
      setState(() {
        _wanStatus = wanStatus;
        _wifiStatus = wifiStatus;
        _simStatus = simStatus;
        _upRate = upRate;
        _downRate = downRate;
      });
      debugPrint('wanStatus=$wanStatus,wifi=$wifiStatus,sim=$simStatus');
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  Timer? timer;
  @override
  void initState() {
    super.initState();
    // 获取套餐总量
    sharedGetData('c_type', int).then((value) {
      if (value != null) {
        setState(() => _comboType = int.parse(value.toString()));
      }
    });
    sharedGetData('c_contain', double).then((value) {
      if (value != null) {
        setState(() => _totalComboData = double.parse(value.toString()));
      }
    });
    Future.wait([
      sharedGetData('c_type', int),
      sharedGetData('c_contain', double),
      sharedGetData('c_cycle', int),
    ]).then((results) => {
          if (results[0] != null && results[1] != null && results[2] != null)
            {
              setState(() {
                _comboLabel = results[0] == 0
                    ? '${results[1]}GB/${comboCycleLabel[results[2] as int]}'
                    : '${results[1]}h/${comboCycleLabel[results[2] as int]}';
              }),
            }
        });
    updateStatus();

    timer = Timer.periodic(const Duration(milliseconds: 2000), (t) async {
      updateStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    // 更新套餐总量
    Future.wait([
      sharedGetData('c_type', int),
      sharedGetData('c_contain', double),
      sharedGetData('c_cycle', int),
    ]).then((results) => {
          if (results[0] != null &&
              results[1] != null &&
              results[2] != null &&
              (results[0].toString() != _comboType.toString() ||
                  results[1].toString() != _totalComboData.toString()))
            {
              setState(() {
                _comboType = int.parse(results[0].toString());
                _totalComboData = double.parse(results[1].toString());
                _comboLabel = results[0] == 0
                    ? '${results[1]}GB/${comboCycleLabel[results[2] as int]}'
                    : '${results[1]}h/${comboCycleLabel[results[2] as int]}';
              }),
              debugPrint(
                  'index得到的结果${results.toString()}${results[1].toString() == _totalComboData.toString()}')
            }
        });
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              alignment: Alignment.topCenter,
              image: AssetImage('assets/images/picture_home_bg.png'),
              fit: BoxFit.fitWidth)),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Row(
            children: [Text(vn), const FaIcon(FontAwesomeIcons.chevronDown)],
          ),
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body: Column(
          children: <Widget>[
            // 头部widget
            Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(
                  left: 30.sp, right: 26.sp, top: 0, bottom: 30.sp),
              width: 1.sw,
              height: 240.h,
              color: Colors.transparent,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Container(
                        height: 40.h,
                        padding: EdgeInsets.only(
                            left: 16.sp, right: 16.sp, top: 0, bottom: 0),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.sp)),
                            border: Border.all(width: 1, color: Colors.white)),
                        child: Text(
                          '套餐总量：$_comboLabel',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            HomePageStateBtn(
                              imageUrl: 'assets/images/icon_homepage_wan.png',
                              offImageUrl:
                                  'assets/images/icon_homepage_no_wan.png',
                              routeName: '/wan_settings',
                              status: _wanStatus,
                            ),
                            HomePageStateBtn(
                              imageUrl: 'assets/images/icon_homepage_wifi.png',
                              offImageUrl:
                                  'assets/images/icon_homepage_no_wifi.png',
                              routeName: '/wlan_set',
                              status: _wifiStatus,
                            ),
                            HomePageStateBtn(
                              imageUrl: 'assets/images/icon_homepage_sim.png',
                              offImageUrl:
                                  'assets/images/icon_homepage_no_sim.png',
                              status: _simStatus,
                              routeName: '/radio_settings',
                            ),
                          ],
                        ),
                        TextButton(
                            onPressed: () => {
                                  // Navigator.pushNamed(
                                  //     context, '/net_server_settings')
                                  Get.toNamed('/net_server_settings')
                                },
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '套餐设置',
                                    style: TextStyle(
                                        height: 1,
                                        fontSize: 28.sp,
                                        color: Colors.white),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 8.sp),
                                    child: FaIcon(
                                      FontAwesomeIcons.chevronRight,
                                      size: 34.sp,
                                      color: Colors.white,
                                    ),
                                  )
                                ]))
                      ],
                    )
                  ]),
            ),
            // 仪表盘和数值显示
            Expanded(
                flex: 1,
                child: Dashboard(
                  comboType: _comboType,
                  totalComboData: _totalComboData,
                  upRate: _upRate,
                  downRate: _downRate,
                )),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint('状态页面销毁');
    timer?.cancel();
    timer = null;
  }
}
