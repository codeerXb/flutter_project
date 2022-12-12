import 'package:flutter/material.dart';
import 'package:flutter_template/core/widget/common_widget.dart';
import '../../../core/widget/custom_app_bar.dart';

/// DNS设置
class DnsSettings extends StatefulWidget {
  const DnsSettings({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DnsSettingsState();
}

class _DnsSettingsState extends State<DnsSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context: context, title: 'DNS设置'),
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
    list.add(CommonWidget.simpleWidgetWithUserDetail("DNS设置", callBack: () {
      print("DNS设置"); //dns_settings
    }));
    return list;
  }
}
