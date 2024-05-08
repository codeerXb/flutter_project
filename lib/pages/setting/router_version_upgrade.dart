import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_template/core/http/http_app.dart';
import 'package:flutter_template/core/utils/toast.dart';
import '../../core/utils/shared_preferences_util.dart';
import 'package:get/get.dart';
import '../../core/utils/string_util.dart';
import '../setting/beans/router_upgrade.dart';
import '../../config/base_config.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

String clientRandom = StringUtil.generateRandomString(10);
String clientId = "client_$clientRandom";

class RouterUpgradePage extends StatefulWidget {
  const RouterUpgradePage({super.key});

  @override
  State<RouterUpgradePage> createState() => _RouterUpgradePageState();
}

class _RouterUpgradePageState extends State<RouterUpgradePage> {
  MqttServerClient client = MqttServerClient.withPort(
      BaseConfig.mqttMainUrl, clientId, BaseConfig.websocketPort);
  String sn = '';
  String subTopic = "";
  RouterUpgradeBean? routerUpgradeModel;
  @override
  void initState() {
    sharedGetData('deviceSn', String).then(((res) {
      debugPrint("sn: $res");
      setState(() {
        sn = res.toString();
        getRouterVersion(sn);
      });
    }));
    super.initState();
  }

  void getRouterVersion(String sn) {
    App.get('/platform/deviceFiles/queryVersionUpgradeInfoBySn?sn=$sn')
        .then((res) {
      final model = RouterUpgradeBean.fromJson(res);
      if (model.code == 200 && model.data != null) {
        
        setState(() {
          routerUpgradeModel = model;
        });
        
      } else {
        ToastUtils.toast(model.message!);
      }
    }).catchError((error) {
      ToastUtils.error(error.toString());
    });
  }

  requestRouterUpdate(String sn) async {
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
    }

    client.published!.listen((MqttPublishMessage message) {
      debugPrint(
          'Published topic: topic is ${message.variableHeader!.topicName}, with Qos ${message.header!.qos}');
    });

    final sessionIdStr = StringUtil.generateRandomString(10);
    var publishTopic = "cpe/$sn";
    var parms = {
      "event": "update",
      "sn": sn,
      "sessionId": sessionIdStr,
      "data": {
        "type": 1,
        "version": routerUpgradeModel?.data?.version,
        "md5" : routerUpgradeModel?.data?.md5,
        "url" : routerUpgradeModel?.data?.url
      }
    };

    _publishMessage(publishTopic, parms);

    client.subscribe(publishTopic, MqttQos.atLeastOnce);

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final MqttPublishMessage recMess = c![0].payload as MqttPublishMessage;
      final String topic = c[0].topic;
      final String pt = const Utf8Decoder().convert(recMess.payload.message);
      // String desString = "topic is <$topic>, payload is <-- $pt -->";
      String result = pt.substring(0, pt.length - 1);
      String desString = "topic is <$topic>, payload is <-- $result -->";
      debugPrint("string =$desString");
      Map datas = jsonDecode(result);
      final resultModel = datas["data"];

      if (resultModel["updateResult"] == '1') {
        ToastUtils.toast("Upgrade successful!");
        Future.delayed( const Duration(seconds: 2),() {
          Get.back();
        });
      }else {
        ToastUtils.toast("Upgrade failed");
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
  }

  void onConnected() {
    debugPrint('OnConnected client callback - Client connection was sucessful');
  }

  void pong() {
    debugPrint('Ping response client callback invoked');
  }

  // 发送消息
  void _publishMessage(String topic, Map<String, dynamic> message) {
    debugPrint("======发送的消息成功了=======");
    debugPrint("===$topic===${jsonEncode(message)}=======");
    var builder = MqttClientPayloadBuilder();
    var jsonData = json.encode(message);
    builder.addUTF8String(jsonData);
    client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: showRouterUpgrade(context),
    );
  }

  Widget showRouterUpgrade(BuildContext context) {
    return CupertinoAlertDialog(
      content: SingleChildScrollView(
        child: ListBody(
          children: [ 
            Text(routerUpgradeModel?.data?.upgradeFlag == "0" ?  "The current version of the router is already the latest, no need to upgrade" : "A new version is detected, does it need to be upgraded?",style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            Offstage(
              offstage: routerUpgradeModel?.data?.upgradeFlag == "0",
              child: Text("The new version is: ${routerUpgradeModel?.data?.version}",style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w700),),
            )
          ],
        ),
      ),
      actions: [
        CupertinoDialogAction(
          child: const Text("Cancel",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
        CupertinoDialogAction(
          child: const Text("Confirm",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
          onPressed: () {
            if (routerUpgradeModel?.data?.upgradeFlag != "0") {
              requestRouterUpdate(sn);
            }else {
              Navigator.of(context).pop(true);
            }
          },
        ),
        
      ],
    );
  }

  @override
  void dispose() {
    client.disconnect();
    super.dispose();
  }
}