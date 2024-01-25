import 'dart:async';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SocketChannelPage extends StatefulWidget {
  const SocketChannelPage({super.key});

  @override
  State<SocketChannelPage> createState() => _SocketChannelPageState();
}
//ws://3.234.163.231:8083/mqtt
// ws://10.0.30.194:15674/ws
// wss://echo.websocket.events
// ws://172.16.11.201:8083/mqtt
var wsUrl = Uri.parse('ws://10.0.30.194:15674/ws');

class _SocketChannelPageState extends State<SocketChannelPage> {
  final TextEditingController _controller = TextEditingController();
  // final _channel = IOWebSocketChannel.connect(wsUrl,
  //       headers: {'Connection': 'upgrade', 'Upgrade': 'websocket'});
  final _channel = WebSocketChannel.connect(wsUrl);
  late Stream _stream;
  
  @override
  void initState() {
    _listenOnData();
    super.initState();
  }

  _listenOnData() {
    // await _channel.ready;
    _stream = _channel.stream.asBroadcastStream();
    _stream.listen(
      (data) => debugPrint("Web测试获取到的数据: ${data.toString()}"),
      onDone: () {
        _closeConnect();
        reConnect();
      },
      onError: (err, stack) {
        _closeConnect();
        reConnect();
      },
      cancelOnError: true,
    );
  }

  void _closeConnect() {
    _channel.sink.close();
  }

  reConnect() async {
    debugPrint("${DateTime.now().toString()} Starting connection attempt...");
    await Future.delayed(const Duration(seconds: 4));
      // _channel = IOWebSocketChannel.connect(wsUrl,headers: {'Upgrade': "websocket","Connection" : "upgrade","origin":"ws://10.0.30.194:15674"});
      debugPrint("${DateTime.now().toString()} Connection attempt completed.");
    // setState(() {
      
    // });
    _stream.listen((data) => debugPrint("socket测试获取到的数据: ${data.toString()}"),
        onDone: reConnect, onError: wserror, cancelOnError: true);
  }

// 错误日志
  wserror(err) {
    debugPrint(err.runtimeType.toString());
    WebSocketChannelException ex = err;
    _channel.sink.close();
    debugPrint(ex.message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "SocketServer",
          style: TextStyle(fontSize: 22, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              child: TextFormField(
                controller: _controller,
                decoration: const InputDecoration(labelText: 'Send a message'),
              ),
            ),
            const SizedBox(height: 24),
            StreamBuilder(
              stream: _stream,
              builder: (context, snapshot) {
                return Text(snapshot.hasData ? '${snapshot.data}' : '');
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: const Icon(Icons.send),
      ),
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      _channel.sink.add(_controller.text);
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    _controller.dispose();
    super.dispose();
  }
}

