import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter_template/core/http/http_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/pages/topo/model/equipment_datas.dart';
import '../../config/base_config.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import '../../core/event_bus/eventbus_utils.dart';
import '../../core/utils/string_util.dart';

String Id_Random = StringUtil.generateRandomString(10);

class AccessControlDevicesPage extends StatefulWidget {
  const AccessControlDevicesPage({super.key});

  @override
  State<AccessControlDevicesPage> createState() =>
      _AccessControlDevicesPageState();
}

class _AccessControlDevicesPageState extends State<AccessControlDevicesPage> {
  MqttServerClient client = MqttServerClient.withPort(
      BaseConfig.mqttMainUrl, "client_$Id_Random", BaseConfig.websocketPort);
  int currentIndex = 0;
  bool loading = true;
  String sn = "";
  EquipmentDatas topoData = EquipmentDatas(onlineDeviceTable: [], max: null);

  @override
  void initState() {
    sharedGetData('deviceSn', String).then(((res) {
      setState(() {
        sn = res.toString();
        getTerminalEquipmentDatas(sn);
      });
    }));
    super.initState();
  }

  Future<void> getTerminalEquipmentDatas(String sn) async {
    try {
      Map<String, dynamic> form = {'sn': sn, "type": "getDevicesTable"};
      var res = await App.post('/cpeMqtt/getDevicesTable', data: form);

      var d = json.decode(res.toString());

      if (d['code'] == 200) {
        if (mounted) {
          setState(() {
            loading = false;
            List<OnlineDeviceTable>? onlineDeviceTable = [];
            int id = 0;
            d['data']['wifiDevices'].addAll(d['data']['lanDevices']);
            if ((d['data']['wifiDevices'] as List).isNotEmpty) {
              d['data']['wifiDevices'].forEach((item) {
                OnlineDeviceTable device = OnlineDeviceTable.fromJson({
                  'id': id,
                  'LeaseTime': '1',
                  'Type': item['connection'] ?? 'LAN',
                  'HostName': item['name'],
                  'IP': item['IPAddress'],
                  'MAC': item['MACAddress'] ?? item['MacAddress']
                });
                onlineDeviceTable.add(device);
                id++;
              });
              topoData = EquipmentDatas(
                  onlineDeviceTable: onlineDeviceTable, max: 255);
            }

            // ToastUtils.toast(S.current.success);
          });
        }
      }
    } catch (err) {
      debugPrint(err.toString());
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  requestParentCofingStatus(String sn,String selMac) async {
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
    var configTopicStr = "cpe/$sn-addDevice";
    var configParms = {
      "event": "mqtt2sodTable",
      "sn": sn,
      "sessionId": sessionIdConfig,
      "pubTopic": configTopicStr,
      "param": {
        "method": "add",
        "table":{"table":"WiFiAccessTable","value":{"MAC":selMac}}
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
      String result = pt.substring(0, pt.length - 1);
      debugPrint("string =$desString");
      Map datas = jsonDecode(result);
      var resultMeg = datas["data"];
      if (resultMeg == "Success") eventBus.fire("addDeviceSuccess");
      ToastUtils.toast(resultMeg);
      debugPrint("结果 =$resultMeg");
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
          "Select Device",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          ListView.builder(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 60),
              itemCount: topoData.onlineDeviceTable!.length,
              itemBuilder: (BuildContext context, int index) {
                return RadioListTile(
                  value: index,
                  groupValue: currentIndex,
                  title: Text(
                    "${topoData.onlineDeviceTable![index].hostName}",
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.left,
                  ),
                  // subtitle: const Text(
                  //   "加入黑名单的设备会被自动拦截",
                  //   style: TextStyle(
                  //       fontSize: 14,
                  //       fontWeight: FontWeight.w600),
                  //   textAlign: TextAlign.left,
                  // ),
                  activeColor: Colors.green,
                  onChanged: (int? value) {
                    setState(() {
                      currentIndex = value!;
                    });
                  },
                );
              }),
          Positioned(
              bottom: 20.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 40.0,
                  child: OutlinedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              const MaterialStatePropertyAll(Colors.blue),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)))),
                      onPressed: () {
                        requestParentCofingStatus(sn,topoData.onlineDeviceTable![currentIndex].mac!);

                      },
                      child: const Text("Confirm",
                          style: TextStyle(color: Colors.white, fontSize: 14))),
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
