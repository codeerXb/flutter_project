import 'package:flutter/material.dart';
import 'package:flutter_template/core/widget/common_widget.dart';
import '../../../core/widget/custom_app_bar.dart';

/// 无线开关
class WirelessSwitch extends StatefulWidget {
  const WirelessSwitch({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WirelessSwitchState();
}

class _WirelessSwitchState extends State<WirelessSwitch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context: context, title: '无线开关'),
      body: SingleChildScrollView(
        child: Container(
          decoration:
              const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: problemListWidget(),
          ),
        ),
      ),
    );
  }

  List<Widget> problemListWidget() {
    List<Widget> list = [];
    list.add(CommonWidget.simpleWidgetWithUserDetail("无线开关", callBack: () {
      print("无线开关"); //wireless_switch
    }));
    return list;
  }
}
