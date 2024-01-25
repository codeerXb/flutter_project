import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';
class WebSocketService {
  IOWebSocketChannel channel = IOWebSocketChannel.connect('wss://echo.websocket.events');
  init() async {
    return await createWebsocket();
  }

  createWebsocket() async {
    var obj = {
      "uid": "uid",
      "type": 1,
      "nickname": "nickname",
      "msg": "",
      "bridge": [],
      "groupId": ""
    };
    String text = json.encode(obj).toString();
    channel.sink.add(text);
     //监听到服务器返回消息
    channel.stream.listen((data) => listenMessage(data),onError: onError,onDone: onDone);
  }

  listenMessage(data){
    var obj = jsonDecode(data);
    debugPrint(data);
  }

  sendMessage(data){//发送消息
  var obj = {
      "uid": "uid",
      "type": 2,
      "nickname": "nickname",
      "msg": data,
      "bridge": "_bridge" ,
      "groupId": "_groupId"
    };
    String text = json.encode(obj).toString();
    debugPrint(text);
    channel.sink.add(text);
  }

  onError(error){
    debugPrint('error------------>${error.toString()}');
  }

  void onDone() {
    debugPrint('websocket断开了');
    createWebsocket();
    debugPrint('websocket重连');
  }

  closeWebSocket(){//关闭链接
    channel.sink.close();
    debugPrint('关闭了websocket');
  }
}