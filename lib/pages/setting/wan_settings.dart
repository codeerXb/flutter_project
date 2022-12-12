import 'package:flutter/material.dart';
import 'package:flutter_template/core/widget/common_widget.dart';
import '../../../core/widget/custom_app_bar.dart';

/// WAN设置
class WanSettings extends StatefulWidget {
  const WanSettings({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WanSettingsState();
}

class _WanSettingsState extends State<WanSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context: context, title: 'WAN设置'),
      body: SingleChildScrollView(
        child: Container(
          decoration:
              const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Row(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          child: const Text('网络模式'),
                          // Text('NAT'),
                          // Text('BRIDGE'),
                        )
                      ]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('提交'),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red)),
                          onPressed: () {},
                          child: const Text('取消'),
                        ),
                      ])
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> problemListWidget() {
    List<Widget> list = [];
    list.add(CommonWidget.simpleWidgetWithUserDetail("WAN设置", callBack: () {
      print("WAN设置"); //wan_settings
    }));
    return list;
  }
}
