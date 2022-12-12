import 'package:flutter/material.dart';
import 'package:flutter_template/core/widget/common_widget.dart';
import '../../../core/widget/custom_app_bar.dart';

/// LAN设置
class LanSettings extends StatefulWidget {
  const LanSettings({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LanSettingsState();
}

class _LanSettingsState extends State<LanSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context: context, title: 'LAN设置'),
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
    list.add(CommonWidget.simpleWidgetWithUserDetail("LAN设置", callBack: () {
      print("LAN设置"); //lan_settings
    }));
    return list;
  }
}
