import 'package:flutter/material.dart';
import 'package:flutter_template/pages/wifi_set/visitor/2.4GHZ_visitor/2.4GHZ_datas.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'dart:convert' as convert;
import 'dart:async';

class SocketPage extends StatefulWidget {
  const SocketPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SocketState();
}

class _SocketState extends State<SocketPage> {
  Map mapData1 = {
    "cmd": 2,
    "param1": 0,
    "param2": 1,
    "param3": 0,
    "param4": 0,
    "data_table": [{}]
  };

  late WebSocketChannel channel;

  @override
  void initState() {
    super.initState();
    wsConnect();
  }

  onData(message) {
    debugPrint("res -----> $message");
  }

  wsConnect() {
    final wsUrl = Uri.parse('ws://192.168.225.10:4321');
    channel = WebSocketChannel.connect(wsUrl);
    // channel.sink.add(convert.jsonEncode(mapData));
    channel.stream.listen(onData, onDone: (() {
      debugPrint("onDone");
    }), onError: (error) {
      debugPrint("连接ws 错误");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("WebSocket"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
      ),
    );
  }

  void _sendMessage() {
    print(1);
    channel.sink.add(convert.jsonEncode(mapData1)); // 发送数据.
    // Timer.periodic(const Duration(milliseconds: 200), (timer) {
    //   channel.sink.add(convert.jsonEncode(mapData2)); // 发送数据.
    // });
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}
