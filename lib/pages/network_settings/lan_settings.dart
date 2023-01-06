import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/widget/custom_app_bar.dart';
import '../../core/http/http.dart';
import '../../core/utils/toast.dart';
import '../../core/widget/otp_input.dart';
import 'model/lan_data.dart';

/// LAN设置
class LanSettings extends StatefulWidget {
  const LanSettings({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LanSettingsState();
}

class _LanSettingsState extends State<LanSettings> {
  // 地址
  final TextEditingController address = TextEditingController();
  final TextEditingController address1 = TextEditingController();
  final TextEditingController address2 = TextEditingController();
  final TextEditingController address3 = TextEditingController();

// 子网掩码
  final TextEditingController subnetMask = TextEditingController();
  final TextEditingController subnetMask1 = TextEditingController();
  final TextEditingController subnetMask2 = TextEditingController();
  final TextEditingController subnetMask3 = TextEditingController();
  dynamic addressVal = '';

// 开始网址最后一位
  final TextEditingController start = TextEditingController();
  dynamic startVal = '';

// 结束网址最后一位
  final TextEditingController end = TextEditingController();
  dynamic endVal = '';

// 租约时间
  final TextEditingController lanTimeController = TextEditingController();
  dynamic subnetMaskVal = '';

// DHCP
  bool isCheck = true;

  // 点击空白  关闭键盘 时传的一个对象
  FocusNode blankNode = FocusNode();

  LanSettingData lanSetData = LanSettingData();
  @override
  void initState() {
    super.initState();
    getLanSettingData();
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
          print('走这儿');
        } else {
          isCheck = false;
          print('是这里');
        }
      });
    } catch (e) {
      debugPrint('获取LAN设置 失败：$e.toString()');

      ToastUtils.toast('获取LAN设置 失败');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context: context, title: 'LAN设置'),
      body: SingleChildScrollView(
        child: InkWell(
          onTap: () => closeKeyboard(context),
          child: Container(
            padding: EdgeInsets.all(10.sp),
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
                    ),
                    Padding(padding: EdgeInsets.only(top: 40.sp)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text('子网掩码'),
                        OtpInput(subnetMask, false),
                        const Text('.'),
                        OtpInput(subnetMask1, false),
                        const Text('.'),
                        OtpInput(subnetMask2, false),
                        const Text('.'),
                        OtpInput(subnetMask3, false),
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
                        OtpInput(address, false),
                        const Text('.'),
                        OtpInput(address1, false),
                        const Text('.'),
                        OtpInput(address2, false),
                        const Text('.'),
                        OtpInput(start, false),
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
                        OtpInput(address, false),
                        const Text('.'),
                        OtpInput(address1, false),
                        const Text('.'),
                        OtpInput(address2, false),
                        const Text('.'),
                        OtpInput(end, false),
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
                          child: TextFormField(
                            controller: lanTimeController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
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
      ),
    );
  }

  /// 点击空白  关闭输入键盘
  void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(blankNode);
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
