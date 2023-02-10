import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/widget/custom_app_bar.dart';
import '../../core/http/http.dart';
import '../../core/utils/toast.dart';
import '../../core/widget/common_box.dart';
import '../../core/widget/otp_input.dart';
import '../../generated/l10n.dart';
import 'model/dns_data.dart';

/// DNS设置
class DnsSettings extends StatefulWidget {
  const DnsSettings({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DnsSettingsState();
}

class _DnsSettingsState extends State<DnsSettings> {
  // 主
  final TextEditingController dsnMain = TextEditingController();
  final TextEditingController dsnMain1 = TextEditingController();
  final TextEditingController dsnMain2 = TextEditingController();
  final TextEditingController dsnMain3 = TextEditingController();
  dynamic dsnMainVal = '';

  // 辅
  final TextEditingController dsnAssist = TextEditingController();
  final TextEditingController dsnAssist1 = TextEditingController();
  final TextEditingController dsnAssist2 = TextEditingController();
  final TextEditingController dsnAssist3 = TextEditingController();
  dynamic dsnAssistVal = '';

  DnsSettingData dnsSetData = DnsSettingData();

  DnsData dnsDataVal = DnsData();

  String aa = '';
  String bb = '';

  @override
  void initState() {
    super.initState();
    getDnsData();

    dsnMain.addListener(() {
      debugPrint('监听主：${dsnMain.text}');
    });

    dsnMain1.addListener(() {
      debugPrint('监听主1：${dsnMain1.text}');
    });

    dsnMain2.addListener(() {
      debugPrint('监听主2：${dsnMain2.text}');
    });

    dsnMain3.addListener(() {
      debugPrint('监听主3：${dsnMain3.text}');
      debugPrint(
          '2测试${dsnMain.text}.${dsnMain1.text}.${dsnMain2.text}.${dsnMain3.text}');
    });

    dsnAssist.addListener(() {
      debugPrint('监听辅：${dsnAssist.text}');
    });

    dsnAssist1.addListener(() {
      debugPrint('监听辅：${dsnAssist1.text}');
    });

    dsnAssist2.addListener(() {
      debugPrint('监听辅：${dsnAssist2.text}');
    });

    dsnAssist3.addListener(() {
      debugPrint('监听辅：${dsnAssist3.text}');
      debugPrint(
          '1测试${dsnAssist.text}.${dsnAssist1.text}.${dsnAssist2.text}.${dsnAssist3.text}');
    });
    // if (dsnMain.text == '' &&
    //     dsnMain1.text == '' &&
    //     dsnMain2.text == '' &&
    //     dsnMain3.text == '') {
    //   aa = '{"lteManualDns1":"","lteManualDns2":""}';
    //   debugPrint('----11---$aa');
    // } else {
    //   aa =
    // '{"lteManualDns1":"${dsnMain.text}.${dsnMain1.text}.${dsnMain2.text}.${dsnMain3.text}","lteManualDns2":"${dsnAssist.text}.${dsnAssist1.text}.${dsnAssist2.text}.${dsnAssist3.text}"}';
    //   debugPrint('----22---$aa');
    // }
  }

  // 点击空白  关闭键盘 时传的一个对象
  FocusNode blankNode = FocusNode();

  /// 点击空白  关闭输入键盘
  void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(blankNode);
  }

  void getDnsData() async {
    Map<String, dynamic> data = {
      'method': 'obj_get',
      'param': '["lteManualDns1","lteManualDns2"]',
    };
    try {
      var response = await XHttp.get('/data.html', data);
      var d = json.decode(response.toString());
      dnsSetData = DnsSettingData.fromJson(d);
      if (dnsSetData.lteManualDns1 != '' && dnsSetData.lteManualDns2 != '') {
        setState(() {
          // 主
          dsnMainVal = dnsSetData.lteManualDns1.toString();
          dsnMain.text =
              dsnMainVal.split('.')[0] == "" ? "" : dsnMainVal.split('.')[0];
          dsnMain1.text =
              dsnMainVal.split('.')[1] == "" ? "" : dsnMainVal.split('.')[1];
          dsnMain2.text =
              dsnMainVal.split('.')[2] == "" ? "" : dsnMainVal.split('.')[2];
          dsnMain3.text =
              dsnMainVal.split('.')[3] == "" ? "" : dsnMainVal.split('.')[3];

          // 辅
          dsnAssistVal = dnsSetData.lteManualDns2.toString();
          dsnAssist.text = dsnAssistVal.split('.')[0] == ""
              ? ""
              : dsnAssistVal.split('.')[0];
          dsnAssist1.text = dsnAssistVal.split('.')[1] == ""
              ? ""
              : dsnAssistVal.split('.')[1];
          dsnAssist2.text = dsnAssistVal.split('.')[2] == ""
              ? ""
              : dsnAssistVal.split('.')[2];
          dsnAssist3.text = dsnAssistVal.split('.')[3] == ""
              ? ""
              : dsnAssistVal.split('.')[3];
        });
      }
    } catch (e) {
      debugPrint('获取DSN 失败：$e.toString()');
      ToastUtils.toast(S.current.error);
    }
  }

// 修改 有值时
  void getRadioSettingData() async {
    Map<String, dynamic> data = {
      'method': 'obj_set',
      'param':
          '{"lteManualDns1":"${dsnMain.text}.${dsnMain1.text}.${dsnMain2.text}.${dsnMain3.text}","lteManualDns2":"${dsnAssist.text}.${dsnAssist1.text}.${dsnAssist2.text}.${dsnAssist3.text}"}',
    };
    XHttp.get('/data.html', data).then((res) {
      try {
        var d = json.decode(res.toString());
        setState(() {
          dnsDataVal = DnsData.fromJson(d);
          if (dnsDataVal.success == true) {
            ToastUtils.toast(S.current.success);
          } else {
            ToastUtils.toast(S.current.error+'11');
          }
        });
      } on FormatException catch (e) {
        print(e);
        ToastUtils.toast(S.current.error+'22');
      }
    }).catchError((e) {
      debugPrint('修改DSN 失败：$e.toString()');
      ToastUtils.toast(S.current.error+'33');
    });
  }

// 修改 无值
  void getRadioData() async {
    Map<String, dynamic> data = {
      'method': 'obj_set',
      'param': '{"lteManualDns1":"","lteManualDns2":""}',
    };
    XHttp.get('/data.html', data).then((res) {
      try {
        var d = json.decode(res.toString());
        setState(() {
          dnsDataVal = DnsData.fromJson(d);
          if (dnsDataVal.success == true) {
            ToastUtils.toast(S.current.success);
          } else {
            ToastUtils.toast(S.current.error+'11');
          }
        });
      } on FormatException catch (e) {
        print(e);
        ToastUtils.toast(S.current.error+'22');
      }
    }).catchError((e) {
      debugPrint(S.current.error);
      ToastUtils.toast(S.current.error+'33');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(context: context, title: S.of(context).dnsSettings),
        body: SingleChildScrollView(
          child: InkWell(
            onTap: () => closeKeyboard(context),
            child: Container(
              decoration:
                  const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
              height: 1400.w,
              child: Column(
                children: [
                  Row(children: [
                    const Icon(Icons.priority_high, color: Colors.red),
                    Flexible(
                      child: Text(
                        S.of(context).dnsStatic,
                        style: TextStyle(fontSize: 24.sp, color: Colors.red),
                      ),
                    ),
                  ]),
                  Padding(padding: EdgeInsets.only(top: 20.sp)),
                  InfoBox(
                    boxCotainer: Column(children: [
                      BottomLine(
                        rowtem: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                             Text( S.of(context).PrimaryDNS),
                            OtpInput(dsnMain, false),
                            const Text('.'),
                            OtpInput(dsnMain1, false),
                            const Text('.'),
                            OtpInput(dsnMain2, false),
                            const Text('.'),
                            OtpInput(dsnMain3, false),
                          ],
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 30.sp)),
                      BottomLine(
                        rowtem: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                             Text( S.of(context).SecondaryDNS),
                            OtpInput(dsnAssist, false),
                            const Text('.'),
                            OtpInput(dsnAssist1, false),
                            const Text('.'),
                            OtpInput(dsnAssist2, false),
                            const Text('.'),
                            OtpInput(dsnAssist3, false),
                          ],
                        ),
                      ),
                    ]),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 10.w),
                      child: Center(
                        child: SizedBox(
                          height: 70.sp,
                          width: 680.sp,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    const Color.fromARGB(255, 48, 118, 250))),
                            onPressed: () {
                              if (dsnMain.text == '' &&
                                  dsnMain1.text == '' &&
                                  dsnMain2.text == '' &&
                                  dsnMain3.text == '' &&
                                  dsnAssist.text == '' &&
                                  dsnAssist1.text == '' &&
                                  dsnAssist2.text == '' &&
                                  dsnAssist3.text == '') {
                                getRadioData();
                              } else {
                                getRadioSettingData();
                              }
                            },
                            child: Text(
                              S.of(context).save,
                              style: TextStyle(fontSize: 36.sp),
                            ),
                          ),
                        ),
                      ))
                ],
              ),
            ),
          ),
        ));
  }
}
