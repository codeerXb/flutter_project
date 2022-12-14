import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/widget/custom_app_bar.dart';
import '../../core/widget/otp_input.dart';

/// LAN设置
class LanSettings extends StatefulWidget {
  const LanSettings({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LanSettingsState();
}

class _LanSettingsState extends State<LanSettings> {
  final TextEditingController _fieldOne = TextEditingController();
  final TextEditingController _fieldOne1 = TextEditingController();
  final TextEditingController _fieldOne2 = TextEditingController();
  final TextEditingController _fieldOne3 = TextEditingController();
  // 多选框
  var status = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context: context, title: 'LAN设置'),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          height: 780,
          decoration:
              const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
          child: Column(
            children: [
              const Padding(padding: EdgeInsets.only(top: 40)),
              Row(children: const [
                TitleWidger(title: 'LAN主机设置'),
              ]),
              Column(children: [
                const Padding(padding: EdgeInsets.only(top: 30)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text('IP地址'),
                    OtpInput(_fieldOne, false),
                    OtpInput(_fieldOne1, false),
                    OtpInput(_fieldOne2, false),
                    OtpInput(_fieldOne3, false),
                    const Text(
                      '*',
                      style: TextStyle(color: Colors.red),
                    )
                  ],
                ),
                const Padding(padding: EdgeInsets.only(top: 30)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text('子网掩码'),
                    OtpInput(_fieldOne, false),
                    OtpInput(_fieldOne1, false),
                    OtpInput(_fieldOne2, false),
                    OtpInput(_fieldOne3, false),
                    const Text(
                      '*',
                      style: TextStyle(color: Colors.red),
                    )
                  ],
                ),
              ]),
              const Padding(padding: EdgeInsets.only(top: 40)),
              Row(children: const [
                TitleWidger(title: 'DHCP 配置'),
              ]),
              Column(children: [
                const Padding(padding: EdgeInsets.only(top: 30)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text('DHCP 服务器'),
                    const Padding(padding: EdgeInsets.only(right: 160)),
                    Checkbox(
                      value: status,
                      // 改变后的事件
                      onChanged: (value) {
                        setState(() {
                          status = value!;
                        });
                      },
                      // 选中后的颜色
                      activeColor: Colors.blue,
                      // 选中后对号的颜色
                      checkColor: Colors.white,
                    ),
                    const Text('启用'),
                  ],
                ),
                const Padding(padding: EdgeInsets.only(top: 30)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text('起始地址'),
                    OtpInput(_fieldOne, false),
                    OtpInput(_fieldOne1, false),
                    OtpInput(_fieldOne2, false),
                    OtpInput(_fieldOne3, false),
                    const Text(
                      '*',
                      style: TextStyle(color: Colors.red),
                    )
                  ],
                ),
                const Padding(padding: EdgeInsets.only(top: 30)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text('结束地址'),
                    OtpInput(_fieldOne, false),
                    OtpInput(_fieldOne1, false),
                    OtpInput(_fieldOne2, false),
                    OtpInput(_fieldOne3, false),
                    const Text(
                      '*',
                      style: TextStyle(color: Colors.red),
                    )
                  ],
                ),
                const Padding(padding: EdgeInsets.only(top: 30)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text('租约时间'),
                    SizedBox(
                      width: 500.sp,
                      child: const TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "请输入租约时间（2/m~1440/m）",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const Text(
                      '*',
                      style: TextStyle(color: Colors.red),
                    )
                  ],
                ),
              ]),
              const Padding(padding: EdgeInsets.only(top: 100)),
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
            ],
          ),
        ),
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
