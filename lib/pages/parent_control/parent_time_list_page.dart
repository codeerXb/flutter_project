import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_template/core/http/http_app.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:flutter_template/core/utils/toast.dart';
import '../.././core/utils/string_util.dart';
import '../../config/base_config.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:get/get.dart';
import './Model/time_list_beans.dart';

String clientRandom = StringUtil.generateRandomString(10);
String clientId = "client_$clientRandom";

class ParentTimeListPage extends StatefulWidget {
  const ParentTimeListPage({super.key});

  @override
  State<ParentTimeListPage> createState() => _ParentTimeListPageState();
}

class _ParentTimeListPageState extends State<ParentTimeListPage> {
  MqttServerClient client = MqttServerClient.withPort(
      BaseConfig.mqttMainUrl, clientId, BaseConfig.websocketPort);
  List<TimeInfoBean> timeList = [];
  String macAddress = "";
  String sn = "";
  String subTopic = "";

  @override
  void initState() {
    macAddress = Get.arguments["mac"];
    sharedGetData('deviceSn', String).then(((res) {
      printInfo(info: 'deviceSn$res');
      sn = res.toString();
      requestSingleDeviceTime(sn);
    }));

    super.initState();
  }

  void requestSingleDeviceTime(String sn) {
    App.get('/platform/parentControlApp/queryTimeRuleBySnAndMac?sn=$sn&mac=$macAddress')
        .then((res) {
      final timeListModel = TimeListBeans.fromJson(res);
      if (timeListModel.code == 200 && timeListModel.data != null) {
        setState(() {
          timeList = timeListModel.data!;
        });
        debugPrint("获取的时间配置列表:$timeList");
      } else {
        ToastUtils.toast(timeListModel.message!);
      }
    }).catchError((error) {
      ToastUtils.error(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Time",
          style: TextStyle(
              fontSize: 22, color: Colors.black, fontWeight: FontWeight.w500),
              textScaler: TextScaler.noScaling
        ),
        centerTitle: true,
        actions: [
          SizedBox(
            width: 40,
            height: 40,
            child: IconButton(
              icon: const Icon(
                Icons.add_circle,
                color: Colors.green,
                size: 30,
              ),
              onPressed: () {
                if (timeList.length < 5) {
                  Get.toNamed("/websiteCreatTimePage",
                      arguments: {"mac": macAddress})?.then((value){
                        if (value == "Success") {
                          requestSingleDeviceTime(sn);
                        }
                        
                      });
                } else {
                  ToastUtils.toast(
                      "Supports up to 5 time configuration plans.");
                }
              },
            ),
          ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
            color: Color.fromRGBO(242, 242, 247, 1),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            border:
                Border(bottom: BorderSide(width: 1, color: Color(0xffe5e5e5)))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: const ScrollPhysics(),
                    itemCount: timeList.length,
                    itemBuilder: (BuildContext context, timeIndex) {
                      return setUpTimeContent(timeList, timeIndex);
                    })),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Supports up to 5 time configuration plans.",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }

  Widget setUpTimeContent(List<TimeInfoBean> timeArray, int index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            border:
                Border(bottom: BorderSide(width: 1, color: Color(0xffe5e5e5)))),
        child: ListTile(
          leading: Image.asset(
            "assets/images/time_parent.png",
            width: 20,
            height: 20,
          ),
          title: Text(
            "${timeArray[index].timeStart} - ${timeArray[index].timeStop}",
            style: const TextStyle(
                fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
                textScaler: TextScaler.noScaling
          ),
          subtitle: Text(
            "${timeArray[index].weekdays}",
            style: const TextStyle(fontSize: 12, color: Colors.black),
            textScaler: TextScaler.noScaling
          ),
          trailing: Transform(
            transform: Matrix4.translationValues(16, 0, 0),
            child: IconButton(
              onPressed: () {
                //delete
                setState(() {
                  debugPrint("获取的列表索引:$index -- 删除的选项id是:${timeArray[index].id}");
                  final indexId = timeArray[index].id;
                  delDeviceTimeAction(sn, indexId);
                  timeArray.removeAt(index);
                });
              },
              icon: Image.asset(
                "assets/images/delete2.png",
                width: 25,
                height: 25,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> setupTimeListView(List<TimeInfoBean> timeArray) {
    List<Widget> widgets = [];
    for (int i = 0; i < timeArray.length; i++) {
      widgets.add(Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                  bottom: BorderSide(width: 1, color: Color(0xffe5e5e5)))),
          child: ListTile(
            leading: Image.asset(
              "assets/images/time_parent.png",
              width: 20,
              height: 20,
            ),
            title: Text(
              "${timeArray[i].timeStart} - ${timeArray[i].timeStop}",
              style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
                  textScaler: TextScaler.noScaling
            ),
            subtitle: Text(
              "${timeArray[i].weekdays}",
              style: const TextStyle(fontSize: 12, color: Colors.black),
              textScaler: TextScaler.noScaling
            ),
            trailing: Transform(
              transform: Matrix4.translationValues(16, 0, 0),
              child: IconButton(
                onPressed: () {
                  //delete
                  setState(() {
                    timeList.removeAt(i);
                    delDeviceTimeAction(sn, timeArray[i].id);
                  });
                },
                icon: Image.asset(
                  "assets/images/delete2.png",
                  width: 25,
                  height: 25,
                ),
              ),
            ),
          ),
        ),
      ));
    }
    return widgets;
  }

  delDeviceTimeAction(String sn, String? id) async {
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
    subTopic = "cpe/$sn/delTime";
    var parms = {
      "event": "mqtt2sodTable",
      "sn": sn,
      "sessionId": sessionIdStr,
      "pubTopic": subTopic,
      "param": {
        "method": "del",
        "table": {"table": "FwParentControlTable", "id": id}
      }
    };

    _publishMessage(publishTopic, parms);

    client.subscribe(subTopic, MqttQos.atLeastOnce);

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final MqttPublishMessage recMess = c![0].payload as MqttPublishMessage;
      final String topic = c[0].topic;
      final String pt = const Utf8Decoder().convert(recMess.payload.message);
      // String desString = "topic is <$topic>, payload is <-- $pt -->";
      String result = pt.substring(0, pt.length - 1);
      String desString = "topic is <$topic>, payload is <-- $result -->";
      debugPrint("string =$desString");
      Map datas = jsonDecode(result);
      var message = datas["data"];
      ToastUtils.toast(message);
      if (message == "Success") {
        getTableData();
        Future.delayed( const Duration(seconds: 2),() {
          requestSingleDeviceTime(sn);
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
      "param": {
        "method": "get",
        "table": "FwParentControlTable"
      }
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
    debugPrint("===$topic===${jsonEncode(message)}=======");
    var builder = MqttClientPayloadBuilder();
    var jsonData = json.encode(message);
    builder.addUTF8String(jsonData);
    client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }

  @override
  void setState(VoidCallback fn) {
    if(mounted) {
      super.setState(fn);
    }
    
  }

  @override
  void dispose() {
    client.disconnect();
    super.dispose();
  }
}
