import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../core/utils/channel_progress.dart';
import 'package:flutter/material.dart';
import '../../config/base_config.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'dart:convert';
import './beans/scan_quality_bean.dart';
import '../../pages/wifi_set/wlan/wlanBeans.dart';
import '../../pages/wifi_set/wlan/wlan5gBeans.dart';
import '../.././core/utils/string_util.dart';

String Id_Random = StringUtil.generateRandomString(10);
MqttServerClient client = MqttServerClient.withPort(
      BaseConfig.mqttMainUrl, 'client_$Id_Random', BaseConfig.websocketPort);

class ChannelScanPage extends StatefulWidget {
  const ChannelScanPage({super.key});

  @override
  State<ChannelScanPage> createState() => _ChannelScanPageState();
}

class _ChannelScanPageState extends State<ChannelScanPage>
    with TickerProviderStateMixin {
  
  // var getCurrentChannelTopic = "platform_server/apiv1/sma_currentChannel";
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
    sharedGetData('deviceSn', String).then(((res) {
      printInfo(info: 'deviceSn$res');
      sn = res.toString();
      requestInitData(sn);
    }));
    super.initState();

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

  requestInitData(String sn) async {
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
    var publishTopic = "cpe/$sn";
    var channelParms = {
      "event": "mqtt2sodObj",
      "sn": sn,
      "sessionId": sessionIdCha,
      "param": {
        "method": "get",
        "nodes": [
          "wifiCurrentChannel",
          "wifi5gCurrentChannel",
          "wifiCountryChannelList_HT20",
          "wifi5gCountryChannelList"
        ]
      }
    };

    final sessionIdScan = StringUtil.generateRandomString(10);
    var scanNorParms = {
      "event": "WifiChannelScan",
      "sn": sn,
      "sessionId": sessionIdScan,
    };

    _publishMessage(publishTopic, channelParms);
    _publishMessage(publishTopic, scanNorParms);

    subTopic = "app/channelQuality/$sn";
    client.subscribe(subTopic, MqttQos.atLeastOnce);
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final MqttPublishMessage recMess = c![0].payload as MqttPublishMessage;
      final String topic = c[0].topic;
      final String pt = const Utf8Decoder().convert(recMess.payload.message);
      String desString = "topic is <$topic>, payload is <-- $pt -->";
      debugPrint("string =$desString");
      final payloadModel = ScanQualityBean.fromJson(jsonDecode(pt));
      if (topic == subTopic) { 
        currentNormalChannel = payloadModel.data!.wifiCurrentChannel!;
        currentAdvanceChannel = payloadModel.data!.wifi5gCurrentChannel!;
        currentChannelState = payloadModel.data!.wifiQuality!;
        bastNormalChannel = payloadModel.data!.band24GHz![0].channel!;
        bastAdvanceChannel = payloadModel.data!.band5GHz![0].channel!;
        debugPrint("2.4G的list: =${payloadModel.data!.band24GHz}");
        debugPrint("5G的list =${payloadModel.data!.band5GHz}");
        debugPrint(
            "2.4G的当前信道 =$currentNormalChannel --5G的当前信道:$currentAdvanceChannel---当前质量:$currentChannelState");
        if (payloadModel.data!.band24GHz!.isNotEmpty ||
            payloadModel.data!.band5GHz!.isNotEmpty) {
          setState(() {
            _offstage = true;
            qualityBean = payloadModel;
            if (currentChannelState == "Great") {
              isUpdated = true;
            } else {
              isUpdated = false;
            }
          });
        }
      } else if (topic == setCurrentChannelTopic) {
        final recMess = c[0].payload as MqttPublishMessage;
        final pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        // String result = pt.substring(0, pt.length - 1);
        String desString = "topic is <$topic>, payload is <-- $pt -->";
        debugPrint("string =$desString");
        Map datas = jsonDecode(pt);
        debugPrint("设置信道: =${datas["data"]}");
        if (datas["data"] == "Success") {
          setState(() {
            currentChannelState = "Great";
            isUpdated = true;
            currentNormalChannel = bastNormalChannel;
            currentAdvanceChannel = bastAdvanceChannel;
          });
        } else {
          setState(() {
            currentChannelState = "Normal";
            isUpdated = false;
            currentNormalChannel = payloadModel.data!.wifiCurrentChannel!;
            currentAdvanceChannel = payloadModel.data!.wifi5gCurrentChannel!;
          });
        }
      } else {}
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
    debugPrint("======发送的消息成功了=======");
    debugPrint("===$topic===$message=======");
    var builder = MqttClientPayloadBuilder();
    var jsonData = json.encode(message);
    builder.addUTF8String(jsonData);
    client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }

  /// 设置最优信道
  setUpBastChannnel() {
    final sessionIdCha = StringUtil.generateRandomString(10);
    var topic = "cpe/$sn";
    var parameters = {
      "event": "mqtt2sodObj",
      "sn": sn,
      "sessionId": sessionIdCha,
      "pubTopic": setCurrentChannelTopic,
      "param": {
        "method": "set",
        "nodes": {
          "wifiChannel": bastNormalChannel,
          "wifi5gChannel": bastAdvanceChannel
        }
      }
    };
    _publishMessage(topic, parameters);
    client.subscribe(setCurrentChannelTopic, MqttQos.atLeastOnce);
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
                                              .data!.band24GHz!.isNotEmpty ||
                                          currentNormalChannel.isNotEmpty) {
                                        Get.toNamed('/channelList', arguments: {
                                          "list": qualityBean.data!.band24GHz,
                                          "currentNol": currentNormalChannel
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
                                              .data!.band5GHz!.isNotEmpty &&
                                          currentAdvanceChannel.isNotEmpty) {
                                        Get.toNamed('/advancechannelList',
                                            arguments: {
                                              "data":
                                                  qualityBean.data!.band5GHz,
                                              "currentChannel":
                                                  currentAdvanceChannel
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
                                          setUpBastChannnel();
                                          setState(() {
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
