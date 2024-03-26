import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http_app.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:flutter_template/core/widget/custom_app_bar.dart';
import 'package:flutter_template/pages/toolbar/toolbar_controller.dart';
import 'package:flutter_template/pages/topo/model/equipment_datas.dart';
import 'package:get/get.dart';
import '../../generated/l10n.dart';
import '../../core/utils/string_util.dart';
import '../../../config/base_config.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

String clientRandom = StringUtil.generateRandomString(10);
String clientId = "client_$clientRandom";

class AccessEquipment extends StatefulWidget {
  const AccessEquipment({super.key});

  @override
  State<AccessEquipment> createState() => _AccessEquipmentState();
}

class _AccessEquipmentState extends State<AccessEquipment> {
  MqttServerClient client = MqttServerClient.withPort(
      BaseConfig.mqttMainUrl, clientId, BaseConfig.websocketPort);
  String subTopic = "";
  OnlineDeviceTable data = OnlineDeviceTable(mac: '');
  int day = 0;
  int hour = 0;
  int min = 0;
  String sn = '';
  String navName = '';
  bool _switchValue = false;
  String deviceId = "";
  String policyType = "";
  bool testLoading = true;

  @override
  void initState() {
    setState(() {
      data = Get.arguments["deviceItemModel"];
      editTitleVal.text = data.hostName.toString();
      navName = (data.hostName.toString() == "" || data.hostName.toString() == "*")? "Unknow Device" : data.hostName.toString();
    });
    super.initState();
    sharedGetData('deviceSn', String).then(((res) {
        setState(() {
          sn = res.toString();
          requestFilterDeviceList(sn, data.mac!);
        });
      }));
    
    if (data.leaseTime != null && data.leaseTime.toString() != "") {
      var time = int.parse(data.leaseTime.toString());
      day = time ~/ (24 * 3600);
      hour = (time - day * 24 * 3600) ~/ 3600;
      min = (time - day * 24 * 3600 - hour * 3600) ~/ 60;
    }
    
  }

  void requestFilterDeviceList(String sn, String macAddress) {
    App.get('/platform/parentControlApp/prepareForQueryMacFilterId?sn=$sn&mac=$macAddress')
        .then((res) {
      // var dict = json.decode(res.toString());
      debugPrint("结果:$res");
      getDisconnectedDeviceListWithId(sn);
    }).catchError((error) {
      ToastUtils.error(error.toString());
    });
  }

  getDisconnectedDeviceListWithId(String sn) async {
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
      "param": {"method": "get", "table": "FwMacFilterTable"}
    };
    final nodePubTopic = "cpe/$sn/nodePubTopic";
    var nodeParms = {
      "event": "mqtt2sodObj",
      "sn": sn,
      "sessionId": sessionIdStr,
      "pubTopic": nodePubTopic,
      "param": {
        "method": "get",
        "nodes": ["securityMacFilterPolicy"]
      }
    };
    _publishMessage(publishTopic, nodeParms);
    _publishMessage(publishTopic, parms);

    client.subscribe(nodePubTopic, MqttQos.atLeastOnce);

    subTopic = "app/macFilterId/$sn";
    client.subscribe(subTopic, MqttQos.atLeastOnce);

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final MqttPublishMessage recMess = c![0].payload as MqttPublishMessage;
      final String topic = c[0].topic;
      final String pt = const Utf8Decoder().convert(recMess.payload.message);
      String desString = "topic is <$topic>, payload is <-- $pt -->";
      if (topic == "app/macFilterId/$sn") {
        debugPrint("监听app/macFilterId的结果是 =$desString");
        Map datas = jsonDecode(pt);
        var id = datas["param"]["id"];
        debugPrint("设备id:$id");
        setState(() {
          testLoading = false;
          deviceId = id;
          _switchValue = deviceControlStatus();
        });
      } else if (topic == "cpe/$sn/FwMacFilterId") {
        debugPrint("监听FwMacFilterId删除的结果是 =$desString");
        final response = pt.substring(0, pt.length - 1);
        Map datas = jsonDecode(response);
        var res = datas["data"];
        debugPrint("删除表操作:$res");
      } else if (topic == "cpe/$sn/FwMacFilterAdd") {
        debugPrint("监听FwMacFilterAdd的结果是 =$desString");
        final response = pt.substring(0, pt.length - 1);
        Map datas = jsonDecode(response);
        var res = datas["data"];
        debugPrint("操作表添加:$res");
      } else if (topic == nodePubTopic) {
        debugPrint("监听securityMacFilterPolicy的结果是 =$desString");
        String result = pt.substring(0, pt.length - 1);
        Map datas = jsonDecode(result);
        final securityPolicy = datas["data"]["securityMacFilterPolicy"];
        debugPrint("设备安全策略:$securityPolicy");
        setState(() {
          policyType = securityPolicy;
        });
        
      } else {}
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

  bool deviceControlStatus() {
    bool netStatus = false;
    if (policyType == "deny") {
      if (deviceId == "") {
        netStatus = true;
      } else {
        netStatus = false;
      }
    } else {
      if (deviceId == "") {
        netStatus = false;
      } else {
        netStatus = true;
      }
    }
    return netStatus;
  }

  void delActionWithTable() {
    final sessionIdStr = StringUtil.generateRandomString(10);
    var publishTopic = "cpe/$sn";
    var subTopic = "cpe/$sn/FwMacFilterId";
    var parms = {
      "event": "mqtt2sodTable",
      "sn": sn,
      "sessionId": sessionIdStr,
      "pubTopic": subTopic,
      "param": {
        "method": "del",
        "table": {"table": "FwMacFilterTable", "id": deviceId}
      }
    };

    _publishMessage(publishTopic, parms);

    client.subscribe(subTopic, MqttQos.atLeastOnce);
  }

  void addActionWithTable() {
    final sessionIdStr = StringUtil.generateRandomString(10);
    var publishTopic = "cpe/$sn";
    var subTopic = "cpe/$sn/FwMacFilterAdd";
    var parms = {
      "event": "mqtt2sodTable",
      "sn": sn,
      "sessionId": sessionIdStr,
      "pubTopic": subTopic,
      "param": {
        "method": "add",
        "table": {
          "table": "FwMacFilterTable",
          "value": {
            "MAC": data.mac,
          }
        }
      }
    };
    _publishMessage(publishTopic, parms);

    client.subscribe(subTopic, MqttQos.atLeastOnce);
  }

//重设名称
  editName(String sn, String mac, String nickname) async {
    Map<String, dynamic> form = {
      'sn': sn,
      'mac': mac,
      'nickname': nickname,
    };
    var res = await App.post('/platform/cpeNick/nick', data: form);

    var d = json.decode(res.toString());
    if (d['code'] != 200) {
      ToastUtils.error(d['message']);
    } else {
      ToastUtils.success(d['message']);
      setState(() {
        navName = editTitleVal.text;
      });
      Get.back();
    }
  }

  final ToolbarController toolbarController = Get.put(ToolbarController());

  final TextEditingController editTitleVal = TextEditingController();

  editDeviceName() {
    //底部弹出Container
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          onPopInvoked: (didPoped) async {
            if (didPoped) {
              return;
            } else {
              Navigator.pop(context);
            }
          },
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                left: 40.w,
                right: 40.w,
                //将在输入框底部添加一个填充，以确保输入框不会被键盘遮挡。
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: 30.w)),

                  //title
                  Text(
                    S.current.ModifyRemarks,
                    style: TextStyle(fontSize: 46.sp),
                  ),
                  Padding(padding: EdgeInsets.only(top: 46.w)),

                  //输入框
                  TextField(
                    autofocus: true,
                    controller: editTitleVal,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 20.w),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: S.current.pleaseEnter,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          // 清空输入框中的内容
                          editTitleVal.clear();
                        },
                      ),
                    ),
                  ),

                  Padding(padding: EdgeInsets.only(top: 20.w)),
                  //btn
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //取消
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            editTitleVal.text = navName;
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(300.w, 70.w),
                        ),
                        child: Text(S.current.cancel),
                      ),
                      //确定
                      ElevatedButton(
                        onPressed: () {
                          if (editTitleVal.text.isNotEmpty) {
                            editName(
                                sn, data.mac.toString(), editTitleVal.text);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(300.w, 70.w),
                        ),
                        child: Text(S.current.confirm),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(
        context: context,
        title: navName,
        actions: [
          //编辑title icon
          InkWell(
            onTap: () {
              editDeviceName();
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.edit_note_outlined,
                color: const Color.fromRGBO(144, 147, 153, 1),
                size: 70.w,
              ),
            ),
          )
        ],
        result: true,
      ),
      body: testLoading
          ? const Center(
              child: CircularProgressIndicator(
                backgroundColor: Color.fromRGBO(215, 220, 220, 0.3),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                  height: 1400.w,
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(240, 240, 240, 1)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(children: [
                        TitleWidger(title: S.current.deviceInfo),
                      ]),
                      InfoBox(
                        boxCotainer: Column(
                          children: [
                            BottomLine(
                                rowtem: RowContainer(
                              leftText: S.current.MACAddress,
                              righText: data.mac.toString(),
                            )),
                            BottomLine(
                                rowtem: RowContainer(
                              leftText: S.of(context).IPAddress,
                              righText: data.iP.toString(),
                            )),
                            BottomLine(
                              rowtem: RowContainer(
                                leftText: S.current.connectionMode,
                                righText: data.type.toString(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.sp),
                      ),
                      const Row(children: [
                        TitleWidger(title: "Device Control"),
                      ]),

                      InfoBox(
                          boxCotainer: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Internet Access ",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                          CupertinoSwitch(
                            value: _switchValue,
                            onChanged: ((value) {
                              if (value == true) {
                                if (policyType == "deny") {
                                  // del
                                  delActionWithTable();
                                } else {
                                  //add
                                  addActionWithTable();
                                }
                              } else {
                                if (policyType == "deny") {
                                  // add
                                  addActionWithTable();
                                } else {
                                  //del
                                  delActionWithTable();
                                }
                              }
                              setState(() {
                                _switchValue = value;
                              });
                            }),
                            activeColor: CupertinoColors.activeGreen,
                          )
                        ],
                      ))
                      // 家长
                      // InfoBox(
                      //   boxCotainer: SizedBox(
                      //     child: GestureDetector(
                      //       behavior: HitTestBehavior.opaque,
                      //       onTap: () {
                      //         Get.toNamed("/parent", arguments: data);
                      //       },
                      //       child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text(S.current.parentalControl,
                      //               style: TextStyle(fontSize: 30.sp)),
                      //           Row(
                      //             children: [
                      //               Icon(
                      //                 Icons.arrow_forward_ios_outlined,
                      //                 color: const Color.fromRGBO(144, 147, 153, 1),
                      //                 size: 30.w,
                      //               )
                      //             ],
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // 游戏
                      // InfoBox(
                      //   boxCotainer: SizedBox(
                      //     child: GestureDetector(
                      //       behavior: HitTestBehavior.opaque,
                      //       onTap: () {
                      //         // ToastUtils.toast(S.current.nogameAcceleration);
                      //         // Get.toNamed("/parental_control", arguments: data);
                      //         Get.snackbar(
                      //           'Warning',
                      //           S.current.nogameAcceleration,
                      //           snackPosition: SnackPosition.TOP,
                      //           duration: const Duration(seconds: 10),
                      //           backgroundColor:
                      //               const Color.fromARGB(132, 63, 63, 63),
                      //           colorText: Colors.white,
                      //           margin: const EdgeInsets.all(10),
                      //           padding: const EdgeInsets.symmetric(
                      //               horizontal: 20, vertical: 15),
                      //           borderRadius: 10,
                      //           animationDuration: const Duration(milliseconds: 200),
                      //           mainButton: TextButton(
                      //             onPressed: () {
                      //               Get.back();
                      //             },
                      //             child: const Icon(
                      //               Icons.close,
                      //               color: Colors.red,
                      //             ),
                      //           ),
                      //         );
                      //       },
                      //       child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text(S.current.gameAcceleration,
                      //               style: TextStyle(fontSize: 30.sp)),
                      //           Row(
                      //             children: [
                      //               Icon(
                      //                 Icons.arrow_forward_ios_outlined,
                      //                 color: const Color.fromRGBO(144, 147, 153, 1),
                      //                 size: 30.w,
                      //               )
                      //             ],
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // AI
                      // InfoBox(
                      //   boxCotainer: SizedBox(
                      //     child: GestureDetector(
                      //       behavior: HitTestBehavior.opaque,
                      //       onTap: () {
                      //         // ToastUtils.toast(S.current.noaivideo);
                      //         // Get.toNamed("/parental_control", arguments: data);
                      //         Get.snackbar(
                      //           'Warning',
                      //           S.current.noaivideo,
                      //           isDismissible: true,
                      //           snackPosition: SnackPosition.TOP,
                      //           duration: const Duration(seconds: 10),
                      //           backgroundColor:
                      //               const Color.fromARGB(132, 63, 63, 63),
                      //           colorText: Colors.white,
                      //           margin: const EdgeInsets.all(10),
                      //           padding: const EdgeInsets.symmetric(
                      //               horizontal: 20, vertical: 15),
                      //           borderRadius: 10,
                      //           animationDuration: const Duration(milliseconds: 200),
                      //           mainButton: TextButton(
                      //             onPressed: () {
                      //               Get.back();
                      //             },
                      //             child: const Icon(
                      //               Icons.close,
                      //               color: Colors.red,
                      //             ),
                      //           ),
                      //         );
                      //       },
                      //       child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text(S.current.aivideo,
                      //               style: TextStyle(fontSize: 30.sp)),
                      //           Row(
                      //             children: [
                      //               Icon(
                      //                 Icons.arrow_forward_ios_outlined,
                      //                 color: const Color.fromRGBO(144, 147, 153, 1),
                      //                 size: 30.w,
                      //               )
                      //             ],
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  )),
            ),
    );
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    client.disconnect();
    super.dispose();
  }
}
