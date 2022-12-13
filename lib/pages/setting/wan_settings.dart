import 'package:flutter/material.dart';
import 'package:flutter_template/core/widget/common_widget.dart';
import 'package:get/get.dart';
import '../../../core/widget/custom_app_bar.dart';

/// WAN设置
class WanSettings extends StatefulWidget {
  const WanSettings({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WanSettingsState();
}

class _WanSettingsState extends State<WanSettings> {
  int sex = 1;
  int status = 1;
  bool flag = true;

  get child => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context: context, title: 'WAN设置'),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(10),
            height: 780,
            decoration:
                const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
            child: Column(children: [
              const SizedBox(
                height: 40,
              ),
              Row(children: [
                const Flexible(
                  child: Text('网络模式', style: TextStyle(fontSize: 20)),
                ),
                const SizedBox(
                  width: 60,
                ),
                Radio(
                  // 按钮的值
                  value: 1,
                  // 改变事件
                  onChanged: (value) {
                    setState(() {
                      sex = value.hashCode;
                    });
                  },
                  // 按钮组的值
                  groupValue: sex,
                ),
                const Text("NAT"),
                const SizedBox(
                  width: 20,
                ),
                Radio(
                  value: 2,
                  onChanged: (value) {
                    setState(() {
                      sex = value.hashCode;
                    });
                  },
                  groupValue: sex,
                ),
                const Text("BRIDGE"),
              ]),
              const SizedBox(
                height: 60,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('提交'),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red)),
                  onPressed: () {},
                  child: const Text('取消'),
                ),
              ])
            ])),
      ),
    );
  }
}
