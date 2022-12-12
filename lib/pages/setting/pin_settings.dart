import 'package:flutter/material.dart';
import 'package:flutter_template/core/widget/common_widget.dart';
import '../../../core/widget/custom_app_bar.dart';

/// PIN设置
class PinSettings extends StatefulWidget {
  const PinSettings({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PinSettingsState();
}

class _PinSettingsState extends State<PinSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context: context, title: 'PIN设置'),
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
    list.add(CommonWidget.simpleWidgetWithUserDetail("PIN码管理", callBack: () {
      print("PIN码管理"); //pin_settings
    }));
    return list;
  }
}
