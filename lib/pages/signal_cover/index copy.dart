import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import './wifi_info.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late String _wifiObject;

  @override
  void initState() {
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<String> initPlatformState() async {
    WifiInfoWrapper? wifiObject;
    // Platform messages may fail, so we use a try/catch PlatformException.
    wifiObject = await WifiInfoPlugin.wifiDetails;

    return wifiObject.signalStrength.toString();
  }

  @override
  Widget build(BuildContext context) {
    // _wifiObject != null ? _wifiObject.ipAddress.toString() : "ip";
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Custom Apartment Layout '),
        ),
        body: FutureBuilder<String>(
            future: initPlatformState(),
            builder: (context, snapshot) {
              // 请求已结束
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  // 请求失败，显示错误
                  return Text("Error: ${snapshot.error}");
                } else {
                  // 请求成功，显示数据
                  return Center(child: Text("Contents: ${snapshot.data}"));
                }
              } else {
                // 请求未结束，显示loading
                return const CircularProgressIndicator();
              }
            }),
      ),
    );
  }
}
