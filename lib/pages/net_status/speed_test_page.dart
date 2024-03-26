import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../config/base_config.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import '../../pages/net_status/beans/speed_bean.dart';
import '../../core/utils/string_util.dart';

String Id_Random = StringUtil.generateRandomString(10);
MqttServerClient client = MqttServerClient.withPort(
    BaseConfig.mqttMainUrl, 'client_$Id_Random', BaseConfig.websocketPort);

class SpeedTestHomeVC extends StatefulWidget {
  const SpeedTestHomeVC({super.key});

  @override
  State<SpeedTestHomeVC> createState() => _SpeedTestHomeVCState();
}

class _SpeedTestHomeVCState extends State<SpeedTestHomeVC> {
  String sn = "";
  // SpeedModel? speedmodel;
  String downUnit = 'Kbps';
  String upUnit = 'Kbps';

  String testUp = '';
  String testDown = '';
  String lantency = '';
  bool testLoading = false;
  String speedTime = "";

  @override
  void initState() {
    sharedGetData('deviceSn', String).then(((res) {
      debugPrint('deviceSn$res');
      sn = res.toString();
      requestTestSpeedData(sn);
    }));
    super.initState();
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

    var subTopic = "cpe/$sn";
    final sessionIdStr = StringUtil.generateRandomString(10);
    var parameterNames = {
      "event": "getSpeedtest",
      "sn": sn,
      "sessionId": sessionIdStr,
      "pubTopic": "$subTopic-sma_server_1"
    };
    _publishMessage(subTopic, parameterNames);
    client.subscribe("$subTopic-sma_server_1", MqttQos.atLeastOnce);

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      debugPrint("====================监听到新消息了======================");
      final MqttPublishMessage recMess = c![0].payload as MqttPublishMessage;
      final String topic = c[0].topic;
      // final pt =
      // MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      String pt = const Utf8Decoder().convert(recMess.payload.message);
      String result = pt.substring(0, pt.length - 1);
      String desString = "topic is <$topic>, payload is <-- $result -->";
      debugPrint("string =$desString");
      final payloadModel = SpeedModel.fromJson(jsonDecode(result));
      setState(() {
        testLoading = true;
        var timespeed = payloadModel.data!.timestamp!.substring(0, 16);
        var year = timespeed.substring(0, 10);
        var hour = timespeed.substring(12, timespeed.length - 3);
        var minute = timespeed.substring(14, timespeed.length);
        var newHour = int.parse(hour) + 8;
        var timestr = "$year $newHour:$minute";
        speedTime = timestr;
        testUp = StringUtil.getUnitlessRate(payloadModel.data!.upload!);
        testDown = StringUtil.getUnitlessRate(payloadModel.data!.download!);
        lantency = getPing(payloadModel.data!.ping!);

        sharedAddAndUpdate("speedTime", String, speedTime);
        sharedAddAndUpdate("testUp", String, testUp);
        sharedAddAndUpdate("testDown", String, testDown);
        sharedAddAndUpdate("lantency", String, lantency);

        debugPrint("数据是:$testUp -- $testDown -- $lantency");
      });
    });
  }

  String getPing(ping) {
    return '${ping}ms';
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
            "Speed test in progress",
            textAlign: TextAlign.center,
            softWrap: true,
            style: TextStyle(fontSize: 15, color: Colors.black),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Speed Test',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: testLoading
          ? Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Speed test results",
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
                    'Latency $lantency',
                    style: const TextStyle(fontSize: 14),
                  )
                ],
              ),
            )
          : loadingIndicator(),
    );
  }

  @override
  void dispose() {
    client.disconnect();
    super.dispose();
  }
}
