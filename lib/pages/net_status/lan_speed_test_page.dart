
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';

class LanSpeedPage extends StatefulWidget {
  const LanSpeedPage({super.key});

  @override
  State<LanSpeedPage> createState() => _LanSpeedPageState();
}

class _LanSpeedPageState extends State<LanSpeedPage> {
  late final WebViewController _controller;
  // final flutterWebViewPlugin = FlutterWebviewPlugin();
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
    
    super.initState();

    _controller = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..setBackgroundColor(const Color(0x00000000))
  ..setNavigationDelegate(
    NavigationDelegate(
      onProgress: (int progress) {
        // Update loading bar.
      },
      onPageStarted: (String url) {},
      onPageFinished: (String url) {},
      onWebResourceError: (WebResourceError error) {},
      onNavigationRequest: (NavigationRequest request) {
        if (request.url.startsWith('https://www.youtube.com/')) {
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      },
    ),
  )
  ..loadRequest(Uri.parse(url));
  }

  @override
  void dispose() {
    // flutterWebViewPlugin.dispose();
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
        body: WebViewWidget(controller: _controller));
  }
}
