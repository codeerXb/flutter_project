import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

class NetworkPage extends StatefulWidget {
  const NetworkPage({required Key key}) : super(key: key);
  @override
  _NetworkPageState createState() => _NetworkPageState();
}

class _NetworkPageState extends State<NetworkPage> {
  bool _isConnected = true;
  late OverlayEntry _overlayEntry;

  @override
  void initState() {
    super.initState();
    // 监听网络连接状态变化
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _isConnected = (result != ConnectivityResult.none);
        if (_isConnected) {
          // 如果有网络连接，移除弹窗
          _overlayEntry.remove();
          print('111');
        } else {
          print('222');
          // 如果没有网络连接，显示弹窗
          _showOverlay();
          print('333');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("检测网络变化")),
        body: const Center(
          child: Text('主屏'),
        ));
  }

  void _showOverlay() {
    // 创建一个OverlayEntry并显示在屏幕上
    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return Stack(
          children: <Widget>[
            // 全屏黑色半透明背景
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            // 网络连接断开的提示弹窗
            Positioned(
              top: MediaQuery.of(context).size.height * 0.2,
              left: MediaQuery.of(context).size.width * 0.1,
              right: MediaQuery.of(context).size.width * 0.1,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const <Widget>[
                    Text(
                      '没有互联网连接',
                      style: TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      '请检查您的网络设置并重试。',
                      style: TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
    Overlay.of(context)!.insert(_overlayEntry);
  }
}
