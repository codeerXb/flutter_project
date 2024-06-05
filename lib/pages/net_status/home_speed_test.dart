import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_internet_speed_test/flutter_internet_speed_test.dart';
import 'package:flutter_template/core/utils/toast.dart';
import '../.././core/utils/string_util.dart';
import 'package:get/get.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:network_info_plus/network_info_plus.dart';
import '../topo/model/terminal_equipment_bean.dart';
import 'package:flutter_template/core/http/http_app.dart';
import '../../config/base_config.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import '../../pages/net_status/beans/speed_bean.dart';
import "../../core/utils/logger.dart";

String Id_Random = StringUtil.generateRandomString(10);
MqttServerClient client = MqttServerClient.withPort(
    BaseConfig.mqttMainUrl, 'client_$Id_Random', BaseConfig.websocketPort);

class HomeSpeedPage extends StatefulWidget {
  const HomeSpeedPage({super.key});

  @override
  State<HomeSpeedPage> createState() => _HomeSpeedPageState();
}

class _HomeSpeedPageState extends State<HomeSpeedPage> {
  final internetSpeedTest = FlutterInternetSpeedTest()..enableLog();
  String random = StringUtil.generateRandomString(10);
  bool _testInProgress = false;
  double _downloadRate = 0;
  double _uploadRate = 0;
  String _unitText = 'Mbps';

  String downUrl = "";
  String upLoadUrl = "";

  String diviceName = "";
  String sn = "";
  String deviceName = "";

  String testUp = '---';
  String testDown = '---';

  @override
  void initState() {
    sharedGetData('deviceSn', String).then(((res) {
      printInfo(info: 'deviceSn$res');
      sn = res.toString();
      getCurrentDeviceIp(sn);
      requestTestSpeedData(sn);
    }));

    setState(() {
      var baseUrl = Get.arguments["lanspeedUrl"] as String;
      if (baseUrl.isEmpty) {
        downUrl = "http://192.168.1.1/pub/downloading?n=$random";
        upLoadUrl = "http://192.168.1.1/pub/upload?n=$random";
      } else {
        downUrl = "http://$baseUrl/pub/downloading?n=$random";
        upLoadUrl = "http://$baseUrl/pub/upload?n=$random";
      }
    });

    routerSpeedTestF();
    super.initState();
  }

  getCurrentDeviceIp(String sn) {
    final info = NetworkInfo();
    info.getWifiIP().then((wifiIp) {
      debugPrint('当前wifi的iP地址$wifiIp');
      requestEquipmentList(sn, wifiIp!);
    });
  }

  requestEquipmentList(String sn, String ipAddress) {
    Map<String, dynamic> data = {'sn': sn};
    App.post('/cpeMqtt/getDevicesTable', data: data).then((res) {
      final model = TerminalEquipmentBean.fromJson(jsonDecode(res));
      if (model.code == 200 && model.data!.wifiDevices != null) {
        for (WifiDevices element in model.data!.wifiDevices!) {
          if (element.iPAddress == ipAddress) {
            setState(() {
              if (element.name!.isNotEmpty) {
                if(element.name == "*") {
                  deviceName = "Unknown Device";
                }else {
                  deviceName = element.name!;
                }
                
              } else {
                deviceName = "Unknown Device";
              }
            });
          }
          continue;
        }
      }
    }).catchError((error) {
      ToastUtils.error(error.toString());
    });
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
      XLogger.getLogger().d("string =$desString");
      final payloadModel = SpeedModel.fromJson(jsonDecode(result));
      if (payloadModel.data != null) {
        setState(() {
          _testInProgress = false;
          deviceName = sn;
          testUp = StringUtil.getUnitlessRate(payloadModel.data!.upload!);
          testDown = StringUtil.getUnitlessRate(payloadModel.data!.download!);
          XLogger.getLogger().d("数据是:$testUp -- $testDown");
        });
      }else {
        Future.delayed(const Duration(seconds: 3),(){
          setState(() {
            _testInProgress = false;

          testUp = StringUtil.getUnitlessRate(0);
          testDown = StringUtil.getUnitlessRate(0);
          });
        });
      }
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
    debugPrint("===$topic ===$message=======");
    var builder = MqttClientPayloadBuilder();
    var jsonData = json.encode(message);
    builder.addUTF8String(jsonData);

    client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }

/**
 * http://192.168.1.1/pub/downloading?n=0.8968550196060845
  http://192.168.1.1/pub/upload?n=0.7035157222346089
 */

  void routerSpeedTestF() async {
    await internetSpeedTest.startTesting(
        useFastApi: true,
        downloadTestServer: downUrl,
        uploadTestServer: upLoadUrl,
        onStarted: () {
          setState(() => _testInProgress = true);
        },
        onCompleted: (TestResult download, TestResult upload) {
          if (kDebugMode) {
            XLogger.getLogger().d('the transfer rate ${download.transferRate}, ${upload.transferRate}');
          }
          setState(() {
            _downloadRate = download.transferRate;
            _unitText = download.unit == SpeedUnit.kbps ? 'Kbps' : 'Mbps';
          });
          setState(() {
            _uploadRate = upload.transferRate;
            _unitText = upload.unit == SpeedUnit.kbps ? 'Kbps' : 'Mbps';
            _testInProgress = false;
          });

          Future.delayed(const Duration(seconds: 5), () {
            setState(() {
              _testInProgress = true;
              deviceName = sn;
            });
          });
        },
        onProgress: (double percent, TestResult data) {
          if (kDebugMode) {
            print('the transfer rate $data.transferRate, the percent $percent');
          }
          setState(() {
            _unitText = data.unit == SpeedUnit.kbps ? 'Kbps' : 'Mbps';
            if (data.type == TestType.download) {
              _downloadRate = data.transferRate;
            } else {
              _uploadRate = data.transferRate;
            }
          });
        },
        onError: (String errorMessage, String speedTestError) {
          if (kDebugMode) {
            XLogger.getLogger().e('the errorMessage $errorMessage, the speedTestError $speedTestError');
          }
          // reset();
        },
        onDefaultServerSelectionInProgress: () {},
        onDefaultServerSelectionDone: (Client? client) {},
        onDownloadComplete: (TestResult data) {
          setState(() {
            _downloadRate = data.transferRate;
            _unitText = data.unit == SpeedUnit.kbps ? 'Kbps' : 'Mbps';
          });
        },
        onUploadComplete: (TestResult data) {
          setState(() {
            _uploadRate = data.transferRate;
            _unitText = data.unit == SpeedUnit.kbps ? 'Kbps' : 'Mbps';
          });
        },
        onCancel: () {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.white,
        elevation: 1.0,
        centerTitle: true,
        title: const Text(
          'SpeedTest',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
          textScaler: TextScaler.noScaling,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Testing speed to',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.normal,
                ),
                textScaler: TextScaler.noScaling,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                deviceName,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
                textScaler: TextScaler.noScaling,
              ),
              const SizedBox(
                height: 10,
              ),
              _testInProgress
                  ? const Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Color.fromRGBO(215, 220, 220, 0.3),
                      ),
                    )
                  : Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.asset(
                                      "assets/images/speed_down.png",
                                      width: 25,
                                      height: 25,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      testDown,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                          textScaler: TextScaler.noScaling,
                                    ),
                                  ],
                                ),
                                Text('$_unitText Download',textScaler: TextScaler.noScaling,),
                              ],
                            ),
                            Image.asset(
                              "assets/images/speed_route.png",
                              width: 130,
                              height: 210,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.asset(
                                      "assets/images/speed_upload.png",
                                      width: 25,
                                      height: 25,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      testUp,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                          textScaler: TextScaler.noScaling,
                                    ),
                                  ],
                                ),
                                Text('$_unitText Upload',textScaler: TextScaler.noScaling,),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 16,
                            ),
                            Transform.translate(
                              offset: Platform.isAndroid ? const Offset(1.5, -16) : const Offset(1.6, -16),
                              child: Image.asset(
                                "assets/images/speed_device.png",
                                width: 130,
                                height: 210,
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.asset(
                                      "assets/images/speed_down.png",
                                      width: 25,
                                      height: 25,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      '$_downloadRate',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                          textScaler: TextScaler.noScaling,
                                    ),
                                  ],
                                ),
                                Text('$_unitText Download',textScaler: TextScaler.noScaling,),
                              ],
                            ),
                            Transform.translate(
                                offset: Platform.isAndroid ? const Offset(0.5, -32) : const Offset(0, -32),
                                child: Image.asset(
                                  "assets/images/speed_mobile.png",
                                  width: 130,
                                  height: 210,
                                ),
                            ),

                            Column(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.asset(
                                      "assets/images/speed_upload.png",
                                      width: 25,
                                      height: 25,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      '$_uploadRate',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                          textScaler: TextScaler.noScaling,
                                    ),
                                  ],
                                ),
                                Text('$_unitText Upload',textScaler: TextScaler.noScaling,),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    client.disconnect();
    super.dispose();
  }
}
