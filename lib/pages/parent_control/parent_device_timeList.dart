import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import '../.././core/utils/string_util.dart';
import '../../config/base_config.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import "./Model/time_config_list.dart";

String clientRandom = StringUtil.generateRandomString(10);
String clientId = "client_$clientRandom";

class TimeConfigListPage extends StatefulWidget {
  const TimeConfigListPage({super.key});

  @override
  State<TimeConfigListPage> createState() => _TimeConfigListPageState();
}

class _TimeConfigListPageState extends State<TimeConfigListPage> {
  MqttServerClient client = MqttServerClient.withPort(
      BaseConfig.mqttMainUrl, clientId, BaseConfig.websocketPort);
  String sn = "";
  String subTopic = "";
  RxList deviceList = [].obs;
  TimeConfigListBeans? datas;
  bool? cancheck = false;

  bool loading = false;
  bool _isOpen = false;

  @override
  void initState() {
    sharedGetData('deviceSn', String).then(((res) {
      printInfo(info: 'deviceSn$res');
      sn = res.toString();
      requestData(sn);
    }));
    super.initState();
  }

  void requestData(String sn) async {
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
      "event": "mqtt2sodTable",
      "sn": sn,
      "sessionId": sessionIdStr,
      "param": {"method": "get", "table": "FwParentControlTable"}
    };

    _publishMessage(publishTopic, parms);

    subTopic = "app/parentControl/allTime/$sn";
    client.subscribe(subTopic, MqttQos.atLeastOnce);

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final MqttPublishMessage recMess = c![0].payload as MqttPublishMessage;
      final String topic = c[0].topic;
      final String pt = const Utf8Decoder().convert(recMess.payload.message);
      String desString = "topic is <$topic>, payload is <-- $pt -->";
      debugPrint("string =$desString");
      if (topic == subTopic) {
        final timeListModel = TimeConfigListBeans.fromJson(jsonDecode(pt));
        debugPrint("时间列表数据:$timeListModel");
        if (timeListModel.param != null && timeListModel.param!.isNotEmpty) {
          setState(() {
            loading = true;
            datas = timeListModel;
          });
        }
      }else {
        String result = pt.substring(0, pt.length - 1);
        Map datas = jsonDecode(result);
        var res = datas["data"];
        debugPrint("时间规则设置结果 =$res");
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
    debugPrint("===$topic===$message=======");
    var builder = MqttClientPayloadBuilder();
    var jsonData = json.encode(message);
    builder.addUTF8String(jsonData);
    client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }

  setTimeRulesEffected() {
    final sessionId = StringUtil.generateRandomString(10);
    var topic = "cpe/$sn";
    var pubtopic = "cpe/$sn/setTimeRule";
    var parameters = {
      "event": "mqtt2sodObj",
      "sn": sn,
      "sessionId": sessionId,
      "pubTopic": pubtopic,
      "param": {
        "method": "set",
        "nodes": {"securityParentControlEnable": _isOpen == true ? "1" : '0'}
      }
    };
    _publishMessage(topic, parameters);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Use Time Configure',
            style: TextStyle(
                color: Colors.black, fontSize: 22, fontWeight: FontWeight.w500),
                textScaler: TextScaler.noScaling
          ),
          centerTitle: true,
          actions: [
            FlutterSwitch(
              width: 70.0,
              height: 40.0,
              activeText: "ON",
              inactiveText: "OFF",
              activeColor: Colors.green,
              activeTextColor: Colors.white,
              inactiveTextColor: Colors.blue[50]!,
              value: _isOpen,
              valueFontSize: 12.0,
              borderRadius: 30.0,
              showOnOff: true,
              onToggle: (val) {
                setState(() {
                  _isOpen = val;
                  setTimeRulesEffected();
                });
              },
            )
          ],
          backgroundColor: Colors.white,
        ),
        body: loading
            ? Container(
                height: double.infinity,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(242, 242, 247, 1),
                  // borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                padding: const EdgeInsets.only(bottom: 20),
                child: Stack(
                  children: [
                    SingleChildScrollView(
                        child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minHeight: 100,
                        // maxHeight: 100000
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 15, 30),
                            child: datas == null
                                ? Container()
                                : SizedBox(
                                    child: ListView.separated(
                                      padding: const EdgeInsets.only(
                                          top: 10, bottom: 10),
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: datas!.param?.length ?? 0,
                                      itemBuilder: (context, index) {
                                        return setUpContentView(
                                            datas!.param![index].deviceName!,
                                            datas!
                                                .param![index].deviceTimeRule!,
                                            datas!.param![index].mac);
                                      },
                                      separatorBuilder: (context, index) {
                                        return const SizedBox(
                                          height: 10,
                                        );
                                      },
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              )
            : const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Color.fromRGBO(215, 220, 220, 0.3),
                ),
              ));
  }

  Widget setUpContentView(
      String deviceName, List<DeviceTimeRule> timeArray, String? macAddress) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      // decoration: const BoxDecoration(
      //     color: Colors.white,
      //     borderRadius: BorderRadius.all(Radius.circular(8.0)),
      //     border:
      //         Border(bottom: BorderSide(width: 1, color: Color(0xffe5e5e5)))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0)),
                border: Border(
                    bottom: BorderSide(width: 1, color: Color(0xffe5e5e5)))),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    deviceName,
                    style: const TextStyle(fontSize: 15, color: Colors.black),
                    textScaler: TextScaler.noScaling
                  ),
                  IconButton(
                      onPressed: () {
                        Get.toNamed("/websiteTimeListPage",
                            arguments: {"mac": macAddress});
                      },
                      icon: Image.asset(
                        "assets/images/edit_parent.png",
                        width: 20,
                        height: 20,
                      ))
                ],
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: timeConfigListView(timeArray),
          ),
        ],
      ),
    );
  }

  Widget timeConfigListView(List<DeviceTimeRule> times) {
    return times.isNotEmpty
        ? Container(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  "assets/images/time_parent.png",
                  width: 20,
                  height: 20,
                ),
                const SizedBox(
                  width: 15,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: timeListItemCell(times),
                )
              ],
            ),
          )
        : Container();
  }

  List<Widget> timeListItemCell(List<DeviceTimeRule> timeConfigs) {
    List<Widget> listTime = [];
    for (DeviceTimeRule item in timeConfigs) {
      listTime.add(SizedBox(
        height: 30,
        child: Text("${item.timeStart} - ${item.timeStop} ${item.weekdays}",
            style: const TextStyle(fontSize: 12, color: Colors.black),textScaler: TextScaler.noScaling),
      ));
    }
    return listTime;
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
            "Loading, please wait",
            style: TextStyle(fontSize: 15, color: Colors.black),
            textScaler: TextScaler.noScaling
          )
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
