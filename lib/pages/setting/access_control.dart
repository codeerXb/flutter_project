import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:get/get.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import '../../config/base_config.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import '../../core/utils/string_util.dart';
import 'package:flutter_template/core/utils/logger.dart';

String Id_Random = StringUtil.generateRandomString(10);

class AccessController extends StatefulWidget {
  const AccessController({super.key});

  @override
  State<AccessController> createState() => _AccessControllerState();
}

class _AccessControllerState extends State<AccessController> {
  MqttServerClient client = MqttServerClient.withPort(
      BaseConfig.mqttMainUrl, "client_$Id_Random", BaseConfig.websocketPort);

  String sn = "";

  bool switchToggle = false;

  String selectModel = "";
  int selValue = 0;
  String selResult = "";
  List options = ["Block blacklisted devices", "Block non-whitelisted devices"];

  @override
  void initState() {
    sharedGetData('deviceSn', String).then(((res) {
      setState(() {
        sn = res.toString();
        requestDatas(sn);
      });
    }));
    super.initState();
    setState(() {
      selectModel = options[selValue];
    });
  }

  requestDatas(String sn) async {
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
    var configTopicStr = "cpe/$sn-getAccessListSetting";
    var configParms = {
      "event": "mqtt2sodObj",
      "sn": sn,
      "sessionId": sessionIdConfig,
      "pubTopic": configTopicStr,
      "param": {
        "method": "get",
        "nodes": ["wifiAccessListSetting"]
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
      XLogger.getLogger().d(" wifi控制列表get---$desString");
      String result = pt.substring(0, pt.length - 1);
      if (topic == configTopicStr) {
        Map datas = jsonDecode(result);
        var resultData = datas["data"]["wifiAccessListSetting"];
        setState(() {
          switchToggle = resultData != "off" ? true : false;
          if (resultData == "allow") {
            selectModel = options[1];
          } else if (resultData == "reject") {
            selectModel = options[0];
          }
        });
      } else {
        Map datas = jsonDecode(result);
        var resultData = datas["data"];
        if (resultData == "Success") ToastUtils.toast(resultData);
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

  void _publishMessage(String topic, Map<String, dynamic> message) {
    debugPrint("===发送$topic ===$message=======");
    var builder = MqttClientPayloadBuilder();
    var jsonData = json.encode(message);
    builder.addUTF8String(jsonData);
    client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }

  setWiFiConfiguration() {
    final sessionId = StringUtil.generateRandomString(10);
    var topic = "cpe/$sn";
    var pubtopic = "cpe/$sn/setwifiConfig";
    var wifiConfig = "";
    if (!switchToggle) {
      wifiConfig = "off";
    } else {
      if (selectModel == options[0]) {
        wifiConfig = "reject";
      } else {
        wifiConfig = "allow";
      }
    }
    var parameters = {
      "event": "mqtt2sodObj",
      "sn": sn,
      "sessionId": sessionId,
      "pubTopic": pubtopic,
      "param": {
        "method": "set",
        "nodes": {"wifiAccessListSetting": wifiConfig}
      }
    };
    _publishMessage(topic, parameters);
    client.subscribe(pubtopic, MqttQos.atLeastOnce);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "AccessControl",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
          child: Container(
        height: double.infinity,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Padding(padding: EdgeInsets.only(top: 20)),
            ListTile(
              leading: const Text(
                "Anti-scratch switch",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
              trailing: CupertinoSwitch(
                value: switchToggle,
                onChanged: (value) {
                  setState(() {
                    switchToggle = value;
                    if (!switchToggle || (switchToggle && selResult.isNotEmpty)) setWiFiConfiguration();
                  });
                },
              ),
            ),
            const Divider(color: Colors.grey, endIndent: 16, indent: 16),
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
              leading: const SizedBox(
                width: 150,
                child: Text(
                  "Anti-robbing network settings",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  maxLines: 2,
                ),
              ),
              trailing: InkWell(
                onTap: () {
                  showAlertWindown(context);
                },
                child: FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(
                          selectModel,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                          softWrap: true,
                          overflow: TextOverflow.visible,
                          maxLines: 2,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios_outlined),
                        onPressed: () {
                          showAlertWindown(context);
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
            const Divider(color: Colors.grey, endIndent: 16, indent: 16),
            InkWell(
              onTap: () {
                Get.toNamed("/access_blacklist");
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                    leading: const Text(
                      "blacklist",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios_outlined),
                      onPressed: () {
                        Get.toNamed("/access_blacklist");
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "Devices added to the blacklist will be automatically blocked",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.grey, endIndent: 16, indent: 16),
          ],
        ),
      )),
    );
  }

  void showAlertWindown(BuildContext context) async {
    int result = await showModalBottomSheet(
        context: context,
        constraints: const BoxConstraints(maxHeight: 250),
        builder: (BuildContext context) {
          return StatefulBuilder(builder: ((context, setState) {
            return Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Anti-robbing network mode settings",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  RadioListTile(
                    value: 0,
                    groupValue: selValue,
                    title: const Text(
                      "Block blacklisted devices",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.left,
                    ),
                    subtitle: const Text(
                      "Devices added to the blacklist will be automatically blocked",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.left,
                    ),
                    activeColor: Colors.green,
                    onChanged: (int? value) {
                      setState(() {
                        selValue = value!;
                        debugPrint("当前的选项值1:$selValue");
                      });
                    },
                  ),
                  RadioListTile(
                    value: 1,
                    groupValue: selValue,
                    title: const Text(
                      "Block non-whitelisted devices",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.left,
                    ),
                    subtitle: const Text(
                      "Only allow whitelisted devices to connect to the router",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.left,
                    ),
                    activeColor: Colors.green,
                    onChanged: (int? value) {
                      setState(() {
                        selValue = value!;
                        debugPrint("当前的选项值2:$selValue");
                      });
                    },
                  ),
                  OutlinedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              const MaterialStatePropertyAll(Colors.blue),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)))),
                      onPressed: () {
                        Navigator.pop(context, selValue);
                      },
                      child: const Text("Confirm",
                          style: TextStyle(color: Colors.white, fontSize: 14)))
                ],
              ),
            );
          }));
        });
    debugPrint("当前的选项值3:$result");
    setState(() {
      selValue = result;
      selResult = result.toString();
      selectModel = options[selValue];
      if (switchToggle) setWiFiConfiguration();
    });
  }

  @override
  void dispose() {
    client.disconnect();
    super.dispose();
  }
}
