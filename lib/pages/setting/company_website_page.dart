import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CompanyWebsitePage extends StatefulWidget {
  const CompanyWebsitePage({super.key});

  @override
  State<CompanyWebsitePage> createState() => _CompanyWebsitePageState();
}

class _CompanyWebsitePageState extends State<CompanyWebsitePage> {
  // final flutterWebViewPlugin = FlutterWebviewPlugin();
  late final WebViewController _controller;
  String url = "https://codiumnetworks.com/";

  @override
  void initState() {
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
    super.initState();
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
            'Website',
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
        ),
        body: WebViewWidget(controller: _controller));
  }
}