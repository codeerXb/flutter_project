import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/request/request.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:flutter_template/core/widget/common_picker.dart';
import 'package:flutter_template/core/widget/water_loading.dart';
import 'package:flutter_template/pages/login/login_controller.dart';
import 'package:flutter_template/pages/wifi_set/wps/wps_datas.dart';
import 'package:get/get.dart';
import '../../../core/widget/custom_app_bar.dart';
import '../../../generated/l10n.dart';

/// WPS设置

class WpsSet extends StatefulWidget {
  const WpsSet({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WpsSetState();
}

class _WpsSetState extends State<WpsSet> {
  wpsDatas wpsData = wpsDatas(
      wifiWpsClientPin: '',
      //WPS 1启动
      wifiWps: '',
      //模式
      wifiWpsMode: '');
  String showVal = '2.4GHz';
  int val = 0;
  bool isCheck = false;
  //wps选中
  String wpsVal = '0';
  //key  wifiWps/wifi5gWps
  dynamic paramKey = 'wifiWps';
  String modeShowVal = 'PBC';
  int modeVal = 0;
  dynamic parmas = '';
  final TextEditingController pinVal = TextEditingController();

  final LoginController loginController = Get.put(LoginController());
  String sn = '';
  String type = '';

  @override
  void initState() {
    super.initState();
    sharedGetData('deviceSn', String).then(((res) {
      sn = res.toString();
      if (mounted) {
        if (loginController.login.state == 'cloud' && sn.isNotEmpty) {
          getTRWpsData();
        }
        if (loginController.login.state == 'local') {
          getData();
          handleSave();
        }
      }
    }));
  }

  // 提交
  bool _isLoading = false;
  Future<void> _saveData() async {
    setState(() {
      _isLoading = true;
    });
    closeKeyboard(context);
    if (loginController.login.state == 'cloud' && sn.isNotEmpty) {
      if (showVal == '2.4GHz') {
        await setTRWpsData();
      } else {
        await setTRWpsData2();
      }
    }
    if (loginController.login.state == 'local') {
      handleSave();
      //选择PBC
      if (isCheck && modeShowVal == 'PBC') {
        savePbc('{"${paramKey}Mode": "$modeShowVal"}');
      }
      //选择Client PIN
      if (isCheck && modeShowVal == 'Client PIN') {
        showVal == '2.4GHz'
            ? savePbc(
                '{ "${paramKey}Mode": "client",  "wifiWpsClientPin": "${pinVal.text}"}')
            : savePbc(
                '{ "${paramKey}Mode": "client",  "wifi5gWpsClientPin": "${pinVal.text}"}');
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  bool loading = false;
  // 获取 云端   2.4G
  getTRWpsData() async {
    setState(() {
      _isLoading = true;
      loading = true;
    });
    var parameterNames = [
      "InternetGatewayDevice.WEB_GUI.WiFi.WLANSettings.1.WPS"
    ];
    var res = await Request().getACSNode(parameterNames, sn);
    try {
      var jsonObj = jsonDecode(res);
      printInfo(info: '````$jsonObj');
      setState(() {
        type = jsonObj["data"]["InternetGatewayDevice"]["WEB_GUI"]["WiFi"]
            ["WLANSettings"]["1"]["WPS"]["Enable"]["_type"];
        var wps1 = jsonObj["data"]["InternetGatewayDevice"]["WEB_GUI"]["WiFi"]
            ["WLANSettings"]["1"]["WPS"]["Enable"]["_value"]!;
        isCheck = wps1 == true ? true : false;
        printInfo(info: '${isCheck = wps1 == true ? true : false}');
      });
    } catch (e) {
      debugPrint('获取信息失败：${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
        loading = false;
      });
    }
  }

  // 获取 云端  5G
  getTRWpsData2() async {
    setState(() {
      _isLoading = true;
      loading = true;
    });
    var parameterNames = [
      "InternetGatewayDevice.WEB_GUI.WiFi.WLANSettings.2.WPS"
    ];
    var res = await Request().getACSNode(parameterNames, sn);
    try {
      var jsonObj = jsonDecode(res);
      printInfo(info: '````$jsonObj');
      setState(() {
        type = jsonObj["data"]["InternetGatewayDevice"]["WEB_GUI"]["WiFi"]
            ["WLANSettings"]["2"]["WPS"]["Enable"]["_type"];
        var wps2 = jsonObj["data"]["InternetGatewayDevice"]["WEB_GUI"]["WiFi"]
            ["WLANSettings"]["2"]["WPS"]["Enable"]["_value"]!;
        isCheck = wps2 == true ? true : false;
      });
    } catch (e) {
      debugPrint('获取信息失败：${e.toString()}');
    } finally {
      setState(() {
        loading = false;
        _isLoading = false;
      });
    }
  }

// 设置 云端   2.4G
  setTRWpsData() async {
    var parameterNames = [
      [
        "InternetGatewayDevice.WEB_GUI.WiFi.WLANSettings.1.WPS.Enable",
        isCheck,
        type
      ]
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

  // 设置 云端   5G
  setTRWpsData2() async {
    var parameterNames = [
      [
        "InternetGatewayDevice.WEB_GUI.WiFi.WLANSettings.2.WPS.Enable",
        isCheck,
        type
      ]
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

  //1 保存
  void handleSave() async {
    Map<String, dynamic> data = {
      'method': 'obj_set',
      'param': '{"$paramKey": "$wpsVal"}',
    };
    try {
      await XHttp.get('/data.html', data);
      ToastUtils.toast(S.current.success);
    } catch (e) {
      debugPrint('wps设置失败:$e.toString()');
      ToastUtils.toast(S.current.error);
    }
  }

  //2.保存模式
  void savePbc(params) async {
    Map<String, dynamic> data = {
      'method': 'obj_set',
      'param': params,
    };
    try {
      await XHttp.get('/data.html', data);
      ToastUtils.toast(S.current.success);
    } catch (e) {
      debugPrint('wps设置失败:$e.toString()');
      ToastUtils.toast(S.current.error);
    }
  }

  //读取
  void getData() async {
    Map<String, dynamic> data = {
      'method': 'obj_get',
      'param':
          '["wifiBandGet","wifiWps","wifiWpsMode","wifiWpsClientPin","wifi5gWps","wifi5gWpsMode","wifi5gWpsClientPin"]',
    };
    try {
      var response = await XHttp.get('/data.html', data);
      var d = json.decode(response.toString());
      setState(() {
        wpsData = wpsDatas.fromJson(d);
        //频段的值
        showVal = wpsData.wifiWps.toString() == '1' ? '2.4GHz' : '5GHz';
        val = wpsData.wifiWps.toString() == '1' ? 0 : 1;
        //频段是2G/5G 提交时提交
        paramKey = wpsData.wifiWps.toString() == '0' ? 'wifiWps' : 'wifi5gWps';

        wpsVal = wpsData.wifi5gWps.toString();

        // 2G
        if (wpsData.wifiWps.toString() == '1') {
          //模式
          modeShowVal =
              wpsData.wifiWpsMode.toString() == 'client' ? 'Client PIN' : 'PBC';
          // 客户模式
          modeVal = ['PBC', 'client'].indexOf(wpsData.wifiWpsMode.toString());
          //pin值
          pinVal.text = wpsData.wifiWpsClientPin.toString();
          //wps选中
          isCheck = wpsData.wifiWps.toString() == '1' ? true : false;
        }
        //5g
        else {
          //模式
          modeShowVal = wpsData.wifi5gWpsMode.toString() == 'client'
              ? 'Client PIN'
              : 'PBC';
          // 客户模式
          modeVal = ['PBC', 'client'].indexOf(wpsData.wifi5gWpsMode.toString());
          //pin值
          pinVal.text = wpsData.wifi5gWpsClientPin.toString();
          //wps选中
          isCheck = wpsData.wifi5gWps.toString() == '1' ? true : false;
        }
      });
    } catch (e) {
      debugPrint('获取wps设置失败:$e.toString()');
    }
  }

  // 点击空白  关闭键盘 时传的一个对象
  FocusNode blankNode = FocusNode();

  /// 点击空白  关闭输入键盘
  void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(blankNode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(context: context, title: 'WPS', actions: <Widget>[
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
            : GestureDetector(
                onTap: () => closeKeyboard(context),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(240, 240, 240, 1)),
                  height: 1000,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TitleWidger(title: S.of(context).Settings),
                        InfoBox(
                            boxCotainer: Column(
                          children: [
                            //频段
                            GestureDetector(
                              onTap: () {
                                closeKeyboard(context);
                                var result = CommonPicker.showPicker(
                                  context: context,
                                  options: ['2.4GHz', '5GHz'],
                                  value: val,
                                );
                                result?.then((selectedValue) => {
                                      if (val != selectedValue &&
                                          selectedValue != null)
                                        {
                                          setState(() => {
                                                val = selectedValue,
                                                showVal =
                                                    ['2.4GHz', '5GHz'][val],
                                                printInfo(
                                                    info: 'showVal$showVal'),
                                                if (showVal == '2.4GHz')
                                                  {getTRWpsData()}
                                                else
                                                  {getTRWpsData2()},
                                                //提交时改变key
                                                paramKey = val == 0
                                                    ? 'wifiWps'
                                                    : 'wifi5gWps',
                                              })
                                        }
                                    });
                              },
                              child: BottomLine(
                                rowtem: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(S.of(context).Band,
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 5, 0, 0),
                                            fontSize: 28.sp)),
                                    Row(
                                      children: [
                                        Text(showVal,
                                            style: TextStyle(
                                                color: const Color.fromARGB(
                                                    255, 5, 0, 0),
                                                fontSize: 28.sp)),
                                        Icon(
                                          Icons.arrow_forward_ios_outlined,
                                          color: const Color.fromRGBO(
                                              144, 147, 153, 1),
                                          size: 30.w,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //WPS
                            BottomLine(
                              rowtem: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('WPS',
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 5, 0, 0),
                                          fontSize: 28.sp)),
                                  Row(
                                    children: [
                                      Switch(
                                        value: isCheck,
                                        onChanged: (newVal) {
                                          setState(() {
                                            isCheck = newVal;
                                            wpsVal =
                                                newVal == false ? '0' : '1';
                                          });
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            //模式
                            Offstage(
                              offstage: true,
                              child: GestureDetector(
                                onTap: () {
                                  closeKeyboard(context);
                                  var result = CommonPicker.showPicker(
                                    context: context,
                                    options: ['PBC', 'Client PIN'],
                                    value: modeVal,
                                  );
                                  result?.then((selectedValue) => {
                                        if (modeVal != selectedValue &&
                                            selectedValue != null)
                                          {
                                            setState(() => {
                                                  modeVal = selectedValue,
                                                  modeShowVal = [
                                                    'PBC',
                                                    'Client PIN'
                                                  ][modeVal]
                                                })
                                          }
                                      });
                                },
                                child: BottomLine(
                                  rowtem: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(S.of(context).Mode,
                                          style: TextStyle(
                                              color: const Color.fromARGB(
                                                  255, 5, 0, 0),
                                              fontSize: 28.sp)),
                                      Row(
                                        children: [
                                          Text(modeShowVal,
                                              style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 5, 0, 0),
                                                  fontSize: 28.sp)),
                                          Icon(
                                            Icons.arrow_forward_ios_outlined,
                                            color: const Color.fromRGBO(
                                                144, 147, 153, 1),
                                            size: 30.w,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            //客户 PIN
                            Offstage(
                              offstage: modeShowVal == 'PBC' || !isCheck,
                              child: BottomLine(
                                rowtem: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(S.of(context).ClientPIN,
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 5, 0, 0),
                                            fontSize: 28.sp)),
                                    SizedBox(
                                      width: 100.w,
                                      child: TextFormField(
                                        textAlign: TextAlign.right,
                                        keyboardType: TextInputType.number,
                                        controller: pinVal,
                                        style: TextStyle(
                                            fontSize: 26.sp,
                                            color: const Color(0xff051220)),
                                        decoration: InputDecoration(
                                          hintStyle: TextStyle(
                                              fontSize: 26.sp,
                                              color: const Color(0xff737A83)),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
                        // //提交
                        // Padding(
                        //   padding: EdgeInsets.only(top: 10.w),
                        //   child: Center(
                        //       child: SizedBox(
                        //     height: 70.sp,
                        //     width: 680.sp,
                        //     child: ElevatedButton(
                        //       style: ButtonStyle(
                        //           backgroundColor: MaterialStateProperty.all(
                        //               const Color.fromARGB(255, 48, 118, 250))),
                        //       onPressed: () {
                        //         printInfo(info: 'showVal$showVal');
                        // if (mounted) {
                        //   if (loginController.login.state == 'cloud' &&
                        //       sn.isNotEmpty) {
                        //     if (showVal == '2.4G') {
                        //       setTRWpsData();
                        //     } else {
                        //       setTRWpsData2();
                        //     }
                        //   } else if (loginController.login.state == 'local') {
                        //     handleSave();
                        //     //选择PBC
                        //     if (isCheck && modeShowVal == 'PBC') {
                        //       savePbc('{"${paramKey}Mode": "$modeShowVal"}');
                        //     }
                        //     //选择Client PIN
                        //     if (isCheck && modeShowVal == 'Client PIN') {
                        //       showVal == '2.4GHz'
                        //           ? savePbc(
                        //               '{ "${paramKey}Mode": "client",  "wifiWpsClientPin": "${pinVal.text}"}')
                        //           : savePbc(
                        //               '{ "${paramKey}Mode": "client",  "wifi5gWpsClientPin": "${pinVal.text}"}');
                        //     }
                        //   }
                        // }
                        // },
                        //       child: Text(
                        //         S.of(context).save,
                        //         style: TextStyle(fontSize: 36.sp),
                        //       ),
                        //     ),
                        //   )),
                        // )
                      ],
                    ),
                  ),
                ),
              ));
  }
}
