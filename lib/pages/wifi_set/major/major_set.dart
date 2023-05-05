import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/request/request.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:flutter_template/core/widget/common_picker.dart';
import 'package:flutter_template/core/widget/common_widget.dart';
import 'package:flutter_template/pages/login/login_controller.dart';
import 'package:flutter_template/pages/wifi_set/major/major_datas.dart';
import 'package:get/get.dart';
import '../../../core/widget/custom_app_bar.dart';
import '../../../generated/l10n.dart';

/// 专业设置
class MajorSet extends StatefulWidget {
  const MajorSet({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MajorSetState();
}

class _MajorSetState extends State<MajorSet> {
  String showVal = '';
  majorDatas majorData = majorDatas(wifiRegionCountry: 'CN');
  int index = 0;
  dynamic val = 'CN';

  final LoginController loginController = Get.put(LoginController());
  String sn = '';
  String type = '';
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
          getTRDate();
        }
        if (loginController.login.state == 'local') {
          getData();
          handleSave();
        }
        setState(() {
          _isLoading = false;
        });
      }
    }));
  }

  bool _isLoading = false;
  // 提交
  Future<void> _saveData() async {
    Navigator.push(context, DialogRouter(LoadingDialog()));
    setState(() {
      _isLoading = true;
    });
    if (loginController.login.state == 'cloud' && sn.isNotEmpty) {
      // 云端请求赋值
      try {
        await setTRData();
      } catch (e) {
        debugPrint('云端请求出错：${e.toString()}');
        Get.back();
      }
    }
    if (loginController.login.state == 'local') {
      // 本地请求赋值
      handleSave();
    }
    Navigator.pop(context);
    setState(() {
      _isLoading = false;
    });
  }

  //保存
  void handleSave() async {
    Map<String, dynamic> data = {
      'method': 'obj_set',
      'param': '{"wifiRegionCountry":"$val"}',
    };
    XHttp.get('/data.html', data).then((res) {
      try {
        ToastUtils.toast(S.current.success);
      } on FormatException catch (e) {
        print(e);
      }
    }).catchError((onError) {
      debugPrint('失败：${onError.toString()}');
      ToastUtils.toast(S.current.error);
    });
  }

  // 获取 云端
  getTRDate() async {
    Navigator.push(context, DialogRouter(LoadingDialog()));
    printInfo(info: 'sn在这里有值吗-------$sn');
    var parameterNames = [
      "InternetGatewayDevice.WEB_GUI.WiFi.WLANSettings.CountryCode",
    ];
    var res = await Request().getACSNode(parameterNames, sn);
    try {
      var jsonObj = jsonDecode(res);
      printInfo(info: '````$jsonObj');
      setState(() {
        type = jsonObj["data"]["InternetGatewayDevice"]["WEB_GUI"]["WiFi"]
            ["WLANSettings"]["CountryCode"]["_type"];
        var radioState = jsonObj["data"]["InternetGatewayDevice"]["WEB_GUI"]
            ["WiFi"]["WLANSettings"]["CountryCode"]["_value"];
        index = ['CN', 'FR', 'RU', 'US', 'SG', 'AU', 'CL', 'PL']
            .indexOf(radioState);
        //读取地区
        switch (radioState) {
          case 'CN':
            showVal = S.current.China;
            break;
          case 'FR':
            showVal = S.current.France;
            break;
          case 'RU':
            showVal = S.current.Russia;
            break;
          case 'US':
            showVal = S.current.UnitedStates;
            break;
          case 'SG':
            showVal = S.current.Singapore;
            break;
          case 'AU':
            showVal = S.current.Australia;
            break;
          case 'CL':
            showVal = S.current.Chile;
            break;
          case 'PL':
            showVal = S.current.Poland;
            break;
        }
      });
    } catch (e) {
      debugPrint('获取信息失败：${e.toString()}');
    }
    Navigator.pop(context);
  }

// 设置 云端
  setTRData() async {
    var parameterNames = [
      ["InternetGatewayDevice.WEB_GUI.WiFi.WLANSettings.CountryCode", val, type]
    ];
    var res = await Request().setACSNode(parameterNames, sn);
    try {
      var jsonObj = jsonDecode(res);
      printInfo(info: '````$jsonObj');
      setState(() {});
    } catch (e) {
      debugPrint('获取信息失败：${e.toString()}');
    }
  }

  //读取
  void getData() async {
    Map<String, dynamic> data = {
      'method': 'obj_get',
      'param': '["wifiRegionCountry","wifiWpsPbcState","wifi5gWpsPbcState"]',
    };
    try {
      var response = await XHttp.get('/data.html', data);
      var d = json.decode(response.toString());
      setState(() {
        majorData = majorDatas.fromJson(d);
        index = ['CN', 'FR', 'RU', 'US', 'SG', 'AU', 'CL', 'PL']
            .indexOf(majorData.wifiRegionCountry.toString());
        //读取地区
        switch (majorData.wifiRegionCountry.toString()) {
          case 'CN':
            showVal = S.current.China;
            break;
          case 'FR':
            showVal = S.current.France;
            break;
          case 'RU':
            showVal = S.current.Russia;
            break;
          case 'US':
            showVal = S.current.UnitedStates;
            break;
          case 'SG':
            showVal = S.current.Singapore;
            break;
          case 'AU':
            showVal = S.current.Australia;
            break;
          case 'CL':
            showVal = S.current.Chile;
            break;
          case 'PL':
            showVal = S.current.Poland;
            break;
        }
      });
    } catch (e) {
      debugPrint('获取专业设置失败：$e.toString()');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(
            context: context,
            title: S.of(context).majorSet,
            actions: <Widget>[
              Container(
                margin: EdgeInsets.all(20.w),
                child: OutlinedButton(
                  onPressed: _isLoading ? null : _saveData,
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
        body: Container(
          decoration:
              const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
          height: 1000,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TitleWidger(title: S.of(context).majorSet),
                InfoBox(
                    boxCotainer: Column(
                  children: [
                    //地区
                    GestureDetector(
                      onTap: () {
                        var result = CommonPicker.showPicker(
                          context: context,
                          options: [
                            S.current.China,
                            S.current.France,
                            S.current.Russia,
                            S.current.UnitedStates,
                            S.current.Singapore,
                            S.current.Australia,
                            S.current.Chile,
                            S.current.Poland
                          ],
                          value: index,
                        );
                        result?.then((selectedValue) => {
                              if (index != selectedValue &&
                                  selectedValue != null)
                                {
                                  setState(() => {
                                        index = selectedValue,
                                        showVal = [
                                          S.current.China,
                                          S.current.France,
                                          S.current.Russia,
                                          S.current.UnitedStates,
                                          S.current.Singapore,
                                          S.current.Australia,
                                          S.current.Chile,
                                          S.current.Poland
                                        ][index],
                                        val = [
                                          'CN',
                                          'FR',
                                          'RU',
                                          'US',
                                          'SG',
                                          'AU',
                                          'CL',
                                          'PL'
                                        ][index],
                                      })
                                }
                            });
                      },
                      child: BottomLine(
                        rowtem: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(S.of(context).Region,
                                style: TextStyle(
                                    color: const Color.fromARGB(255, 5, 0, 0),
                                    fontSize: 28.sp)),
                            Row(
                              children: [
                                Text(showVal,
                                    style: TextStyle(
                                        color:
                                            const Color.fromARGB(255, 5, 0, 0),
                                        fontSize: 28.sp)),
                                Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: const Color.fromRGBO(144, 147, 153, 1),
                                  size: 30.w,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
              ],
            ),
          ),
        ));
  }
}
