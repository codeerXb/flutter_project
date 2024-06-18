import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:get/get.dart';
import 'package:flutter_template/core/http/http_app.dart';
import './Model/device_rule_config.dart';
import '../.././core/utils/string_util.dart';
import '../../config/base_config.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

String clientRandom = StringUtil.generateRandomString(10);
String clientId = "client_$clientRandom";

class ParentConfigPage extends StatefulWidget {
  const ParentConfigPage({super.key});

  @override
  State<ParentConfigPage> createState() => _ParentConfigPageState();
}

class _ParentConfigPageState extends State<ParentConfigPage> {
  MqttServerClient client = MqttServerClient.withPort(
      BaseConfig.mqttMainUrl, clientId, BaseConfig.websocketPort);
  FocusNode fousNode = FocusNode();
  TextEditingController nameController = TextEditingController();
  var currentPanelIndex = 0; // 当前panel的index
  String date = 'Mon';
  bool isOpened = false;
  DateTime dateTimeSelected = DateTime.now();
  DateTime endTimeSelected = DateTime.now();
  final List<String> _selectedItems = [];
  final List<String> _selectedvideoItems = [];
  final List<String> _selectedshopItems = [];
  final List<String> _selectedappStoreItems = [];
  var shopflag = true;
  var socialflag = true;
  var videoflag = true;
  var appflag = true;

  Map<String, List<ApplicationInfo>> datasMap = {
    "E-Commerce Portal Access Times": [],
    "Video": [],
    "App Store": [],
    "Social Media": []
  };

  bool switchValue = true;
  List websiteList = [];
  String sn = "";
  String macAddress = "";
  DeviceRule? ruleBean;
  String methodType = "";
  var macName = "";
  List<String> urlList = [];

  @override
  void initState() {
    macAddress = Get.arguments["mac"];
    macName = macAddress.replaceAll(":", "");
    methodType = Get.arguments["method"];
    sharedGetData('deviceSn', String).then(((res) {
      printInfo(info: 'deviceSn$res');
      sn = res.toString();
      requestSingleDeviceRule(sn);
    }));
    super.initState();
  }

  void requestSingleDeviceRule(String sn) {
    App.get('/platform/parentControlApp/queryBlacklistRuleBySnAndMac?sn=$sn&mac=$macAddress')
        .then((res) {
      final ruleModel = DeviceRuleBeans.fromJson(res);
      if (ruleModel.code == 200 && ruleModel.data != null) {
        setState(() {
          ruleBean = ruleModel.data!.deviceRule;
          debugPrint("获取的设备配置规则:$ruleBean");
          datasMap = {
            "E-Commerce Portal Access Times":
                ruleBean!.eCommercePortalAccessTimes!,
            "Video": ruleBean!.video!,
            "App Store": ruleBean!.appStore!,
            "Social Media": ruleBean!.socialMedia!
          };
          for (ApplicationInfo element in ruleBean!.websiteList!) {
            websiteList.add(element.url);
          }

          datasMap.forEach((key, value) {
            if (key == "E-Commerce Portal Access Times") {
              value = ruleBean!.eCommercePortalAccessTimes!;
              for (var element in value) {
                if(element.selectedFlag == "1") {
                  urlList.add(element.url!);
                }
              }

            } else if (key == "Video") {
              value = ruleBean!.video!;
              for (var element in value) {
                if(element.selectedFlag == "1") {
                  urlList.add(element.url!);
                }
              }
            } else if (key == "App Store") {
              value = ruleBean!.appStore!;
              for (var element in value) {
                if(element.selectedFlag == "1") {
                  urlList.add(element.url!);
                }
              }
            } else if (key == "Social Media") {
              value = ruleBean!.socialMedia!;
              for (var element in value) {
                if(element.selectedFlag == "1") {
                  urlList.add(element.url!);
                }
              }
            } else if (key == "Website List") {
              value = ruleBean!.websiteList!;
            } else {}
          });
        });
        debugPrint("组装的规则数据:$datasMap");
      } else {
        ToastUtils.toast(ruleModel.message!);
      }
    }).catchError((error) {
      ToastUtils.error(error.toString());
    });
  }

  dealwithDeviceRuleAction(
      String sn, String? methodType, List<String> urlArray) async {
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

    if (urlArray.isEmpty) {
      var subTopic = "cpe/$sn/deleteRule";
      var parms = {
        "event": "ParentControl",
        "sn": sn,
        "sessionId": sessionIdStr,
        "pubTopic": subTopic,
        "param": {
          "method": "delete",
          "data": {"config": "appfilter2", "section": macName}
        }
      };
      _publishMessage(publishTopic, parms);
      Future.delayed(const Duration(seconds: 2), () {
        ToastUtils.toast("Submitted successfully");
        sleep(const Duration(seconds: 1));
        Get.back(result: "success");
      });
      // client.subscribe(subTopic, MqttQos.atLeastOnce);
    } else {
      if (methodType == "add") {
        var subTopic = "cpe/$sn/addRule";
        var parms = {
          "event": "ParentControl",
          "sn": sn,
          "sessionId": sessionIdStr,
          "pubTopic": subTopic,
          "param": {
            "method": "add",
            "data": {
              "config": "appfilter2",
              "type": "rule",
              "name": macName,
              "values": {"url": urlArray, "mac": macAddress}
            }
          }
        };
        _publishMessage(publishTopic, parms);
        Future.delayed(const Duration(seconds: 2), () {
          ToastUtils.toast("Submitted successfully");
          sleep(const Duration(seconds: 1));
          Get.back(result: "success");
        });
        // client.subscribe(subTopic, MqttQos.atLeastOnce);
      } else {
        var subTopic = "cpe/$sn/setRule";
        var parms = {
          "event": "ParentControl",
          "sn": sn,
          "sessionId": sessionIdStr,
          "pubTopic": subTopic,
          "param": {
            "method": "set",
            "data": {
              "config": "appfilter2",
              "type": "rule",
              "section": macName,
              "values": {"url": urlArray, "mac": macAddress}
            }
          }
        };
        _publishMessage(publishTopic, parms);
        Future.delayed(const Duration(seconds: 2), () {
          ToastUtils.toast("Submitted successfully");
          sleep(const Duration(seconds: 1));
          Get.back(result: "success");
        });
        // client.subscribe(subTopic, MqttQos.atMostOnce);
      }
    }

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final MqttPublishMessage recMess = c![0].payload as MqttPublishMessage;
      final String topic = c[0].topic;
      final String pt = const Utf8Decoder().convert(recMess.payload.message);
      String desString = "topic is <$topic>, payload is <-- $pt -->";
      debugPrint("string =$desString");
      if (topic == "cpe/$sn/addRule") {
        Map datas = jsonDecode(pt);
        var message = datas["data"];
        ToastUtils.toast(message);
      } else if (topic == "cpe/$sn/setRule") {
        Map datas = jsonDecode(pt);
        var message = datas["data"];
        ToastUtils.toast(message);
      } else {
        Map datas = jsonDecode(pt);
        var message = datas["data"];
        ToastUtils.toast(message);
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
        appBar: AppBar(
          title: const Text('Configure',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.w500),
              textScaler: TextScaler.noScaling),
          centerTitle: true,
          backgroundColor: Colors.white,
          // actions: [
          //   FlutterSwitch(
          //     width: 100.0,
          //     height: 40.0,
          //     activeText: "Blacklist",
          //     inactiveText: "Whitelist",
          //     activeColor: const Color.fromARGB(255, 22, 136, 230),
          //     inactiveColor: !switchValue ? Color.fromARGB(255, 22, 136, 230) : Colors.grey,
          //     activeTextColor: Colors.white,
          //     inactiveTextColor: Colors.blue[50]!,
          //     value: switchValue,
          //     valueFontSize: 12.0,
          //     borderRadius: 30.0,
          //     showOnOff: true,
          //     onToggle: (val) {
          //       setState(() {
          //         switchValue = val;
          //       });
          //     },
          //   ),
          //   // SizedBox(
          //   //   width: 40,
          //   //   child: CupertinoSwitch(
          //   //     value: switchValue,
          //   //     onChanged: (value) {
          //   //       setState(() {
          //   //         switchValue = value;
          //   //       });
          //   //     },
          //   //     thumbColor: CupertinoColors.white,
          //   //     activeColor: CupertinoColors.activeBlue,
          //   //   ),
          //   // ),
          //   const SizedBox(
          //     width: 15,
          //   )
          // ],
        ),
        body: ruleBean != null
            ? Container(
                height: double.infinity,
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(242, 242, 247, 1)),
                padding: const EdgeInsets.only(bottom: 20),
                child: SingleChildScrollView(
                    child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minHeight: 100,
                    // maxHeight: 100000
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Padding(
                      //   padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      //   child: SizedBox(
                      //     height: 75,
                      //     child: Card(
                      //       margin: EdgeInsets.all(5),
                      //       elevation: 2,
                      //       color: Colors.white,
                      //       shape: RoundedRectangleBorder(
                      //         side: const BorderSide(color: Colors.white, width: 0.5),
                      //         borderRadius: BorderRadius.circular(8),
                      //       ),
                      //       clipBehavior: Clip.antiAlias,
                      //       child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Padding(padding:const EdgeInsets.only(left: 15,right: 10),
                      //           child: Image.asset("assets/images/name.png",width: 25,height: 25,)
                      //           ),
                      //           Expanded(
                      //               child: TextField(
                      //             controller: nameController,
                      //             autofocus: true,
                      //             focusNode: fousNode,
                      //             keyboardType: TextInputType.text,
                      //             decoration:const InputDecoration(
                      //               // prefixIcon:
                      //               border: InputBorder.none,
                      //               // labelText: 'User Name',
                      //               hintText: 'Enter Your Name',
                      //             ),
                      //           ))
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: ListView(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: _buildList(datasMap),
                        ),
                      ),
                      // Offstage(
                      //   offstage: !switchValue,
                      //   child:
                      // ),
                      Container(
                        margin: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 1),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              width: 1, color: const Color(0xffe5e5e5)),
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8.0),
                              topRight: Radius.circular(8.0)),
                        ),
                        // clipBehavior: Clip.antiAlias,
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.only(left: 20, right: 5),
                          horizontalTitleGap: 5,
                          leading: Image.asset(
                            'assets/images/weblist.png',
                            width: 25,
                            height: 25,
                          ),
                          title: const Text("Website List",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                              textScaler: TextScaler.noScaling),
                          trailing: IconButton(
                            onPressed: () {
                              Get.toNamed("/websiteConfigPage",
                                      arguments: {"websites": websiteList})
                                  ?.then((results) {
                                if (results != null) {
                                  setState(() {
                                    List inputUrlArray = [];
                                    websiteList = [];
                                    inputUrlArray.addAll(results);
                                    websiteList.addAll(inputUrlArray);
                                    debugPrint("输入的网站是:$websiteList");
                                  });
                                }
                              });
                            },
                            icon: Image.asset(
                              'assets/images/edit_parent.png',
                              width: 20,
                              height: 20,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              width: 1, color: const Color(0xffe5e5e5)),
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(8.0),
                              bottomRight: Radius.circular(8.0)),
                        ),
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: websiteList.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 1,
                                            color: Color(0xffe5e5e5)))),
                                child: ListTile(
                                    title: Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Text(
                                    websiteList[index],
                                    style: const TextStyle(
                                        fontSize: 15, color: Colors.black),
                                  ),
                                )),
                              );
                            }),
                      ),

                      const SizedBox(
                        height: 15,
                      ),

                      SizedBox(
                        width: 150,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                              EdgeInsets.only(top: 28.w, bottom: 28.w),
                            ),
                            shape: MaterialStateProperty.all(
                                const StadiumBorder()),
                            backgroundColor: MaterialStateProperty.all(
                                const Color.fromARGB(255, 30, 104, 233)),
                          ),
                          onPressed: () {
                            if (websiteList.isNotEmpty) {
                              for (var element in websiteList) {
                                urlList.add(element);
                              }
                            }
                            debugPrint("所有选择的网站是:$urlList");
                            urlList = urlList.toSet().toList();
                            debugPrint("最终选择的网站是:$urlList");
                            dealwithDeviceRuleAction(sn, methodType, urlList);
                          },
                          child: Text(
                            "Submit",
                            style: TextStyle(
                                fontSize: 32.sp,
                                color: const Color(0xffffffff)),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              )
            : const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Color.fromRGBO(215, 220, 220, 0.3),
                ),
              ));
  }

/*
  Widget _buildPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          currentPanelIndex = index;
          _data[index].isExpanded = isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((Item item) {
        return ExpansionPanel(
          canTapOnHeader: true,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(item.headerValue),
            );
          },
          body: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _items.length,
              itemBuilder: (BuildContext context, int index) {
                return CheckboxListTile(
                    value: _selectedItems.contains(item.expandedValue),
                    title: Text(item.expandedValue),
                    // subtitle: Text('${_items[index]}'),
                    controlAffinity: ListTileControlAffinity.trailing,
                    onChanged: (isChecked) {
                      setState(() {
                            // _items.removeWhere((currentItem){
                            debugPrint(
                                "当前的是$_selectedItems --- index : $isChecked");
                            //   return _items[index] == currentItem;
                            // _itemChange(_items[index], isChecked!);
                            // });
                          });
                    });
              }),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
*/

  List<Widget> _buildList(Map<String, List<ApplicationInfo>> datasMap) {
    List<Widget> widgets = [];
    for (var key in datasMap.keys) {
      widgets.add(_generateExpansionTileWidget(key, datasMap[key]));
    }
    return widgets;
  }

  /// 生成 ExpansionTile 组件
  Widget _generateExpansionTileWidget(title, List<ApplicationInfo>? names) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: const Color(0xffe5e5e5)),
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      ),
      // clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            generateTypeIcon(title),
            const SizedBox(
              width: 5,
            ),
            Expanded(
                child: Text(title,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                    softWrap: true,
                    textScaler: TextScaler.noScaling))
          ],
        ),
        children: names!.map((name) {
          if (shopflag == true ||
              socialflag == true ||
              videoflag == true ||
              appflag == true) {
            if (title == "Social Media") {
              // debugPrint("Social Media元素选中的状态是:${name.selectedFlag}");
              // if (name.selectedFlag == "1" && socialflag == true) {
              //   socialflag = false;
              //   _selectedItems.add(name.appName!);
              //   urlList.add(name.url!);
              // } else {
              //   _selectedItems.remove(name.appName!);
              //   urlList.remove(name.url!);
              // }
            } else if (title == "Video") {
              // debugPrint("Video元素选中的状态是:${name.selectedFlag}");
              // if (name.selectedFlag == "1" && videoflag == true) {
              //   videoflag = false;
              //   _selectedvideoItems.add(name.appName!);
              //   urlList.add(name.url!);
              // }else {
              //   _selectedvideoItems.remove(name.appName!);
              //   urlList.remove(name.url!);
              // }
            } else if (title == "E-Commerce Portal Access Times") {
              // debugPrint("E-Commerce元素选中的状态是:${name.selectedFlag}");
              // if (name.selectedFlag == "1" && shopflag == true) {
              //   shopflag = false;
              //   _selectedshopItems.add(name.appName!);
              //   urlList.add(name.url!);
              // }else {
              //   _selectedshopItems.remove(name.appName!);
              //   urlList.remove(name.url!);
              // }
            } else {
              // debugPrint("App Store元素选中的状态是:${name.selectedFlag}");
              // if (name.selectedFlag == "1" && appflag == true) {
              //   appflag = false;
              //   _selectedappStoreItems.add(name.appName!);
              //   urlList.add(name.url!);
              // }else {
              //   _selectedappStoreItems.remove(name.appName!);
              //   urlList.remove(name.url!);
              // }
            }
          }

          return _generateWidget(name, title);
        }).toList(),
        onExpansionChanged: (value) {
          debugPrint("当前是否打开: $value");
        },
      ),
    );
  }

  Widget generateTypeIcon(String type) {
    if (type == "E-Commerce Portal Access Times") {
      return Image.asset(
        'assets/images/shopping.png',
        width: 25,
        height: 25,
      );
    } else if (type == "Video") {
      return Image.asset(
        'assets/images/video.png',
        width: 25,
        height: 25,
      );
    } else if (type == "Social Media") {
      return Image.asset(
        'assets/images/social media.png',
        width: 25,
        height: 25,
      );
    } else {
      return Image.asset(
        'assets/images/app store.png',
        width: 25,
        height: 25,
      );
    }
  }

  /// 生成 ExpansionTile 下的 ListView 的单个组件
  Widget _generateWidget(ApplicationInfo name, String type) {
    /// 使用该组件可以使宽度撑满
    return CheckboxListTile(
        value: name.selectedFlag == "1" ? true : false,
        title: Text(
          "${name.appName}",
          style: const TextStyle(color: Colors.black, fontSize: 14),
          softWrap: true,
        ),
        // subtitle: Text('${_items[index]}'),
        controlAffinity: ListTileControlAffinity.trailing,
        onChanged: (isChecked) {
          setState(() {
            name.selectedFlag = isChecked == true ? "1" : "0";
          });
          _itemChange(name.appName!, name.url!, type, isChecked!, name);

          debugPrint(
              "当前的是$_selectedItems --$_selectedshopItems --$_selectedvideoItems --$_selectedappStoreItems --- urlList : $urlList");
        });
  }

  void _itemChange(String itemValue, String url, String type, bool isSelected,
      ApplicationInfo selectedItem) {
    if (type == "Social Media") {
      debugPrint("Social Media元素选中的状态是:$isSelected");
      if (isSelected && !isContainApplication(type, itemValue)) {
        _selectedItems.add(itemValue);
        urlList.add(url);
      } else {
        _selectedItems.remove(itemValue);
        urlList.remove(url);
      }
    } else if (type == "Video" && !isContainApplication(type, itemValue)) {
      debugPrint("Video元素选中的状态是:$isSelected");
      if (isSelected) {
        _selectedvideoItems.add(itemValue);
        urlList.add(url);
      } else {
        _selectedvideoItems.remove(itemValue);
        urlList.remove(url);
      }
    } else if (type == "E-Commerce Portal Access Times" &&
        !isContainApplication(type, itemValue)) {
      debugPrint("E-Commerce元素选中的状态是:$isSelected");
      if (isSelected) {
        _selectedshopItems.add(itemValue);
        urlList.add(url);
      } else {
        _selectedshopItems.remove(itemValue);
        urlList.remove(url);
      }
    } else if (type == "App Store" && !isContainApplication(type, itemValue)) {
      debugPrint("App Store元素选中的状态是:$isSelected");
      if (isSelected) {
        _selectedappStoreItems.add(itemValue);
        urlList.add(url);
      } else {
        _selectedappStoreItems.remove(itemValue);
        urlList.remove(url);
      }
    } else {}
    // setState(() {

    // });
  }

  bool isContainApplication(String type, String name) {
    bool iscontain = false;
    if (type == "Social Media") {
      iscontain = _selectedItems.contains(name);
    } else if (type == "Video") {
      iscontain = _selectedvideoItems.contains(name);
    } else if (type == "E-Commerce Portal Access Times") {
      iscontain = _selectedshopItems.contains(name);
    } else {
      iscontain = _selectedappStoreItems.contains(name);
    }
    return iscontain;
  }

  @override
  void dispose() {
    client.disconnect();
    super.dispose();
  }
}
