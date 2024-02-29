import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class CompanyWebsitePage extends StatefulWidget {
  const CompanyWebsitePage({super.key});

  @override
  State<CompanyWebsitePage> createState() => _CompanyWebsitePageState();
}

class _CompanyWebsitePageState extends State<CompanyWebsitePage> {
  final flutterWebViewPlugin = FlutterWebviewPlugin();
  String url = "https://codiumnetworks.com/";

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
            'Website',
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