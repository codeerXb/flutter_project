import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  double comboContain = -1;

  @override
  void initState() {
    super.initState();
    getLanSettingData();

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
            loginout();
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
            loginout();
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

  void loginout() {
    // 这里还需要调用后台接口的方法

    sharedDeleteData("loginInfo");
    sharedClearData();
    Get.offAllNamed("/get_equipment");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context: context, title: S.of(context).lanSettings),
      body: SingleChildScrollView(
        child: InkWell(
          onTap: () => closeKeyboard(context),
          child: Container(
            decoration:
                const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
            // height: 1400.w,
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
                              constraints: BoxConstraints(maxWidth: 160.w),
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
                              constraints: BoxConstraints(maxWidth: 160.w),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: 160.w),
                                child: FittedBox(
                                    child:
                                        Text('DHCP ${S.of(context).server}'))),
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
                              constraints: BoxConstraints(maxWidth: 160.w),
                              child: FittedBox(
                                  child: Text(S.of(context).startIPAddress))),
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
                              constraints: BoxConstraints(maxWidth: 160.w),
                              child: FittedBox(
                                  child: Text(S.of(context).endIPAddress))),
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
                              labelText: "${S.of(context).minutes}(2/m~1440/m)",
                              border: const OutlineInputBorder(),
                              enabled: isCheckVal == '1' ? true : false,
                              filled: isCheckVal == '1'
                                  ? false
                                  : true, //一定加入个属性不然不生效
                              fillColor:
                                  const Color.fromARGB(255, 243, 240, 240),
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
                Padding(
                  padding: EdgeInsets.only(top: 10.w),
                  child: Center(
                      child: SizedBox(
                    height: 70.sp,
                    width: 710.sp,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 48, 118, 250))),
                      onPressed: () {
                        if (isCheckVal == '1') {
                          getLanSettingSubmit();
                        } else {
                          getLanSetting();
                        }
                      },
                      child: Text(
                        S.of(context).save,
                        style: TextStyle(fontSize: 36.sp),
                      ),
                    ),
                  )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
