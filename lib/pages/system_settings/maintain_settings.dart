import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/widget/custom_app_bar.dart';
import '../../core/http/http.dart';
import '../../core/utils/shared_preferences_util.dart';
import '../../core/utils/toast.dart';
import 'model/maintain_data.dart';

/// 维护设置
class MaintainSettings extends StatefulWidget {
  const MaintainSettings({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MaintainSettingsState();
}

class _MaintainSettingsState extends State<MaintainSettings> {
  bool isCheck = false;
  MaintainData maintainVal = MaintainData();

  String showVal = '';
  String radioShowVal = '';
  int val = 0;

  @override
  void initState() {
    super.initState();
  }

  // 重启
  void getmaintaData() {
    Map<String, dynamic> data = {
      'method': 'obj_set',
      'param': '{"systemReboot":"1"}',
    };
    XHttp.get('/data.html', data).then((res) {
      try {
        var d = json.decode(res.toString());
        setState(() {
          maintainVal = MaintainData.fromJson(d);
          if (maintainVal.success == true) {
            ToastUtils.toast('重启成功');
            loginout();
          } else {
            ToastUtils.toast('重启失败');
          }
        });
      } on FormatException catch (e) {
        print(e);
        ToastUtils.toast('重启失败');
      }
    }).catchError((onError) {
      debugPrint('失败：${onError.toString()}');
      ToastUtils.toast('重启失败');
    });
  }

  void loginout() {
    // 这里还需要调用后台接口的方法

    sharedDeleteData("loginInfo");
    sharedClearData();
    Get.offAllNamed("/get_equipment");
  }

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
                  boxCotainer: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('开启重启定时'),
                      Switch(
                        value: isCheck,
                        onChanged: (newVal) {
                          setState(() {
                            isCheck = newVal;
                          });
                        },
                      ),
                    ],
                  ),
                  Offstage(
                    offstage: !isCheck,
                    child: const SizedBox(
                      child: Text("重启日期"),
                    ),
                  ),
                  Offstage(
                    offstage: !isCheck,
                    child: const SizedBox(
                      child: Text("重启时间"),
                    ),
                  ),
                ],
              )),
              Padding(padding: EdgeInsets.only(top: 40.sp)),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '点击 重启 按钮重启设备',
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color.fromARGB(255, 48, 118, 250))),
                        onPressed: () {
                          getmaintaData();
                        },
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '点击 恢复出厂 按钮进行恢复出厂操作',
                      ),
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
        padding: EdgeInsets.all(10.0.sp),
        margin: EdgeInsets.only(bottom: 5.sp),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: boxCotainer);
  }
}
