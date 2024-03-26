import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_template/core/request/request.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import '../../config/base_config.dart';
import '../../core/mqtt/mqtt_service.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import '../.././core/utils/string_util.dart';
import 'dart:convert';
import 'dart:async';
import './beans/scan_quality_bean.dart';
import 'package:get/get.dart';
String Id_Random = StringUtil.generateRandomString(10);
MqttServerClient client = MqttServerClient.withPort(
    BaseConfig.mqttMainUrl, 'client_$Id_Random', BaseConfig.websocketPort);

class AdvanceChannelListPage extends StatefulWidget {
  const AdvanceChannelListPage({super.key});

  @override
  State<AdvanceChannelListPage> createState() => _AdvanceChannelListPageState();
}

class _AdvanceChannelListPageState extends State<AdvanceChannelListPage> {
    // MqttClient client = MqttServerClient(BaseConfig.mqttMainUrl, "flutter_client",
    //   maxConnectionAttempts: 10);
  var setCurrentChannelTopic = "platform_server/apiv1/sma_setcurrentChannel5G";
  List<Band5GHz> listArray = [];
  String currentChannnel = "";
  String bastChannel = "";
  String sn = "";
  bool isLoaded = true;
  bool isUpdated = false;
  // Timer? timer;
  @override
  void initState() {
    sharedGetData('deviceSn', String).then(((res) {
      debugPrint('deviceSn : $res');
      sn = res.toString();
      // getCurrentChannnel();
    }));
    setState(() {
      listArray = Get.arguments["data"];
      currentChannnel = Get.arguments["currentChannel"];
      bastChannel = listArray[0].channel!;
    });

    for (Band5GHz item in listArray) {
      if (item.channel == currentChannnel && item.quality == "1") {
        setState(() {
          isUpdated = true;
        });
      }
    }

    super.initState();
  }


  void updateCurrentChannel() async {
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
    var topic = "cpe/$sn";
    final topicSb = StringBuffer();
    topicSb.write(setCurrentChannelTopic);
    topicSb.write(sn);
    final currentChannelTopic = topicSb.toString();
    var parameters = {
      "event": "mqtt2sodObj",
      "sn": sn,
      "sessionId": sessionIdCha,
      "pubTopic": currentChannelTopic,
      "param": {
        "method": "set",
        "nodes": {
          "wifi5gChannel": bastChannel,
        }
      }
    };

    _publishMessage(topic, parameters);

    client.subscribe(setCurrentChannelTopic, MqttQos.atLeastOnce);

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
    debugPrint("====================监听5G更新信道到新消息了======================");
    final MqttPublishMessage recMess = c![0].payload as MqttPublishMessage;
    final String topic = c[0].topic;
    final String pt = const Utf8Decoder().convert(recMess.payload.message);
    // String desString = "topic is <$topic>, payload is <-- $pt -->";
    // debugPrint("string =$desString");
    String result = pt.substring(0, pt.length - 1);
    String desString = "topic is <$topic>, payload is <-- $result -->";
    debugPrint("string =$desString");
    Map datas = jsonDecode(result);
      debugPrint("设置信道: =${datas["data"]}");
      if (datas["data"] == "Success") {
        setState(() {
          isLoaded = true;
          currentChannnel = listArray[0].channel!;
        });
      }
  });

  }

  void onSubscribed(String topic) {
  debugPrint('Subscription confirmed for topic $topic');
}

void onDisconnected() {
  debugPrint('OnDisconnected client callback - Client disconnection');
  if (client.connectionStatus!.disconnectionOrigin ==
      MqttDisconnectionOrigin.solicited) {
    debugPrint('OnDisconnected callback is solicited, this is correct');
  }
  // exit(-1);
}

void onConnected() {
  debugPrint('OnConnected client callback - Client connection was sucessful');
}

void pong() {
  debugPrint('Ping response client callback invoked');
}

  // 发送消息
  void _publishMessage(String topic, Map<String, dynamic> message) {
    debugPrint("======发送获取5G更新信道的消息成功了=======");
    debugPrint("======$message=======");
    var builder = MqttClientPayloadBuilder();
    var jsonData = json.encode(message);
    builder.addUTF8String(jsonData);
    client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }


  /// 获取当前的信道
  // Future getCurrentChannnel() async {
  //   // 获取SOD节点数据
  //   var parameterNames = {
  //     "method": "get",
  //     "nodes": ["wifi5gCurrentChannel"]
  //   };

  //   var res = await Request().getACSNode(parameterNames, sn);
  //   var jsonObj = jsonDecode(res);
  //   var currentChannelRes = jsonObj["data"]["wifi5gCurrentChannel"];
  //   setState(() {
  //     currentChannnel = currentChannelRes;
  //   });
  //   debugPrint('当前的信道是:----$jsonObj----}');
  // }

  /// 设置最优信道
  // Future<int> setUpBastChannnel() async {
  //   var parameters = {
  //     "method": "set",
  //     "nodes": {"wifi5gChannel": bastChannel}
  //   };
  //   var res = await Request().setACSNode(parameters, sn);
  //   var jsonObj = jsonDecode(res);
  //   debugPrint('返回的配置结果是:----$jsonObj----}');
  //   return jsonObj["code"];
  // }

  // getChannelResult() {
  //   setUpBastChannnel().then((res) {
  //     if (res == 200) {
  //       timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
  //         getDeviceRestratResult().then((value) {
  //           if (value == "0") {
  //             timer.cancel();
  //             getCurrentChannnel();
  //             setState(() {
  //               isLoaded = true;
  //             });
  //           }
  //         });
  //       });
  //     }
  //   });
  // }

  // Future<String> getDeviceRestratResult() async {
  //   var parameterNames = {
  //     "method": "get",
  //     "nodes": ["wifi5gIsRestart"]
  //   };

  //   var res = await Request().getACSNode(parameterNames, sn);
  //   var jsonObj = jsonDecode(res);
  //   var restartRes = jsonObj["data"]["wifi5gIsRestart"];
  //   debugPrint('当前的结果是:----$restartRes----}');
  //   return restartRes;
  // }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    client.disconnect();
    // timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Get.back(result: bastChannel);
            },
          ),
          title: const Text(
            "WiFi Quality",
            style: TextStyle(fontSize: 24, color: Colors.black),
          ),
        ),
        body: isLoaded
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      // flex: 4,
                      child: ListView.builder(
                          itemCount: listArray.length,
                          itemBuilder: (BuildContext context, int index) {
                            return setListItem(listArray[index]);
                          })),
                  Container(
                    width: double.infinity,
                    height: 100,
                    alignment: Alignment.topCenter,
                    child: OutlinedButton(
                        style:  ButtonStyle(
                            backgroundColor: isUpdated ? const MaterialStatePropertyAll(
                                                  Colors.grey) :
                              const MaterialStatePropertyAll(Colors.blue)),
                        onPressed: () {
                          if (!isUpdated) {
                            updateCurrentChannel();
                          setState(() {
                            isLoaded = false;
                            
                          });
                          }
                          
                        },
                        child: const Text(
                          "Update",
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        )),
                  )
                ],
              )
            : showLoadingIndicator());
  }

  Widget setListItem(Band5GHz model) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 30,
            child: Text(
              "${model.channel}",
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 10,
              child: LinearProgressIndicator(
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation(Colors.blue),
                value: double.parse(model.quality!),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          SizedBox(
            width: 30,
            child: Text(
              currentChannnel == model.channel ? "now" : "",
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget showLoadingIndicator() {
    return Offstage(
      offstage: isLoaded,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoActivityIndicator(
              animating: true,
              radius: 20,
              color: Colors.grey,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "Optimizing, please wait",
              style: TextStyle(fontSize: 15, color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
