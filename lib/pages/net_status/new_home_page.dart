import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/http/http_app.dart';
import 'package:flutter_template/core/request/request.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/common_widget.dart';
import 'package:flutter_template/core/widget/water_loading.dart';
import 'package:flutter_template/generated/l10n.dart';
import 'package:flutter_template/pages/login/login_controller.dart';
import 'package:flutter_template/pages/net_status/model/flow_statistics.dart';
import 'package:flutter_template/pages/net_status/model/net_connect_status.dart';
import 'package:flutter_template/pages/net_status/model/online_device.dart';
import 'package:flutter_template/pages/system_settings/model/maintain_data.dart';
import 'package:flutter_template/pages/toolbar/toolbar_controller.dart';
import 'package:flutter/cupertino.dart';
import '../../core/utils/string_util.dart';
import 'package:get/get.dart';
import '../../config/base_config.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import '../../pages/net_status/beans/speed_bean.dart';
import "../../core/utils/color_utils.dart";

String Id_Random = StringUtil.generateRandomString(10);

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MqttServerClient client = MqttServerClient.withPort(
      BaseConfig.mqttMainUrl, "client_$Id_Random", BaseConfig.websocketPort);
  // late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  // String _netType = "";
  // 订阅的主题
  var subTopic = "";
  // bool isLoad = false;
  // 点击空白  关闭键盘 时传的一个对象
  FocusNode blankNode = FocusNode();

  SpeedModel? speedmodel;

  bool inProduction = const bool.fromEnvironment("dart.vm.product");

  var reqUrl = "http://222.71.171.172:38083";
  /// 点击空白  关闭输入键盘
  void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(blankNode);
  }

  String? name = '';
  String mainUrl = "http://10.0.30.194:8000";

  String merchantName = "";

  String lanSpeedUrl = "";
  // 请求获取设备名
  Future<String?> getDeviceName() async {
    var res = await Request().getEquipmentData();
    printInfo(info: '设备名字：${res.systemProductModel}');
    if (mounted && res.systemProductModel != null) {
      setState(() {
        name = res.systemProductModel;
      });
    }
    return res.systemProductModel;
  }

  final ToolbarController toolbarController = Get.put(ToolbarController());
  final LoginController loginController = Get.put(LoginController());

  // 有线连接状况：1:连通0：未连接
  String _wanStatus = '0';
  // wifi连接状况：1:连通0：未连接
  String _wifiStatus = '0';
  // sim卡连接状况：1:连通0：未连接
  String _simStatus = '0';
  // 上行速率总数
  double _upRate = 0;
  //下行速率转换
  double upKb = 0;
  // 下行速率总数
  double _downRate = 0;
  // 下行速率转换
  double downKb = 0;
  // 实时在线设备数量
  int _onlineCount = 0;
  // 剩余流量百分比
  // double _progress = 0;

  // 已经使用的流量总数
  double _usedFlow = 0;
  // 已经使用的流量总数 整数部分
  int usedFlowInt = 0;
  // 已经使用的流量总数 小数部分
  String usedFlowDecimals = '0KB';

  // 下拉列表
  bool isShowList = false;
  String sn = '';
  String downUnit = 'Kbps';
  String upUnit = 'Kbps';

  String testUp = '0 Kbps';
  String testDown = '0 Kbps';
  String lantency = '0 ms';
  bool testLoading = false;
  String speedTime = "";

  String userAccount = "";

  bool isConnectedNet = true;
  Timer? soundTimer;

  String getPing(ping) {
    return '${ping}ms';
  }

  @override
  void initState() {
    
    // 设置网络变化监听
    // connectListener();
    // 获取网络连接状态
    // getConnectType();

    sharedGetData("user_phone", String).then((data) {
      debugPrint("当前获取的用户信息:${data.toString()}");
      if (StringUtil.isNotEmpty(data)) {
        userAccount = data as String;
        getqueryingBoundDevices();
      }
    });
  
    sharedGetData('deviceSn', String).then(((res) {
      printInfo(info: 'deviceSn$res');
      if (mounted) {
        if (inProduction) {
          requestDeviceStatus(res.toString());
        }else {
          debugPrint("debug模式不执行");
        }
        
        setState(() {
          sn = res.toString();
          //状态为local 请求本地  状态为cloud  请求云端
          printInfo(info: 'state--${loginController.login.state}');
          if (loginController.login.state == 'cloud' && sn.isNotEmpty) {
            getBasicInfo();
            // getTROnlineCount(sn);
            // obtainUserInformaition();
          }
          // getLastSpeed(sn);
          requestTestSpeedData(sn);
        });
      }
    }));

    super.initState();
  }

  void requestDeviceStatus(String sn) {
    soundTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        requestRouterStatus(sn);
    });
  }

  requestRouterStatus(String sn) {
    BaseOptions options = BaseOptions();
    ///请求header的配置
    options.headers["authorization"] = "Basic YWRtaW46YWRtaW4xMjM=";
    final dio = Dio(options);
    dio
        .get(
            '$reqUrl/api/v4/clients/cpe_$sn')
        .then((res) {
      debugPrint('请求的连接状态地址:$reqUrl/api/v4/clients/cpe_$sn');
      var d = json.decode(res.toString());
      debugPrint('requestRouterStatus响应------>$d');
      if (d['code'] == 0) {
        setState(() {
          if (d["data"] != null && d["data"].isNotEmpty) {
            isConnectedNet = d["data"][0]["connected"];
            debugPrint("当前是否连接对应的WiFi:$isConnectedNet");
          }else {
            isConnectedNet = false;
          }
        
      });
      } else {
        setState(() {
          isConnectedNet = false;
        });
        // ToastUtils.toast("Connection to server timed out");
      }
    }).catchError((err) {
      setState(() {
        isConnectedNet = false;
      });
      // ToastUtils.toast("Connection to server timed out");
    });
  }

/// 获取联网类型
  // void getConnectType() async {
  //   var connectResult = await (Connectivity().checkConnectivity());

  //   if (connectResult == ConnectivityResult.mobile) {
  //     _netType = "mobile";
  //   } else if (connectResult == ConnectivityResult.wifi) {
  //     _netType = "WIFi";
  //   } else if (connectResult == ConnectivityResult.none){
  //     _netType = "none";
  //   }else {
  //     _netType = "other";
  //   }
  //   setState(() { });
  // }

  /// 判断网络是否连接
  // Future<bool> isConnected() async {
  //   var connectResult = await (Connectivity().checkConnectivity());
  //   return connectResult != ConnectivityResult.none;
  // }

  /// 设置网络切换监听
  // connectListener() async {
  //   _connectivitySubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
  //     debugPrint("当前的网络是$result");
  //     if (result == ConnectivityResult.wifi || result == ConnectivityResult.mobile) {
        
  //     }else if (result == ConnectivityResult.none) {
  //     }else {}
  //   });
  //   setState(() { });
  // }

  void obtainUserInformaition() async {
    Dio resDio = Dio();
    String url = "$mainUrl/saas/device/instance/$sn/tenant/info";
    resDio.get(url).then((response) {
      Map<String, dynamic> data = response.data;
      if (data["status"] == 200) {
        debugPrint("获取的租户信息:$merchantName");
        setState(() {
          if (data["result"] != null) {
            merchantName = data["result"]["name"];
          }
        });
      }
    });
  }

  requestTestSpeedData(String sn) async {
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

    final sessionIdCha = StringUtil.generateRandomString(10);
    subTopic = "cpe/$sn";
    var pubTopicStr = "cpe/$sn-lanspeedtest";
    var channelParms = {
      "event": "mqtt2sodObj",
      "sn": sn,
      "sessionId": sessionIdCha,
      "pubTopic": pubTopicStr,
      "param": {
        "method": "get",
        "nodes": [
          "networkLanSettingIp",
        ]
      }
    };

    // final sessionIdConfig = StringUtil.generateRandomString(10);
    // var configTopicStr = "cpe/$sn-parentConfig";
    // var configParms = {
    //   "event": "getParentControlConfig",
    //   "sn": sn,
    //   "sessionId": sessionIdConfig,
    //   "pubTopic": configTopicStr
    // };
    // _publishMessage(subTopic, configParms);
    _publishMessage(subTopic, channelParms);
    client.subscribe(pubTopicStr, MqttQos.atLeastOnce);
    // client.subscribe(configTopicStr, MqttQos.atLeastOnce);
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      debugPrint("====================监听到新消息了======================");
      final MqttPublishMessage recMess = c![0].payload as MqttPublishMessage;
      final String topic = c[0].topic;
      final String pt = const Utf8Decoder().convert(recMess.payload.message);
      String desString = "topic is <$topic>, payload is <-- $pt -->";
      String result = pt.substring(0, pt.length - 1);
      debugPrint("string =$desString");
      if (topic == pubTopicStr) {
        Map datas = jsonDecode(result);
        setState(() {
          lanSpeedUrl = datas["data"]["networkLanSettingIp"];
          debugPrint("lanspeedUrl: =$lanSpeedUrl");
        });
      }
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

  // 发送消息
  void _publishMessage(String topic, Map<String, dynamic> message) {
    debugPrint("======发送获取App测速的消息成功了=======");
    debugPrint("===$topic ===$message=======");
    var builder = MqttClientPayloadBuilder();
    var jsonData = json.encode(message);
    builder.addUTF8String(jsonData);

    client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }

  Widget loadingIndicator() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CupertinoActivityIndicator(
            animating: true,
            radius: 20,
            color: Colors.grey,
          ),
          Text(
            "Speed measurement in progress",
            textAlign: TextAlign.center,
            softWrap: true,
            style: TextStyle(fontSize: 15, color: Colors.black),
          ),
        ],
      ),
    );
  }

  // void getLastSpeed(String sn) {
  //   App.get('/platform/cpeMqttSpeed/queryLatestOneSpeed', {'sn': sn})
  //       .then((res) {
  //     setState(() {
  //       speedTime = res['data']['createTime'];
  //       testUp = getRate(res['data']['upload']);
  //       testDown = getRate(res['data']['download']);
  //       lantency = getPing(res['data']['ping']);
  //     });
  //   }).catchError((err) {
  //     printError(info: err.toString());
  //   });
  // }

//1连接
  var connectStatus = '1';

  /// 获取云端基础信息
  Future<void> getBasicInfo() async {
    // var parameterNames = [
    //   "InternetGatewayDevice.WEB_GUI.Overview.VersionInfo.ProductModel",
    //   "InternetGatewayDevice.WEB_GUI.Ethernet.Status.ConnectStatus",
    // ];
    var parameterNames = {
      "method": "get",
      "nodes": ["systemProductModel", "lteMainStatusGet"]
    };
    try {
      var res = await Request().getACSNode(parameterNames, sn);
      var jsonObj = jsonDecode(res);
      if (mounted && jsonObj['data'] != null) {
        setState(() {
          connectStatus = jsonObj['data']['lteMainStatusGet'];
          name = jsonObj["data"]["systemProductModel"];
        });
      }
    } catch (e) {
      debugPrint('获取信息失败：${e.toString()}');
    }
  }
/*
  ///  获取云端轮询信息
  Future<void> getTROnlineCount(sn) async {
    // 已用流量
    try {
      var updownRes = await App.get('/cpeMqtt/getCurrentInfo/$sn');

      if (updownRes['code'] == 200 && mounted) {
        setState(() {
          // 上下行速率
          _upRate = double.parse(updownRes['data']['ULRateCurrent'].toString());
          _downRate =
              double.parse(updownRes['data']['DLRateCurrent'].toString());

          downKb = (_downRate * 8) / 1000;
          if (downKb >= 1000 * 1000) {
            // gb/s
            downKb = double.parse((downKb / 1000 / 1000).toStringAsFixed(2));
            downUnit = 'Gbps';
          } else if (downKb >= 1000) {
            // mb/s
            downKb = double.parse((downKb / 1000).toStringAsFixed(2));
            downUnit = 'Mbps';
          }
          downKb = double.parse(downKb.toStringAsFixed(2));
          downUnit = 'Kbps';
          printInfo(info: 'time:${DateTime.now()}--down:$downKb$downUnit');

          upKb = (_upRate * 8) / 1000;
          if (upKb >= 1000 * 1000) {
            // gb/s
            upKb = double.parse((upKb / 1000 / 1000).toStringAsFixed(2));
            upUnit = 'Gbps';
          } else if (upKb >= 1000) {
            // mb/s
            upKb = double.parse((upKb / 1000).toStringAsFixed(2));
            upUnit = 'Mbps';
          }
          upKb = double.parse(upKb.toStringAsFixed(2));
          upUnit = 'Kbps';
          // 列表数量
          _onlineCount =
              int.parse(updownRes['data']['WifiDeviceNum'].toString()) +
                  int.parse(updownRes['data']['LanDeviceNum'].toString());
        });
      }
    } catch (err) {
      printError(info: err.toString());
      if (err is TimeoutException) {
        ToastUtils.error(S.current.timeout);
      }
    }
  }
  */

  /// 获取设备列表并更新在线数量  本地
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

  /// 获取网络连接状态和上下行速率并更新  本地
  Future<void> updateStatus() async {
    Map<String, dynamic> netStatus = {
      'method': 'obj_get',
      'param':
          '["ethernetConnectionStatus","systemDataRateDlCurrent","systemDataRateUlCurrent","wifiHaveOrNot","wifi5gHaveOrNot","wifiEnable","wifi5gEnable","lteRoam"]'
    };
    try {
      var response = await XHttp.get('/data.html', netStatus);
      // 以 { 或者 [ 开头的
      RegExp exp = RegExp('^[{[]');
      if (!exp.hasMatch(response) && mounted) {
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
      if (mounted) {
        setState(() {
          _wanStatus = wanStatus;
          _wifiStatus = wifiStatus;
          _simStatus = simStatus;
          _upRate = upRate;
          _downRate = downRate;
          downKb = (_downRate * 8) / 1000;
          if (downKb >= 1000 * 1000) {
            // gb/s
            downKb = double.parse((downKb / 1000 / 1000).toStringAsFixed(2));
            downUnit = 'Gbps';
          } else if (downKb >= 1000) {
            // mb/s
            downKb = double.parse((downKb / 1000).toStringAsFixed(2));
            downUnit = 'Mbps';
          }
          downKb = double.parse(downKb.toStringAsFixed(2));
          downUnit = 'Kbps';

          upKb = (_upRate * 8) / 1000;
          if (upKb >= 1000 * 1000) {
            // gb/s
            upKb = double.parse((upKb / 1000 / 1000).toStringAsFixed(2));
            upUnit = 'Gbps';
          } else if (upKb >= 1000) {
            // mb/s
            upKb = double.parse((upKb / 1000).toStringAsFixed(2));
            upUnit = 'Mbps';
          }
          upKb = double.parse(upKb.toStringAsFixed(2));
          upUnit = 'Kbps';
        });
      }
      debugPrint('wanStatus=$wanStatus,wifi=$wifiStatus,sim=$simStatus');
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  /// 请求获取已用流量  本地
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
          // _progress = 0;
        });
        debugPrint('flowStatistics得到数据不是json');
      }
      var jsonObj = json.decode(obj);
      var flowTable = FlowStatistics.fromJson(jsonObj).flowTable;
      if (flowTable != null && mounted) {
        // 得到流量卡的总通过流量
        double usedFlowBytes = double.parse(flowTable[0].recvBytes!) +
            double.parse(flowTable[0].sendBytes!) +
            double.parse(flowTable[1].recvBytes!) +
            double.parse(flowTable[1].sendBytes!) +
            double.parse(flowTable[2].recvBytes!) +
            double.parse(flowTable[2].sendBytes!) +
            double.parse(flowTable[3].recvBytes!) +
            double.parse(flowTable[3].sendBytes!);
        setState(() {
          _usedFlow = usedFlowBytes / 1048576;

          /// 舍弃当前变量的小数部分，结果为 33。返回值为 int 类型。
          usedFlowInt = (_usedFlow >= 1024)
              ? (_usedFlow / 1024).truncate()
              : _usedFlow.truncate();

          /// 获取小数部分，通过.分割，返回值为String类型
          usedFlowDecimals = (_usedFlow >= 1024)
              ? '${(_usedFlow / 1024).toStringAsFixed(2).toString().split('.')[1].substring(0, 2)}GB'
              : '${_usedFlow.toStringAsFixed(2).toString().split('.')[1].substring(0, 1)}MB';
        });
      }
      return _usedFlow;
    } catch (e) {
      debugPrint('获取流量信息错误：${e.toString()}');
    }
    return _usedFlow;
  }

  // body loading
  bool loading = false;
  // home page loading
  bool loadingDevice = false;
  //设备下拉
  List optionsList = [];
  String currentDevice = '';
  List deviceList = [];

  // 重启
  MaintainData maintainVal = MaintainData();

  // 恢复
  MaintainData factoryReset = MaintainData();
  //  查询绑定设备 App
  void getqueryingBoundDevices() {
    if (mounted) {
      setState(() {
        loadingDevice = true;
      });
      App.get('/platform/appCustomer/queryCustomerCpe?account=$userAccount')
          .then((res) {
        if (res == null || res.toString().isEmpty) {
          throw Exception('Response is empty.');
        }
        var d = json.decode(json.encode(res));
        printInfo(info: '查询的绑定设备$d');
        if (d['code'] != 200) {
          // 9999：用户令牌不能为空
          // 9998：平台登录标识不能为空
          // 9996：用户令牌过期或非法
          // 9997：平台登录标识非法
          if (d['code'] == 9999 ||
              d['code'] == 9998 ||
              d['code'] == 9997 ||
              d['code'] == 9996) {
            ToastUtils.error(S.of(context).tokenExpired);
            sharedDeleteData('user_token');
            Get.offAllNamed('/user_login');
          } else {
            ToastUtils.error(S.of(context).failed);
          }
          return;
        } else {
          setState(() {
            // [{id: 1, deviceSn: RS621A00211700113, type: SRS621-a},
            //{id: 2, deviceSn: 1245, type: SRS821-k}]
            deviceList = d['data'];
            var options = [];
            d['data'].forEach((item) {
              options.add(item['type'].toString());
            });
            optionsList = options;
          });
          // 读取当前
          sharedGetData('deviceSn', String).then(((res) {
            if (res != '') {
              setState(() {
                d['data'].forEach((item) {
                  if (item['deviceSn'] == res) {
                    currentDevice = item['type'];
                  }
                });
                if (currentDevice == '') {
                  Get.offNamed('/get_equipment');
                  sharedDeleteData('deviceSn');
                  ToastUtils.error('Current device unbind');
                }
              });
            } else {
              Get.offNamed('/get_equipment');
              sharedDeleteData('deviceSn');
              ToastUtils.error('Current device unbind');
            }
          }));
        }
      }).catchError((onError) {
        debugPrint(onError.toString());
      }).whenComplete(() {
        setState(() {
          loadingDevice = false;
        });
      });
    }
  }

  void loginout() {
    // 出了usertoken不清除其他都可以清除
    sharedDeleteData('user_phone');
    sharedDeleteData('deviceSn');
    Get.offAllNamed("/get_equipment");
  }

  // 重启 云端
  Future getReBootData() async {
    var parameterNames = {
      "method": "set",
      "nodes": {"systemReboot": "1"}
    };
    var res = await Request().setACSNode(parameterNames, sn);
    try {
      var jsonObj = jsonDecode(res);
      debugPrint('响应------>$jsonObj');
      if (jsonObj['code'] == 200) {
        ToastUtils.toast(S.current.success);
        loginout();
      } else {
        ToastUtils.toast(S.current.error);
      }
    } catch (e) {
      ToastUtils.error(S.current.contimeout);
    }
  }

  // 重启
  void getmaintaData() {
    Map<String, dynamic> data = {
      'method': 'obj_set',
      'param': '{"systemReboot":"1"}',
    };
    XHttp.get('/data.html', data).then((res) {
      try {
        var d = json.decode(res.toString());
        setState(() {
          maintainVal = MaintainData.fromJson(d);
          if (maintainVal.success == true) {
            ToastUtils.toast(S.current.success);
            loginout();
          } else {
            ToastUtils.toast(S.current.error);
          }
        });
      } on FormatException catch (error) {
        ToastUtils.toast(S.current.error);
      }
    }).catchError((onError) {
      debugPrint('失败：${onError.toString()}');
      ToastUtils.toast(S.current.error);
    });
  }

  // 恢复出厂 云端
  Future getFactoryResetData() async {
    var parameterNames = {
      "method": "set",
      "nodes": {"systemFactoryReset": "1", "systemReboot": "1"}
    };
    var res = await Request().setACSNode(parameterNames, sn);
    try {
      var jsonObj = jsonDecode(res);
      debugPrint('响应------>$jsonObj');
      if (jsonObj['code'] == 200) {
        ToastUtils.toast(S.current.success);
        loginout();
      } else {
        ToastUtils.toast(S.current.error);
      }
    } catch (e) {
      ToastUtils.error(S.current.contimeout);
    }
  }

  // 恢复出厂
  void getFactoryReset() {
    Map<String, dynamic> data = {
      'method': 'obj_set',
      'param': '{"systemFactoryReset":"1","systemRebootFlag":"1"}',
    };
    XHttp.get('/data.html', data).then((res) {
      try {
        var d = json.decode(res.toString());
        setState(() {
          factoryReset = MaintainData.fromJson(d);
          if (factoryReset.success == true) {
            ToastUtils.toast(S.current.success);
            loginout();
          } else {
            ToastUtils.toast(S.current.error);
          }
        });
      } on FormatException catch (e) {
        debugPrint(e.message);
        ToastUtils.toast(S.current.error);
      }
    }).catchError((onError) {
      debugPrint('失败：${onError.toString()}');
      ToastUtils.toast(S.current.error);
    });
  }

  Future<bool?> showWifiAlertDialog(BuildContext context) {
    bool isIPad = MediaQuery.of(context).size.shortestSide > 600;
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, state) {
          return AlertDialog(
            title: const Center(
              child: Text(""),
            ),
            content: Container(
              padding: const EdgeInsets.only(top: 10),
              width: isIPad ? MediaQuery.of(context).size.width - 300 : 260,
              height: 160,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // SizedBox(
                  //     width: isIPad
                  //         ? MediaQuery.of(context).size.width - 350
                  //         : 250,
                  //     height: 50,
                  //     child: ElevatedButton(
                  //       style: ButtonStyle(
                  //         backgroundColor: MaterialStateProperty.all<Color>(
                  //             const Color.fromRGBO(1, 113, 247, 1)),
                  //       ),
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           Image.asset(
                  //             "assets/images/WANSPEEDTEST.png",
                  //             width: 25,
                  //             height: 25,
                  //           ),
                  //           Text(
                  //             "WAN SPEEDTEST",
                  //             textAlign: TextAlign.center,
                  //             // softWrap: true,
                  //             style: TextStyle(
                  //               color: Colors.white,
                  //               fontSize: 36.sp,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //       onPressed: () {
                  //         Get.toNamed("/speedTestPage");
                  //       },
                  //     )),
                  SizedBox(
                      width: isIPad
                          ? MediaQuery.of(context).size.width - 350
                          : 250,
                      height: 50,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromRGBO(1, 113, 247, 1)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/speed_test_icon.png",//"assets/images/speed_test_icon.png",
                              width: 25,
                              height: 25,
                            ),
                            Text(
                              " SPEEDTEST",//" SPEEDTEST",
                              textAlign: TextAlign.center,
                              // softWrap: true,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 36.sp,
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          Get.toNamed("/lanSpeedTestPage",
                              arguments: {"lanspeedUrl": lanSpeedUrl});
                        },
                      )),
                  SizedBox(
                      width: isIPad
                          ? MediaQuery.of(context).size.width - 350
                          : 250,
                      height: 50,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromRGBO(1, 113, 247, 1)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/CHANNELSCAN.png",
                              width: 25,
                              height: 25,
                            ),
                            Text(
                              "CHANNEL SCAN",
                              textAlign: TextAlign.center,
                              // softWrap: true,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 36.sp,
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          // showWifiScanContent();
                          Navigator.of(context).pop();
                          Get.offAllNamed('/channelScan');
                        },
                      )),
                ],
              ),
            ),
            actions: <Widget>[
              Center(
                child: SizedBox(
                  width: 100,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                        side: const BorderSide(color: Colors.blue, width: 1.0),
                      ),
                    ),
                    child: Text(
                      "OK",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30.sp,
                      ),
                    ),
                    onPressed: () {
                      //关闭对话框并返回true
                      Navigator.of(context).pop(true);
                    },
                  ),
                ),
              )
            ],
          );
        });
      },
    );
  }

  // 弹出对话框
  Future<bool?> showSpeedDialog(BuildContext context) {
    bool isLoad = false;
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, state) {
          if (speedmodel != null) {
            debugPrint("测速执行");
            if (mounted) {
              state(() {
                isLoad = true;
                var timespeed = speedmodel!.data!.timestamp!.substring(0, 16);
                debugPrint("时间是:$timespeed");
                var year = timespeed.substring(0, 10);
                var hour = timespeed.substring(12, timespeed.length - 3);
                var minute = timespeed.substring(14, timespeed.length);
                var newHour = int.parse(hour) + 8;
                var timestr = "$year $newHour:$minute";
                debugPrint("时间是:$timestr");
                speedTime = timestr;
                testUp = StringUtil.getRate(speedmodel!.data!.upload!);
                testDown = StringUtil.getRate(speedmodel!.data!.download!);
                lantency = getPing(speedmodel!.data!.ping!);

                debugPrint("数据是:$testUp -- $testDown -- $lantency");
              });
            }
          }
          // Future.delayed(const Duration(milliseconds: 40000), () {

          // });

          return AlertDialog(
            title: const Center(
              child: Text(
                "Speed",
                style: TextStyle(fontSize: 18),
              ),
            ),
            content: isLoad
                ? Container(
                    padding: const EdgeInsets.only(top: 20),
                    width: 150,
                    height: 170,
                    child: Center(
                      child: dialogContent(),
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.only(top: 20),
                    width: 150,
                    height: 170,
                    child: Center(
                      child: loadingIndicator(),
                    ),
                  ),
            actions: <Widget>[
              // TextButton(
              //   child: const Text("Close",
              //       style: TextStyle(fontSize: 15, color: Colors.blue)),
              //   onPressed: () => Navigator.of(context).pop(), // 关闭对话框
              // ),
              TextButton(
                child: const Text("OK",
                    style: TextStyle(fontSize: 15, color: Colors.blue)),
                onPressed: () {
                  //关闭对话框并返回true
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });
      },
    );
  }

  // wifi scan
  Future<bool?> showWifiScanContent() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            padding: const EdgeInsets.only(top: 20),
            width: 150,
            height: 150,
            child: const Center(
              child: Text(
                "YOUR WIFI CHANNEL UPDATE TO THE BEST",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("OK",
                  style: TextStyle(fontSize: 15, color: Colors.blue)),
              onPressed: () {
                //关闭对话框并返回true
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  Widget dialogContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Recent speed test results",
          style: TextStyle(color: Colors.grey, fontSize: 15),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          speedTime,
          style: const TextStyle(color: Colors.blue, fontSize: 15),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          'Up⬆ $testUp',
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          'Down⬇ $testDown',
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          'Lantency $lantency',
          style: const TextStyle(fontSize: 14),
        )
      ],
    );
  }

  // test speed
  // void testSpeed() async {
  //   setState(() {
  //     testLoading = true;
  //   });
  //   try {
  //     Future.delayed(const Duration(milliseconds: 3000)).then((value) async {
  //       final speed = await App.get(
  //           '/platform/cpeMqttSpeed/queryLatestSpeed', {'sn': sn});
  //       debugPrint(
  //           '我的createTime${speed['data'].first['createTime']},${speed['data'].length.toString()}');
  //       setState(() {
  //         speedTime = speed['data'].first['createTime'];
  //         testUp = getRate(speed['data'].first['upload']);
  //         testDown = getRate(speed['data'].first['download']);
  //         lantency = getPing(speed['data'].first['ping']);
  //         testLoading = false;
  //       });
  //     });
  //   } catch (e) {
  //     printInfo(info: e.toString());
  //   }
  // }

  Widget setUpHeadView(BuildContext context) {
    bool isIPad = MediaQuery.of(context).size.shortestSide > 600;
    return Container(
      padding: const EdgeInsets.only(top: 20),
      height: 500,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Home Wi-Fi",
            style: TextStyle(
                fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Image.asset(isConnectedNet == true ? "assets/images/home_new.png" :
            "assets/images/home_disconnect.png",
            width: 260,
            height: 260,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(isConnectedNet == true ?
                "assets/images/zan_home.png" : "assets/images/homeWarn.png",
                width: 30,
                height: 30,
              ),
              const SizedBox(
                width: 5,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    "Your wifi network is",
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                  Text(isConnectedNet == true ?
                    "Securely Connected!" : "Disconnected",
                    style: TextStyle(
                        fontSize: 15, color: isConnectedNet == true ? const Color.fromRGBO(8, 180, 151, 1) : ColorUtils.hexToColor("#FBB063")),
                  ),
                ],
              ),
              const SizedBox(
                width: 5,
              ),
              Image.asset(isConnectedNet == true ? 
                "assets/images/icon_home.png" : "assets/images/homeSad.png",
                width: 30,
                height: 30,
              )
            ],
          ),
          SizedBox(
            height: isIPad ? 70 : 45,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    isConnectedNet == true ? const Color.fromARGB(255, 35, 197, 145) : ColorUtils.hexToColor("#FBB063")),
              ),
              child: Text( 
                "Check Network Performance",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36.sp,
                ),
              ),
              onPressed: () {
                showWifiAlertDialog(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget setUpBottomView(BuildContext context) {
    bool isIPad = MediaQuery.of(context).size.shortestSide > 600;
    return SizedBox(
      height: isIPad ? 400 : 200,
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all<Size>(
                                Size(140.w, 140.w)),
                            shape:
                                MaterialStateProperty.all(const CircleBorder()),
                            backgroundColor: const MaterialStatePropertyAll(
                                Color.fromRGBO(254, 138, 52, 1)),
                          ),
                          onPressed: () {
                            // 显示弹窗
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                      title: Text(S.current.hint),
                                      content: Text(S.of(context).isRestart),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text(S.current.cancel),
                                          onPressed: () {
                                            //取消
                                            Navigator.pop(context, 'Cancle');
                                          },
                                        ),
                                        TextButton(
                                            child: Text(S.current.confirm),
                                            onPressed: () {
                                              //确定
                                              Navigator.pop(context, "Ok");
                                              Navigator.push(
                                                  context,
                                                  DialogRouter(
                                                      LoadingDialog()));
                                              if (mounted) {
                                                if (loginController
                                                            .login.state ==
                                                        'cloud' &&
                                                    sn.isNotEmpty) {
                                                  getReBootData();
                                                }
                                                if (loginController
                                                        .login.state ==
                                                    'local') {
                                                  getmaintaData();
                                                }
                                              }
                                              Navigator.pop(context);
                                            })
                                      ]);
                                });
                          },
                          child: Image.asset(
                            "assets/images/factory_home.png",
                            width: 25,
                            height: 25,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Reboot',
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    )
                  ],
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all<Size>(
                                Size(140.w, 140.w)),
                            shape:
                                MaterialStateProperty.all(const CircleBorder()),
                            backgroundColor: const MaterialStatePropertyAll(
                                Color.fromRGBO(62, 158, 231, 1)),
                          ),
                          onPressed: () {
                            Get.toNamed('/connected_device');
                          },
                          child: Image.asset(
                            "assets/images/device_home.png",
                            width: 25,
                            height: 25,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(S.current.device,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.black))
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return loadingDevice
        ? const Center(
            child: SizedBox(width: 100, height: 100, child: WaterLoading()))
        : Scaffold(
            appBar: AppBar(
              elevation: 0,
              // 不自动添加返回键
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 0,
                  ),
                  Image.asset(
                    "assets/images/codium_logo.png",
                    width: 50,
                    height: 50,
                  )
                ],
              ),
              // title: InkWell(
              //   // overlayColor: const MaterialStatePropertyAll(Colors.transparent),
              //   // 下拉icon
              //   child: Ink(
              //     width: 1.sw,
              //     child: DropdownButton(
              //       style: TextStyle(
              //         color: Colors.black,
              //         fontSize: 36.sp,
              //       ),
              //       dropdownColor:
              //           const Color.fromARGB(221, 174, 167, 167), // 设置下拉框的背景颜色
              //       underline: Container(), //去除下划线
              //       value: currentDevice,
              //       // icon: Icon(
              //       //   FontAwesomeIcons.chevronDown,
              //       //   size: 30.w,
              //       //   color: Colors.white,
              //       // ),
              //       iconEnabledColor: Colors.white,
              //       items: optionsList.map((option) {
              //         // bool isSelected = option == currentDevice;
              //         return DropdownMenuItem(
              //           value: option,
              //           child: Row(
              //             children: [
              //               Text(option),
              //             ],
              //           ),
              //         );
              //       }).toList(),
              //       onChanged: (value) {
              //         setState(() {
              //           loading = true;
              //           currentDevice = value.toString();
              //           String? deviceSn;
              //           for (var item in deviceList) {
              //             if (item['type'] == value.toString()) {
              //               deviceSn = item['deviceSn'];
              //             }
              //           }
              //           // 为了更新新的设备
              //           Get.offNamed("/get_equipment");
              //           Get.offNamed("/home");
              //           loginController.setUserEquipment(
              //               'deviceSn', deviceSn.toString());
              //           sharedAddAndUpdate("deviceSn", String, deviceSn.toString());
              //           loginController.setState('cloud');
              //           ToastUtils.toast('Save success');
              //           loading = false;
              //         });
              //       },
              //       onTap: (() {
              //         // WidgetsBinding.instance.addPostFrameCallback((_) {
              //         //   setState(() {
              //         //     isShowList = !isShowList;
              //         //   });
              //         // });
              //       }),
              //     ),
              //   ),
              // ),

              backgroundColor: Colors.transparent,
            ),
            backgroundColor: Colors.white,
            body: loading
                ? const Center(
                    child: SizedBox(
                      height: 80,
                      width: 80,
                      child: WaterLoading(
                        color: Color.fromARGB(255, 65, 167, 251),
                      ),
                    ),
                  )
                : SafeArea(
                    child: GestureDetector(
                    onTap: () => closeKeyboard(context),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      decoration: const BoxDecoration(color: Color(0xFFF0F0F0)),
                      height: double.infinity,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            setUpHeadView(context),
                            //  设备操作
                            const SizedBox(
                              height: 40,
                            ),
                            setUpBottomView(context),
                          ],
                        ),
                      ),
                    ),
                  )),
          );
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint('状态页面销毁');
    soundTimer?.cancel();
    client.disconnect();
    // _connectivitySubscription.cancel();
  }
}

//card
class WhiteCard extends StatelessWidget {
  final Widget boxCotainer;
  final double height;
  const WhiteCard({super.key, required this.boxCotainer, this.height = 150});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height.w,
      padding: EdgeInsets.all(28.0.w),
      margin: EdgeInsets.only(top: 20.w, left: 30.w, right: 30.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.w),
      ),
      child: boxCotainer,
    );
  }
}
