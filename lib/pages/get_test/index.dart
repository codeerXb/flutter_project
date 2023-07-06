import 'dart:async';

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class GlobalNetworkDialog extends StatefulWidget {
  @override
  GlobalNetworkDialogState createState() => GlobalNetworkDialogState();
}

class GlobalNetworkDialogState extends State<GlobalNetworkDialog> {
  late StreamSubscription<ConnectivityResult> subscription;
  bool isOnline = true;

  @override
  void initState() {
    super.initState();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      setState(() {
        isOnline = result != ConnectivityResult.none;
      });
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: StreamBuilder(
        stream: Connectivity().onConnectivityChanged,
        builder:
            (BuildContext context, AsyncSnapshot<ConnectivityResult> snapshot) {
          if (snapshot.hasData && snapshot.data != ConnectivityResult.none) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('My App'),
              ),
              body: const Center(
                child: Text('在线!'),
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: const Text('My App'),
              ),
              body: const Center(
                child: Text('离线!'),
              ),
            );
          }
        },
      ),
    );
  }
}
