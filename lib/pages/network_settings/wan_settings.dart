import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/request/request.dart';
import 'package:flutter_template/pages/login/login_controller.dart';
import 'package:flutter_template/pages/network_settings/model/wan_data.dart';
import 'package:get/get.dart';
import '../../../core/widget/custom_app_bar.dart';
import '../../core/utils/shared_preferences_util.dart';
import '../../core/utils/toast.dart';
import '../../core/widget/common_box.dart';
import '../../core/widget/common_picker.dart';
import '../../generated/l10n.dart';

/// WAN设置
class WanSettings extends StatefulWidget {
  const WanSettings({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WanSettingsState();
}

class _WanSettingsState extends State<WanSettings> {
  WanSettingData wanSettingVal = WanSettingData();
  String showVal = '';
  int val = 0;
  String wanVal = 'nat';
  String sn = '';
  String type = '';

  WanNetworkModel wanNetwork = WanNetworkModel();
  final LoginController loginController = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
    sharedGetData('deviceSn', String).then(((res) {
      printInfo(info: 'deviceSn$res');
      setState(() {
        sn = res.toString();
        //状态为local 请求本地  状态为cloud  请求云端
        printInfo(info: 'state--${loginController.login.state}');
        if (mounted) {
          if (loginController.login.state == 'cloud' && sn.isNotEmpty) {
            getTRWanVal();
          }
          if (loginController.login.state == 'local') {
            getWanVal();
          }
        }
      });
    }));
  }

  // 获取 云端
  getTRWanVal() async {
    printInfo(info: 'sn在这里有值吗-------$sn');
    var parameterNames = [
      "InternetGatewayDevice.WEB_GUI.Network.WANSettings.NetworkMode",
    ];
    var res = await Request().setTRUsedFlow(parameterNames, sn);
    try {
      var jsonObj = jsonDecode(res);
      printInfo(info: '````$jsonObj');
      setState(() {
        type = jsonObj["data"]["InternetGatewayDevice"]["WEB_GUI"]["Network"]
            ["WANSettings"]["NetworkMode"]["_type"];
        var radioState = jsonObj["data"]["InternetGatewayDevice"]["WEB_GUI"]
            ["Network"]["WANSettings"]["NetworkMode"]["_value"];
        if (radioState == 'nat') {
          showVal = 'NAT';
          val = 0;
        }
        if (radioState == 'bridge') {
          showVal = S.current.BRIDGE;
          val = 1;
        }
        if (radioState == 'router') {
          showVal = 'ROUTER';
          val = 2;
        }
      });
    } catch (e) {
      debugPrint('获取信息失败：${e.toString()}');
    }
  }

// 设置 云端
  setTRWanData() async {
    var parameterNames = [
      [
        "InternetGatewayDevice.WEB_GUI.Network.WANSettings.NetworkMode",
        wanVal,
        type
      ]
    ];
    var res = await Request().getTRUsedFlow(parameterNames, sn);
    printInfo(info: '----$res');
    try {
      var jsonObj = jsonDecode(res);
      printInfo(info: '````$jsonObj');
      setState(() {});
    } catch (e) {
      debugPrint('获取信息失败：${e.toString()}');
    }
  }

  void getWanData() {
    Map<String, dynamic> data = {
      'method': 'obj_set',
      'param': '{"networkWanSettingsMode":"$wanVal"}',
    };
    XHttp.get('/data.html', data).then((res) {
      try {
        var d = json.decode(res.toString());
        setState(() {
          wanNetwork = WanNetworkModel.fromJson(d);
          if (wanNetwork.success == true) {
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

  void loginout() {
    // 这里还需要调用后台接口的方法
    sharedDeleteData("loginInfo");
    sharedClearData();
    Get.offAllNamed("/get_equipment");
  }

  void getWanVal() async {
    Map<String, dynamic> data = {
      'method': 'obj_get',
      'param': '["networkWanSettingsMode"]',
    };
    try {
      var response = await XHttp.get('/data.html', data);
      var d = json.decode(response.toString());
      setState(() {
        wanSettingVal = WanSettingData.fromJson(d);
        if (wanSettingVal.networkWanSettingsMode.toString() == 'nat') {
          showVal = 'NAT';
          val = 0;
        }
        if (wanSettingVal.networkWanSettingsMode.toString() == 'bridge') {
          showVal = S.current.BRIDGE;
          val = 1;
        }
        if (wanSettingVal.networkWanSettingsMode.toString() == 'router') {
          showVal = 'ROUTER';
          val = 2;
        }
      });
    } catch (e) {
      debugPrint('失败：$e.toString()');
      ToastUtils.toast(S.current.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context: context, title: S.of(context).wanSettings),
      body: SingleChildScrollView(
        child: Container(
            decoration:
                const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
            height: 1400.w,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //WAN设置
                  TitleWidger(title: S.of(context).wanSettings),
                  GestureDetector(
                      onTap: () {
                        var result = CommonPicker.showPicker(
                          context: context,
                          options: ['NAT', S.current.BRIDGE, 'ROUTER'],
                          value: val,
                        );
                        result?.then((selectedValue) => {
                              if (val != selectedValue && selectedValue != null)
                                {
                                  setState(() => {
                                        val = selectedValue,
                                        showVal = [
                                          'NAT',
                                          S.current.BRIDGE,
                                          'ROUTER'
                                        ][val],
                                        if (val == 0)
                                          {
                                            wanVal = 'nat',
                                            if (mounted)
                                              {
                                                if (loginController
                                                            .login.state ==
                                                        'cloud' &&
                                                    sn.isNotEmpty)
                                                  {setTRWanData()}
                                                else if (loginController
                                                        .login.state ==
                                                    'local')
                                                  {getWanData()}
                                              }
                                          },
                                        if (val == 1)
                                          {
                                            wanVal = 'bridge',
                                            if (mounted)
                                              {
                                                if (loginController
                                                            .login.state ==
                                                        'cloud' &&
                                                    sn.isNotEmpty)
                                                  {setTRWanData()}
                                                else if (loginController
                                                        .login.state ==
                                                    'local')
                                                  {getWanData()}
                                              }
                                          },
                                        if (val == 2)
                                          {
                                            wanVal = 'router',
                                            if (mounted)
                                              {
                                                if (loginController
                                                            .login.state ==
                                                        'cloud' &&
                                                    sn.isNotEmpty)
                                                  {setTRWanData()}
                                                else if (loginController
                                                        .login.state ==
                                                    'local')
                                                  {getWanData()}
                                              }
                                          },
                                      })
                                }
                            });
                      },
                      child: InfoBox(
                          boxCotainer: Column(children: [
                        BottomLine(
                          rowtem: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(S.of(context).NetworkMode,
                                    style: TextStyle(fontSize: 30.sp)),
                                Row(
                                  children: [
                                    Text(showVal,
                                        style: TextStyle(fontSize: 30.sp)),
                                    Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      color: const Color.fromRGBO(
                                          144, 147, 153, 1),
                                      size: 30.w,
                                    )
                                  ],
                                ),
                              ]),
                        ),
                      ]))),
                  SizedBox(
                    height: 60.sp,
                  ),
                ])),
      ),
    );
  }
}
