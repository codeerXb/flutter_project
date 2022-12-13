import 'package:flutter/material.dart';
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
          padding: const EdgeInsets.all(10),
          height: 780,
          decoration:
              const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
          child: Column(
            children: [
              Row(children: const [
                Icon(Icons.priority_high, color: Colors.red),
                Flexible(
                  child: Text(
                    'USIM卡的PIN码锁，可以保护本设备不被别人在您未授权的情况下接入互联网。您可以激活、修改、解锁自己USIM卡的PIN码；USIM未插入和PIN校验未通过时，设备不能提供互联网接入服务。',
                    style: TextStyle(fontSize: 14, color: Colors.red),
                  ),
                ),
              ]),
              Column(children: [
                const Padding(padding: EdgeInsets.only(top: 60)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('USIM卡状态', style: TextStyle(fontSize: 20)),
                    Text('SIM卡未准备完成', style: TextStyle(fontSize: 20))
                  ],
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
