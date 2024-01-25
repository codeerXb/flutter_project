import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import './mqtt_service.dart';
import 'package:typed_data/typed_buffers.dart';
import './beans/mqtt_bean.dart';
import './mqtt_event_bus.dart';
import 'package:get/get.dart';
import "package:flutter_template/config/base_config.dart";

// ws://10.0.30.194:15674/ws
// 生产
// ws://3.234.163.231:8083/mqtt
// 测试
// ws://172.16.11.201:8083/mqtt

class MqttPage extends StatefulWidget {
  // final Map arguments;
  const MqttPage({Key? key}) : super(key: key);

  @override
  State<MqttPage> createState() => _MqttPageState();
}

class _MqttPageState extends State<MqttPage> {
  MqttClient client = MqttServerClient(
      BaseConfig.mqttMainUrl, "flutter_client",
      maxConnectionAttempts: 10);
  var message = "";
  List<mqtt_model> messageList = [];
  RxList list = [].obs;
  @override
  void initState() {
    connect().then((value) {
      client = value;
      debugPrint("执行到订阅这里了");
      client.subscribe("topic", MqttQos.atLeastOnce);
      _startListen();
      eventBus.on<MqttListenNotifiction>().listen((event) {
        // if (!mounted) return;
        setState(() {
          debugPrint("调用了吗?");
          // messageList.add(event.model);
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample Code'),
      ),
      body: Obx(() {
        return Center(
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return Text('Data received:${list[index].data!.msg}',
                  style: const TextStyle(color: Colors.black, fontSize: 25));
            },
            itemCount: list.length,
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _publish("topic", "message123");
        },
        tooltip: 'Increment Counter',
        child: const Icon(Icons.add),
      ),
    );
  }

//  监听消息的具体实现
  _onData(List<MqttReceivedMessage<MqttMessage>> data) {
    debugPrint("====================监听到新消息了======================");
    final MqttPublishMessage recMess = data[0].payload as MqttPublishMessage;
    final String topic = data[0].topic;
    final String pt = const Utf8Decoder().convert(recMess.payload.message);
    String desString = "topic is <$topic>, payload is <-- $pt -->";
    debugPrint("string =$desString");
    final payloadModel = mqtt_model.fromJson(jsonDecode(pt));
    //数据转模型或监听处理
    eventBus.fire(payloadModel);
    list.add(payloadModel);
  }

//  开启监听消息
  _startListen() {
    client.updates!.listen(_onData);
  }

// 发送消息
  void _publish(String topic, String message) {
    // final builder = MqttClientPayloadBuilder();
    // builder.addString('Hello from flutter_client:$message');
    Uint8Buffer uint8buffer = Uint8Buffer();
    var codeUnits = message.codeUnits;
    uint8buffer.addAll(codeUnits);

    client.publishMessage(topic, MqttQos.atLeastOnce, uint8buffer);
  }

// 订阅主题
  void subscribeTopic(String topic) {
    final state = client.connectionStatus?.state;
    if (state != null) {
      if (state == MqttConnectionState.connected) {
        debugPrint("执行到订阅这里了");
        client.subscribe("$topic/data", MqttQos.atLeastOnce);
      }
    }
  }

  @override
  void dispose() {
    // 断连
    client.disconnect();
    super.dispose();
  }
}
