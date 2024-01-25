import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../core/utils/channel_progress.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/base_config.dart';
import '../../core/mqtt/mqtt_service.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'dart:convert';
import 'package:flutter_template/core/request/request.dart';
import 'package:flutter_template/core/http/http_app.dart';
import './beans/scan_quality_bean.dart';
import '../../pages/wifi_set/wlan/wlanBeans.dart';
import '../../pages/wifi_set/wlan/wlan5gBeans.dart';
import '../.././core/utils/string_util.dart';

class ChannelScanPage extends StatefulWidget {
  const ChannelScanPage({super.key});

  @override
  State<ChannelScanPage> createState() => _ChannelScanPageState();
}

class _ChannelScanPageState extends State<ChannelScanPage>
    with TickerProviderStateMixin {
  MqttClient client = MqttServerClient(BaseConfig.mqttMainUrl, "flutter_client",
      maxConnectionAttempts: 10);
      MqttClient clientChannel = MqttServerClient(BaseConfig.mqttMainUrl, "flutter_client",
      maxConnectionAttempts: 10);
      var getCurrentChannelTopic = "platform_server/apiv1/sma_currentChannel";
      var setCurrentChannelTopic = "platform_server/apiv1/sma_setcurrentChannel";
  // 订阅的主题
  var subTopic = "";
  String sn = "";
  late AnimationController _animationController;
  bool _offstage = false;
  String currentChannelState = "Normal";
  ScanQualityBean qualityBean = ScanQualityBean();
  String currentNormalChannel = "";
  String currentAdvanceChannel = "";
  String bastNormalChannel = "";
  String bastAdvanceChannel = "";
  bool isUpdated = false;

  wlanBean? wlanModel;
  wlanAdvancedBean? advanceModel;

  // late Timer timer;

  @override
  void initState() {
    super.initState();

    sharedGetData('deviceSn', String).then(((res) {
      printInfo(info: 'deviceSn$res');
      debugPrint('扫描执行了}');
      sn = res.toString();
      // getScanParam();
      // getCurrentChannnel();
      requestInitData();
      //   timer = Timer.periodic(const Duration(seconds: 60), (tm) {

      // });
    }));

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    bool isForward = true;
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        isForward = true;
      } else if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        if (isForward) {
          // _animationController.reverse();
        } else {
          _animationController.forward();
        }
      } else if (status == AnimationStatus.reverse) {
        isForward = false;
      }
    });
    _animationController.forward();
  }

  Future get24gList() async {
    // 获取SOD节点数据
    var parameterNames = {
      "method": "get",
      "nodes": [
        "wifiEnable",
        "wifiMode",
        "wifiHtmode",
        "wifiChannel",
        "wifiTxpower",
        "wifiCountryChannelList_HT20"
      ]
    };
    // 获取SOD节点数据
    await Request().getACSNode(parameterNames, sn);
    // var jsonObj = jsonDecode(res);
    // var jsonModel = wlanBean.fromJson(jsonObj);
    // wlanModel = jsonModel;
    // debugPrint('wlan节点数据:----$jsonObj----}');
  }

  Future get5gList() async {
    // 获取SOD节点数据
    var parameterNames = {
      "method": "get",
      "nodes": [
        "wifi5gEnable",
        "wifi5gMode",
        "wifi5gHtmode",
        "wifi5gChannel",
        "wifi5gTxpower",
        "wifi5gCountryChannelList"
      ]
    };
    await Request().getACSNode(parameterNames, sn);
    // var jsonObj = jsonDecode(res);
    // var jsonModel = wlanAdvancedBean.fromJson(jsonObj);
    // advanceModel = jsonModel;
    // debugPrint('wlan_5g数据:$jsonObj');
  }

  Future getScanParam() async {
    return Future.wait([get24gList(), get5gList()]);
  }

  ///请求信道扫描的接口
  // void requestWiFiScanData() {
  //   var param = {
  //     'sn': sn,
  //     "band24gChannel": wlanModel!.data!.wifiCountryChannelListHT20,
  //     "band5gChannel": advanceModel!.data!.wifi5gCountryChannelList
  //   };
  //   debugPrint('发送信道扫描的参数是:${param.toString()}');
  //   App.post('/platform/cpeMqttWifiScan/queryWifiQuality', data: param)
  //       .then((value) => debugPrint("返回${value.toString()}"));
  // }

  requestInitData() {
    final sessionIdStr = StringUtil.generateRandomString(10);
    subTopic = "app/channelQuality/$sn";
    var pushChannelTopic = "platform_server/apiv1/sma_server_3";
    
    final sessionIdCha = StringUtil.generateRandomString(10);
    var currentChannelTopic = "cpe/$sn";
    var channelParms = {
        "event": "mqtt2sodObj",
        "sn": sn,
        "sessionId": sessionIdCha,
        "pubTopic" : getCurrentChannelTopic,
        "param" : {
          "method" : "get",
          "nodes" : ["wifiCurrentChannel", "wifi5gCurrentChannel"]
        }
      };

      final sessionIdScan = StringUtil.generateRandomString(10);
      var scanNorParms = {
        "event": "WifiChannelScan",
        "sn": sn,
        "sessionId": sessionIdScan,
        "pubTopic" : pushChannelTopic
      };

      final sessionIdNor= StringUtil.generateRandomString(10);
      var channelNorParms = {
        "event": "mqtt2sodObj",
        "sn": sn,
        "sessionId": sessionIdNor,
        "pubTopic" : pushChannelTopic,
        "param" : {
          "method" : "get",
          "nodes" : [
        "wifiEnable",
        "wifiMode",
        "wifiHtmode",
        "wifiChannel",
        "wifiTxpower",
        "wifiCountryChannelList_HT20"
      ]
        }
      };

      final sessionIdAdn= StringUtil.generateRandomString(10);
      var channelAdnParms = {
        "event": "mqtt2sodObj",
        "sn": sn,
        "sessionId": sessionIdAdn,
        "pubTopic" : pushChannelTopic,
        "param" : {
          "method" : "get",
          "nodes" : [
        "wifi5gEnable",
        "wifi5gMode",
        "wifi5gHtmode",
        "wifi5gChannel",
        "wifi5gTxpower",
        "wifi5gCountryChannelList"
      ]
        }
      };

    connect().then((value) {
      client = value;
      debugPrint("执行到订阅这里了,订阅的主题是:$subTopic");
      debugPrint("信道订阅的主题是:$currentChannelTopic");
      // var channelTopic = "platform_server/apiv1/sma_server_1";
      var publishTopic = "cpe/$sn";
      
      var parameterNames = {
        "event": "WifiChannelScan",
        "sn": sn,
        "sessionId": sessionIdStr,
        "pubTopic" : "platform_server/apiv1/sma_server_3"
      };
      _publishMessage(currentChannelTopic, channelNorParms);
      _publishMessage(currentChannelTopic, channelAdnParms);
      _publishMessage(currentChannelTopic, channelParms);
      _publishMessage(publishTopic, scanNorParms);
      _publishMessage(publishTopic, parameterNames);
      client.subscribe(getCurrentChannelTopic, MqttQos.atLeastOnce);
      client.subscribe(subTopic, MqttQos.atLeastOnce);
      _getDeviceList();
    });
  }

  //  监听消息的具体实现
  _getListTableData(List<MqttReceivedMessage<MqttMessage>> data) {
    debugPrint("====================监听到新消息了======================");
    final MqttPublishMessage recMess = data[0].payload as MqttPublishMessage;
    final String topic = data[0].topic;
    final String pt = const Utf8Decoder().convert(recMess.payload.message);
    String desString = "topic is <$topic>, payload is <-- $pt -->";
    debugPrint("string =$desString");
    
    if (topic == getCurrentChannelTopic) {
      String result = pt.substring(0, pt.length - 1);
    String desString = "topic is <$topic>, payload is <-- $result -->";
    debugPrint("string =$desString");
      Map datas = jsonDecode(result);
      debugPrint("信道的数据1: =${datas["data"]["wifiCurrentChannel"]}");
      debugPrint("信道的数据2: =${datas["data"]["wifi5gCurrentChannel"]}");
      currentNormalChannel = datas["data"]["wifiCurrentChannel"];
      currentAdvanceChannel = datas["data"]["wifi5gCurrentChannel"];

      var isNormalStatus = false;
        var isAdvanceStatus = false;
        for (var normalModel in qualityBean.data!.band24GHz!) {
          if (normalModel.channel == bastNormalChannel &&
              normalModel.quality == "1") {
            isNormalStatus = true;
          }
        }
        for (var model in qualityBean.data!.band5GHz!) {
          if (model.channel == bastAdvanceChannel && model.quality == "1") {
            isAdvanceStatus = true;
          }
        }

        Future.delayed(const Duration(milliseconds: 3000), () {
          if (isNormalStatus && isAdvanceStatus) {
            setState(() {
              currentChannelState = "Great";
              isUpdated = true;
            });
          } else {
            setState(() {
              currentChannelState = "Normal";
              isUpdated = false;
            });
          }
        });

    }
    else if(topic == setCurrentChannelTopic) {
      String result = pt.substring(0, pt.length - 1);
    String desString = "topic is <$topic>, payload is <-- $result -->";
    debugPrint("string =$desString");
      Map datas = jsonDecode(result);
      debugPrint("设置信道: =${datas["data"]}");
      if (datas["data"] == "Success") {
        final sessionIdCha = StringUtil.generateRandomString(10);
    var currentChannelTopic = "cpe/$sn";
    var channelParms = {
        "event": "mqtt2sodObj",
        "sn": sn,
        "sessionId": sessionIdCha,
        "pubTopic" : getCurrentChannelTopic,
        "param" : {
          "method" : "get",
          "nodes" : ["wifiCurrentChannel", "wifi5gCurrentChannel"]
        }
      };

      _publishMessage(currentChannelTopic, channelParms);
      client.subscribe(getCurrentChannelTopic, MqttQos.atLeastOnce);

      }
    }
    else {
      final payloadModel = ScanQualityBean.fromJson(jsonDecode(pt));
    debugPrint("2.4G的list: =${payloadModel.data!.band24GHz}");
    debugPrint("5G的list =${payloadModel.data!.band5GHz}");
    debugPrint("2.4G的当前信道 =$currentNormalChannel --5G的当前信道:$currentAdvanceChannel");
    if (payloadModel.data!.band24GHz!.isNotEmpty ||
        payloadModel.data!.band5GHz!.isNotEmpty) {
      var currentNormalStatus = false;
      var currentAdvanceStatus = false;
      for (var normalModel in payloadModel.data!.band24GHz!) {
        if (normalModel.channel == currentNormalChannel &&
            normalModel.quality == "1") {
          currentNormalStatus = true;
        }
      }
      for (var model in payloadModel.data!.band5GHz!) {
        if (model.channel == currentAdvanceChannel && model.quality == "1") {
          currentAdvanceStatus = true;
        }
      }
      setState(() {
        _offstage = true;
        qualityBean = payloadModel;
        if (currentNormalStatus && currentAdvanceStatus) {
          currentChannelState = "Great";
          isUpdated = true;
        } else {
          currentChannelState = "Normal";
          isUpdated = false;
        }
      });
    }
    }
    
  }

//  开启监听消息
  _getDeviceList() {
    client.updates!.listen(_getListTableData);
  }

  // 发送消息
  void _publishMessage(String topic, Map<String, dynamic> message) {
    debugPrint("======发送获取Applist的消息成功了=======");
    debugPrint("======$message=======");
    var builder = MqttClientPayloadBuilder();
    var jsonData = json.encode(message);
    builder.addUTF8String(jsonData);

    client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }

/**
 * "data": {
    "wifiCurrentChannel": "7",
    "wifi5gCurrentChannel": "153"
  },
 */
  /// 获取当前的信道
  // Future getCurrentChannnel() async {
  //   // 获取SOD节点数据
  //   var parameterNames = {
  //     "method": "get",
  //     "nodes": ["wifiCurrentChannel", "wifi5gCurrentChannel"]
  //   };

  //   var res = await Request().getACSNode(parameterNames, sn);
  //   var jsonObj = jsonDecode(res);
  //     debugPrint('当前的信道是11111111:----$jsonObj----}');
  //     currentNormalChannel = jsonObj["data"]["wifiCurrentChannel"];
  //       currentAdvanceChannel = jsonObj["data"]["wifi5gCurrentChannel"];
  //       debugPrint("2.4G的当前信道11 =$currentNormalChannel --5G的当前信道11=:$currentAdvanceChannel");
  // }

  /// 设置最优信道
  setUpBastChannnel(){
    final sessionIdCha = StringUtil.generateRandomString(10);
    var topic = "cpe/$sn";
    var parameters = {
        "event": "mqtt2sodObj",
        "sn": sn,
        "sessionId": sessionIdCha,
        "pubTopic" : setCurrentChannelTopic,
        "param" : {
          "method" : "set",
          "nodes": {
        "wifiChannel": bastNormalChannel,
        "wifi5gChannel": bastAdvanceChannel
      }
        }
      };
      _publishMessage(topic, parameters);
      client.subscribe(setCurrentChannelTopic, MqttQos.atLeastOnce);
    // var parameters = {
    //   "method": "set",
    //   "nodes": {
    //     "wifiChannel": bastNormalChannel,
    //     "wifi5gChannel": bastAdvanceChannel
    //   }
    // };
    // var res = await Request().setACSNode(parameters, sn);
    // var jsonObj = jsonDecode(res);
    // debugPrint('返回的配置结果是:----$jsonObj----}');
    // return jsonObj["code"];
  }

  channelResult() {
    setUpBastChannnel();
    // .then((res) {
    //   if (res == 200) {
    //     getCurrentChannnel();
    //     // 遍历
    //     var isNormalStatus = false;
    //     var isAdvanceStatus = false;
    //     for (var normalModel in qualityBean.data!.band24GHz!) {
    //       if (normalModel.channel == bastNormalChannel &&
    //           normalModel.quality == "1") {
    //         isNormalStatus = true;
    //       }
    //     }
    //     for (var model in qualityBean.data!.band5GHz!) {
    //       if (model.channel == bastAdvanceChannel && model.quality == "1") {
    //         isAdvanceStatus = true;
    //       }
    //     }

    //     Future.delayed(const Duration(milliseconds: 3000), () {
    //       if (isNormalStatus && isAdvanceStatus) {
    //         setState(() {
    //           currentChannelState = "Great";
    //           isUpdated = true;
    //         });
    //       } else {
    //         setState(() {
    //           currentChannelState = "Normal";
    //           isUpdated = false;
    //         });
    //       }
    //     });
    //   }
    // });
  }

  @override
  void dispose() {
    _animationController.dispose();
    client.disconnect();
    // timer.cancel();
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Get.offAllNamed("/home");
            },
          ),
          title: const Text('WiFi Quality'),
          centerTitle: true,
        ),
        body: _offstage
            ? SingleChildScrollView(
                child: Container(
                  color: Colors.black12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      AnimatedBuilder(
                        animation: _animationController,
                        builder: (BuildContext context, child) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 32.0),
                            child: Column(
                              children: <Widget>[
                                Stack(
                                  children: [
                                    Positioned(
                                      child: SizedBox(
                                        width: 200,
                                        height: 200,
                                        child: CirclePercentProgress(
                                          progress: _animationController.value,
                                          isGreat:
                                              currentChannelState == "Great"
                                                  ? true
                                                  : false,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 200,
                                      height: 200,
                                      alignment: Alignment.center,
                                      child: ShaderMask(
                                        shaderCallback: (Rect bounds) {
                                          return const LinearGradient(
                                            colors: [
                                              Colors.black,
                                              Colors.black
                                            ],
                                          ).createShader(bounds);
                                        },
                                        blendMode: BlendMode.srcATop,
                                        child: Text(
                                          currentChannelState,
                                          style: const TextStyle(fontSize: 30),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 100,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: InkWell(
                                    onTap: () {
                                      if (qualityBean
                                          .data!.band24GHz!.isNotEmpty || currentNormalChannel.isNotEmpty) {
                                        Get.toNamed('/channelList', arguments: {
                                          "list": qualityBean.data!.band24GHz,
                                          "currentNol" : currentNormalChannel
                                        })?.then((value) {
                                          debugPrint(
                                              '2.4G逆传的值是:----$value----}');
                                          var currentC = value.toString();
                                          if (currentC.isEmpty) {
                                            bastNormalChannel = qualityBean
                                                .data!.band24GHz![0].channel!;
                                          } else {
                                            bastNormalChannel = currentC;
                                          }
                                        });
                                      }
                                    },
                                    child: const Card(
                                      child: ListTile(
                                        title: Text('2.4GHz'),
                                        trailing: SizedBox(
                                          width: 20,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.green,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Expanded(
                                                  child: Icon(Icons
                                                      .keyboard_arrow_right))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: InkWell(
                                    onTap: () {
                                      if (qualityBean
                                          .data!.band5GHz!.isNotEmpty && currentAdvanceChannel.isNotEmpty) {
                                        Get.toNamed('/advancechannelList',
                                            arguments: {
                                              "data": qualityBean.data!.band5GHz,
                                              "currentChannel" : currentAdvanceChannel
                                            })?.then((value) {
                                          debugPrint(
                                              '5G的逆传的值是:----$value----}');
                                          var currentC = value.toString();
                                          if (currentC.isEmpty) {
                                            bastAdvanceChannel = qualityBean
                                                .data!.band5GHz![0].channel!;
                                          } else {
                                            bastAdvanceChannel = currentC;
                                          }
                                        });
                                      }
                                    },
                                    child: const Card(
                                      child: ListTile(
                                        title: Text('5GHz'),
                                        trailing: SizedBox(
                                          width: 20,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.green,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Expanded(
                                                  child: Icon(Icons
                                                      .keyboard_arrow_right))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 120,
                                ),
                                SizedBox(
                                  width: 200,
                                  height: 50,
                                  child: OutlinedButton(
                                      style: ButtonStyle(
                                          backgroundColor: isUpdated
                                              ? const MaterialStatePropertyAll(
                                                  Colors.grey)
                                              : const MaterialStatePropertyAll(
                                                  Colors.blue)),
                                      onPressed: () {
                                        if (!isUpdated) {
                                          setState(() {
                                            channelResult();
                                            _animationController.reverse();
                                          });
                                        }
                                      },
                                      child: const Text(
                                        "Update",
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.white),
                                      )),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              )
            : setLoadingIndicator());
  }

  Widget setLoadingIndicator() {
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
            "Optimizing, please wait",
            style: TextStyle(fontSize: 15, color: Colors.black),
          )
        ],
      ),
    );
  }
}
