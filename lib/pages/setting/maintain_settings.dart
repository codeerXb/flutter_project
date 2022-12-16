import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/widget/custom_app_bar.dart';

/// 维护设置
class MaintainSettings extends StatefulWidget {
  const MaintainSettings({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MaintainSettingsState();
}

class _MaintainSettingsState extends State<MaintainSettings> {
  // 多选框
  var status = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context: context, title: '维护设置'),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.sp),
          decoration:
              const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 20.sp)),
              Row(children: const [
                TitleWidger(title: '重启定时'),
              ]),
              InfoBox(
                boxCotainer: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text('开启重启定时'),
                    Padding(padding: EdgeInsets.only(right: 20.sp)),
                    Checkbox(
                      value: status,
                      // 改变后的事件
                      onChanged: (value) {
                        setState(() {
                          status = value!;
                        });
                      },
                      // 选中后的颜色
                      activeColor: Colors.blueAccent,
                      // 选中后对号的颜色
                      checkColor: Colors.white,
                    ),
                    const Text('启用'),
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 40.sp)),
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
                      child: const Text('提交'),
                    ),
                  )
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 60.sp)),
              Row(children: const [
                TitleWidger(title: '重启'),
              ]),
              Column(children: [
                Padding(padding: EdgeInsets.only(top: 10.sp)),
                InfoBox(
                  boxCotainer: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        '点击 重启 按钮重启设备',
                        style: TextStyle(color: Colors.black, fontSize: 28.sp),
                      ),
                      Padding(padding: EdgeInsets.only(right: 100.sp)),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color.fromARGB(255, 48, 118, 250))),
                        onPressed: () {},
                        child: const Text('重启'),
                      ),
                    ],
                  ),
                ),
              ]),
              Padding(padding: EdgeInsets.only(top: 60.sp)),
              Row(children: const [
                TitleWidger(title: '恢复出厂'),
              ]),
              Column(children: [
                Padding(padding: EdgeInsets.only(top: 10.sp)),
                InfoBox(
                  boxCotainer: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        '点击 恢复出厂 按钮进行恢复出厂操作',
                        style: TextStyle(color: Colors.black, fontSize: 28.sp),
                      ),
                      Padding(padding: EdgeInsets.only(right: 20.sp)),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color.fromARGB(255, 48, 118, 250))),
                        onPressed: () {},
                        child: const Text('恢复出厂'),
                      ),
                    ],
                  ),
                ),
              ]),
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
        style: TextStyle(color: Colors.blueAccent, fontSize: 32.sp),
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
