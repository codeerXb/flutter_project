import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

class NetworkPage extends StatefulWidget {
  const NetworkPage({required Key key}) : super(key: key);
  @override
  _NetworkPageState createState() => _NetworkPageState();
}

class _NetworkPageState extends State<NetworkPage> {
  // 定义事件
  var subscription;
  // 网络提示
  late String _stateText;

  // 初始化状态
  @override
  void initState() {
    super.initState();

    // 官方代码
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      // WIFI网络
      if (result == ConnectivityResult.wifi) {
        setState(() {
          _stateText = "当前为WIFI网络";
        });
        // 移动网络
      } else if (result == ConnectivityResult.mobile) {
        setState(() {
          _stateText = "当前为手机网络";
        });
        // 没有网络
      } else {
        setState(() {
          _stateText = "当前没有网络";
        });
      }
    });
  }

  // 消毁组件
  @override
  dispose() {
    super.dispose();
    // 消毁组件
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("检测网络变化")),
        body: Center(child: Text("${_stateText}")));
  }
}
