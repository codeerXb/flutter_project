import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/widget/custom_app_bar.dart';
import '../../core/widget/common_widget.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context: context, title: 'WAN设置'),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(20.sp),
            decoration:
                const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
            child: Column(children: [
              SizedBox(
                height: 80.sp,
              ),
              InfoBox(
                boxCotainer: Row(children: [
                  Flexible(
                    child: Text('网络模式', style: TextStyle(fontSize: 32.sp)),
                  ),
                  SizedBox(
                    width: 200.sp,
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
                  SizedBox(
                    width: 40.sp,
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
              ),
              SizedBox(
                height: 120.sp,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: 70.sp,
                    width: 700.sp,
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
              ),
            ])),
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
        padding: EdgeInsets.all(2.0.sp),
        margin: EdgeInsets.only(bottom: 5.sp),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: boxCotainer);
  }
}
