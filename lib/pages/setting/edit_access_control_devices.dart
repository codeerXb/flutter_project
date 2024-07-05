import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_template/core/utils/logger.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:get/get.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import '../../config/base_config.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import '../../core/event_bus/eventbus_utils.dart';
import '../../core/utils/string_util.dart';
import "../setting/beans/access_control_data.dart";

String Id_Random = StringUtil.generateRandomString(10);

class EditAccessBlackList extends StatefulWidget {
  const EditAccessBlackList({super.key});

  @override
  State<EditAccessBlackList> createState() => _EditAccessBlackListState();
}

class _EditAccessBlackListState extends State<EditAccessBlackList> {

  MqttServerClient client = MqttServerClient.withPort(
      BaseConfig.mqttMainUrl, "client_$Id_Random", BaseConfig.websocketPort);

  int currentSelIndex = 0;

  String sn = "";

  WiFiAccessTable dataList = WiFiAccessTable();

  @override
  void initState() {
    sharedGetData('deviceSn', String).then(((res) {
      setState(() {
        sn = res.toString();
      });
    }));
    var model = Get.arguments["selectItem"];
    if (model != null) {
      setState(() {
      dataList = model;
    });
    }
    
    super.initState();
  }


  requestDatas(String sn , int id) async {
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

    var subTopic = "cpe/$sn";
    final sessionIdConfig = StringUtil.generateRandomString(10);
    var configTopicStr = "cpe/$sn-delDevice";
    var configParms = {
      "event": "mqtt2sodTable",
      "sn": sn,
      "sessionId": sessionIdConfig,
      "pubTopic": configTopicStr,
      "param": {
        "method": "del",
        "table": {
            "table": "WiFiAccessTable",
            "id": id
        }
      }
    };
  
    _publishMessage(subTopic, configParms);
    client.subscribe(configTopicStr, MqttQos.atLeastOnce);
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      debugPrint("====================监听到新消息了======================");
      final MqttPublishMessage recMess = c![0].payload as MqttPublishMessage;
      final String topic = c[0].topic;
      final String pt = const Utf8Decoder().convert(recMess.payload.message);
      String desString = "topic is <$topic>, payload is <-- $pt -->";
      XLogger.getLogger().d(" 结果---$desString");
      String result = pt.substring(0, pt.length - 1);
      Map datas = jsonDecode(result);
      var resultData = datas["data"];
      if (resultData == "Success") ToastUtils.toast(resultData);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Block blacklist",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          dataList.mac!.isEmpty ? Container() : RadioListTile(
                  value: 1,
                  groupValue: currentSelIndex,
                  title: const Text(
                    "拦截黑名单设备",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.left,
                  ),
                  // subtitle: const Text(
                  //   "加入黑名单的设备会被自动拦截",
                  //   style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  //   textAlign: TextAlign.left,
                  // ),
                  activeColor: Colors.green,
                  onChanged: (int? value) {
                    setState(() {
                      currentSelIndex = value!;
                    });
                  },
                ),
          Positioned(
              bottom: 20.0,
              child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 40,
                      height: 40,
                      child: OutlinedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  const MaterialStatePropertyAll(Colors.red),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)))),
                          onPressed: () {
                            requestDatas(sn, dataList.id!);
                          },
                          child: const Text("Delete",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 14))),
                    ),
                  )),
        ],
      ),
    );
  }
  @override
  void dispose() {
    client.disconnect();
    super.dispose();
  }
}
