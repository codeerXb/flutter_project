import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:d_chart/commons/data_model.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:get/get.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../.././core/utils/string_util.dart';
import '../../config/base_config.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import "./Model/terminal_equipmentBean.dart";
import "./Model/statistics_beans.dart";
import "./Model/statistics_time_list.dart";
import '../../core/event_bus/eventbus_utils.dart';
import '../../core/event_bus/config_event.dart';

String clientRandom = StringUtil.generateRandomString(10);
String clientId = "client_$clientRandom";

class PieChartPage extends StatefulWidget {
  const PieChartPage({super.key});

  @override
  State<PieChartPage> createState() => _PieChartPageState();
}

class _PieChartPageState extends State<PieChartPage> {
  MqttServerClient client = MqttServerClient.withPort(
      BaseConfig.mqttMainUrl, clientId, BaseConfig.websocketPort);
  var key = GlobalKey<_PieChartPageState>();
  var pieKey = const ValueKey("pie");
  bool _isOpenControlInRow = true;
  List<EquipmentInfo> devices = [];
  String? selectedValue;
  String selectedMacAddress = "";
  String dropDownValue = "one";
  StatisticsBeans? staBeans;
  AppTimeListBeans? timeListModel;

  List<OrdinalData> ordinalDataList = [];

  List<StatisticsTypeData> resList = [];

  List<OrdinalData> pieDataList = [
    OrdinalData(domain: 'Nan', measure: 100, color: Colors.red),
];


  String tapIndex = "";
  String sn = "";
  String subTopic = "";

  @override
  void initState() {
    if (mounted) {
      var equements = Get.arguments["equipments"];
        for (int i = 0; i < equements.length; i++) {
          if (((i+1) < equements.length && equements[i].name == equements[i + 1].name) || equements[i].name == "*") {
            equements.removeAt(i);
          }
        }
      setState(() {
        devices = equements;
      });
    }

    sharedGetData('configEnable', String).then(((res) {
      printInfo(info: 'configEnable$res');
      var configSw = res.toString();
      setState(() {
        _isOpenControlInRow = configSw == "1" ? true : false;
      });
    }));

    sharedGetData('deviceSn', String).then(((res) {
      printInfo(info: 'deviceSn$res');
      sn = res.toString();
      if (devices.isNotEmpty) {
        requestData(sn, devices[0].mac!.toLowerCase());
      }
      
    }));

    super.initState();
  }

  requestData(String sn, String macAddress) async {
    client.logging(on: false);
    client.keepAlivePeriod = 30;
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
    var statisticsParms = {
      "event": "getParentControlAppClassVisitTime",
      "sn": sn,
      "sessionId": sessionIdStr,
      "param": {"mac": macAddress}
    };

    final appTimeSessionId = StringUtil.generateRandomString(10);
    var appTimeParms = {
      "event": "getParentControlDevVisitTime",
      "sn": sn,
      "sessionId": appTimeSessionId,
      "param": {"mac": macAddress}
    };

    _publishMessage(publishTopic, statisticsParms);
    _publishMessage(publishTopic, appTimeParms);

    subTopic = "app/appClassVisitTime/$sn";
    var timeListTopic = "app/appVisitTime/$sn";
    client.subscribe(subTopic, MqttQos.atLeastOnce);
    client.subscribe(timeListTopic, MqttQos.atLeastOnce);
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final MqttPublishMessage recMess = c![0].payload as MqttPublishMessage;
      final String topic = c[0].topic;
      final String pt = const Utf8Decoder().convert(recMess.payload.message);
      String desString = "topic is <$topic>, payload is <-- $pt -->";
      debugPrint("string =$desString");
      if (topic == "app/appClassVisitTime/$sn") {
        final statisticsInfoModel = StatisticsBeans.fromJson(jsonDecode(pt));
        staBeans = statisticsInfoModel;
        List<OrdinalData> pieDatas = [];
        List<StatisticsTypeData> timeDatas = [];
        if (statisticsInfoModel.param != null) {
          if (statisticsInfoModel.param!.visitTimeList!.isNotEmpty) {
            for (VisitTimeList item
                in statisticsInfoModel.param!.visitTimeList!) {
              if (item.typeName == "Social") {
                if (item.visitTime != "0") {
                  pieDatas.add(OrdinalData(
                      domain: 'Social',
                      measure: int.parse(item.visitTime!),
                      color: const Color.fromRGBO(53, 199, 89, 1)));
                }

                timeDatas.add(StatisticsTypeData(
                    "assets/images/social media.png",
                    "Social Media",
                    "${int.parse(item.visitTime!)}mins"));
              } else if (item.typeName == "Video") {
                if (item.visitTime != "0") {
                  pieDatas.add(OrdinalData(
                      domain: 'Video',
                      measure: int.parse(item.visitTime!),
                      color: const Color.fromRGBO(88, 86, 215, 1)));
                }

                timeDatas.add(StatisticsTypeData("assets/images/video.png",
                    "Video", "${int.parse(item.visitTime!)}mins"));
              } else if (item.typeName == "E-Commerce") {
                if (item.visitTime != "0") {
                  pieDatas.add(OrdinalData(
                      domain: 'E-Commerce',
                      measure: int.parse(item.visitTime!),
                      color: const Color.fromRGBO(2, 123, 254, 1)));
                }

                timeDatas.add(StatisticsTypeData(
                    "assets/images/shopping.png",
                    "E-Commerce Portal Access Times",
                    "${int.parse(item.visitTime!)}mins"));
              } else if (item.typeName == "App Store") {
                if (item.visitTime != "0") {
                  pieDatas.add(OrdinalData(
                      domain: 'App Store',
                      measure: int.parse(item.visitTime!),
                      color: const Color.fromRGBO(255, 149, 0, 1)));
                }

                timeDatas.add(StatisticsTypeData("assets/images/app store.png",
                    "App Store", "${int.parse(item.visitTime!)}mins"));
              } else {
                if (item.visitTime != "0") {
                  pieDatas.add(OrdinalData(
                      domain: 'Website',
                      measure: int.parse(item.visitTime!),
                      color: const Color.fromRGBO(255, 214, 0, 1)));
                }

                timeDatas.add(StatisticsTypeData("assets/images/weblist.png",
                    "Website", "${int.parse(item.visitTime!)}mins"));
              }
            }
            debugPrint("数据统计源:$pieDatas");
            debugPrint("分类统计源:$timeDatas");
            if (mounted) {
              setState(() {
                ordinalDataList = pieDatas;
                resList = timeDatas;
              });
            }
          }
        }
      } else if (topic == "app/appVisitTime/$sn") {
        final appTimeListModel = AppTimeListBeans.fromJson(jsonDecode(pt));
        if (appTimeListModel.param != null &&
            appTimeListModel.param!.isNotEmpty) {
          timeListModel = appTimeListModel;
          debugPrint("单个App的分类:$timeListModel");
        }
      } else if (topic == "cpe/$sn/_parent_config") {
        String result = pt.substring(0, pt.length - 1);
        Map datas = jsonDecode(result);
        var res = datas["data"];
        debugPrint("家长控制设置结果 =$res");
      } else {
        String result = pt.substring(0, pt.length - 1);
        Map datas = jsonDecode(result);
        var res = datas["data"];
        debugPrint("规则配置设置结果 =$res");
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
    debugPrint("======发送的消息成功了=======");
    debugPrint("===$topic===$message=======");
    var builder = MqttClientPayloadBuilder();
    var jsonData = json.encode(message);
    builder.addUTF8String(jsonData);
    client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }

  void uploadParentConfigData() {
    final sessionIdCha = StringUtil.generateRandomString(10);
    var topic = "cpe/$sn";
    var pubtopic = "cpe/$sn/_parent_config";
    var parameters = {
      "event": "setParentControlConfig",
      "sn": sn,
      "sessionId": sessionIdCha,
      "pubTopic": pubtopic,
      "param": {
        "enable": _isOpenControlInRow == true ? "1" : '0',
        "work_mode": "0",
        "rules": {
          "chatapps": "",
          "shoppingapps": "",
          "downloadapps": "",
          "websiteapps": "",
          "videoapps": ""
        },
        "time": {
          "time_mode": "1",
          "days": "0 1 2 3 4 5 6",
          "start_time": "00:00",
          "end_time": "23:59"
        },
        "users": ""
      }
    };
    _publishMessage(topic, parameters);
    client.subscribe(pubtopic, MqttQos.atLeastOnce);
  }

  void setRulesToTakeEffect() {
    final sessionIdCha = StringUtil.generateRandomString(10);
    var topic = "cpe/$sn";
    var pubtopic = "cpe/$sn/setRule";
    var parameters = {
      "event": "ParentControl",
      "sn": sn,
      "sessionId": sessionIdCha,
      "pubTopic": pubtopic,
      "param": {
        "method": "set",
        "data": {
          "config": "appfilter2",
          "type": "global",
          "name": "global",
          "values": {"enable": _isOpenControlInRow == true ? "1" : '0'}
        }
      }
    };
    _publishMessage(topic, parameters);
  }

  void _chageSwitchStatus() {
    eventBus.fire(FlagEvent(true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Parental Control Dashboard",
          style: TextStyle(
              fontSize: 18, color: Colors.black, fontWeight: FontWeight.w500),
              textScaler: TextScaler.noScaling
        ),
        // centerTitle: true,
        actions: [
          FlutterSwitch(
            width: 70.0,
            height: 40.0,
            activeText: "ON",
            inactiveText: "OFF",
            activeColor: Colors.green,
            activeTextColor: Colors.white,
            inactiveTextColor: Colors.blue[50]!,
            value: _isOpenControlInRow,
            valueFontSize: 12.0,
            borderRadius: 30.0,
            showOnOff: true,
            onToggle: (val) {
              setState(() {
                _isOpenControlInRow = val;
                _chageSwitchStatus();
                uploadParentConfigData();
                setRulesToTakeEffect();
              });
            },
          ),
          const SizedBox(
            width: 5,
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: resList.isEmpty ? setLoadingIndicator() : setUpBodyContent(),
    );
  }

  Widget getPieChart() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: DChartPieO(
        key: key,
        data: ordinalDataList,
        customLabel: (ordinalData, index) {
          double res = ordinalData.measure / int.parse(staBeans!.param!.totalVisitTime!);
          return (ordinalDataList.isEmpty || staBeans!.param!.totalVisitTime == "0") ? ordinalData.domain : "${ordinalData.domain} ${"${(res * 100).ceil()}%"}";
        },
        configRenderPie: ConfigRenderPie(
            arcWidth: 40,
            // arcRatio: 0.1,
            strokeWidthPx: 0.0,
            arcLabelDecorator: ArcLabelDecorator(
                labelPadding: 0,
                showLeaderLines: false,
                labelPosition: ArcLabelPosition.outside,
                outsideLabelStyle: const LabelStyle(fontSize: 12),
                leaderLineStyle: const ArcLabelLeaderLineStyle(
                    color: Colors.black, length: 20, thickness: 1.0))),
      ),
    );
  }

  Widget NANStatisticsDataPieView() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: DChartPieO(
        key: pieKey,
        data: pieDataList,
        customLabel: (ordinalData, index) {
          return "No statistics yet";
        },
        configRenderPie: ConfigRenderPie(
            arcWidth: 100,
            // arcRatio: 0.1,
            strokeWidthPx: 0.0,
            arcLabelDecorator: ArcLabelDecorator(
                labelPadding: 0,
                showLeaderLines: false,
                labelPosition: ArcLabelPosition.outside,
                outsideLabelStyle: const LabelStyle(fontSize: 16),
                leaderLineStyle: const ArcLabelLeaderLineStyle(
                    color: Colors.black, length: 40, thickness: 1.0))),
      ),
    );
  }

  Widget setUpBodyContent() {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: double.infinity,
            minHeight: MediaQuery.of(context).size.height - 20),
        child: _isOpenControlInRow
            ? Container(
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(242, 242, 242, 1)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: const Color.fromRGBO(242, 242, 242, 1),
                              width: 0.5),
                          borderRadius: BorderRadius.circular((8))),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            height: 50,
                            child: setDropdownMenue(),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                              height: 240,
                              child: ordinalDataList.isEmpty ? NANStatisticsDataPieView() : getPieChart()),
                          // EasyPieChart(
                          //   key: key,
                          //   children: pies,
                          //   pieType: PieType.fill,
                          //   onTap: (index) {
                          //     Get.toNamed("/parentDetailList");
                          //     debugPrint("当前选中的是$index");
                          //   },
                          //   start: 180,
                          //   size: 400,
                          //   style: const TextStyle(
                          //       fontSize: 20,
                          //       color: Colors.black,
                          //       backgroundColor: Colors.white),
                          //   // child: Text("当前占比30%"),
                          //   // centerStyle: TextStyle(fontSize: 16,color: Colors.black),
                          // ),

                          const SizedBox(
                            height: 30,
                          ),

                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: resList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return getAppcationTypeList(
                                  resList[index].imageUrl!,
                                  resList[index].typeName!,
                                  resList[index].time!);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 20,
                      height: 150,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: const Color.fromRGBO(242, 242, 242, 1),
                              width: 0.5),
                          borderRadius: BorderRadius.circular((8))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                "assets/images/parentConfig.png",
                                width: 30,
                                height: 30,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Global Configuration",
                                style: TextStyle(
                                    fontSize: 40.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                                    textScaler: TextScaler.noScaling
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          setUpFooterView()
                        ],
                      ),
                    )

                    // SizedBox(
                    //   height: 80,
                    //   child: buildCustomWidget(),
                    // ),
                    // SizedBox(
                    //   height: 20,
                    // )
                  ],
                ),
              )
            : Container(),
      ),
    );
  }

  Widget setUpFooterView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          width: 140,
          height: 60,
          child: ElevatedButton(
            style: ButtonStyle(
              // padding: MaterialStateProperty.all(
              //     EdgeInsets.fromLTRB(20.w, 28.w, 20.w, 28.w)),
              shape: MaterialStateProperty.all(const StadiumBorder()),
              backgroundColor: MaterialStateProperty.all(
                  const Color.fromARGB(255, 30, 104, 233)),
            ),
            onPressed: () {
              // Get.toNamed("/parentConfigPage");
              Get.toNamed("/websiteDevicePage");
            },
            child: Text(
              "Blacklist Configure",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 32.sp, color: const Color(0xffffffff)),
              textScaler: TextScaler.noScaling
            ),
          ),
        ),
        SizedBox(
          width: 140,
          height: 60,
          child: ElevatedButton(
            style: ButtonStyle(
              // padding: MaterialStateProperty.all(
              //   EdgeInsets.fromLTRB(20.w, 28.w, 20.w, 28.w),
              // ),
              shape: MaterialStateProperty.all(const StadiumBorder()),
              backgroundColor: MaterialStateProperty.all(
                  const Color.fromRGBO(52, 199, 89, 1)),
            ),
            onPressed: () {
              Get.toNamed("/timeConfigPage");
            },
            child: Text(
              "Use Time Configure",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 32.sp, color: const Color(0xffffffff)),
              textScaler: TextScaler.noScaling
            ),
          ),
        ),
      ],
    );
  }

  Widget getAppcationTypeList(String imgPath, String title, String totalTime) {
    return InkWell(
      onTap: () {
        if (timeListModel != null && timeListModel!.param!.isNotEmpty) {
          if (title == "Social Media" &&
              timeListModel!.param![0].social!.isNotEmpty) {
            List<Social> timeList = [];
            timeList = timeListModel!.param![0].social!;
            if (totalTime != "0") {
              Get.toNamed("/parentDetailList",
                  arguments: {"timeArray": timeList});
            }
          } else if (title == "Video" &&
              timeListModel!.param![1].video!.isNotEmpty) {
            List<Video> timeList = [];
            timeList = timeListModel!.param![1].video!;
            if (totalTime != "0") {
              Get.toNamed("/parentDetailList",
                  arguments: {"timeArray": timeList});
            }
          } else if (title == "E-Commerce Portal Access Times" &&
              timeListModel!.param![2].eCommerce!.isNotEmpty) {
            List<ECommerce> timeList = [];
            timeList = timeListModel!.param![2].eCommerce!;
            if (totalTime != "0") {
              Get.toNamed("/parentDetailList",
                  arguments: {"timeArray": timeList});
            }
          } else if (title == "App Store" &&
              timeListModel!.param![3].appStore!.isNotEmpty) {
            List<AppStore> timeList = [];
            timeList = timeListModel!.param![3].appStore!;
            if (totalTime != "0") {
              Get.toNamed("/parentDetailList",
                  arguments: {"timeArray": timeList});
            }
          } else if (title == "Website" &&
              timeListModel!.param![4].website!.isNotEmpty) {
            List<Website> timeList = [];
            timeList = timeListModel!.param![4].website!;
            if (totalTime != "0") {
              Get.toNamed("/parentDetailList",
                  arguments: {"timeArray": timeList});
            }
          } else {}
        }
      },
      child: Container(
        decoration: const BoxDecoration(
            border:
                Border(bottom: BorderSide(width: 1, color: Colors.black12))),
        height: 80,
        child: ListTile(
          contentPadding: const EdgeInsets.only(left: 10, right: 10),
          leading: Image.asset(
            imgPath,
            width: 20,
            height: 20,
          ),
          title: Text(
            title,
            style: const TextStyle(fontSize: 16, color: Colors.black),
            textScaler: TextScaler.noScaling
          ),
          subtitle: Text(
            totalTime,
            style: const TextStyle(fontSize: 16, color: Colors.black),
            textScaler: TextScaler.noScaling
          ),
          trailing: Image.asset(
            "assets/images/parent_time_back.png",
            width: 20,
            height: 20,
          ),
        ),
      ),
    );
  }

  Widget setDropdownMenue() {
    return Center(
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          hint: Row(
            children: [
              Expanded(
                child: Text(
                  devices[0].name! == "*" ? "Unknown Device" : devices[0].name!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                  textScaler: TextScaler.noScaling
                ),
              ),
            ],
          ),
          items: devices
              .map((EquipmentInfo item) => DropdownMenuItem<String>(
                    value: item.name,
                    child: Text(
                      item.name! == "*" ? "Unknown Device" :item.name!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                      textScaler: TextScaler.noScaling
                    ),
                  ))
              .toList(),
          value: selectedValue,
          onChanged: (String? value) {
            setState(() {
              selectedValue = value;
              for (var item in devices) {
                if (item.name == value) {
                  selectedMacAddress = item.mac!;
                }
              }
              // 请求统计信息
              requestData(sn, selectedMacAddress.toLowerCase());
            });
          },
          buttonStyleData: ButtonStyleData(
            height: 50,
            width: 260,
            padding: const EdgeInsets.only(left: 14, right: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: Colors.white,
              ),
              color: const Color.fromRGBO(247, 248, 250, 1),
            ),
            elevation: 0,
          ),
          iconStyleData: const IconStyleData(
            icon: Icon(
              Icons.keyboard_arrow_down,
            ),
            iconSize: 14,
            iconEnabledColor: Colors.black,
            iconDisabledColor: Colors.grey,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 200,
            width: 260,
            decoration: const BoxDecoration(
              // borderRadius: BorderRadius.circular(14),
              color: Colors.white,
            ),
            offset: const Offset(0, 0),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: MaterialStateProperty.all<double>(6),
              thumbVisibility: MaterialStateProperty.all<bool>(true),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
            padding: EdgeInsets.only(left: 14, right: 14),
          ),
        ),
      ),
    );
  }
/*
  Widget setUpTopView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 300,
          child: SwitchListTile(
            value: _isOpenControlInRow,
            title: const Text("control switch"),
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (val) {
              setState(() {
                _isOpenControlInRow = val;
              });
            },
          ),
        ),
        Expanded(
            child: SizedBox(
          width: 40,
          height: 30,
          child: IconButton(
              onPressed: () {
                Get.toNamed("/parentConfigHome");
              },
              icon: const Icon(Icons.settings)),
        )),
        // Divider(
        //   height: 1.0,
        //   indent: 60.0,
        //   color: Colors.black,
        // )
      ],
    );
  }
*/
  Widget buildCustomWidget() {
    return Center(
      child: Align(
        alignment: Alignment.topCenter,
        child: Wrap(
          alignment: WrapAlignment.center,
          direction: Axis.horizontal,
          children: [
            createWrapChild("social media", const Color(0xfffdcb6e)),
            createWrapChild("shopping", const Color(0xff0984e3)),
            createWrapChild("app", Colors.lightGreen),
            createWrapChild("video", const Color(0xfffd79a8)),
            createWrapChild("website", const Color(0xff6c5ce7)),
          ],
        ),
      ),
    );
  }

  Widget createWrapChild(String title, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.symmetric(vertical: 2.0),
          height: 20.0,
          width: 18.0,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 8.0,
        ),
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            title,
            style: const TextStyle(fontSize: 15, color: Colors.black),
            softWrap: true,
            textScaler: TextScaler.noScaling
          ),
        ),
        const SizedBox(
          width: 8.0,
        ),
      ],
    );
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
    // eventBus.destroy();
    super.dispose();
  }
}

class CustomCard extends StatelessWidget {
  final Widget child;
  const CustomCard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(padding: const EdgeInsets.all(20.0), child: child));
  }
}

class StatisticsTypeData {
  String? imageUrl;
  String? typeName;
  String? time;
  StatisticsTypeData(this.imageUrl, this.typeName, this.time);
}
