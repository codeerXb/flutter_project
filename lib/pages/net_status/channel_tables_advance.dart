import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_template/core/event_bus/eventbus_utils.dart';
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

String id_random = StringUtil.generateRandomString(10);
class AdvanceChannelListPage extends StatefulWidget {
  const AdvanceChannelListPage({super.key});

  @override
  State<AdvanceChannelListPage> createState() => _AdvanceChannelListPageState();
}

class _AdvanceChannelListPageState extends State<AdvanceChannelListPage> {
    MqttServerClient client = MqttServerClient.withPort(
    BaseConfig.mqttMainUrl, 'client_$id_random', BaseConfig.websocketPort);
  var setCurrentChannelTopic = "platform_server/apiv1/sma_setcurrentChannel5G";
  var getCurrentChannelTopic = "platform_server/apiv1/sma_currentChannel";
  List<Band5GHz> listArray = [];
  String currentChannnel = "";
  String bastChannel = "";
  String sn = "";
  bool isLoaded = true;
  bool isUpdated = false;
  bool isClick = false;
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

    client.subscribe(currentChannelTopic, MqttQos.atLeastOnce);
    setState(() {
      isLoaded = false;
    });

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
        
        Future.delayed(const Duration(seconds: 1),() {
          getCurrentChannnel();
        });
        
        eventBus.fire("getCurrentChannnel");
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
  Future getCurrentChannnel() async {
    final sessionIdCha = StringUtil.generateRandomString(10);
    var topic = "cpe/$sn";
    // 获取SOD节点数据
    var parameterNames = {
      "event": "mqtt2sodObj",
      "sn": sn,
      "sessionId": sessionIdCha,
      "pubTopic": getCurrentChannelTopic,
      "param": {
        "method": "get",
        "nodes": ["wifi5gCurrentChannel"]
      }
    };
    _publishMessage(topic, parameterNames);
    client.subscribe(getCurrentChannelTopic, MqttQos.atLeastOnce);
  }

  
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
              Get.back(result: isClick ? bastChannel : currentChannnel);
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
                          setState(() {
                            isClick = true;
                            bastChannel = listArray[0].channel!;
                            updateCurrentChannel();
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
                valueColor: AlwaysStoppedAnimation(paintingIndicatorColor(double.parse(model.quality!))),
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

  Color paintingIndicatorColor(double value) {
    if (value > 0.0 && value <= 0.4) {
      return Colors.red;
    }else if (value > 0.4 && value <= 0.7) {
      return Colors.yellow;
    }else {
      return Colors.blue;
    }
    
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
