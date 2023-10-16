import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/request/request.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:flutter_template/core/widget/custom_app_bar.dart';
import 'package:flutter_template/core/widget/water_loading.dart';
import 'package:flutter_template/pages/login/login_controller.dart';
import 'package:flutter_template/pages/wifi_set/visitor/2.4GHZ_visitor/2.4GHZ_datas.dart';
import 'package:get/get.dart';
import '../../../../core/utils/toast.dart';
import '../../../../core/widget/common_picker.dart';
import '../../../../generated/l10n.dart';

/// 4G访客3
class Visitor3 extends StatefulWidget {
  const Visitor3({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Visitor3State();
}

class _Visitor3State extends State<Visitor3> {
  final LoginController loginController = Get.put(LoginController());
  Vis2gDatas data_2g = Vis2gDatas();
  final TextEditingController ssidVal = TextEditingController();
  final TextEditingController maxVal = TextEditingController();
  final TextEditingController password = TextEditingController();
  WiFiSsidTable currentData = WiFiSsidTable(
    ssid: '',
  );
  String sn = '';
  bool loading = false;
  //是否允许访问内网
  bool networkCheck = false;
  //隐藏SSID网络
  bool showSsid = false;
  //AP隔离
  bool apVAl = false;
  //安全
  String safeShowVal = 'WPA-PSK';
  int safeIndex = 0;
  String safeVal = 'psk-mixed';
  //wpa加密
  String wpaShowVal = S.current.aesRecommend;
  int wpaIndex = 0;
  String wpaVal = 'aes';
  //密码
  bool passwordValShow = true;
  @override

  // 点击空白  关闭键盘 时传的一个对象
  FocusNode blankNode = FocusNode();

  /// 点击空白  关闭输入键盘
  void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(blankNode);
  }

  //读取
  void get2GData() async {
    Map<String, dynamic> data = {
      'method': 'tab_dump',
      'param': '["WiFiSsidTable"]',
    };
    try {
      var response = await XHttp.get('/data.html', data);
      var d = json.decode(response.toString());
      setState(() {
        data_2g = Vis2gDatas.fromJson(d);
        currentData = data_2g.wiFiSsidTable![3];
        //是否允许访问内网 0不启用
        networkCheck =
            currentData.allowAccessIntranet.toString() == '0' ? false : true;
        //ssid
        ssidVal.text = currentData.ssid.toString();
        //最大设备
        maxVal.text = currentData.maxClient.toString();
        //隐藏SSID网络
        showSsid = currentData.ssidHide.toString() == '0' ? false : true;
        //AP隔离  ApIsolate=='0' 不启用
        apVAl = currentData.apIsolate.toString() == '0' ? false : true;
        // 安全
        switch (currentData.encryption.toString().split('+')[0]) {
          case 'psk':
            safeShowVal = 'WPA-PSK';
            break;
          case 'psk2':
            safeShowVal = 'WPA2-PSK';
            break;
          case 'psk-mixed':
            safeShowVal = 'WPA-PSK&WPA2-PSK';
            break;
        }
        safeIndex = ['psk', 'psk2', 'psk-mixed']
            .indexOf(currentData.encryption.toString().split('+')[0]);
        safeVal = ['psk', 'psk2', 'psk-mixed'][safeIndex];
        //wpa加密
        if (currentData.encryption.toString().split('+').length == 3) {
          wpaShowVal = 'TKIP&AES';
          wpaIndex = 2;
        } else {
          currentData.encryption.toString().split('+')[1] == 'aes'
              ? wpaShowVal = S.current.aesRecommend
              : wpaShowVal = 'TKIP';
          currentData.encryption.toString().split('+')[1] == 'aes'
              ? wpaIndex = 0
              : wpaIndex = 1;
        }
        wpaVal = ['aes', 'tkip', 'tkip+aes'][wpaIndex];
        //密码
        password.text = currentData.key.toString();
      });
    } catch (e) {
      debugPrint('获取2.4GHZ失败:$e.toString()');
    }
  }

// 云端获取数据
  Future getCloudData() async {
    if (sn == '') {
      var value = await sharedGetData('deviceSn', String);
      sn = value.toString();
    }
    try {
      List<String> parameterNames = [
        'InternetGatewayDevice.WEB_GUI.WiFi.WLANSettings.1.SSIDProfile.4',
      ];
      var res = await Request().getACSNode(parameterNames, sn);
      var data = jsonDecode(res)['data']['InternetGatewayDevice']['WEB_GUI']
          ['WiFi']['WLANSettings']['1']['SSIDProfile']['4'];

      setState(() {
        //是否允许访问内网
        networkCheck = data['AccessToIntranet']['_value'];
        //ssid
        ssidVal.text = data['SSID']['_value'].toString();
        //最大设备
        maxVal.text = data['MaxNoOfDev']['_value'].toString();
        //隐藏SSID网络
        showSsid = data['HideSSIDBroadcast']['_value'];
        //AP隔离
        apVAl = data['APIsolation']['_value'];

        // 安全
        switch (data['EncryptionMode']['_value'].split('+')[0]) {
          case 'psk':
            safeShowVal = 'WPA-PSK';
            break;
          case 'psk2':
            safeShowVal = 'WPA2-PSK';
            break;
          case 'psk-mixed':
            safeShowVal = 'WPA-PSK&WPA2-PSK';
            break;
        }
        safeIndex = ['psk', 'psk2', 'psk-mixed']
            .indexOf(data['EncryptionMode']['_value'].split('+')[0]);
        safeVal = ['psk', 'psk2', 'psk-mixed'][safeIndex];

        //wpa加密
        switch (data['EncryptionMode']['_value'].split('+')[1]) {
          case 'aes':
            wpaShowVal = S.current.aesRecommend;
            break;
          case 'tkip':
            wpaShowVal = 'TKIP';
            break;
          case 'tkip+aes':
            wpaShowVal = 'TKIP&ARS';
            break;
        }

        wpaIndex = ['aes', 'tkip', 'tkip+aes']
            .indexOf(data['EncryptionMode']['_value'].split('+')[1]);
        wpaVal = ['aes', 'tkip', 'tkip+aes'][wpaIndex];
      });
    } catch (e) {
      printError(info: 'getCloudData for visitor error: ${e.toString()}');
    }
  }

  //保存
  void handleSave(params) async {
    Map<String, dynamic> data = {
      'method': 'tab_set',
      'param': params,
    };
    XHttp.get('/data.html', data).then((res) {
      try {
        ToastUtils.toast(S.current.success);
      } on FormatException catch (e) {
        debugPrint(e.message);
      }
    }).catchError((onError) {
      debugPrint('失败：${onError.toString()}');
      ToastUtils.toast(S.current.error);
    });
  }

  Future getData() async {
    var value = await sharedGetData('deviceSn', String);
    printInfo(info: 'deviceSn$value');
    sn = value.toString();

    if (loginController.login.state == 'cloud' && sn.isNotEmpty) {
      //状态为local 请求本地  状态为cloud  请求云端
      if (mounted) {
        setState(() {
          loading = true;
        });
        await getCloudData();
        setState(() {
          loading = false;
        });
      }
    }
    if (loginController.login.state == 'local') {
      setState(() {
        loading = true;
      });
      get2GData();
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

// 设置 云端
  setData() async {
    Object? sn = await sharedGetData('deviceSn', String);
    String prefix =
        'InternetGatewayDevice.WEB_GUI.WiFi.WLANSettings.1.SSIDProfile.4.';
    try {
      var res = await Request().setACSNode([
        ['${prefix}AccessToIntranet', networkCheck, 'xsd:boolean'],
        ['${prefix}SSID', ssidVal.text, 'xsd:string'],
        ['${prefix}MaxNoOfDev', maxVal.text, 'xsd:unsignedInt'],
        ['${prefix}HideSSIDBroadcast', showSsid, 'xsd:boolean'],
        ['${prefix}APIsolation', apVAl, 'xsd:boolean'],
        ['${prefix}EncryptionMode', '$safeVal+$wpaVal', 'xsd:string'],
      ], sn);
      printInfo(info: '----$res');

      if (json.decode(res)['code'] == 200) {
        ToastUtils.toast('Save success');
      }
    } catch (e) {
      printError(info: e.toString());
    }
  }

// 提交
  Future<void> _saveData() async {
    setState(() {
      loading = true;
    });
    if (loginController.login.state == 'cloud' && sn.isNotEmpty) {
      // 云端请求赋值
      try {
        setData();
      } catch (e) {
        debugPrint('云端请求出错：${e.toString()}');
        Get.back();
      }
    }
    if (loginController.login.state == 'local') {
      // 本地请求赋值
      handleSave(
          '{"table":"WiFiSsidTable","value":[{"id":3,"AllowAccessIntranet":"${networkCheck ? "1" : "0"}","Ssid":"${ssidVal.text}","MaxClient":"${maxVal.text}","SsidHide":"${showSsid ? "1" : "0"}","ApIsolate":"${apVAl ? "1" : "0"}","Encryption":"$safeVal+$wpaVal","ShowPasswd":"0","Key":"${password.text}"}]}');
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            customAppbar(context: context, title: 'guest3', actions: <Widget>[
          Container(
            margin: EdgeInsets.all(20.w),
            child: OutlinedButton(
              onPressed: loading ? null : _saveData,
              child: Row(
                children: [
                  if (loading)
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  if (!loading)
                    Text(
                      S.current.save,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: loading ? Colors.grey : null,
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
                            //访客网络索引
                            // BottomLine(
                            //   rowtem: Row(
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       Text(S.of(context).NetworkIndex,
                            //           style: TextStyle(
                            //               color: const Color.fromARGB(
                            //                   255, 5, 0, 0),
                            //               fontSize: 28.sp)),
                            //       Text('2.4G_3',
                            //           style: TextStyle(
                            //               color: const Color.fromARGB(
                            //                   255, 5, 0, 0),
                            //               fontSize: 28.sp)),
                            //     ],
                            //   ),
                            // ),
                            //是否允许访问内网
                            BottomLine(
                              rowtem: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(S.of(context).AllowAccess,
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 5, 0, 0),
                                          fontSize: 28.sp)),
                                  Row(
                                    children: [
                                      Switch(
                                        value: networkCheck,
                                        onChanged: (newVal) {
                                          setState(() {
                                            networkCheck = newVal;
                                          });
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            //SSID
                            BottomLine(
                              rowtem: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('SSID',
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 5, 0, 0),
                                          fontSize: 28.sp)),
                                  SizedBox(
                                    width: 300.w,
                                    child: TextFormField(
                                      textAlign: TextAlign.right,
                                      controller: ssidVal,
                                      style: TextStyle(
                                          fontSize: 26.sp,
                                          color: const Color(0xff051220)),
                                      decoration: InputDecoration(
                                        hintText: S.current.ascii32,
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
                            //最大设备数
                            BottomLine(
                              rowtem: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(S.of(context).Maximum,
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 5, 0, 0),
                                          fontSize: 28.sp)),
                                  SizedBox(
                                    width: 100.w,
                                    child: TextFormField(
                                      textAlign: TextAlign.right,
                                      keyboardType: TextInputType.number,
                                      controller: maxVal,
                                      style: TextStyle(
                                          fontSize: 26.sp,
                                          color: const Color(0xff051220)),
                                      decoration: InputDecoration(
                                        hintText: "1~32",
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
                            //隐藏SSID网络
                            BottomLine(
                              rowtem: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(S.of(context).HideSSIDBroadcast,
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 5, 0, 0),
                                          fontSize: 28.sp)),
                                  Row(
                                    children: [
                                      Switch(
                                        value: showSsid,
                                        onChanged: (newVal) {
                                          setState(() {
                                            showSsid = newVal;
                                          });
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            //AP隔离
                            // BottomLine(
                            //   rowtem: Row(
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       Text(S.of(context).APIsolation,
                            //           style: TextStyle(
                            //               color: const Color.fromARGB(
                            //                   255, 5, 0, 0),
                            //               fontSize: 28.sp)),
                            //       Row(
                            //         children: [
                            //           Switch(
                            //             value: apVAl,
                            //             onChanged: (newVal) {
                            //               setState(() {
                            //                 apVAl = newVal;
                            //               });
                            //             },
                            //           ),
                            //         ],
                            //       )
                            //     ],
                            //   ),
                            // ),
                            //安全
                            GestureDetector(
                              onTap: () {
                                closeKeyboard(context);
                                var result = CommonPicker.showPicker(
                                  context: context,
                                  options: [
                                    'WPA-PSK',
                                    'WPA2-PSK',
                                    'WPA-PSK&WPA2-PSK'
                                  ],
                                  value: safeIndex,
                                );
                                result?.then((selectedValue) => {
                                      if (safeIndex != selectedValue &&
                                          selectedValue != null)
                                        {
                                          setState(() => {
                                                safeIndex = selectedValue,
                                                safeShowVal = [
                                                  'WPA-PSK',
                                                  'WPA2-PSK',
                                                  'WPA-PSK&WPA2-PSK'
                                                ][safeIndex],
                                                safeVal = [
                                                  'psk',
                                                  'psk2',
                                                  'psk-mixed'
                                                ][safeIndex]
                                              })
                                        }
                                    });
                              },
                              child: BottomLine(
                                rowtem: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(S.of(context).Security,
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 5, 0, 0),
                                            fontSize: 28.sp)),
                                    Row(
                                      children: [
                                        Text(safeShowVal,
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
                            //WPA加密
                            GestureDetector(
                              onTap: () {
                                closeKeyboard(context);
                                var result = CommonPicker.showPicker(
                                  context: context,
                                  options: [
                                    S.current.aesRecommend,
                                    'TKIP',
                                    'TKIP&AES'
                                  ],
                                  value: wpaIndex,
                                );
                                result?.then((selectedValue) => {
                                      if (wpaIndex != selectedValue &&
                                          selectedValue != null)
                                        {
                                          setState(() => {
                                                wpaIndex = selectedValue,
                                                wpaShowVal = [
                                                  S.current.aesRecommend,
                                                  'TKIP',
                                                  'TKIP&AES'
                                                ][wpaIndex],
                                                wpaVal = [
                                                  'aes',
                                                  'tkip',
                                                  'tkip+aes'
                                                ][wpaIndex]
                                              })
                                        }
                                    });
                              },
                              child: BottomLine(
                                rowtem: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(S.of(context).WPAEncry,
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 5, 0, 0),
                                            fontSize: 28.sp)),
                                    Row(
                                      children: [
                                        Text(wpaShowVal,
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
                            //密码
                            BottomLine(
                              rowtem: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(S.of(context).Password,
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 5, 0, 0),
                                          fontSize: 28.sp)),
                                  SizedBox(
                                    height: 80.w,
                                    width: 300.w,
                                    child: TextFormField(
                                      textAlign: TextAlign.right,
                                      obscureText: passwordValShow,
                                      controller: password,
                                      style: TextStyle(
                                          fontSize: 26.sp,
                                          color: const Color(0xff051220)),
                                      decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                passwordValShow =
                                                    !passwordValShow;
                                              });
                                            },
                                            icon: Icon(!passwordValShow
                                                ? Icons.visibility
                                                : Icons.visibility_off)),
                                        hintText: S.current.ASCII,
                                        hintStyle: TextStyle(
                                            fontSize: 26.sp,
                                            color: const Color(0xff737A83)),
                                        border: InputBorder.none,
                                      ),
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        return value!.trim().length > 8
                                            ? null
                                            : "密码不能少于8位";
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                        //提交
                        // Padding(
                        //   padding: EdgeInsets.only(top: 10.w),
                        //   child: Center(
                        //     child: SizedBox(
                        //       height: 70.sp,
                        //       width: 680.sp,
                        //       child: ElevatedButton(
                        //         style: ButtonStyle(
                        //             backgroundColor: MaterialStateProperty.all(
                        //                 const Color.fromARGB(
                        //                     255, 48, 118, 250))),
                        //         onPressed: () {
                        //           handleSave(
                        //               '{"table":"WiFiSsidTable","value":[{"id":3,"AllowAccessIntranet":"${networkCheck ? "1" : "0"}","Ssid":"${ssidVal.text}","MaxClient":"${maxVal.text}","SsidHide":"${showSsid ? "1" : "0"}","ApIsolate":"${apVAl ? "1" : "0"}","Encryption":"$safeVal+$wpaVal","ShowPasswd":"0","Key":"${password.text}"}]}');
                        //         },
                        //         child: Text(
                        //           S.of(context).save,
                        //           style: TextStyle(fontSize: 30.sp),
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                ),
              ));
  }
}
