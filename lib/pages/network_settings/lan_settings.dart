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

  bool isCheck = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context: context, title: 'LAN设置'),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.sp),
          decoration:
              const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 20.sp)),
              Row(children: const [
                TitleWidger(title: 'LAN主机设置'),
              ]),
              InfoBox(
                boxCotainer: Column(children: [
                  Padding(padding: EdgeInsets.only(top: 40.sp)),
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
                  Padding(padding: EdgeInsets.only(top: 40.sp)),
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
                  Padding(padding: EdgeInsets.only(bottom: 20.sp)),
                ]),
              ),
              Padding(padding: EdgeInsets.only(top: 80.sp)),
              Row(children: const [
                TitleWidger(title: 'DHCP 配置'),
              ]),
              InfoBox(
                boxCotainer: Column(children: [
                  Padding(padding: EdgeInsets.only(top: 20.sp)),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('DHCP 服务器'),
                        Switch(
                          value: isCheck,
                          onChanged: (newVal) {
                            setState(() {
                              isCheck = newVal;
                            });
                          },
                        ),
                      ]),
                  Padding(padding: EdgeInsets.only(top: 40.sp)),
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
                  Padding(padding: EdgeInsets.only(top: 40.sp)),
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
                  Padding(padding: EdgeInsets.only(top: 40.sp)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text('租约时间'),
                      SizedBox(
                        width: 510.sp,
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
                  Padding(padding: EdgeInsets.only(bottom: 20.sp)),
                ]),
              ),
              Padding(padding: EdgeInsets.only(top: 150.sp)),
              Row(
                children: [
                  SizedBox(
                    height: 70.sp,
                    width: 710.sp,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 48, 118, 250))),
                      onPressed: () {},
                      child: Text(
                        '提交',
                        style: TextStyle(fontSize: 36.sp),
                      ),
                    ),
                  )
                ],
              )
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
        style: TextStyle(color: Colors.blueAccent, fontSize: 30.sp),
      ),
    );
  }
}

class InfoBox extends StatelessWidget {
  final Widget boxCotainer;

  const InfoBox({super.key, required this.boxCotainer});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10.0.w),
        margin: EdgeInsets.only(bottom: 3.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.w),
        ),
        child: boxCotainer);
  }
}