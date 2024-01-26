import 'package:flutter/material.dart';
import '../../core/mqtt/mqtt_service.dart';
import '../../config/base_config.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import '../../pages/net_status/beans/speed_bean.dart';
import '../../core/utils/string_util.dart';
import 'dart:convert';

class SpeedTestHomeVC extends StatefulWidget {
  const SpeedTestHomeVC({super.key});

  @override
  State<SpeedTestHomeVC> createState() => _SpeedTestHomeVCState();
}

class _SpeedTestHomeVCState extends State<SpeedTestHomeVC> {
  MqttClient client = MqttServerClient(BaseConfig.mqttMainUrl, "flutter_client",
      maxConnectionAttempts: 10);

  String sn = "";
  SpeedModel? speedmodel;
  String downUnit = 'Kbps';
  String upUnit = 'Kbps';

  String testUp = '0 Kbps';
  String testDown = '0 Kbps';
  String lantency = '0 ms';
  bool testLoading = false;
  String speedTime = "";

  requestTestSpeedData(String sn) async {
    var subTopic = "cpe/$sn";
    connect().then((value) {
      client = value;
      debugPrint("执行到订阅这里了,订阅的主题是:$subTopic");
      final sessionIdStr = StringUtil.generateRandomString(10);
      var parameterNames = {
        "event": "getSpeedtest",
        "sn": sn,
        "sessionId": sessionIdStr,
        "pubTopic": "$subTopic-sma_server_1"
      };
      _publishMessage(subTopic, parameterNames);
      client.subscribe("$subTopic-sma_server_1", MqttQos.atLeastOnce);
    });
  }

  _getListTableData(List<MqttReceivedMessage<MqttMessage>> data) {
    debugPrint("====================监听到新消息了======================");
    final MqttPublishMessage recMess = data[0].payload as MqttPublishMessage;
    final String topic = data[0].topic;
    // final pt =
    // MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    String pt = const Utf8Decoder().convert(recMess.payload.message);
    String result = pt.substring(0, pt.length - 1);
    String desString = "topic is <$topic>, payload is <-- $result -->";
    debugPrint("string =$desString");
    final payloadModel = SpeedModel.fromJson(jsonDecode(result));
    setState(() {
      speedmodel = payloadModel;
    });
    
    debugPrint("测速数据: =${speedmodel!.data!.download!}");
  }

//  开启监听消息
  _getDeviceList() {
    client.updates!.listen(_getListTableData);
  }

  // 发送消息
  void _publishMessage(String topic, Map<String, dynamic> message) {
    debugPrint("======发送获取App测速的消息成功了=======");
    debugPrint("===$topic ===$message=======");
    var builder = MqttClientPayloadBuilder();
    var jsonData = json.encode(message);
    builder.addUTF8String(jsonData);

    client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }

  @override
  void initState() {
    sharedGetData('deviceSn', String).then(((res) {
      debugPrint('deviceSn$res');
      requestTestSpeedData(sn);
    }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Speed Test',style: TextStyle(fontSize: 20,color: Colors.black),),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Recent speed test results",
          style: TextStyle(color: Colors.grey, fontSize: 15),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          speedTime,
          style: const TextStyle(color: Colors.blue, fontSize: 15),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          'Up⬆ $testUp',
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          'Down⬇ $testDown',
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          'Lantency $lantency',
          style: const TextStyle(fontSize: 14),
        )
      ],
    )
      ),
    );
  }
}