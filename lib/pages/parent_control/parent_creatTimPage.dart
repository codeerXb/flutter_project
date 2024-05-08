import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import '../.././core/utils/string_util.dart';
import '../../config/base_config.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:get/get.dart';
import 'package:flutter_spinner_time_picker/flutter_spinner_time_picker.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

String clientRandom = StringUtil.generateRandomString(10);
String clientId = "client_$clientRandom";

class ParentCreatTimePage extends StatefulWidget {
  const ParentCreatTimePage({super.key});

  @override
  State<ParentCreatTimePage> createState() => _ParentCreatTimePageState();
}

class _ParentCreatTimePageState extends State<ParentCreatTimePage> {
  MqttServerClient client = MqttServerClient.withPort(
      BaseConfig.mqttMainUrl, clientId, BaseConfig.websocketPort);

  TimeOfDay selectedStartTime = TimeOfDay.now();
  TimeOfDay selectedEndTime = TimeOfDay.now();
  String sn = "";
  String subTopic = "";
  String macAddress = "";
  List weeks = [
    "Every Monday",
    "Every Tuesday",
    "Every Wednesday",
    "Every Thursday",
    "Every Friday",
    "Every Saturday",
    "Every Sunday"
  ];

  List ruleWeeks = [
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun",
  ];

  List<bool> checked = List<bool>.filled(7, false);
  List checkWeeks = [];

  // bool? monCheck = false;
  // bool? tusCheck = false;
  // bool? wedCheck = false;
  // bool? turCheck = false;
  // bool? friCheck = false;
  // bool? satuCheck = false;
  // bool? sunCheck = false;

  @override
  void initState() {
    sharedGetData('deviceSn', String).then(((res) {
      printInfo(info: 'deviceSn$res');
      sn = res.toString();
    }));
    macAddress = Get.arguments["mac"];
    super.initState();
  }

  void _showStartTimePicker() async {
    final pickedTime = await showSpinnerTimePicker(
      context,
      initTime: selectedStartTime,
      is24HourFormat: true,
    );

    if (pickedTime != null) {
      setState(() {
        selectedStartTime = pickedTime;
        debugPrint("当前选择的时间是:${pickedTime.hour}:${pickedTime.minute}");
      });
    }
  }

  void _showEndTimePicker() async {
    final pickedTime = await showSpinnerTimePicker(
      context,
      initTime: selectedEndTime,
      is24HourFormat: true,
    );

    if (pickedTime != null) {
      setState(() {
        selectedEndTime = pickedTime;
        debugPrint("当前选择的时间是:${pickedTime.hour}:${pickedTime.minute}");
      });
    }
  }

  uploadDeviceTimeConfig(BuildContext context, String sn, String weekDays,
      String startTime, String endTime, String mac) async {
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
    subTopic = "cpe/$sn/addTime";
    var parms = {
      "event": "mqtt2sodTable",
      "sn": sn,
      "sessionId": sessionIdStr,
      "pubTopic": subTopic,
      "param": {
        "method": "add",
        "table": {
          "table": "FwParentControlTable",
          "value": {
            "Name": "test",
            "Weekdays": weekDays,
            "TimeStart": startTime,
            "TimeStop": endTime,
            "Host": mac,
            "Target": "DROP"
          }
        }
      }
    };

    _publishMessage(publishTopic, parms);

    client.subscribe(subTopic, MqttQos.atLeastOnce);

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final MqttPublishMessage recMess = c![0].payload as MqttPublishMessage;
      final String topic = c[0].topic;
      final String pt = const Utf8Decoder().convert(recMess.payload.message);
      String desString = "topic is <$topic>, payload is <-- $pt -->";
      debugPrint("string =$desString");
      String result = pt.substring(0, pt.length - 1);
      Map datas = jsonDecode(result);
      var message = datas["data"];
      ToastUtils.toast(message);
      final progress = ProgressHUD.of(context);
      if (message == "Success") {
        getTableData();
        progress!.dismiss();
        Future.delayed(const Duration(seconds: 2), () {
          Get.back(result: message);
        });
      }
    });
  }

  getTableData() {
    final sessionId = StringUtil.generateRandomString(10);
    var topic = "cpe/$sn";
    var parameters = {
      "event": "mqtt2sodTable",
      "sn": sn,
      "sessionId": sessionId,
      "param": {"method": "get", "table": "FwParentControlTable"}
    };
    _publishMessage(topic, parameters);
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
    debugPrint("===$topic===$message=======");
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
            "Time",
            style: TextStyle(
                fontSize: 22, color: Colors.black, fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
        ),
        body: ProgressHUD(
          child: Builder(builder: ((context) {
            return Container(
              height: double.infinity,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(242, 242, 247, 1),
              ),
              child: Stack(
                children: [
                  SingleChildScrollView(
                      child: Column(
                    children: [
                      createTimeRange(),
                      const SizedBox(
                        height: 20,
                      ),
                      setUpWeeklyView(),
                    ],
                  )),
                  Positioned(
                      left: 80,
                      right: 80,
                      bottom: 20,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                            EdgeInsets.only(top: 28.w, bottom: 28.w),
                          ),
                          shape:
                              MaterialStateProperty.all(const StadiumBorder()),
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 30, 104, 233)),
                        ),
                        onPressed: () {
                          final startT =
                              '${selectedStartTime.hour}:${selectedStartTime.minute.toString().padLeft(2, '0')}';
                          final endT =
                              '${selectedEndTime.hour}:${selectedEndTime.minute.toString().padLeft(2, '0')}';
                          final weeks = checkWeeks.join(",");
                          final progress = ProgressHUD.of(context);
                          progress?.show();
                          uploadDeviceTimeConfig(
                              context, sn, weeks, startT, endT, macAddress);
                        },
                        child: Text(
                          "Submit",
                          style: TextStyle(
                              fontSize: 32.sp, color: const Color(0xffffffff)),
                        ),
                      ))
                ],
              ),
            );
          })),
        ));
  }

  Widget createTimeRange() {
    return Container(
      margin: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          border:
              Border(bottom: BorderSide(width: 1, color: Color(0xffe5e5e5)))),
      child: Column(
        children: [
          const SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Starting time',
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
                SizedBox(
                  width: 5,
                ),
                Text('End Time',
                    style: TextStyle(color: Colors.black, fontSize: 14)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                '${selectedStartTime.hour}:${selectedStartTime.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              const Text(
                '--',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                  '${selectedEndTime.hour}:${selectedEndTime.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FilledButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 30, 104, 233))),
                onPressed: _showStartTimePicker,
                child: const Text('Pick a Time'),
              ),
              FilledButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 30, 104, 233))),
                onPressed: _showEndTimePicker,
                child: const Text('Pick a Time'),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget setUpWeeklyView() {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15),
      decoration: const BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(width: 1, color: Color(0xffe5e5e5))),
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: weeks.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      bottom: BorderSide(width: 1, color: Color(0xffe5e5e5)))),
              child: CheckboxListTile(
                value: checked[index],
                side: const BorderSide(color: Colors.grey),
                checkColor: Colors.white,
                activeColor: Colors.green,
                title: Text(
                  weeks[index],
                  style: const TextStyle(fontSize: 15, color: Colors.black),
                ),
                controlAffinity: ListTileControlAffinity.trailing,
                onChanged: (isChecked) {
                  setState(() {
                    checked[index] = isChecked!;
                    if (isChecked) {
                      checkWeeks.add(ruleWeeks[index]);
                      debugPrint("当前选中的星期是:$checkWeeks");
                    } else {
                      checkWeeks.remove(ruleWeeks[index]);
                      debugPrint("当前选中的星期是:$checkWeeks");
                    }
                  });
                },
              ),
            );
          }),
    );
  }

  @override
  void dispose() {
    client.disconnect();
    super.dispose();
  }
}
