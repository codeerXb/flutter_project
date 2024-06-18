import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:get/get.dart';
import '../.././core/utils/string_util.dart';
import '../../config/base_config.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import "./Model/black_config_list_bean.dart";

String clientRandom = StringUtil.generateRandomString(10);
String clientId = "client_$clientRandom";

class ParentDevicePage extends StatefulWidget {
  const ParentDevicePage({super.key});

  @override
  State<ParentDevicePage> createState() => _ParentDevicePageState();
}

class _ParentDevicePageState extends State<ParentDevicePage> {
  MqttServerClient client = MqttServerClient.withPort(
      BaseConfig.mqttMainUrl, clientId, BaseConfig.websocketPort);
  bool? cancheck = false;
  String sn = "";
  String subTopic = "";
  BlackListConfigBeans? blackConfigModel;

  bool loading = false;

  @override
  void initState() {
    sharedGetData('deviceSn', String).then(((res) {
      printInfo(info: 'deviceSn$res');
      sn = res.toString();
      requestBlackConfigList(sn);
    }));
    super.initState();
  }

  requestBlackConfigList(String sn) async {
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
      "event": "ParentControl",
      "sn": sn,
      "sessionId": sessionIdStr,
      "param": {
        "method": "get",
        "data": {"config": "appfilter2"}
      }
    };

    _publishMessage(publishTopic, parms);
    subTopic = "app/parentControl/allBlackList/$sn";
    client.subscribe(subTopic, MqttQos.atLeastOnce);

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final MqttPublishMessage recMess = c![0].payload as MqttPublishMessage;
      final String topic = c[0].topic;
      final String pt = const Utf8Decoder().convert(recMess.payload.message);
      String desString = "topic is <$topic>, payload is <-- $pt -->";
      debugPrint("string =$desString");
      final blackListBean = BlackListConfigBeans.fromJson(jsonDecode(pt));
      debugPrint("规则列表数据:$blackListBean");
      if (blackListBean.param != null && blackListBean.param!.isNotEmpty) {
        setState(() {
          loading = true;
          blackConfigModel = blackListBean;
        });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Blacklist Configure',
            style: TextStyle(
                color: Colors.black, fontSize: 22, fontWeight: FontWeight.w500),
                textScaler: TextScaler.noScaling
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: loading ? Container(
          height: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.black12,
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
                      child: blackConfigModel != null
                          ? ListView.separated(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: blackConfigModel!.param!.length,
                                itemBuilder: (context, index) {
                                  return setUpContentView(
                                      blackConfigModel!
                                          .param![index].deviceName!,
                                      blackConfigModel!
                                          .param![index].deviceRule!,
                                      blackConfigModel!.param![index].mac!);
                                },
                                separatorBuilder: (context, index) {
                                  return const Divider(
                                    height: 10,
                                    thickness: 0,
                                    color: Colors.black12,
                                  );
                                },
                              )
                          : Container(),
                    ),
                  ],
                ),
              )),
              // Positioned(
              //   left: 80,
              //   right: 80,
              //   bottom: 20,
              //   child: ElevatedButton(
              //     style: ButtonStyle(
              //       padding: MaterialStateProperty.all(
              //         EdgeInsets.only(top: 28.w, bottom: 28.w),
              //       ),
              //       shape: MaterialStateProperty.all(const StadiumBorder()),
              //       backgroundColor: MaterialStateProperty.all(
              //           const Color.fromARGB(255, 30, 104, 233)),
              //     ),
              //     onPressed: () {
              //       Get.toNamed("/websiteTimeListPage");
              //     },
              //     child: Text(
              //       "Next Step",
              //       style: TextStyle(
              //           fontSize: 32.sp, color: const Color(0xffffffff)),
              //     ),
              //   ),
              // ),
            ],
          ),
        ): const Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Color.fromRGBO(215, 220, 220, 0.3),
                      ),
                    ));
  }

  Widget setUpContentView(
      String deviceName, DeviceRule contentTypes, String mac) {
    return ClipRRect(
      // padding: const EdgeInsets.only(bottom: 2),
      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      // decoration: const BoxDecoration(
      //     color: Colors.white,
      //     borderRadius: BorderRadius.all(Radius.circular(8.0)),
      //     border: Border(bottom: BorderSide(width: 1, color: Colors.black12))
      //     ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: const BoxDecoration(
                color: Colors.white,
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
                  ),
                  IconButton(
                      onPressed: () {
                        String methodType = "";
                        if (contentTypes.appStore!.isEmpty &&
                            contentTypes.socialMedia!.isEmpty &&
                            contentTypes.video!.isEmpty &&
                            contentTypes.eCommercePortalAccessTimes!.isEmpty &&
                            contentTypes.websiteList!.isEmpty) {
                          methodType = "add";
                        } else {
                          methodType = "set";
                        }
                        Get.toNamed("/parentConfigPage",
                            arguments: {"mac": mac, "method": methodType})?.then((value){
                              if(value == "success") {
                                Stream.periodic(const Duration(seconds: 1)).take(1).listen((event) {
                                  requestBlackConfigList(sn);
                                });
                                
                              }
                            });
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
            padding: const EdgeInsets.only(bottom: 10),
            decoration: const BoxDecoration(
                color: Colors.white,
                ),
            child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: buildSelectedContent(contentTypes),
          ),
          )
        ],
      ),
    );
  }

  List<Widget> buildSelectedContent(DeviceRule contents) {
    List<Widget> seles = [];
    var imgName = "";
    // var allTypeNames = <String>[];
    if (contents.appStore != null && contents.appStore!.isNotEmpty) {
      imgName = "assets/images/app store.png";
      var appNames = <String>[];
      for (CategoryInfo element in contents.appStore!) {
        appNames.add(element.appName!);
      }
      var appString = appNames.join(",");
      seles.add(SizedBox(height: 40, child: ListTile(
        leading: Image.asset(
          imgName,
          width: 15,
          height: 15,
        ),
        title: Text(
          appString,
          style: const TextStyle(fontSize: 12, color: Colors.black),
          overflow: TextOverflow.ellipsis,
          softWrap: false,
          textScaler: TextScaler.noScaling
        ),
      )));
    }

    if (contents.socialMedia != null && contents.socialMedia!.isNotEmpty) {
      imgName = "assets/images/social media.png";
      var appNames = <String>[];
      for (CategoryInfo element in contents.socialMedia!) {
        appNames.add(element.appName!);
      }
      var appString = appNames.join(",");
      seles.add(SizedBox(height: 40,child: ListTile(
        leading: Image.asset(
          imgName,
          width: 15,
          height: 15,
        ),
        title: Text(
          appString,
          style: const TextStyle(fontSize: 12, color: Colors.black),
          overflow: TextOverflow.ellipsis,
          softWrap: false,
          textScaler: TextScaler.noScaling
        ),
      ),));
    }

    if (contents.video != null && contents.video!.isNotEmpty) {
      imgName = "assets/images/video.png";
      var appNames = <String>[];
      for (CategoryInfo element in contents.video!) {
        appNames.add(element.appName!);
      }
      var appString = appNames.join(",");
      seles.add(SizedBox(height: 40,child: ListTile(
        leading: Image.asset(
          imgName,
          width: 15,
          height: 15,
        ),
        title: Text(
          appString,
          style: const TextStyle(fontSize: 12, color: Colors.black),
          overflow: TextOverflow.ellipsis,
          softWrap: false,
          textScaler: TextScaler.noScaling
        ),
      ),));
    }

    if (contents.eCommercePortalAccessTimes != null &&
        contents.eCommercePortalAccessTimes!.isNotEmpty) {
      imgName = "assets/images/shopping.png";
      var appNames = <String>[];
      for (CategoryInfo element in contents.eCommercePortalAccessTimes!) {
        appNames.add(element.appName!);
      }
      var appString = appNames.join(",");
      seles.add(SizedBox(height: 40,child: ListTile(
        leading: Image.asset(
          imgName,
          width: 15,
          height: 15,
        ),
        title: Text(
          appString,
          style: const TextStyle(fontSize: 12, color: Colors.black),
          overflow: TextOverflow.ellipsis,
          softWrap: false,
          textScaler: TextScaler.noScaling
        ),
      )));
    }

    if (contents.websiteList != null && contents.websiteList!.isNotEmpty) {
      imgName = "assets/images/weblist.png";
      var appNames = <String>[];
      for (CategoryInfo element in contents.websiteList!) {
        appNames.add(element.appName!);
      }
      var appString = appNames.join(",");
      seles.add(SizedBox(height: 40,child: ListTile(
        leading: Image.asset(
          imgName,
          width: 15,
          height: 15,
        ),
        title: Text(
          appString,
          style: const TextStyle(fontSize: 12, color: Colors.black),
          overflow: TextOverflow.ellipsis,
          softWrap: false,
          textScaler: TextScaler.noScaling
        ),
      )));
    }

    return seles;
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
