import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../config/base_config.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import '../../pages/net_status/beans/speed_bean.dart';
import '../../core/utils/string_util.dart';
import 'dart:convert';

MqttServerClient client = MqttServerClient.withPort(
    BaseConfig.mqttMainUrl, 'flutter_client', BaseConfig.websocketPort);

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

  String testUp = '0 Kbps';
  String testDown = '0 Kbps';
  String lantency = '0 ms';
  bool testLoading = false;
  String speedTime = "";

  @override
  void initState() {
    sharedGetData('deviceSn', String).then(((res) {
      debugPrint('deviceSn$res');
      sn = res.toString();
    }));

    sharedGetData('speedTime', String).then(((res) {
      debugPrint('speedTime $res');
      setState(() {
        speedTime = res.toString();
      });
    }));
    sharedGetData('testUp', String).then(((res) {
      debugPrint('testUp $res');
      setState(() {
        testUp = res.toString();
      });
    }));
    sharedGetData('testDown', String).then(((res) {
      debugPrint('testDown $res');
      setState(() {
        testDown = res.toString();
      });
    }));
    sharedGetData('lantency', String).then(((res) {
      debugPrint('lantency $res');
      setState(() {
        lantency = res.toString();
      });
    }));

    if (speedTime.isEmpty &&
        testUp.isEmpty &&
        testDown.isEmpty &&
        lantency.isEmpty) {
      requestTestSpeedData(sn);
    } else {
      setState(() {
        testLoading = true;
      });
    }

    Timer(const Duration(seconds: 600), () {
      sharedAddAndUpdate("speedTime", String, "");
      sharedAddAndUpdate("testUp", String, "");
      sharedAddAndUpdate("testDown", String, "");
      sharedAddAndUpdate("lantency", String, "");
    });

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

    final connMess = MqttConnectMessage()
        .authenticateAs('admin', 'smawav')
        .withWillTopic('willtopic')
        .withWillMessage('My Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    print('Client connecting....');
    client.connectionMessage = connMess;

    try {
      await client.connect();
    } on NoConnectionException catch (e) {
      print('Client exception: $e');
      client.disconnect();
    } on SocketException catch (e) {
      print('Socket exception: $e');
      client.disconnect();
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('Client connected');
    } else {
      print(
          'Client connection failed - disconnecting, status is ${client.connectionStatus}');
      client.disconnect();
      exit(-1);
    }

    client.published!.listen((MqttPublishMessage message) {
      print(
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
        // speedmodel = payloadModel;
        testLoading = true;
        var timespeed = payloadModel.data!.timestamp!.substring(0, 16);
        debugPrint("时间是:$timespeed");
        var year = timespeed.substring(0, 10);
        var hour = timespeed.substring(12, timespeed.length - 3);
        var minute = timespeed.substring(14, timespeed.length);
        var newHour = int.parse(hour) + 8;
        var timestr = "$year $newHour:$minute";
        debugPrint("时间是:$timestr");
        speedTime = timestr;
        testUp = StringUtil.getRate(payloadModel.data!.upload!);
        testDown = StringUtil.getRate(payloadModel.data!.download!);
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
    print('Subscription confirmed for topic $topic');
  }

  void onDisconnected() {
    print('OnDisconnected client callback - Client disconnection');
    if (client.connectionStatus!.disconnectionOrigin ==
        MqttDisconnectionOrigin.solicited) {
      print('OnDisconnected callback is solicited, this is correct');
    }
    // exit(-1);
  }

  void onConnected() {
    print('OnConnected client callback - Client connection was sucessful');
  }

  void pong() {
    print('Ping response client callback invoked');
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
