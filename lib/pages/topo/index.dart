import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:css_filter/css_filter.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/http/http_app.dart';
import 'package:flutter_template/core/request/request.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/ashed_line.dart';
import 'package:flutter_template/core/widget/water_loading.dart';
import 'package:flutter_template/pages/login/login_controller.dart';
import 'package:flutter_template/pages/net_status/model/net_connect_status.dart';
import 'package:flutter_template/pages/toolbar/toolbar_controller.dart';
import 'package:flutter_template/pages/topo/model/equipment_datas.dart';
import 'package:get/get.dart';
import '../../generated/l10n.dart';
import '../../core/utils/string_util.dart';
import 'package:flutter_template/core/utils/screen_adapter.dart';
import '../parent_control/Model/terminal_equipmentBean.dart';
import '../../config/base_config.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import '../../core/utils/logger.dart';
import '../../core/event_bus/eventbus_utils.dart';
import '../../core/event_bus/config_event.dart';

typedef void OnItemPressed(bool result);

String Id_Random = StringUtil.generateRandomString(10);

//网络拓扑
class Topo extends StatefulWidget {
  const Topo({Key? key}) : super(key: key);

  @override
  State<Topo> createState() => _TopoState();
}

class _TopoState extends State<Topo> with SingleTickerProviderStateMixin {
  MqttServerClient client = MqttServerClient.withPort(
      BaseConfig.mqttMainUrl, "client_$Id_Random", BaseConfig.websocketPort);
  EquipmentDatas topoData = EquipmentDatas(onlineDeviceTable: [], max: null);
  final LoginController loginController = Get.put(LoginController());
  String sn = '';
  var subTopic = "";
  Map<String, dynamic> onlineCount = {};
  List<String> deviceNames = [];
  late AnimationController _animationController;
  // 实时在线设备数量
  int _onlineCount = 0;
  List<EquipmentInfo> equipmentDatas = [];

  bool _isClick = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    sharedGetData('deviceSn', String).then(((res) {
      printInfo(info: 'deviceSn$res');
      setState(() {
        sn = res.toString();
        requesTerminalEquipment(sn);
        //状态为local 请求本地  状态为cloud  请求云端
        printInfo(info: 'state--${loginController.login.state}');
        if (mounted) {
          // requestOrder(sn);
          getDevices();
          Future.delayed(const Duration(seconds: 2), () {
            getTREquinfoDatas(sn);
          });
          requestParentCofingStatus(sn);
        }
      });
    }));

    eventBus.on<FlagEvent>().listen((event) {
      if (mounted) {
        setState(() {
          XLogger.getLogger().d("配置状态是:${event.flag}");
          _isClick = event.flag;
          if (_isClick) {
            Future.delayed(const Duration(seconds: 2), () {
              requestParentCofingStatus(sn);
            });
          }
        });
      }
    });
  }

  requestOrder(String sn) async {
    await Future.wait<void>([getTREquinfoDatas(sn), getDevices()])
        .then((value) {
      XLogger.getLogger().d("result --- $value");
    }).catchError((error) {
      XLogger.getLogger().e("result --- $error");
    });
  }

  void requesTerminalEquipment(String sn) {
    App.get('/platform/parentControlApp/queryDeviceInfoBySn?sn=$sn')
        .then((res) {
      final terminalModel = TerminalEquipmentBeans.fromJson(res);
      if (terminalModel.code == 200 && terminalModel.data != null) {
        equipmentDatas = terminalModel.data!;
        // debugPrint(
        //     "获取的终端设备列表:${equipmentDatas[0].mac} -- ${equipmentDatas[0].name}");
      } else {
        ToastUtils.toast(terminalModel.message!);
      }
    }).catchError((error) {
      ToastUtils.error(error.toString());
    });
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
    var parameterNames = {
      "method": "get",
      "nodes": ["lteMainStatusGet", "wifiEnable", "wifi5gEnable"]
    };
    // var parameterNames = [
    //   "InternetGatewayDevice.WEB_GUI.Overview.DeviceList",
    //   "InternetGatewayDevice.WEB_GUI.Network.NR-LTE.ConnectStatus",
    //   "InternetGatewayDevice.WEB_GUI.Overview.WiFiStatus"
    // ];
    var parameterNamesTable = {"method": "get", "table": "OnlineDeviceTable"};
    var res = await Request().getSODTable(parameterNamesTable, sn);
    var jsonObj = jsonDecode(res);

    var resNode = await Request().getACSNode(parameterNames, sn);
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
        _wanStatus = '1';
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
              'HostName': value['DeviceName']['_value'],
              'Type': value['Type']['_value'],
            });
            onlineDeviceTable.add(device);
            id++;
          }
        });
        debugPrint('onlineDeviceTable---$onlineDeviceTable----');
        topoData =
            EquipmentDatas(onlineDeviceTable: onlineDeviceTable, max: 255);
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
          print('本地设备列表${EquipmentDatas.fromJson(d)}');
        });
      } on FormatException catch (e) {
        setState(() {
          topoData = EquipmentDatas(onlineDeviceTable: [], max: null);
        });
        debugPrint(e.toString());
      }
    }).catchError((onError) {
      // ToastUtils.toast('获取在线设备失败');
      debugPrint('获取在线设备失败：${onError.toString()}');
    });
  }

  bool loading = true;

  //终端设备列表
  Future<void> getDevices() async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    // 开始旋转
    _animationController.repeat();
    try {
      Map<String, dynamic> form = {'sn': sn, "type": "getDevicesTable"};
      var res = await App.post('/cpeMqtt/getDevicesTable', data: form);

      var d = json.decode(res.toString());

      if (d['code'] == 200) {
        if (mounted) {
          setState(() {
            List<OnlineDeviceTable>? onlineDeviceTable = [];
            int id = 0;
            d['data']['wifiDevices'].addAll(d['data']['lanDevices']);
            if ((d['data']['wifiDevices'] as List).isNotEmpty) {
              d['data']['wifiDevices'].forEach((item) {
                OnlineDeviceTable device = OnlineDeviceTable.fromJson({
                  'id': id,
                  'LeaseTime': '1',
                  'Type': item['connection'] ?? 'LAN',
                  'HostName': item['name'],
                  'IP': item['IPAddress'],
                  'MAC': item['MACAddress'] ?? item['MacAddress']
                });
                onlineDeviceTable.add(device);
                id++;
              });
              _onlineCount = onlineDeviceTable.length;
              topoData = EquipmentDatas(
                  onlineDeviceTable: onlineDeviceTable, max: 255);
            }

            // ToastUtils.toast(S.current.success);
          });
        }
      }
    } catch (err) {
      debugPrint(err.toString());
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
        // 停止旋转
        _animationController.stop();
      }
    }
  }

//1连接
  var connectStatus = '';
// 云端
  Future<void> getTREquinfoDatas(String sn) async {
    var parameterNames = {
      "method": "get",
      "nodes": ["lteMainStatusGet"]
    };
    try {
      // var parameterNames = [
      //   "InternetGatewayDevice.WEB_GUI.Ethernet.Status.ConnectStatus",
      // ];
      var res = await Request().getACSNode(parameterNames, sn);
      Map<String, dynamic> d = jsonDecode(res);
      if (mounted && d['code'] == 200) {
        setState(() {
          // ConnectStatus = d['data']['InternetGatewayDevice']['WEB_GUI']
          //     ['Ethernet']['Status']['ConnectStatus']['_value'];
          connectStatus = d['data']['lteMainStatusGet'];
        });
      }
    } catch (e) {
      debugPrint('获取设备信息失败：${e.toString()}');
    }
  }

  void handleItemPressed(bool result) {
    // Do something with topoData...
    if (result == true && mounted) {
      getDevices();
    }
  }

  requestParentCofingStatus(String sn) async {
    client.logging(on: false);
    client.keepAlivePeriod = 60;
    client.useWebSocket = true;
    client.autoReconnect = true;
    client.onDisconnected = onDisconnected;
    client.onConnected = onConnected;
    client.onSubscribed = onSubscribed;
    client.pongCallback = pong;
    client.setProtocolV311();

    final connMess = MqttConnectMessage()
        .authenticateAs('admin', 'smawav')
        .withWillTopic('willtopic')
        .withWillMessage('My Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    debugPrint('Client connecting....');
    client.connectionMessage = connMess;

    try {
      await client.connect();
    } on NoConnectionException catch (e) {
      debugPrint('Client exception: $e');
      client.disconnect();
    } on SocketException catch (e) {
      debugPrint('Socket exception: $e');
      client.disconnect();
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      debugPrint('Client connected');
    } else {
      debugPrint(
          'Client connection failed - disconnecting, status is ${client.connectionStatus}');
      client.disconnect();
      // exit(-1);
    }

    client.published!.listen((MqttPublishMessage message) {
      debugPrint(
          'Published topic: topic is ${message.variableHeader!.topicName}, with Qos ${message.header!.qos}');
    });

    subTopic = "cpe/$sn";
    final sessionIdConfig = StringUtil.generateRandomString(10);
    var configTopicStr = "cpe/$sn-parentConfig";
    var configParms = {
      "event": "getParentControlConfig",
      "sn": sn,
      "sessionId": sessionIdConfig,
      "pubTopic": configTopicStr
    };
    _publishMessage(subTopic, configParms);
    client.subscribe(configTopicStr, MqttQos.atLeastOnce);
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      debugPrint("====================监听到新消息了======================");
      final MqttPublishMessage recMess = c![0].payload as MqttPublishMessage;
      final String topic = c[0].topic;
      final String pt = const Utf8Decoder().convert(recMess.payload.message);
      String desString = "topic is <$topic>, payload is <-- $pt -->";
      String result = pt.substring(0, pt.length - 1);
      debugPrint("string =$desString");
      Map datas = jsonDecode(result);
      var configEnable = datas["data"]["enable"];
      debugPrint("家长控制开关 =$configEnable");
      sharedAddAndUpdate("configEnable", String, configEnable);
    });
  }

  /// The subscribed callback
  void onSubscribed(String topic) {
    debugPrint('Subscription confirmed for topic $topic');
  }

  /// The unsolicited disconnect callback
  void onDisconnected() {
    debugPrint('OnDisconnected client callback - Client disconnection');
    if (client.connectionStatus!.disconnectionOrigin ==
        MqttDisconnectionOrigin.solicited) {
      debugPrint('OnDisconnected callback is solicited, this is correct');
    }
    // exit(-1);
  }

  /// The successful connect callback
  void onConnected() {
    debugPrint('OnConnected client callback - Client connection was sucessful');
  }

  /// Pong callback
  void pong() {
    debugPrint('Ping response client callback invoked');
  }

  void _publishMessage(String topic, Map<String, dynamic> message) {
    debugPrint("===发送$topic ===$message=======");
    var builder = MqttClientPayloadBuilder();
    var jsonData = json.encode(message);
    builder.addUTF8String(jsonData);

    client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
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
              leading: RotationTransition(
                turns:
                    Tween(begin: 0.0, end: 1.0).animate(_animationController),
                child: IconButton(
                    onPressed: () {
                      //刷新
                      if (mounted) {
                        getDevices();
                      }
                    },
                    icon: const Icon(
                      Icons.refresh,
                      color: Colors.black,
                    )),
              ),
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
                      // if (_wanStatus == '0' &&
                      //         _simStatus == 'disconnected' &&
                      //         loginController.login.state == 'cloud' ||
                      //     _wanStatus == '0' &&
                      //         _simStatus == '0' &&
                      //         loginController.login.state == 'local')
                      if (connectStatus == '0')
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
                //TODO:以下是暂时放开,后面打包再注释
                // Column(
                //   children: [
                //     GestureDetector(
                //       onTap: (() {
                //         Get.toNamed("/odu");
                //       }),
                //       child: Stack(
                //         children: [
                //           Container(
                //             decoration: const BoxDecoration(
                //               borderRadius:
                //                   BorderRadius.all(Radius.circular(10)),
                //             ),
                //             clipBehavior: Clip.hardEdge,
                //             height: 196.w,
                //             width: 196.w,
                //             margin: const EdgeInsets.all(5),
                //             child: Image.asset('assets/images/odu.png',
                //                 fit: BoxFit.cover),
                //           ),
                //         ],
                //       ),
                //     ),
                //     Text(
                //       'ODU',
                //       style: TextStyle(
                //         fontWeight: FontWeight.bold,
                //         fontSize: 24.sp,
                //       ),
                //     ),
                //     Stack(children: [
                //       SizedBox(
                //         height: 80.w,
                //         width: 1.sw,
                //       ),
                //       Center(
                //         child: Container(
                //             height: 16.w,
                //             width: 16.w,
                //             decoration: BoxDecoration(
                //               color: const Color(0xFF2F5AF5),
                //               borderRadius: BorderRadius.circular(8.w),
                //             )),
                //       ),
                //       Center(
                //           child: Container(
                //               height: 54.w,
                //               width: 10.w,
                //               margin: EdgeInsets.only(top: 16.w),
                //               child: XFDashedLine(
                //                 axis: Axis.vertical,
                //                 count: 10,
                //                 dashedWidth: 2.w,
                //                 dashedHeight: 2.w,
                //                 color: const Color(0xFF2F5AF5),
                //               ))),
                //     ])
                //   ],
                // ),
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
                                            child: const Text('')
                                            // Icon(
                                            //   Icons.close,
                                            //   color: const Color.fromARGB(
                                            //       255, 206, 47, 47),
                                            //   size: 32.w,
                                            // ),
                                            ),
                                      ),
                                  ]),
                            ),
                          ],
                        )),
                  ),
                ),
                loading
                    ? const Center(
                        child: SizedBox(
                          height: 80,
                          width: 80,
                          child: WaterLoading(
                            color: Color.fromARGB(255, 65, 167, 251),
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          if (topoData.onlineDeviceTable!.isNotEmpty)
                            GridView.count(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              crossAxisCount: 4,
                              childAspectRatio: 1.0,
                              children: topoData.onlineDeviceTable!
                                  .map(
                                    (e) => TopoItems(
                                      onItemPressed: handleItemPressed,
                                      title: (e.hostName.toString().isEmpty ||
                                              e.hostName.toString() == "*")
                                          ? "Unknown Device"
                                          : e.hostName.toString(),
                                      isNative: false,
                                      isShow: true,
                                      topoData: e,
                                    ),
                                  )
                                  .toList(),
                            ),
                          // NoDevice
                          if (!topoData.onlineDeviceTable!.isNotEmpty)
                            Center(
                              child: Container(
                                  margin: EdgeInsets.only(top: 50.sp),
                                  height: 100.w,
                                  child: Text(S.of(context).NoDeviceConnected)),
                            ),
                        ],
                      ),
                // if (!topoData.onlineDeviceTable!.isNotEmpty)
                // Center(
                //   child: Container(
                //       margin: EdgeInsets.only(top: 100.sp),
                //       height: 200.w,
                //       child: Text(S.of(context).NoDeviceConnected)),
                // ),
                //2*3网格
                Container(
                  margin: EdgeInsets.only(left: 30.w, right: 30.0.w, top: 20.w),
                  height: 480.w,
                  child: GridView(
                    physics: const NeverScrollableScrollPhysics(), //禁止滚动
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, //一行的Widget数量
                      childAspectRatio: 2, //宽高比为1
                      crossAxisSpacing: 16, //横轴方向子元素的间距
                    ),
                    children: <Widget>[
                      // 接入设备
                      // GestureDetector(
                      //   onTap: () {
                      //     Get.toNamed('/connected_device');
                      //   },
                      //   child: GardCard(
                      //       boxCotainer: Row(
                      //     mainAxisAlignment:
                      //         MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Icon(Icons.devices_other_rounded,
                      //           color: const Color.fromRGBO(
                      //               95, 141, 255, 1),
                      //           size: 60.sp),
                      //       Expanded(
                      //         child: Column(
                      //           mainAxisAlignment:
                      //               MainAxisAlignment.center,
                      //           children: [
                      //             Text(S.current.device),
                      //             Text(
                      //               '$_onlineCount ${S.current.line}',
                      //               style: TextStyle(
                      //                   color: Colors.black54,
                      //                   fontSize:
                      //                       ScreenAdapter.fontSize(25)),
                      //             ),
                      //           ],
                      //         ),
                      //       )
                      //     ],
                      //   )),
                      // ),
                      //儿童上网

                      GestureDetector(
                        onTap: () {
                          Get.toNamed('/parentList',
                              arguments: {"equipments": equipmentDatas});
                        },
                        child: GardCard(
                            boxCotainer: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.child_care,
                                color: const Color.fromRGBO(95, 141, 255, 1),
                                size: 60.sp),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                                flex: 2,
                                child: Text(
                                  S.of(context).parent,
                                  textAlign: TextAlign.left,
                                  softWrap: true,
                                  style: TextStyle(fontSize: 30.w),
                                  textScaler: TextScaler.noScaling,
                                ))
                          ],
                        )),
                      ),

                      // 访客网路
                      GestureDetector(
                        onTap: () {
                          Get.toNamed("/visitor_one");
                        },
                        child: GardCard(
                            boxCotainer: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              width: ScreenAdapter.width(80),
                              height: ScreenAdapter.height(80),
                              image: const AssetImage(
                                  'assets/images/visitor_net.png'),
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                                flex: 2,
                                child: Text(
                                  S.current.visitorNet,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: 30.w),
                                  textScaler: TextScaler.noScaling,
                                )),
                          ],
                        )),
                      ),

                      // Device Info
                      GestureDetector(
                        onTap: () {
                          Get.toNamed("/common_problem");
                        },
                        child: GardCard(
                            boxCotainer: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                                width: 60.w,
                                height: 60.w,
                                image: const AssetImage(
                                    'assets/images/equ_info.png'),
                                fit: BoxFit.cover),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                S.current.deviceInfo,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 30.w, color: Colors.black),
                                textScaler: TextScaler.noScaling,
                              ),
                            ),
                          ],
                        )),
                      ),
                      // DNS Setting
                      GestureDetector(
                        onTap: () {
                          Get.toNamed("/dns_settings");
                        },
                        child: GardCard(
                            boxCotainer: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                                width: 70.w,
                                height: 70.w,
                                image:
                                    const AssetImage('assets/images/DNS.png'),
                                fit: BoxFit.cover),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                                flex: 2,
                                child: Text(
                                  S.current.dnsSettings,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 30.w, color: Colors.black),
                                  textScaler: TextScaler.noScaling,
                                )),
                          ],
                        )),
                      ),
                      // LAN Setting
                      GestureDetector(
                        onTap: () {
                          Get.toNamed("/lan_settings");
                        },
                        child: GardCard(
                            boxCotainer: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                                width: 70.w,
                                height: 70.w,
                                image:
                                    const AssetImage('assets/images/lan.png'),
                                fit: BoxFit.cover),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                                flex: 2,
                                child: Text(
                                  S.current.lanSettings,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 30.w, color: Colors.black),
                                  textScaler: TextScaler.noScaling,
                                )),
                          ],
                        )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    client.disconnect();
    // eventBus.destroy();
    super.dispose();
  }
}

class TopoItems extends StatefulWidget {
  final String title;
  final bool isShow;
  final bool isNative;
  final OnlineDeviceTable? topoData;
  final OnItemPressed onItemPressed;

  const TopoItems(
      {Key? key,
      required this.title,
      required this.isShow,
      required this.isNative,
      required this.onItemPressed,
      this.topoData})
      : super(key: key);

  @override
  State<TopoItems> createState() => _TopoItemsState();
}

class _TopoItemsState extends State<TopoItems> {
  _TopoState topo = _TopoState();

  // int value = 0;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.topoData!.mac == 'B4:4C:3B:9E:46:3D') {
          Get.toNamed("/video_play");
        } else {
          Get.toNamed("/access_equipment",
              arguments: {"deviceItemModel": widget.topoData})?.then((value) {
            if (value) {
              widget.onItemPressed(value);
            }
          });
        }
      },
      child: Column(
        children: [
          Stack(
            children: [
              CSSFilter.apply(
                value: CSSFilterMatrix().opacity(!widget.isShow ? 0.3 : 1),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(25, 47, 90, 245),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  clipBehavior: Clip.hardEdge,
                  height: 120.w,
                  width: 120.w,
                  margin: const EdgeInsets.all(5),
                  child: Image.asset(
                    widget.topoData!.mac == 'B4:4C:3B:9E:46:3D'
                        ? 'assets/images/camera.png'
                        : 'assets/images/slices.png',
                    // fit: BoxFit.cover,
                    width: 70.w,
                    height: 80.w,
                  ),
                ),
              ),
              if (widget.isNative)
                Positioned(
                  right: 5,
                  top: 5,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 168, 168, 168),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10)),
                    ),
                    height: 16,
                    width: 30,
                    padding: const EdgeInsets.only(left: 2),
                    child: Text(
                      S.current.local,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 22.sp),
                    ),
                  ),
                ),
            ],
          ),
          Flexible(
            child: Text(
              widget.title,
              style: TextStyle(fontSize: 22.sp),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

//card
class GardCard extends StatelessWidget {
  final Widget boxCotainer;
  const GardCard({super.key, required this.boxCotainer});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.w,
      padding: EdgeInsets.all(28.0.w),
      margin: EdgeInsets.only(bottom: 20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.w),
      ),
      child: boxCotainer,
    );
  }
}
