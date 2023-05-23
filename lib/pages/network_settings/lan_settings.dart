import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/request/request.dart';
import 'package:flutter_template/pages/login/login_controller.dart';
import 'package:get/get.dart';
import '../../../core/widget/custom_app_bar.dart';
import '../../core/http/http.dart';
import '../../core/utils/shared_preferences_util.dart';
import '../../core/utils/toast.dart';
import '../../core/widget/common_box.dart';
import '../../core/widget/otp_input.dart';
import '../../generated/l10n.dart';
import 'model/lan_data.dart';

/// LAN设置LAN设置
class LanSettings extends StatefulWidget {
  const LanSettings({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LanSettingsState();
}

LanSettingData lanSetData = LanSettingData();

LanSetRec lanSet = LanSetRec();

LanSetRec lanSetDis = LanSetRec();

class _LanSettingsState extends State<LanSettings> {
  // 地址
  final TextEditingController address = TextEditingController();
  final TextEditingController address1 = TextEditingController();
  final TextEditingController address2 = TextEditingController();
  final TextEditingController address3 = TextEditingController();
  String addressVal = '';

  // 子网掩码
  final TextEditingController subnetMask = TextEditingController();
  final TextEditingController subnetMask1 = TextEditingController();
  final TextEditingController subnetMask2 = TextEditingController();
  final TextEditingController subnetMask3 = TextEditingController();
  String subnetMaskVal = '';

  // DHCP
  bool isCheck =
      lanSetData.networkLanSettingDhcp.toString() == '1' ? true : false;
  String isCheckVal = '1';

  // 开始网址最后一位
  final TextEditingController start = TextEditingController();
  dynamic startVal = '';

  // 结束网址最后一位
  final TextEditingController end = TextEditingController();
  dynamic endVal = '';

  // 租约时间
  final TextEditingController lanTimeController = TextEditingController();
  String lanTimeText = "";

  // 点击空白  关闭键盘 时传的一个对象
  FocusNode blankNode = FocusNode();

  /// 点击空白  关闭输入键盘
  void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(blankNode);
  }

  bool loading = false;

  double comboContain = -1;

  String sn = '';
  String typeIp = '';
  String typeSub = '';
  String typeSer = '';
  String typeSta = '';
  String typeEnd = '';
  String typeLea = '';

  final LoginController loginController = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
    sharedGetData('deviceSn', String).then(((res) async {
      sn = res.toString();
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
        if (loginController.login.state == 'cloud' && sn.isNotEmpty) {
          // 云端请求赋值
          await getTRLanData();
        }
        if (loginController.login.state == 'local') {
          // 本地请求赋值
          getLanSettingData();
        }
        setState(() {
          _isLoading = false;
        });
      }
    }));

    lanTimeController.addListener(() {
      debugPrint('监听租约时间：${lanTimeController.text}');
      debugPrint('6测试${lanTimeController.text}');
    });

    end.addListener(() {
      debugPrint('监听结束网址最后一位：${end.text}');
      debugPrint(
          '5测试${address.text}.${address1.text}.${address2.text}.${end.text}');
    });

    start.addListener(() {
      debugPrint('监听开始网址最后一位：${start.text}');
      debugPrint(
          '4测试${address.text}.${address1.text}.${address2.text}.${start.text}');
    });

    subnetMask.addListener(() {
      debugPrint('监听子网掩码：${subnetMask.text}');
    });

    subnetMask1.addListener(() {
      debugPrint('监听子网掩码1：${subnetMask1.text}');
    });

    subnetMask2.addListener(() {
      debugPrint('监听子网掩码2：${subnetMask2.text}');
    });

    subnetMask3.addListener(() {
      debugPrint('监听子网掩码3：${subnetMask3.text}');
      debugPrint(
          '2测试${subnetMask.text}.${subnetMask1.text}.${subnetMask2.text}.${subnetMask3.text}');
    });

    address.addListener(() {
      debugPrint('监听IP地址：${address.text}');
    });

    address1.addListener(() {
      debugPrint('监听IP地址：${address1.text}');
    });

    address2.addListener(() {
      debugPrint('监听IP地址：${address2.text}');
    });

    address3.addListener(() {
      debugPrint('监听IP地址：${address3.text}');
      debugPrint(
          '1测试${address.text}.${address1.text}.${address2.text}.${address3.text}');
    });
  }

// 获取 云端
  getTRLanData() async {
    setState(() {
      loading = true;
    });
    printInfo(info: 'sn在这里有值吗-------$sn');
    var parameterNames = [
      "InternetGatewayDevice.WEB_GUI.Network.LANSettings.LANHost.IPAddress",
      "InternetGatewayDevice.WEB_GUI.Network.LANSettings.LANHost.SubnetMask",
      "InternetGatewayDevice.WEB_GUI.Network.LANSettings.DHCP.ServerEnable",
      "InternetGatewayDevice.WEB_GUI.Network.LANSettings.DHCP.StartIP",
      "InternetGatewayDevice.WEB_GUI.Network.LANSettings.DHCP.EndIP",
      "InternetGatewayDevice.WEB_GUI.Network.LANSettings.DHCP.LeaseTime",
    ];
    var res = await Request().getACSNode(parameterNames, sn);
    try {
      var jsonObj = jsonDecode(res);
      printInfo(info: '````$jsonObj');
      setState(() {
        // 类型
        typeIp = jsonObj["data"]["InternetGatewayDevice"]["WEB_GUI"]["Network"]
            ["LANSettings"]["LANHost"]["IPAddress"]["_type"];
        typeSub = jsonObj["data"]["InternetGatewayDevice"]["WEB_GUI"]["Network"]
            ["LANSettings"]["LANHost"]["SubnetMask"]["_type"];
        typeSer = jsonObj["data"]["InternetGatewayDevice"]["WEB_GUI"]["Network"]
            ["LANSettings"]["DHCP"]["ServerEnable"]["_type"];
        typeSta = jsonObj["data"]["InternetGatewayDevice"]["WEB_GUI"]["Network"]
            ["LANSettings"]["DHCP"]["StartIP"]["_type"];
        typeEnd = jsonObj["data"]["InternetGatewayDevice"]["WEB_GUI"]["Network"]
            ["LANSettings"]["DHCP"]["EndIP"]["_type"];
        typeLea = jsonObj["data"]["InternetGatewayDevice"]["WEB_GUI"]["Network"]
            ["LANSettings"]["DHCP"]["LeaseTime"]["_type"];

        // IP地址
        addressVal = jsonObj["data"]["InternetGatewayDevice"]["WEB_GUI"]
            ["Network"]["LANSettings"]["LANHost"]["IPAddress"]["_value"];
        address.text = addressVal.split('.')[0];
        address1.text = addressVal.split('.')[1];
        address2.text = addressVal.split('.')[2];
        address3.text = addressVal.split('.')[3];

        // 子网掩码
        subnetMaskVal = jsonObj["data"]["InternetGatewayDevice"]["WEB_GUI"]
            ["Network"]["LANSettings"]["LANHost"]["SubnetMask"]["_value"];
        subnetMask.text = subnetMaskVal.split('.')[0];
        subnetMask1.text = subnetMaskVal.split('.')[1];
        subnetMask2.text = subnetMaskVal.split('.')[2];
        subnetMask3.text = subnetMaskVal.split('.')[3];

        // DHCP
        if (jsonObj["data"]["InternetGatewayDevice"]["WEB_GUI"]["Network"]
                ["LANSettings"]["DHCP"]["ServerEnable"]["_value"] ==
            true) {
          isCheck = true;
          isCheckVal = '1';
        } else {
          isCheck = false;
          isCheckVal = '0';
        }

        // 开始网址最后一位
        startVal = jsonObj["data"]["InternetGatewayDevice"]["WEB_GUI"]
            ["Network"]["LANSettings"]["DHCP"]["StartIP"]["_value"];
        start.text = startVal.split('.')[3];

        // 结束网址最后一位 end
        endVal = jsonObj["data"]["InternetGatewayDevice"]["WEB_GUI"]["Network"]
            ["LANSettings"]["DHCP"]["EndIP"]["_value"];
        end.text = endVal.split('.')[3];

        // 租约时间
        lanTimeController.text = jsonObj["data"]["InternetGatewayDevice"]
                    ["WEB_GUI"]["Network"]["LANSettings"]["DHCP"]["LeaseTime"]
                ["_value"]
            .toString();
      });
    } catch (e) {
      debugPrint('获取信息失败：${e.toString()}');
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

// 设置 云端
  setTRLanData() async {
    var parameterNames = [
      [
        "InternetGatewayDevice.WEB_GUI.Network.LANSettings.LANHost.IPAddress",
        '${address.text}.${address1.text}.${address2.text}.${address3.text}',
        typeIp
      ],
      [
        "InternetGatewayDevice.WEB_GUI.Network.LANSettings.LANHost.SubnetMask",
        '${subnetMask.text}.${subnetMask1.text}.${subnetMask2.text}.${subnetMask3.text}',
        typeSub
      ],
      [
        "InternetGatewayDevice.WEB_GUI.Network.LANSettings.DHCP.ServerEnable",
        '$isCheck',
        typeSer
      ],
      [
        "InternetGatewayDevice.WEB_GUI.Network.LANSettings.DHCP.StartIP",
        '${address.text}.${address1.text}.${address2.text}.${start.text}',
        typeSta
      ],
      [
        "InternetGatewayDevice.WEB_GUI.Network.LANSettings.DHCP.EndIP",
        '${address.text}.${address1.text}.${address2.text}.${end.text}',
        typeEnd
      ],
      [
        "InternetGatewayDevice.WEB_GUI.Network.LANSettings.DHCP.LeaseTime",
        lanTimeController.text,
        typeLea
      ]
    ];
    var res = await Request().setACSNode(parameterNames, sn);
    try {
      var jsonObj = jsonDecode(res);
      if (jsonObj['code'] == 200) {
        ToastUtils.toast('success');
      } else {
        ToastUtils.error('Task Failed');
      }
      printInfo(info: '````$jsonObj');
      setState(() {});
    } catch (e) {
      debugPrint('获取信息失败：${e.toString()}');
    }
  }

  void getLanSettingData() async {
    Map<String, dynamic> data = {
      'method': 'obj_get',
      'param':
          '["networkLanSettingIp","networkLanSettingMask","networkLanSettingDhcp","networkLanSettingStart","networkLanSettingEnd","networkLanSettingLeasetime"]',
    };
    try {
      var response = await XHttp.get('/data.html', data);
      var d = json.decode(response.toString());
      setState(() {
        lanSetData = LanSettingData.fromJson(d);

        // IP地址
        addressVal = lanSetData.networkLanSettingIp.toString();
        address.text = addressVal.split('.')[0];
        address1.text = addressVal.split('.')[1];
        address2.text = addressVal.split('.')[2];
        address3.text = addressVal.split('.')[3];

        // 子网掩码
        subnetMaskVal = lanSetData.networkLanSettingMask.toString();
        subnetMask.text = subnetMaskVal.split('.')[0];
        subnetMask1.text = subnetMaskVal.split('.')[1];
        subnetMask2.text = subnetMaskVal.split('.')[2];
        subnetMask3.text = subnetMaskVal.split('.')[3];

        // 开始网址最后一位
        startVal = lanSetData.networkLanSettingStart.toString();
        start.text = startVal.split('.')[3];

        // 结束网址最后一位 end
        endVal = lanSetData.networkLanSettingEnd.toString();
        end.text = endVal.split('.')[3];

        // 租约时间
        lanTimeController.text =
            lanSetData.networkLanSettingLeasetime.toString();

        // DHCP
        if (lanSetData.networkLanSettingDhcp.toString() == '1') {
          isCheck = true;
          isCheckVal = '1';
        } else {
          isCheck = false;
          isCheckVal = '0';
        }
      });
    } catch (e) {
      debugPrint('获取LAN设置 失败：$e.toString()');
      ToastUtils.toast(S.current.error);
    }
  }

  // 提交 DHCP启用时
  void getLanSettingSubmit() async {
    Map<String, dynamic> data = {
      'method': 'obj_set',
      'param':
          '{"networkLanSettingIp":"${address.text}.${address1.text}.${address2.text}.${address3.text}","networkLanSettingMask":"${subnetMask.text}.${subnetMask1.text}.${subnetMask2.text}.${subnetMask3.text}","networkLanSettingDhcp":"$isCheckVal","networkLanSettingStart":"${address.text}.${address1.text}.${address2.text}.${start.text}","networkLanSettingEnd":"${address.text}.${address1.text}.${address2.text}.${end.text}","networkLanSettingLeasetime":"${lanTimeController.text}"}',
    };

    await XHttp.get('/data.html', data).then((res) {
      try {
        var d = json.decode(res.toString());
        setState(() {
          lanSet = LanSetRec.fromJson(d);
          if (lanSet.success == true) {
            ToastUtils.toast(S.current.success);
          } else {
            ToastUtils.toast(S.current.error);
          }
        });
      } on FormatException catch (e) {
        debugPrint(e.toString());
        ToastUtils.toast(S.current.error);
      }
    }).catchError((onError) {
      debugPrint('失败：${onError.toString()}');
      ToastUtils.toast(S.current.error);
    });
  }

  // 提交 DHCP禁用时
  void getLanSetting() async {
    Map<String, dynamic> data = {
      'method': 'obj_set',
      'param':
          '{"networkLanSettingIp":"${address.text}.${address1.text}.${address2.text}.${address3.text}","networkLanSettingMask":"${subnetMask.text}.${subnetMask1.text}.${subnetMask2.text}.${subnetMask3.text}","networkLanSettingDhcp":"$isCheckVal"}',
    };

    await XHttp.get('/data.html', data).then((res) {
      try {
        var d = json.decode(res.toString());
        setState(() {
          lanSetDis = LanSetRec.fromJson(d);
          if (lanSetDis.success == true) {
            ToastUtils.toast(S.current.success);
          } else {
            ToastUtils.toast(S.current.error);
          }
        });
      } on FormatException catch (e) {
        print(e);
        ToastUtils.toast(S.current.error);
      }
    }).catchError((onError) {
      debugPrint('失败：${onError.toString()}');
      ToastUtils.toast(S.current.error);
    });
  }

  bool _isLoading = false;
  void warningReboot(Function save) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Warning'),
          content: const Text(
              'It is a warning action, because device will reboot. Confirm to save it?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                save();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveData() async {
    setState(() {
      _isLoading = true;
    });
    closeKeyboard(context);
    if (loginController.login.state == 'cloud' && sn.isNotEmpty) {
      // 云端请求赋值
      await setTRLanData();
    }
    if (loginController.login.state == 'local') {
      // 本地请求赋值
      if (isCheckVal == '1') {
        getLanSettingSubmit();
      } else {
        getLanSetting();
      }
    }
    setState(() {
      _isLoading = false;
      Navigator.pop(context);
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(
          context: context,
          title: S.of(context).lanSettings,
          actions: <Widget>[
            Container(
              margin: EdgeInsets.all(20.w),
              child: OutlinedButton(
                onPressed: () => warningReboot(_saveData),
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
                          color: _isLoading ? Colors.grey : null,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ]),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: InkWell(
                onTap: () => closeKeyboard(context),
                child: Container(
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(240, 240, 240, 1)),
                  height: 1400.w,
                  child: Column(
                    children: [
                      Row(children: [
                        TitleWidger(title: S.of(context).lanHostSettings),
                      ]),
                      InfoBox(
                        boxCotainer: Column(children: [
                          BottomLine(
                            rowtem: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ConstrainedBox(
                                    constraints:
                                        BoxConstraints(maxWidth: 160.w),
                                    child: FittedBox(
                                        child: Text(S.of(context).IPAddress))),
                                Row(
                                  children: [
                                    OtpInput(address, false),
                                    const Text('.'),
                                    OtpInput(address1, false),
                                    const Text('.'),
                                    OtpInput(address2, false),
                                    const Text('.'),
                                    OtpInput(address3, false),
                                    const Text(
                                      '*',
                                      style: TextStyle(color: Colors.red),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: 90.w,
                            padding: EdgeInsets.only(bottom: 6.w),
                            margin: EdgeInsets.only(bottom: 6.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ConstrainedBox(
                                    constraints:
                                        BoxConstraints(maxWidth: 160.w),
                                    child: FittedBox(
                                        child: Text(S.of(context).SubnetMask))),
                                Row(
                                  children: [
                                    DisInput(subnetMask, false),
                                    const Text('.'),
                                    DisInput(subnetMask1, false),
                                    const Text('.'),
                                    DisInput(subnetMask2, false),
                                    const Text('.'),
                                    OtpInput(subnetMask3, false),
                                    const Text(
                                      '*',
                                      style: TextStyle(color: Colors.red),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ]),
                      ),
                      Row(children: [
                        TitleWidger(title: 'DHCP ${S.of(context).Settings}'),
                      ]),
                      InfoBox(
                        boxCotainer: Column(children: [
                          BottomLine(
                            rowtem: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ConstrainedBox(
                                      constraints:
                                          BoxConstraints(maxWidth: 160.w),
                                      child: FittedBox(
                                          child: Text(
                                              'DHCP ${S.of(context).server}'))),
                                  Switch(
                                    value: isCheck,
                                    onChanged: (newVal) {
                                      setState(() {
                                        isCheck = newVal;
                                        if (isCheck == true) {
                                          isCheckVal = '1';
                                        } else {
                                          isCheckVal = '0';
                                        }
                                      });
                                    },
                                  ),
                                ]),
                          ),
                          BottomLine(
                            rowtem: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ConstrainedBox(
                                    constraints:
                                        BoxConstraints(maxWidth: 160.w),
                                    child: FittedBox(
                                        child: Text(
                                            S.of(context).startIPAddress))),
                                Row(
                                  children: [
                                    DisInput(address, false),
                                    const Text('.'),
                                    DisInput(address1, false),
                                    const Text('.'),
                                    DisInput(address2, false),
                                    const Text('.'),
                                    Offstage(
                                      offstage: isCheck == false,
                                      child: OtpInput(start, false),
                                    ),
                                    Offstage(
                                      offstage: isCheck == true,
                                      child: DisInput(start, false),
                                    ),
                                    const Text(
                                      '*',
                                      style: TextStyle(color: Colors.red),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          BottomLine(
                            rowtem: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ConstrainedBox(
                                    constraints:
                                        BoxConstraints(maxWidth: 160.w),
                                    child: FittedBox(
                                        child:
                                            Text(S.of(context).endIPAddress))),
                                Row(
                                  children: [
                                    DisInput(address, false),
                                    const Text('.'),
                                    DisInput(address1, false),
                                    const Text('.'),
                                    DisInput(address2, false),
                                    const Text('.'),
                                    Offstage(
                                      offstage: isCheck == false,
                                      child: OtpInput(end, false),
                                    ),
                                    Offstage(
                                      offstage: isCheck == true,
                                      child: DisInput(end, false),
                                    ),
                                    const Text(
                                      '*',
                                      style: TextStyle(color: Colors.red),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: 40.sp)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ConstrainedBox(
                                  constraints: BoxConstraints(maxWidth: 160.w),
                                  child: FittedBox(
                                      child: Text(S.of(context).LeaseTime))),
                              SizedBox(
                                width: 400.sp,
                                child: TextFormField(
                                  textAlign: TextAlign.right,
                                  controller: lanTimeController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText:
                                        "${S.of(context).minutes}(2/m~1440/m)",
                                    border: const OutlineInputBorder(),
                                    enabled: isCheckVal == '1' ? true : false,
                                    filled: isCheckVal == '1'
                                        ? false
                                        : true, //一定加入个属性不然不生效
                                    fillColor: const Color.fromARGB(
                                        255, 243, 240, 240),
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
