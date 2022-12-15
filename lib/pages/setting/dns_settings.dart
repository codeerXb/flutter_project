import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/widget/custom_app_bar.dart';
import '../../core/widget/otp_input.dart';

/// DNS设置
class DnsSettings extends StatefulWidget {
  const DnsSettings({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DnsSettingsState();
}

class _DnsSettingsState extends State<DnsSettings> {
  final TextEditingController _fieldOne = TextEditingController();
  final TextEditingController _fieldOne1 = TextEditingController();
  final TextEditingController _fieldOne2 = TextEditingController();
  final TextEditingController _fieldOne3 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context: context, title: 'DNS设置'),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.sp),
          height: 1340.sp,
          decoration:
              const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
          child: Column(
            children: [
              Row(children: const [
                Icon(Icons.priority_high, color: Colors.red),
                Flexible(
                  child: Text(
                    '静态DNS，VPN DNS具有最高优先级，LTE DNS具有最低优先级. 如果要恢复VPN / LTE DNS，请清除两个DNS配置并提交',
                    style: TextStyle(fontSize: 14, color: Colors.red),
                  ),
                ),
              ]),
              Column(children: [
                Padding(padding: EdgeInsets.only(top: 120.sp)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text('主DNS'),
                    OtpInput(_fieldOne, false),
                    OtpInput(_fieldOne1, false),
                    OtpInput(_fieldOne2, false),
                    OtpInput(_fieldOne3, false),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 100.sp)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text('辅DNS'),
                    OtpInput(_fieldOne, false),
                    OtpInput(_fieldOne1, false),
                    OtpInput(_fieldOne2, false),
                    OtpInput(_fieldOne3, false),
                  ],
                ),
              ]),
              Padding(padding: EdgeInsets.only(top: 200.sp)),
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
