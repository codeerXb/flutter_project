import 'package:flutter/material.dart';
import '../../../core/widget/custom_app_bar.dart';

/// Radio设置
class RadioSettings extends StatefulWidget {
  const RadioSettings({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RadioSettingsState();
}

class _RadioSettingsState extends State<RadioSettings> {
  int sex = 1;
  int status = 1;
  bool flag = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context: context, title: 'Radio设置'),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('状态', style: TextStyle(fontSize: 20)),
                  Text('SIM卡未准备完成', style: TextStyle(fontSize: 20))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(children: [
                const Flexible(
                  child: Text('连接方式', style: TextStyle(fontSize: 20)),
                ),
                const SizedBox(
                  width: 120,
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
                const Text("手动"),
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
                const Text("自动"),
              ]),
              const SizedBox(
                height: 30,
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
              ]),
              Column(children: [
                const SizedBox(
                  height: 40,
                ),
                Row(children: const [
                  TitleWidger(title: '4G状态'),
                ]),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('下行频率', style: TextStyle(fontSize: 16)),
                    Text('- - MHZ', style: TextStyle(fontSize: 16))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('上行频率', style: TextStyle(fontSize: 16)),
                    Text('- - MHZ', style: TextStyle(fontSize: 16))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Band', style: TextStyle(fontSize: 16)),
                    Text('- - ', style: TextStyle(fontSize: 16))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Bandwidth', style: TextStyle(fontSize: 16)),
                    Text('- - MHZ', style: TextStyle(fontSize: 16))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('RSRP', style: TextStyle(fontSize: 16)),
                    Text('- - dBm', style: TextStyle(fontSize: 16))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('RSSI', style: TextStyle(fontSize: 16)),
                    Text('- - dBm', style: TextStyle(fontSize: 16))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('RSRQ', style: TextStyle(fontSize: 16)),
                    Text('- - dB', style: TextStyle(fontSize: 16))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('SINR', style: TextStyle(fontSize: 16)),
                    Text('- - dB', style: TextStyle(fontSize: 16))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('发射功率', style: TextStyle(fontSize: 16)),
                    Text('- - dBm', style: TextStyle(fontSize: 16))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('PCI', style: TextStyle(fontSize: 16)),
                    Text('- - ', style: TextStyle(fontSize: 16))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Cell ID', style: TextStyle(fontSize: 16)),
                    Text('- - ', style: TextStyle(fontSize: 16))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('MCC', style: TextStyle(fontSize: 16)),
                    Text('- - MHZ', style: TextStyle(fontSize: 16))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('MNC', style: TextStyle(fontSize: 16)),
                    Text('- - MHZ', style: TextStyle(fontSize: 16))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
              ])
            ])),
      ),
    );
  }
}

class TitleWidger extends StatelessWidget {
  final String title;

  const TitleWidger({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        title,
        style: const TextStyle(color: Colors.blue, fontSize: 18),
      ),
    );
  }
}
