import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:get/get.dart';

class LanSpeedPage extends StatefulWidget {
  const LanSpeedPage({super.key});

  @override
  State<LanSpeedPage> createState() => _LanSpeedPageState();
}

class _LanSpeedPageState extends State<LanSpeedPage> {
  final flutterWebViewPlugin = FlutterWebviewPlugin();
  String url = "";

  @override
  void initState() {
    setState(() {
      var baseUrl = Get.arguments["lanspeedUrl"] as String;
      if (baseUrl.isEmpty) {
        url = "http://192.168.1.1/pub/speedtest.html";
      }else {
        url = "http://$baseUrl/pub/speedtest.html";
      }
      
    });
    flutterWebViewPlugin.close();
    super.initState();
  }

  @override
  void dispose() {
    flutterWebViewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Lan Speed Test',
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
        ),
        body: Container(
          child: WebviewScaffold(
            url: url,
            //当WebView没加载出来前显示
            initialChild: Container(
              color: Colors.white,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ));
  }
}
