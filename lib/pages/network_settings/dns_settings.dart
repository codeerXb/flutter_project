import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/request/request.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:flutter_template/core/widget/water_loading.dart';
import 'package:flutter_template/pages/login/login_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import '../../../core/widget/custom_app_bar.dart';
import '../../core/http/http.dart';
import '../../core/utils/toast.dart';
import '../../core/widget/common_box.dart';
import '../../core/widget/otp_input.dart';
import '../../generated/l10n.dart';
import 'model/dns_data.dart';
import 'package:flutter_template/core/utils/string_util.dart';

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

  // String primary = '';
  // String subsidiary = '';
  String sn = '';
  // String type = '';

  final LoginController loginController = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
    sharedGetData('deviceSn', String).then(((res) async {
      sn = res.toString();
      //状态为local 请求本地  状态为cloud  请求云端
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
        if (loginController.login.state == 'cloud' && sn.isNotEmpty) {
          // 云端请求赋值
          getTRDnsData();
        }
        if (loginController.login.state == 'local') {
          // 本地请求赋值
          getDnsData();
        }
        setState(() {
          _isLoading = false;
        });
      }
    }));

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
  }

  // 点击空白  关闭键盘 时传的一个对象
  FocusNode blankNode = FocusNode();

  /// 点击空白  关闭输入键盘
  void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(blankNode);
  }

  bool loading = false;

  // 获取 云端
  getTRDnsData() {
    setState(() {
      loading = true;
    });
    printInfo(info: 'sn在这里有值吗-------$sn');
    // var parameterNames = [
    //   "InternetGatewayDevice.WANDevice.1.WANConnectionDevice.1.WANIPConnection.1.DNSServers",
    // ];
    var parameterNames = {
      "method": "get",
      "nodes": ["lteManualDns1", "lteManualDns2"]
    };

    try {
      setState(() async {
        loading = false;
        // type = jsonObj["data"]["InternetGatewayDevice"]["WANDevice"]["1"]
        //         ["WANConnectionDevice"]["1"]["WANIPConnection"]["1"]
        //     ["DNSServers"]["_type"];
        var res = await Request().getACSNode(parameterNames, sn);
        var jsonObj = jsonDecode(res);
        debugPrint('DNS数据:$jsonObj');
        //Primary DNS
        var dnsStart = jsonObj["data"]["lteManualDns1"] as String;
        // dsnMainVal = dnsStart.split(',')[0];
        dsnMain.text =
            dnsStart.split('.')[0] == "" ? "" : dnsStart.split('.')[0];
        dsnMain1.text =
            dnsStart.split('.')[1] == "" ? "" : dnsStart.split('.')[1];
        dsnMain2.text =
            dnsStart.split('.')[2] == "" ? "" : dnsStart.split('.')[2];
        dsnMain3.text =
            dnsStart.split('.')[3] == "" ? "" : dnsStart.split('.')[3];

        // Second DNS
        dsnAssistVal = jsonObj["data"]["lteManualDns2"];
        debugPrint("执行到这里了");
        if (dnsStart.isEmpty && (dsnAssistVal as String).isEmpty) {
          debugPrint("执行到这里了w");
          loading = false;
          ToastUtils.toast(S.current.noData);
        }
        dsnAssist.text =
            dsnAssistVal.split('.')[0] == "" ? "" : dsnAssistVal.split('.')[0];
        dsnAssist1.text =
            dsnAssistVal.split('.')[1] == "" ? "" : dsnAssistVal.split('.')[1];
        dsnAssist2.text =
            dsnAssistVal.split('.')[2] == "" ? "" : dsnAssistVal.split('.')[2];
        dsnAssist3.text =
            dsnAssistVal.split('.')[3] == "" ? "" : dsnAssistVal.split('.')[3];
      });
    } catch (e) {
      debugPrint('DNS信息失败');
      debugPrint('获取信息失败：${e.toString()}');
      setState(() {
        loading = false;
      });
    }
  }

// 设置 云端
  setTRDnsData() async {
    // var parameterNames = [
    //   [
    //     "InternetGatewayDevice.DNS.Client.Server.1.DNSServer",
    //     '${dsnMain.text}.${dsnMain1.text}.${dsnMain2.text}.${dsnMain3.text}',
    //     type
    //   ],
    //   [
    //     "InternetGatewayDevice.DNS.Client.Server.2.DNSServer",
    //     '${dsnAssist.text}.${dsnAssist1.text}.${dsnAssist2.text}.${dsnAssist3.text}',
    //     type
    //   ],
    // ];
    var dns1 = "";
    var dns2 = "";
    if (dsnMain.text.isEmpty &&
        dsnMain1.text.isEmpty &&
        dsnMain2.text.isEmpty &&
        dsnMain3.text.isEmpty) {
      dns1 = "";
    } else {
      if (dsnMain.text.isEmpty ||
          dsnMain1.text.isEmpty ||
          dsnMain2.text.isEmpty ||
          dsnMain3.text.isEmpty) {
        dns1 = "";
        ToastUtils.toast("DNS cannot be empty");
      } else {
        dns1 =
            '${dsnMain.text}.${dsnMain1.text}.${dsnMain2.text}.${dsnMain3.text}';
      }
    }

    if (dsnAssist.text.isEmpty &&
        dsnAssist1.text.isEmpty &&
        dsnAssist2.text.isEmpty &&
        dsnAssist3.text.isEmpty) {
      dns2 = "";
    } else {
      if (dsnAssist.text.isEmpty ||
          dsnAssist1.text.isEmpty ||
          dsnAssist2.text.isEmpty ||
          dsnAssist3.text.isEmpty) {
        dns2 = "";
        ToastUtils.toast("DNS cannot be empty");
      } else {
        dns2 =
            '${dsnAssist.text}.${dsnAssist1.text}.${dsnAssist2.text}.${dsnAssist3.text}';
      }
    }

    bool ipflag = StringUtil.isIp(dns1);
    bool ipassist = StringUtil.isIp(dns2);
    if (dns1.isNotEmpty && dns2.isNotEmpty) {
      if (ipflag == false || ipassist == false) {
        ToastUtils.toast("IP is illegal");
        return;
      }
    }

    var parameterNames = {
      "method": "set",
      "nodes": {"lteManualDns1": dns1, "lteManualDns2": dns2}
    };
    try {
      var res = await Request().setACSNode(parameterNames, sn);
      var jsonObj = jsonDecode(res);
      printInfo(info: 'DNS:$jsonObj');
      if (jsonObj['code'] == 200) {
        ToastUtils.toast(S.current.success);
      } else {
        ToastUtils.error('Request Failed');
      }
      setState(() {});
    } catch (e) {
      debugPrint('获取信息失败：${e.toString()}');
      ToastUtils.error('Request Failed');
      Get.back();
    }
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
            ToastUtils.toast('${S.current.error}11');
          }
        });
      } on FormatException catch (e) {
        debugPrint(e.toString());
        ToastUtils.toast('${S.current.error}22');
      }
    }).catchError((e) {
      debugPrint('修改DSN 失败：$e.toString()');
      ToastUtils.toast('${S.current.error}33');
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
            ToastUtils.toast('${S.current.error}11');
          }
        });
      } on FormatException catch (e) {
        debugPrint(e.toString());
        ToastUtils.toast('${S.current.error}22');
      }
    }).catchError((e) {
      debugPrint(S.current.error);
      ToastUtils.toast('${S.current.error}33');
    });
  }

  bool _isLoading = false;
  Future<void> _saveData() async {
    setState(() {
      _isLoading = true;
    });
    closeKeyboard(context);
    if (loginController.login.state == 'cloud' && sn.isNotEmpty) {
      // 云端请求赋值
      await setTRDnsData();
    }
    if (loginController.login.state == 'local') {
      // 本地请求赋值
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
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(
            context: context,
            title: S.of(context).dnsSettings,
            actions: <Widget>[
              Container(
                margin: EdgeInsets.all(20.w),
                child: OutlinedButton(
                  onPressed: _isLoading ? null : _saveData,
                  style: OutlinedButton.styleFrom(
                side:const BorderSide(width: 1.5,color: Colors.blue),
              ),
                  child: Row(
                    children: [
                      if (_isLoading)
                        const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      if (!_isLoading)
                        Text(
                          S.current.save,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: _isLoading ? Colors.grey : Colors.blue,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ]),
        body: loading
            ? const Center(
                child: SizedBox(
                  height: 80,
                  width: 80,
                  child: WaterLoading(
                    color: Color.fromARGB(255, 65, 167, 251),
                  ),
                ),
              )
            : Container(
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(240, 240, 240, 1)),
                height: 1400.w,
                child: SingleChildScrollView(
                  child: InkWell(
                    onTap: () => closeKeyboard(context),
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(240, 240, 240, 1)),
                      // height: 1400.w,
                      child: Column(
                        children: [
                          Row(children: [
                            const Icon(Icons.priority_high, color: Colors.red),
                            Flexible(
                              child: Text(
                                S.of(context).dnsStatic,
                                style: TextStyle(
                                    fontSize: 24.sp, color: Colors.red),
                              ),
                            ),
                          ]),
                          Padding(padding: EdgeInsets.only(top: 20.sp)),
                          InfoBox(
                            boxCotainer: Column(children: [
                              BottomLine(
                                rowtem: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxWidth: 160.w,
                                        ),
                                        child: FittedBox(
                                          child: Text(
                                            S.of(context).PrimaryDNS,
                                            softWrap: false,
                                          ),
                                        )),
                                    Row(
                                      children: [
                                        OtpInput(dsnMain, false),
                                        const Text('.'),
                                        OtpInput(dsnMain1, false),
                                        const Text('.'),
                                        OtpInput(dsnMain2, false),
                                        const Text('.'),
                                        OtpInput(dsnMain3, false),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              // Padding(padding: EdgeInsets.only(top: 30.sp)),
                              Container(
                                height: 90.w,
                                padding: EdgeInsets.only(bottom: 6.w),
                                margin: EdgeInsets.only(bottom: 6.w),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxWidth: 160.w,
                                        ),
                                        child: FittedBox(
                                          child: Text(
                                            S.of(context).SecondaryDNS,
                                            softWrap: false,
                                          ),
                                        )),
                                    Row(
                                      children: [
                                        OtpInput(dsnAssist, false),
                                        const Text('.'),
                                        OtpInput(dsnAssist1, false),
                                        const Text('.'),
                                        OtpInput(dsnAssist2, false),
                                        const Text('.'),
                                        OtpInput(dsnAssist3, false),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ));
  }
}
