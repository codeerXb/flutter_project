import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({super.key});

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  String url = 'http://3.234.163.231:8000/app.html';
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  @override
  void initState() {
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
            'Privacy Policy',
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