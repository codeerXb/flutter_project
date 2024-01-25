import 'dart:async';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// WebSocket地址
const String _SOCKET_URL = 'wss://echo.websocket.events';

/// WebSocket状态
enum SocketStatus {
  SocketStatusConnected, // 已连接
  SocketStatusFailed, // 失败
  SocketStatusClosed, // 连接关闭
}

class WebSocketUtility {

  static final WebSocketUtility _instance = WebSocketUtility._internal();

  factory WebSocketUtility() => _instance;
  WebSocketChannel? _webSocket;
  late Stream _stream;
  WebSocketUtility._internal() {
    // if (null == _client) {
    //   Options options = new Options();
    //   options.baseUrl = "http://www.wanandroid.com";
    //   options.receiveTimeout = 1000 * 10; //10秒
    //   options.connectTimeout = 5000; //5秒
    //   _client = new Dio(options);
    // }
    _webSocket = WebSocketChannel.connect(Uri.parse(_SOCKET_URL));
    _stream = _webSocket!.stream;
  }


  /// 单例对象
  // static WebSocketUtility? _socket;

  /// 内部构造方法，可避免外部暴露构造函数，进行实例化
  // WebSocketUtility._();

  /// 获取单例内部方法
  // factory WebSocketUtility() {
  //   // 只能有一个实例
  //   // if (_socket == null) {

  //   // }
  //   _socket ??= WebSocketUtility();
  //   return _socket!;
  // }

  // final IOWebSocketChannel // WebSocket
  SocketStatus _socketStatus = SocketStatus.SocketStatusConnected; // socket状态
  Timer? _heartBeat; // 心跳定时器
  final int _heartTimes = 3000; // 心跳间隔(毫秒)
  final int _reconnectCount = 60; // 重连次数，默认60次
  int _reconnectTimes = 0; // 重连计数器
  Timer? _reconnectTimer; // 重连定时器
  Function? onError; // 连接错误回调
  Function? onOpen; // 连接开启回调
  Function? onMessage; // 接收消息回调

  /// 初始化WebSocket
  void initWebSocket(
      {Function? onOpen, Function? onMessage, Function? onError}) {
    this.onOpen = onOpen;
    this.onMessage = onMessage;
    this.onError = onError;
    openSocket();
  }

  /// 开启WebSocket连接
  void openSocket() {
    closeSocket();
    debugPrint('WebSocket连接成功: $_SOCKET_URL');
    // 连接成功，返回WebSocket实例
    _socketStatus = SocketStatus.SocketStatusConnected;
    // 连接成功，重置重连计数器
    _reconnectTimes = 0;
    if (_reconnectTimer != null) {
      _reconnectTimer!.cancel();
      _reconnectTimer = null;
    }
    onOpen!();
    // 接收消息
    // _stream = _webSocket!.stream.asBroadcastStream();
    _stream.listen((data) => webSocketOnMessage(data),
        onError: webSocketOnError, onDone: webSocketOnDone);
  }

  Stream getStream() {
    return _webSocket!.stream.asBroadcastStream();
  }
  
  /// WebSocket接收消息回调
  webSocketOnMessage(data) {
    onMessage!(data);
  }

  /// WebSocket关闭连接回调
  webSocketOnDone() {
    debugPrint('closed');
    reconnect();
  }

  /// WebSocket连接错误回调
  webSocketOnError(e) {
    WebSocketChannelException ex = e;
    _socketStatus = SocketStatus.SocketStatusFailed;
    onError!(ex.message);
    closeSocket();
  }

  /// 初始化心跳
  void initHeartBeat() {
    destroyHeartBeat();
    _heartBeat = Timer.periodic(Duration(milliseconds: _heartTimes), (timer) {
      sentHeart();
    });
  }

  /// 心跳
  void sentHeart() {
    sendMessage('{"module": "HEART_CHECK", "message": "请求心跳"}');
  }

  /// 销毁心跳
  void destroyHeartBeat() {
    if (_heartBeat != null) {
      _heartBeat!.cancel();
      _heartBeat = null;
    }
  }

  /// 关闭WebSocket
  void closeSocket() {
    debugPrint('WebSocket连接关闭');
    _webSocket!.sink.close();
    destroyHeartBeat();
    _socketStatus = SocketStatus.SocketStatusClosed;
  }

  /// 发送WebSocket消息
  void sendMessage(message) {
    switch (_socketStatus) {
      case SocketStatus.SocketStatusConnected:
        debugPrint('发送中：${message.toString()}');
        _webSocket!.sink.add(message);
        break;
      case SocketStatus.SocketStatusClosed:
        debugPrint('连接已关闭');
        break;
      case SocketStatus.SocketStatusFailed:
        debugPrint('发送失败');
        break;
      default:
        break;
    }
  }

  /// 重连机制
  void reconnect() {
    if (_reconnectTimes < _reconnectCount) {
      _reconnectTimes++;
      _reconnectTimer =
          Timer.periodic(Duration(milliseconds: _heartTimes), (timer) {
        openSocket();
      });
    } else {
      if (_reconnectTimer != null) {
        debugPrint('重连次数超过最大次数');
        _reconnectTimer!.cancel();
        _reconnectTimer = null;
      }
      return;
    }
  }
}
