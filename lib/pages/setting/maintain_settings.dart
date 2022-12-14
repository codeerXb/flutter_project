import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/widget/custom_app_bar.dart';
import '../../core/widget/otp_input.dart';

/// LAN设置
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
      appBar: customAppbar(context: context, title: 'LAN设置'),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.sp),
          height: 1340.sp,
          decoration:
              const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 20.sp)),
              Row(children: const [
                TitleWidger(title: '重启定时'),
              ]),
              Row(
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
                    activeColor: Colors.blue,
                    // 选中后对号的颜色
                    checkColor: Colors.white,
                  ),
                  const Text('启用'),
                ],
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
              Padding(padding: EdgeInsets.only(top: 20.sp)),
              Row(children: const [
                TitleWidger(title: '重启'),
              ]),
              Column(children: [
                Padding(padding: EdgeInsets.only(top: 10.sp)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      '点击 重启 按钮重启设备',
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    Padding(padding: EdgeInsets.only(right: 100.sp)),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('重启'),
                    ),
                  ],
                ),
              ]),
              Padding(padding: EdgeInsets.only(top: 20.sp)),
              Row(children: const [
                TitleWidger(title: '恢复出厂'),
              ]),
              Column(children: [
                Padding(padding: EdgeInsets.only(top: 10.sp)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      '点击 恢复出厂 按钮进行恢复出厂操作',
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    Padding(padding: EdgeInsets.only(right: 20.sp)),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('恢复出厂'),
                    ),
                  ],
                ),
              ]),
              Padding(padding: EdgeInsets.only(top: 20.sp)),
              Row(children: const [
                TitleWidger(title: '下载配置文件'),
              ]),
              Column(children: [
                Padding(padding: EdgeInsets.only(top: 10.sp)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      '点击 下载 下载当前配置文件',
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    Padding(padding: EdgeInsets.only(right: 20.sp)),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('下载'),
                    ),
                  ],
                ),
              ]),
              Padding(padding: EdgeInsets.only(top: 20.sp)),
              Row(children: const [
                TitleWidger(title: '恢复配置文件'),
              ]),
              Padding(padding: EdgeInsets.only(top: 10.sp)),
              const Flexible(
                child: Text(
                  '要恢复配置文件，找到本地配置文件，导入文件，点击上传开始长传文件',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 10.sp)),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                const Text(
                  '配置文件',
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('选择文件'),
                ),
                const Text('未选择文件'),
              ]),
              Padding(padding: EdgeInsets.only(top: 10.sp)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: 38,
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('上传'),
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
        style: const TextStyle(color: Colors.blue, fontSize: 18),
      ),
    );
  }
}
