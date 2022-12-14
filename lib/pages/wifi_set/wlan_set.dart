import 'package:flutter/material.dart';
import '../../core/widget/custom_app_bar.dart';

/// WLAN设置
class WlanSet extends StatefulWidget {
  const WlanSet({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WlanSetState();
}

class _WlanSetState extends State<WlanSet> {
  bool isCheck = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(context: context, title: 'WLAN设置'),
        body: Container(
          padding: const EdgeInsets.all(10.0),
          decoration:
              const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
          height: 1000,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children:const [Text('1')],
            ),
          ),
        ));
  }
}
