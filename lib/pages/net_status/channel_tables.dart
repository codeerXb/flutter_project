import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import '../../config/base_config.dart';
import '../../core/mqtt/mqtt_service.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import '../.././core/utils/string_util.dart';
import 'dart:convert';
import './beans/scan_quality_bean.dart';
import 'package:get/get.dart';

class ChannelListPage extends StatefulWidget {
  const ChannelListPage({super.key});

  @override
  State<ChannelListPage> createState() => _ChannelListPageState();
}

class _ChannelListPageState extends State<ChannelListPage> {
  MqttClient client = MqttServerClient(BaseConfig.mqttMainUrl, "flutter_client",
      maxConnectionAttempts: 10);
  var setCurrentChannelTopic = "platform_server/apiv1/sma_setcurrentChannel2.4";
  List<Band24GHz> listArray = [];
  String currentChannnel = "";
  String bastChannel = "";
  String sn = "";
  // Timer? timer;
  bool isLoaded = true;
  @override
  void initState() {
    sharedGetData('deviceSn', String).then(((res) {
      sn = res.toString();
      debugPrint('deviceSn : $res');
    }));
    setState(() {
      listArray = Get.arguments["list"];
      currentChannnel = Get.arguments["currentNol"];
      bastChannel = listArray[0].channel!;
    });
    super.initState();
  }

  void updateCurrentChannel() {
    final sessionIdCha = StringUtil.generateRandomString(10);
    var topic = "cpe/$sn";
    var parameters = {
      "event": "mqtt2sodObj",
      "sn": sn,
      "sessionId": sessionIdCha,
      "pubTopic": setCurrentChannelTopic,
      "param": {
        "method": "set",
        "nodes": {
          "wifiChannel": bastChannel,
        }
      }
    };

    connect().then((value) {
      client = value;
    _publishMessage(topic, parameters);
    client.subscribe(setCurrentChannelTopic, MqttQos.atLeastOnce);
      _getDeviceList();
    });

  }

  _getListTableData(List<MqttReceivedMessage<MqttMessage>> data) {
    debugPrint("====================监听2.4G更新信道到新消息了======================");
    final MqttPublishMessage recMess = data[0].payload as MqttPublishMessage;
    final String topic = data[0].topic;
    final String pt = const Utf8Decoder().convert(recMess.payload.message);
    // String desString = "topic is <$topic>, payload is <-- $pt -->";
    // debugPrint("string =$desString");
    String result = pt.substring(0, pt.length - 1);
      String desString = "topic is <$topic>, payload is <-- $result -->";
      debugPrint("string =$desString");
    Map datas = jsonDecode(result);
      debugPrint("设置信道: =${datas["data"]}");
      if (datas["data"] == "Success") {
        setState(() {
          isLoaded = true;
          currentChannnel = listArray[0].channel!;
        });
      }
  }

  _getDeviceList() {
    client.updates!.listen(_getListTableData);
  }

  // 发送消息
  void _publishMessage(String topic, Map<String, dynamic> message) {
    debugPrint("======发送获取2.4G更新信道的消息成功了=======");
    debugPrint("======$message=======");
    var builder = MqttClientPayloadBuilder();
    var jsonData = json.encode(message);
    builder.addUTF8String(jsonData);
    client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }

  /// 获取当前的信道
  // Future getCurrentChannnel() async {
  //   // 获取SOD节点数据
  //   var parameterNames = {
  //     "method": "get",
  //     "nodes": ["wifiCurrentChannel"]
  //   };

  //   var res = await Request().getACSNode(parameterNames, sn);
  //   var jsonObj = jsonDecode(res);
  //   var currentChannelRes = jsonObj["data"]["wifiCurrentChannel"];
  //   setState(() {
  //     currentChannnel = currentChannelRes;
  //   });
  //   debugPrint('当前的信道是:----$jsonObj----}');
  // }

  /// 设置最优信道
  // Future<int> setUpBastChannnel() async {
  //   var parameters = {
  //     "method": "set",
  //     "nodes": {"wifiChannel": bastChannel}
  //   };
  //   var res = await Request().setACSNode(parameters, sn);
  //   var jsonObj = jsonDecode(res);
  //   debugPrint('返回的配置结果是:----$jsonObj----}');
  //   return jsonObj["code"];
  // }

  // getChannelResult() {
  //   setUpBastChannnel().then((res) {
  //     debugPrint('返回的结果是:----$res----}');
  //     if (res == 200) {
  //       timer = Timer.periodic(const Duration(milliseconds: 1000), (t) {
  //         getDeviceRestratResult().then((value) {
  //           if (value == "0") {
  //             t.cancel();
  //             getCurrentChannnel();
  //             setState(() {
  //               isLoaded = true;
  //             });
  //           }
  //         });
  //       });
  //     }
  //   });
  // }

  // Future<String> getDeviceRestratResult() async {
  //   var parameterNames = {
  //     "method": "get",
  //     "nodes": ["wifiIsRestart"]
  //   };

  //   var res = await Request().getACSNode(parameterNames, sn);
  //   var jsonObj = jsonDecode(res);
  //   var restartRes = jsonObj["data"]["wifiIsRestart"];
  //   debugPrint('当前的信道是:----$restartRes----}');
  //   return restartRes;
  // }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    // timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Get.back(result: currentChannnel);
            },
          ),
          title: const Text(
            "WiFi Quality",
            style: TextStyle(fontSize: 24, color: Colors.black),
          ),
        ),
        body: isLoaded
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      // flex: 4,
                      child: ListView.builder(
                          itemCount: listArray.length,
                          itemBuilder: (BuildContext context, int index) {
                            return setListItem(listArray[index]);
                          })),
                  Container(
                    width: double.infinity,
                    height: 100,
                    alignment: Alignment.topCenter,
                    child: OutlinedButton(
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.blue)),
                        onPressed: () {
                          setState(() {
                            isLoaded = false;
                            updateCurrentChannel();
                          });
                        },
                        child: const Text(
                          "Update",
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        )),
                  )
                ],
              )
            : setLoadingIndicator());
  }

  Widget setListItem(Band24GHz model) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 20,
            child: Text(
              "${model.channel}",
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            // padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
            child: SizedBox(
              height: 10,
              child: LinearProgressIndicator(
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation(Colors.blue),
                value: double.parse(model.quality!),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          SizedBox(
            width: 30,
            child: Text(
              currentChannnel == model.channel ? "now" : "",
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget setLoadingIndicator() {
    return Offstage(
      offstage: isLoaded,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoActivityIndicator(
              animating: true,
              radius: 20,
              color: Colors.grey,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "Optimizing, please wait",
              style: TextStyle(fontSize: 15, color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
