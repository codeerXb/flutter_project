import 'dart:convert';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/request/request.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/ashed_line.dart';
import 'package:flutter_template/pages/login/login_controller.dart';
import 'package:flutter_template/pages/net_status/model/net_connect_status.dart';
import 'package:flutter_template/pages/toolbar/toolbar_controller.dart';
import 'package:flutter_template/pages/topo/model/equipment_datas.dart';
import 'package:flutter_template/pages/topo/topo_item.dart';
import 'package:get/get.dart';

import '../../generated/l10n.dart';

//网络拓扑
class Topo extends StatefulWidget {
  const Topo({Key? key}) : super(key: key);

  @override
  State<Topo> createState() => _TopoState();
}

class _TopoState extends State<Topo> {
  EquipmentDatas topoData = EquipmentDatas(onlineDeviceTable: [], max: null);
  final LoginController loginController = Get.put(LoginController());
  String sn = '';
  Map<String, dynamic> onlineCount = {};
  List<String> deviceNames = [];
  // Map<String, dynamic> deviceList = {};
  @override
  void initState() {
    super.initState();
    sharedGetData('deviceSn', String).then(((res) {
      printInfo(info: 'deviceSn$res');
      setState(() {
        sn = res.toString();
        //状态为local 请求本地  状态为cloud  请求云端
        printInfo(info: 'state--${loginController.login.state}');
        if (loginController.login.state == 'cloud' && sn.isNotEmpty) {
          if (mounted) {
            getTRTopoData(false);
          }
        }
        if (loginController.login.state == 'local') {
          if (mounted) {
            // 获取设备列表并更新在线数量
            getTopoData(false);
            //获取网络链接状态
            updateStatus();
          }
        }
      });
    }));
  }

  final ToolbarController toolbarController = Get.put(ToolbarController());
  final PageController _pageController = PageController();
  // 有线连接状况：1:连通0：未连接
  String _wanStatus = '0';
  // wifi连接状况：1:连通0：未连接 本地
  String _wifiStatus = '0';
  // wifi连接状况：true:连通false：未连接 云端
  // 4G
  bool _wifiStatus4 = false;
  // 5G
  bool _wifiStatus5 = false;

  // sim卡连接状况：1:连通0：未连接
  String _simStatus = '0';

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
      setState(() {
        _wanStatus = wanStatus;
        _wifiStatus = wifiStatus;
        _simStatus = simStatus;
      });
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  //  获取在线设备  云端
  getTRTopoData(sx) async {
    printInfo(info: 'sn在这里有值吗-------$sn');
    var parameterNames = [
      "InternetGatewayDevice.WEB_GUI.Overview.DeviceList",
      "InternetGatewayDevice.WEB_GUI.Network.NR-LTE.ConnectStatus",
      "InternetGatewayDevice.WEB_GUI.Overview.WiFiStatus"
    ];
    var res = await Request().getACSNode(parameterNames, sn);
    if (sx) {
      ToastUtils.toast(S.current.success);
    }
    try {
      var jsonObj = jsonDecode(res);
      if (!mounted) return;
      setState(() {
        // 获取网络链接状态
        _simStatus = jsonObj["data"]["InternetGatewayDevice"]["WEB_GUI"]
            ["Network"]["NR-LTE"]["ConnectStatus"]["_value"];
        var wiFiStatus = jsonObj["data"]["InternetGatewayDevice"]["WEB_GUI"]
            ["Overview"]["WiFiStatus"];
        _wifiStatus4 = wiFiStatus["1"]["Enable"]["_value"];
        _wifiStatus5 = wiFiStatus["2"]["Enable"]["_value"];
        // Topo 列表
        onlineCount = jsonObj["data"]["InternetGatewayDevice"]["WEB_GUI"]
            ["Overview"]["DeviceList"]!;
        List<OnlineDeviceTable>? onlineDeviceTable = [];
        int id = 0;
        onlineCount.forEach((key, value) {
          if (value is Map<String, dynamic>) {
            OnlineDeviceTable device = OnlineDeviceTable.fromJson({
              'id': id,
              'LeaseTime': int.parse(value['LeaseTime']['_value']),
              'IP': value['IPAddress']['_value'],
              'MAC': value['MACAddress']['_value'],
              'hostName': value['DeviceName']['_value'],
              'Type': value['Type']['_value'],
            });
            onlineDeviceTable.add(device);
            id++;
          }
        });
        topoData =
            EquipmentDatas(onlineDeviceTable: onlineDeviceTable, max: 255);

        printInfo(info: "topoData$topoData");
      });
    } catch (e) {
      debugPrint('获取信息失败：${e.toString()}');
    }
  }

  // 获取在线设备 本地
  void getTopoData(sx) {
    Map<String, dynamic> data = {
      'method': 'tab_dump',
      'param': '["OnlineDeviceTable"]',
    };
    XHttp.get('/data.html', data).then((res) {
      if (sx) {
        ToastUtils.toast(S.current.success);
      }
      try {
        debugPrint("\n================== 获取在线设备 ==========================");
        var d = json.decode(res.toString());
        printInfo(info: 'd$d');
        setState(() {
          topoData = EquipmentDatas.fromJson(d);
        });
      } on FormatException catch (e) {
        setState(() {
          topoData = EquipmentDatas(onlineDeviceTable: [], max: null);
        });
        print('The provided string is not valid JSON');
        print(e);
      }
    }).catchError((onError) {
      // ToastUtils.toast('获取在线设备失败');
      debugPrint('获取在线设备失败：${onError.toString()}');
    });
  }

  @override
  Widget build(BuildContext context) {
    bool MESH = true;
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
              backgroundColor: Colors.transparent, //设置为白色字体
              centerTitle: true,
              // title: const Text(
              //   '网络拓扑',
              //   style: TextStyle(color: Colors.black),
              // ),
              systemOverlayStyle: const SystemUiOverlayStyle(
                //设置状态栏的背景颜色
                statusBarColor: Colors.transparent,
                //状态栏的文字的颜色
                statusBarIconBrightness: Brightness.dark,
              ),

              elevation: 0,
              leading: IconButton(
                  onPressed: () {
                    //刷新
                    if (mounted) {
                      if (loginController.login.state == 'cloud' &&
                          sn.isNotEmpty) {
                        getTRTopoData(true);
                      } else if (loginController.login.state == 'local') {
                        getTopoData(true);
                      }
                    }
                  },
                  icon: const Icon(
                    Icons.refresh,
                    color: Colors.black,
                  )),
              // systemOverlayStyle: SystemUiOverlayStyle.light,
              // actions: [
              //   IconButton(
              //       onPressed: () {
              //         // 占位
              //       },
              //       icon: const Icon(Icons.settings))
              // ],
            ),
            backgroundColor: Colors.transparent,
            body: ListView(
              padding: const EdgeInsets.only(top: 20, left: 5, right: 5),
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 100.w,
                      width: 100.w,
                      child: ClipOval(
                          child: Image.asset("assets/images/Internet.png",
                              fit: BoxFit.cover)),
                    ),
                    Stack(children: [
                      SizedBox(
                        height: 80.w,
                        width: 1.sw,
                      ),
                      Center(
                        child: Container(
                            height: 16.w,
                            width: 16.w,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2F5AF5),
                              borderRadius: BorderRadius.circular(8.w),
                            )),
                      ),
                      Center(
                          child: Container(
                              height: 54.w,
                              width: 10.w,
                              margin: EdgeInsets.only(top: 16.w),
                              child: XFDashedLine(
                                axis: Axis.vertical,
                                count: 10,
                                dashedWidth: 2.w,
                                dashedHeight: 2.w,
                                color: const Color(0xFF2F5AF5),
                              ))),
                      if (_wanStatus == '0' &&
                              _simStatus == 'disconnected' &&
                              loginController.login.state == 'cloud' ||
                          _wanStatus == '0' &&
                              _simStatus == '0' &&
                              loginController.login.state == 'local')
                        Center(
                            child: Padding(
                          padding: EdgeInsets.only(top: 25.w),
                          child: Icon(
                            Icons.close,
                            color: const Color.fromARGB(255, 206, 47, 47),
                            size: 32.w,
                          ),
                        )),
                    ])
                  ],
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: (() {
                        Get.toNamed("/odu");
                      }),
                      child: Stack(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            clipBehavior: Clip.hardEdge,
                            height: 196.w,
                            width: 196.w,
                            margin: const EdgeInsets.all(5),
                            child: Image.asset('assets/images/odu.png',
                                fit: BoxFit.cover),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'ODU',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.sp,
                      ),
                    ),
                    Stack(children: [
                      SizedBox(
                        height: 80.w,
                        width: 1.sw,
                      ),
                      Center(
                        child: Container(
                            height: 16.w,
                            width: 16.w,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2F5AF5),
                              borderRadius: BorderRadius.circular(8.w),
                            )),
                      ),
                      Center(
                          child: Container(
                              height: 54.w,
                              width: 10.w,
                              margin: EdgeInsets.only(top: 16.w),
                              child: XFDashedLine(
                                axis: Axis.vertical,
                                count: 10,
                                dashedWidth: 2.w,
                                dashedHeight: 2.w,
                                color: const Color(0xFF2F5AF5),
                              ))),
                    ])
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    toolbarController.setPageIndex(2);
                  },
                  child: Center(
                    child: Container(
                      height: 108.w,
                      width: 144.w,
                      margin: const EdgeInsets.all(5),
                      child: Image.asset('assets/images/router.png',
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
                SizedBox(
                  child: Center(
                    child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        height: 96.w,
                        width: MediaQuery.of(context).size.width - 74,
                        child: Column(
                          children: [
                            Center(
                              child: Stack(
                                  // clipBehavior: Clip.antiAlias,
                                  children: [
                                    SizedBox(
                                      height: 96.w,
                                    ),
                                    Center(
                                      child: Container(
                                          height: 16.w,
                                          width: 16.w,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF2F5AF5),
                                            borderRadius:
                                                BorderRadius.circular(8.w),
                                          )),
                                    ),
                                    Center(
                                      child: Container(
                                          height: 40.w,
                                          width: 16.w,
                                          margin: EdgeInsets.only(top: 16.w),
                                          child: XFDashedLine(
                                            axis: Axis.vertical,
                                            count: 8,
                                            dashedWidth: 2.w,
                                            dashedHeight: 2.w,
                                            color: const Color(0xFF2F5AF5),
                                          )),
                                    ),
                                    Positioned(
                                      top: 56.w,
                                      left: 12.w,
                                      child: DottedBorder(
                                        borderType: BorderType.RRect,
                                        radius: const Radius.circular(100),
                                        color: const Color(0xFF2F5AF5),
                                        dashPattern: const [2, 2],
                                        strokeWidth: 2,
                                        child: Container(
                                          height: 60.w,
                                          color: const Color.fromARGB(
                                              0, 255, 255, 255),
                                          width: 576.w,
                                          // color: Colors.black26,
                                        ),
                                      ),
                                    ),
                                    if (_wifiStatus4 == false &&
                                            _wifiStatus5 == false &&
                                            loginController.login.state ==
                                                'cloud' ||
                                        _wifiStatus == '0' &&
                                            loginController.login.state ==
                                                'local')
                                      Center(
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 15.w),
                                          child: Icon(
                                            Icons.close,
                                            color: const Color.fromARGB(
                                                255, 206, 47, 47),
                                            size: 32.w,
                                          ),
                                        ),
                                      ),
                                  ]),
                            ),
                          ],
                        )),
                  ),
                ),
                if (topoData.onlineDeviceTable!.isNotEmpty)
                  GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 4,
                    childAspectRatio: 1.0,
                    children: topoData.onlineDeviceTable!
                        .map(
                          (e) => TopoItem(
                            title: e.toString(),
                            isNative: false,
                            isShow: true,
                            topoData: e,
                          ),
                        )
                        .toList(),
                  ),
                if (!topoData.onlineDeviceTable!.isNotEmpty)
                  Center(
                    child: Container(
                        margin: EdgeInsets.only(top: 100.sp),
                        height: 200.w,
                        child: Text(S.of(context).NoDeviceConnected)),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
