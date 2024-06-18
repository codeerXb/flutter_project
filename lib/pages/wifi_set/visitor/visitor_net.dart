import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/request/request.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:flutter_template/core/widget/common_widget.dart';
import 'package:flutter_template/core/widget/water_loading.dart';
import 'package:flutter_template/pages/wifi_set/visitor/2.4GHZ_visitor/2.4GHZ_datas.dart';
import 'package:flutter_template/pages/wifi_set/visitor/5G_visitor/5GHZ_datas.dart';
import 'package:get/get.dart';
import '../../../core/widget/custom_app_bar.dart';
import '../../../generated/l10n.dart';
import '../../login/login_controller.dart';
import '../visitor/guest_model.dart';
import '../../../core/utils/global_nav_context.dart';
import '../../../core/utils/logger.dart';

/// 访客网络
class VisitorNet extends StatefulWidget {
  const VisitorNet({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _VisitorNetState();
}

class _VisitorNetState extends State<VisitorNet> {
  String sn = '';
  //2.4GHZ
  Vis2gDatas data_2g = Vis2gDatas(wiFiSsidTable: [
    WiFiSsidTable(
      enable: "0",
    ),
    WiFiSsidTable(
      enable: "0",
    ),
    WiFiSsidTable(
      enable: "0",
    ),
    WiFiSsidTable(
      enable: "0",
    )
  ]);
  //5GHZ
  Vis5gDatas data_5g = Vis5gDatas(wiFi5GSsidTable: [
    WiFiSsidTable(
      enable: "0",
    ),
    WiFiSsidTable(
      enable: "0",
    ),
    WiFiSsidTable(
      enable: "0",
    ),
    WiFiSsidTable(
      enable: "0",
    )
  ]);
  final LoginController loginController = Get.put(LoginController());

  bool loading = false;
  guestModel? guest24Model;
  guestModel? guest5gModel;

  // 云端获取数据
  Future getCloudData() async {
    if (sn == '') {
      var value = await sharedGetData('deviceSn', String);
      sn = value.toString();
    }
    var parameterNames1 = {"method": "get", "table": "WiFiSsidTable"};
    var parameterNames2 = {"method": "get", "table": "WiFi5GSsidTable"};
    var res24G = await Request().getSODTable(parameterNames1, sn);
    var res5G = await Request().getSODTable(parameterNames2, sn);
    final parsedJson24G = jsonDecode(res24G.toString());
    final parsedJson5G = jsonDecode(res5G.toString());
    debugPrint("获取的2.4G的网络数据:$parsedJson24G");
    debugPrint("获取的5G的网络数据:$parsedJson5G");
    var model24g = guestModel.fromJson(parsedJson24G);
    var model5g = guestModel.fromJson(parsedJson5G);
    setState(() {
      guest24Model = model24g;
      guest5gModel = model5g;
    });
    // var prefix24g = (await jsonDecode(res24G)['data'] as List)
    //     .map((e) => e as Map<String, dynamic>)
    //     .toList();
    // var prefix5g = (await jsonDecode(res5G)['data'] as List)
    //     .map((e) => e as Map<String, dynamic>)
    //     .toList();
    // debugPrint("获取的2.4G的长度:${prefix24g.length}");
    // debugPrint("获取的5G的长度:${prefix5g.length}");
    // debugPrint("获取的2.4G的网络数据:${prefix24g}");
    // debugPrint("获取的5G的网络数据:${prefix5g}");
    if (guest5gModel!.data == null || guest24Model!.data == null) {
      ToastUtils.toast("Network Exception");
      return;
    }
    try {
      // List<String> parameterNames = [
      //   'InternetGatewayDevice.WEB_GUI.WiFi.WLANSettings',
      // ];

      // var prefix24g = jsonDecode(res)['data']['InternetGatewayDevice']
      //     ['WEB_GUI']['WiFi']['WLANSettings']['1']['SSIDProfile'];
      // var prefix5g = jsonDecode(res)['data']['InternetGatewayDevice']['WEB_GUI']
      //     ['WiFi']['WLANSettings']['2']['SSIDProfile'];

      setState(() {
        // data_2g.wiFiSsidTable![0].enable =
        //     prefix24g['1']['Enable']['_value'] ? '1' : '0';
        data_2g.wiFiSsidTable![1].enable = guest24Model!.data![1].enable;
        data_2g.wiFiSsidTable![2].enable = guest24Model!.data![2].enable;
        data_2g.wiFiSsidTable![3].enable = guest24Model!.data![3].enable;

        // data_5g.wiFi5GSsidTable![0].enable =
        //     prefix5g['1']['Enable']['_value'] ? '1' : '0';
        data_5g.wiFi5GSsidTable![1].enable = guest5gModel!.data![1].enable;
        data_5g.wiFi5GSsidTable![2].enable = guest5gModel!.data![2].enable;
        data_5g.wiFi5GSsidTable![3].enable = guest5gModel!.data![3].enable;
      });
    } catch (e) {
      printError(info: 'getCloudData for visitor error: ${e.toString()}');
    }
  }

  //读取2.4GHZ
  Future get2GData() async {
    Map<String, dynamic> data = {
      'method': 'tab_dump',
      'param': '["WiFiSsidTable"]',
    };
    try {
      var response = await XHttp.get('/data.html', data);
      var d = json.decode(response.toString());
      setState(() {
        data_2g = Vis2gDatas.fromJson(d);
      });
    } catch (e) {
      printError(info: '获取2.4GHZ失败:$e.toString()');
    }
  }

  //读取5GHZ
  Future get5GData() async {
    Map<String, dynamic> data = {
      'method': 'tab_dump',
      'param': '["WiFi5GSsidTable"]',
    };
    try {
      var response = await XHttp.get('/data.html', data);
      var d = json.decode(response.toString());
      setState(() {
        data_5g = Vis5gDatas.fromJson(d);
      });
    } catch (e) {
      printError(info: '获取5GHZ失败:$e.toString()');
    }
  }

  //保存
  Future handleSave(params) async {
    Map<String, dynamic> data = {
      'method': 'tab_set',
      'param': params,
    };
    XHttp.get('/data.html', data).then((res) {
      try {
        ToastUtils.toast(S.current.success);
      } on FormatException catch (e) {
        printError(info: e.toString());
      }
    }).catchError((onError) {
      debugPrint('失败：${onError.toString()}');
      ToastUtils.toast(S.current.error);
    });
  }

// 设置云端
  setData(params) async {
    Object? sn = await sharedGetData('deviceSn', String);
    try {
      var res = await Request().setSODTable(params, sn);
      printInfo(info: '----$res');

      if (json.decode(res)['code'] == 200) {
        ToastUtils.toast('Save success');
      }
    } catch (e) {
      printError(info: e.toString());
    }
  }

  Future getData() async {
    var value = await sharedGetData('deviceSn', String);
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
      await get2GData();
      await get5GData();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context: context, title: S.of(context).visitorNet),
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
              padding: EdgeInsets.only(bottom: 20.w, left: 30.w, right: 30.w),
              decoration: const BoxDecoration(
                color: Color.fromRGBO(240, 240, 240, 1),
              ),
              height: 1400.w,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(padding: EdgeInsets.only(top: 10.w)),
                    const TitleWidger(title: '2.4GHZ'),
                    //访客 enable == '1'启用
                    InkWell(
                      onTap: () {
                        Get.toNamed("/visitor_one");
                      },
                      child: Container(
                        decoration: const BoxDecoration(color: Colors.white),
                        child: ListTile(
                          title: Text(
                            '${guest24Model!.data![1].ssid}',
                            style: const TextStyle(fontSize: 14),
                            textScaler: TextScaler.noScaling,
                          ),
                          trailing: const Icon(Icons.chevron_right,
                              color: Colors.grey),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.toNamed("/visitor_two");
                      },
                      child: Container(
                        decoration: const BoxDecoration(color: Colors.white),
                        child: ListTile(
                          title: Text(
                            '${guest24Model!.data![2].ssid}',
                            style: const TextStyle(fontSize: 14),
                            textScaler: TextScaler.noScaling,
                          ),
                          trailing: const Icon(Icons.chevron_right,
                              color: Colors.grey),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.toNamed("/visitor_three");
                      },
                      child: Container(
                        decoration: const BoxDecoration(color: Colors.white),
                        child: ListTile(
                          title: Text(
                            '${guest24Model!.data![3].ssid}',
                            style: const TextStyle(fontSize: 14),
                            textScaler: TextScaler.noScaling,
                          ),
                          trailing: const Icon(Icons.chevron_right,
                              color: Colors.grey),
                        ),
                      ),
                    ),
                    // CommonWidget.simpleWidgetWithMine(
                    //     title: '${guest24Model!.data![1].ssid}',
                    //     icon: IconButton(
                    //       onPressed: () {
                    //         setState(() {
                    //           /*
                    //           if (data_2g.wiFiSsidTable![1].enable == '1') {
                    //             data_2g.wiFiSsidTable![1].enable = '0';
                    //             guest24Model!.data![1].enable = "0";
                    //             //guest1
                    //             var parameterNames = {
                    //               "method": "set",
                    //               "table": {
                    //                 "table": "WiFiSsidTable",
                    //                 "value": [
                    //                   {
                    //                     "id": guest24Model!.data![1].id,
                    //                     "Enable": guest24Model!.data![1].enable,
                    //                     "SsidHide":
                    //                         guest24Model!.data![1].ssidHide,
                    //                     "ApIsolate":
                    //                         guest24Model!.data![1].apIsolate,
                    //                     "ShowPasswd":
                    //                         guest24Model!.data![1].showPasswd,
                    //                     "Is4Guest":
                    //                         guest24Model!.data![1].is4Guest,
                    //                     "PasswordLength": guest24Model!
                    //                         .data![1].passwordLength,
                    //                     "PasswordIndex": guest24Model!
                    //                         .data![1].passwordIndex,
                    //                     "MaxClient":
                    //                         guest24Model!.data![1].maxClient,
                    //                     "Ssid": guest24Model!.data![1].ssid,
                    //                     "Key": guest24Model!.data![1].key,
                    //                     "Password1":
                    //                         guest24Model!.data![1].password1,
                    //                     "Password2":
                    //                         guest24Model!.data![1].password2,
                    //                     "Password3":
                    //                         guest24Model!.data![1].password3,
                    //                     "Password4":
                    //                         guest24Model!.data![1].password4,
                    //                     "Encryption":
                    //                         guest24Model!.data![1].encryption,
                    //                     "SsidMac":
                    //                         guest24Model!.data![1].ssidMac,
                    //                     "AllowAccessIntranet": guest24Model!
                    //                         .data![1].allowAccessIntranet,
                    //                     "wifiRadiusServerIP": guest24Model!
                    //                         .data![1].wifiRadiusServerIP,
                    //                     "wifiRadiusServerPort": guest24Model!
                    //                         .data![1].wifiRadiusServerPort,
                    //                     "wifiRadiusSharedKey": guest24Model!
                    //                         .data![1].wifiRadiusSharedKey
                    //                   }
                    //                 ]
                    //               }
                    //             };
                    //             setData(parameterNames);
                    //             // setData([
                    //             //   '${prefix}1.SSIDProfile.2.Enable',
                    //             //   false,
                    //             //   'xsd:boolean'
                    //             // ]);
                    //             // handleSave(
                    //             //     '{"table":"WiFiSsidTable","value":[{"id":1,"Enable":"0"}]}');
                    //           } else {
                    //             data_2g.wiFiSsidTable![1].enable = '1';
                    //             guest24Model!.data![1].enable = "1";
                    //             //启用
                    //             var parameterNames = {
                    //               "method": "set",
                    //               "table": {
                    //                 "table": "WiFiSsidTable",
                    //                 "value": [
                    //                   {
                    //                     "id": guest24Model!.data![1].id,
                    //                     "Enable": guest24Model!.data![1].enable,
                    //                     "SsidHide":
                    //                         guest24Model!.data![1].ssidHide,
                    //                     "ApIsolate":
                    //                         guest24Model!.data![1].apIsolate,
                    //                     "ShowPasswd":
                    //                         guest24Model!.data![1].showPasswd,
                    //                     "Is4Guest":
                    //                         guest24Model!.data![1].is4Guest,
                    //                     "PasswordLength": guest24Model!
                    //                         .data![1].passwordLength,
                    //                     "PasswordIndex": guest24Model!
                    //                         .data![1].passwordIndex,
                    //                     "MaxClient":
                    //                         guest24Model!.data![1].maxClient,
                    //                     "Ssid": guest24Model!.data![1].ssid,
                    //                     "Key": guest24Model!.data![1].key,
                    //                     "Password1":
                    //                         guest24Model!.data![1].password1,
                    //                     "Password2":
                    //                         guest24Model!.data![1].password2,
                    //                     "Password3":
                    //                         guest24Model!.data![1].password3,
                    //                     "Password4":
                    //                         guest24Model!.data![1].password4,
                    //                     "Encryption":
                    //                         guest24Model!.data![1].encryption,
                    //                     "SsidMac":
                    //                         guest24Model!.data![1].ssidMac,
                    //                     "AllowAccessIntranet": guest24Model!
                    //                         .data![1].allowAccessIntranet,
                    //                     "wifiRadiusServerIP": guest24Model!
                    //                         .data![1].wifiRadiusServerIP,
                    //                     "wifiRadiusServerPort": guest24Model!
                    //                         .data![1].wifiRadiusServerPort,
                    //                     "wifiRadiusSharedKey": guest24Model!
                    //                         .data![1].wifiRadiusSharedKey
                    //                   }
                    //                 ]
                    //               }
                    //             };
                    //             setData(parameterNames);
                    //             // handleSave(
                    //             //     '{"table":"WiFiSsidTable","value":[{"id":1,"Enable":"1"}]}');
                    //           }
                    //           */
                    //           data_2g.wiFiSsidTable![1].enable = '1';
                    //             guest24Model!.data![1].enable = "1";
                    //             //启用
                    //             var parameterNames = {
                    //               "method": "set",
                    //               "table": {
                    //                 "table": "WiFiSsidTable",
                    //                 "value": [
                    //                   {
                    //                     "id": guest24Model!.data![1].id,
                    //                     "Enable": guest24Model!.data![1].enable,
                    //                     "SsidHide":
                    //                         guest24Model!.data![1].ssidHide,
                    //                     "ApIsolate":
                    //                         guest24Model!.data![1].apIsolate,
                    //                     "ShowPasswd":
                    //                         guest24Model!.data![1].showPasswd,
                    //                     "Is4Guest":
                    //                         guest24Model!.data![1].is4Guest,
                    //                     "PasswordLength": guest24Model!
                    //                         .data![1].passwordLength,
                    //                     "PasswordIndex": guest24Model!
                    //                         .data![1].passwordIndex,
                    //                     "MaxClient":
                    //                         guest24Model!.data![1].maxClient,
                    //                     "Ssid": guest24Model!.data![1].ssid,
                    //                     "Key": guest24Model!.data![1].key,
                    //                     "Password1":
                    //                         guest24Model!.data![1].password1,
                    //                     "Password2":
                    //                         guest24Model!.data![1].password2,
                    //                     "Password3":
                    //                         guest24Model!.data![1].password3,
                    //                     "Password4":
                    //                         guest24Model!.data![1].password4,
                    //                     "Encryption":
                    //                         guest24Model!.data![1].encryption,
                    //                     "SsidMac":
                    //                         guest24Model!.data![1].ssidMac,
                    //                     "AllowAccessIntranet": guest24Model!
                    //                         .data![1].allowAccessIntranet,
                    //                     "wifiRadiusServerIP": guest24Model!
                    //                         .data![1].wifiRadiusServerIP,
                    //                     "wifiRadiusServerPort": guest24Model!
                    //                         .data![1].wifiRadiusServerPort,
                    //                     "wifiRadiusSharedKey": guest24Model!
                    //                         .data![1].wifiRadiusSharedKey
                    //                   }
                    //                 ]
                    //               }
                    //             };
                    //             setData(parameterNames);
                    //         });
                    //       },
                    //       icon: Icon(
                    //         data_2g.wiFiSsidTable![1].enable == '1'
                    //             ? Icons.check_box
                    //             : Icons.check_box_outline_blank,
                    //         color: Colors.blue,
                    //         size: 0.w,
                    //       ),
                    //     ),
                    //     callBack: () {
                    //       Get.toNamed("/visitor_one");

                    //       // if (data_2g.wiFiSsidTable![1].enable == '1') {
                    //       //   Get.toNamed("/visitor_one");
                    //       // } else {
                    //       //   ToastUtils.toast(S.of(context).notEnable);
                    //       // }
                    //     }),
                    // CommonWidget.simpleWidgetWithMine(
                    //     title: '${guest24Model!.data![2].ssid}',
                    //     icon: IconButton(
                    //       onPressed: () {
                    //         setState(() {
                    //           if (data_2g.wiFiSsidTable![2].enable == '1') {
                    //             //guest2
                    //             data_2g.wiFiSsidTable![2].enable = '0';
                    //             guest24Model!.data![2].enable = "0";
                    //             var parameterNames = {
                    //               "method": "set",
                    //               "table": {
                    //                 "table": "WiFiSsidTable",
                    //                 "value": [
                    //                   {
                    //                     "id": guest24Model!.data![2].id,
                    //                     "Enable": guest24Model!.data![2].enable,
                    //                     "SsidHide":
                    //                         guest24Model!.data![2].ssidHide,
                    //                     "ApIsolate":
                    //                         guest24Model!.data![2].apIsolate,
                    //                     "ShowPasswd":
                    //                         guest24Model!.data![2].showPasswd,
                    //                     "Is4Guest":
                    //                         guest24Model!.data![2].is4Guest,
                    //                     "PasswordLength": guest24Model!
                    //                         .data![2].passwordLength,
                    //                     "PasswordIndex": guest24Model!
                    //                         .data![2].passwordIndex,
                    //                     "MaxClient":
                    //                         guest24Model!.data![2].maxClient,
                    //                     "Ssid": guest24Model!.data![2].ssid,
                    //                     "Key": guest24Model!.data![2].key,
                    //                     "Password1":
                    //                         guest24Model!.data![2].password1,
                    //                     "Password2":
                    //                         guest24Model!.data![2].password2,
                    //                     "Password3":
                    //                         guest24Model!.data![2].password3,
                    //                     "Password4":
                    //                         guest24Model!.data![2].password4,
                    //                     "Encryption":
                    //                         guest24Model!.data![2].encryption,
                    //                     "SsidMac":
                    //                         guest24Model!.data![2].ssidMac,
                    //                     "AllowAccessIntranet": guest24Model!
                    //                         .data![2].allowAccessIntranet,
                    //                     "wifiRadiusServerIP": guest24Model!
                    //                         .data![2].wifiRadiusServerIP,
                    //                     "wifiRadiusServerPort": guest24Model!
                    //                         .data![2].wifiRadiusServerPort,
                    //                     "wifiRadiusSharedKey": guest24Model!
                    //                         .data![2].wifiRadiusSharedKey
                    //                   }
                    //                 ]
                    //               }
                    //             };
                    //             setData(parameterNames);

                    //             // setData([
                    //             //   '${prefix}1.SSIDProfile.3.Enable',
                    //             //   false,
                    //             //   'xsd:boolean'
                    //             // ]);
                    //             // handleSave(
                    //             //     '{"table":"WiFiSsidTable","value":[{"id":2,"Enable":"0"}]}');
                    //           } else {
                    //             //启用
                    //             data_2g.wiFiSsidTable![2].enable = '1';
                    //             guest24Model!.data![2].enable = "1";
                    //             var parameterNames = {
                    //               "method": "set",
                    //               "table": {
                    //                 "table": "WiFiSsidTable",
                    //                 "value": [
                    //                   {
                    //                     "id": guest24Model!.data![2].id,
                    //                     "Enable": guest24Model!.data![2].enable,
                    //                     "SsidHide":
                    //                         guest24Model!.data![2].ssidHide,
                    //                     "ApIsolate":
                    //                         guest24Model!.data![2].apIsolate,
                    //                     "ShowPasswd":
                    //                         guest24Model!.data![2].showPasswd,
                    //                     "Is4Guest":
                    //                         guest24Model!.data![2].is4Guest,
                    //                     "PasswordLength": guest24Model!
                    //                         .data![2].passwordLength,
                    //                     "PasswordIndex": guest24Model!
                    //                         .data![2].passwordIndex,
                    //                     "MaxClient":
                    //                         guest24Model!.data![2].maxClient,
                    //                     "Ssid": guest24Model!.data![2].ssid,
                    //                     "Key": guest24Model!.data![2].key,
                    //                     "Password1":
                    //                         guest24Model!.data![2].password1,
                    //                     "Password2":
                    //                         guest24Model!.data![2].password2,
                    //                     "Password3":
                    //                         guest24Model!.data![2].password3,
                    //                     "Password4":
                    //                         guest24Model!.data![2].password4,
                    //                     "Encryption":
                    //                         guest24Model!.data![2].encryption,
                    //                     "SsidMac":
                    //                         guest24Model!.data![2].ssidMac,
                    //                     "AllowAccessIntranet": guest24Model!
                    //                         .data![2].allowAccessIntranet,
                    //                     "wifiRadiusServerIP": guest24Model!
                    //                         .data![2].wifiRadiusServerIP,
                    //                     "wifiRadiusServerPort": guest24Model!
                    //                         .data![2].wifiRadiusServerPort,
                    //                     "wifiRadiusSharedKey": guest24Model!
                    //                         .data![2].wifiRadiusSharedKey
                    //                   }
                    //                 ]
                    //               }
                    //             };
                    //             setData(parameterNames);

                    //             // setData([
                    //             //   '${prefix}1.SSIDProfile.3.Enable',
                    //             //   true,
                    //             //   'xsd:boolean'
                    //             // ]);
                    //             // handleSave(
                    //             //     '{"table":"WiFiSsidTable","value":[{"id":2,"Enable":"1"}]}');
                    //           }
                    //         });
                    //       },
                    //       icon: Icon(
                    //         data_2g.wiFiSsidTable![2].enable == '1'
                    //             ? Icons.check_box
                    //             : Icons.check_box_outline_blank,
                    //         color: Colors.blue,
                    //         size: 50.w,
                    //       ),
                    //     ),
                    //     callBack: () {
                    //       if (data_2g.wiFiSsidTable![2].enable == '1') {
                    //         Get.toNamed("/visitor_two");
                    //       } else {
                    //         ToastUtils.toast(S.of(context).notEnable);
                    //       }
                    //     }),
                    // CommonWidget.simpleWidgetWithMine(
                    //     title: '${guest24Model!.data![3].ssid}',
                    //     icon: IconButton(
                    //       onPressed: () {
                    //         setState(() {
                    //           if (data_2g.wiFiSsidTable![3].enable == '1') {
                    //             data_2g.wiFiSsidTable![3].enable = '0';
                    //             //gusest3
                    //             guest24Model!.data![3].enable = "0";
                    //             var parameterNames = {
                    //               "method": "set",
                    //               "table": {
                    //                 "table": "WiFiSsidTable",
                    //                 "value": [
                    //                   {
                    //                     "id": guest24Model!.data![3].id,
                    //                     "Enable": guest24Model!.data![3].enable,
                    //                     "SsidHide":
                    //                         guest24Model!.data![3].ssidHide,
                    //                     "ApIsolate":
                    //                         guest24Model!.data![3].apIsolate,
                    //                     "ShowPasswd":
                    //                         guest24Model!.data![3].showPasswd,
                    //                     "Is4Guest":
                    //                         guest24Model!.data![3].is4Guest,
                    //                     "PasswordLength": guest24Model!
                    //                         .data![3].passwordLength,
                    //                     "PasswordIndex": guest24Model!
                    //                         .data![3].passwordIndex,
                    //                     "MaxClient":
                    //                         guest24Model!.data![3].maxClient,
                    //                     "Ssid": guest24Model!.data![3].ssid,
                    //                     "Key": guest24Model!.data![3].key,
                    //                     "Password1":
                    //                         guest24Model!.data![3].password1,
                    //                     "Password2":
                    //                         guest24Model!.data![3].password2,
                    //                     "Password3":
                    //                         guest24Model!.data![3].password3,
                    //                     "Password4":
                    //                         guest24Model!.data![3].password4,
                    //                     "Encryption":
                    //                         guest24Model!.data![3].encryption,
                    //                     "SsidMac":
                    //                         guest24Model!.data![3].ssidMac,
                    //                     "AllowAccessIntranet": guest24Model!
                    //                         .data![3].allowAccessIntranet,
                    //                     "wifiRadiusServerIP": guest24Model!
                    //                         .data![3].wifiRadiusServerIP,
                    //                     "wifiRadiusServerPort": guest24Model!
                    //                         .data![3].wifiRadiusServerPort,
                    //                     "wifiRadiusSharedKey": guest24Model!
                    //                         .data![3].wifiRadiusSharedKey
                    //                   }
                    //                 ]
                    //               }
                    //             };
                    //             setData(parameterNames);
                    //             // setData([
                    //             //   '${prefix}1.SSIDProfile.4.Enable',
                    //             //   false,
                    //             //   'xsd:boolean'
                    //             // ]);
                    //             // handleSave(
                    //             //     '{"table":"WiFiSsidTable","value":[{"id":3,"Enable":"0"}]}');
                    //           } else {
                    //             data_2g.wiFiSsidTable![3].enable = '1';
                    //             //启用
                    //             guest24Model!.data![3].enable = "1";
                    //             var parameterNames = {
                    //               "method": "set",
                    //               "table": {
                    //                 "table": "WiFiSsidTable",
                    //                 "value": [
                    //                   {
                    //                     "id": guest24Model!.data![3].id,
                    //                     "Enable": guest24Model!.data![3].enable,
                    //                     "SsidHide":
                    //                         guest24Model!.data![3].ssidHide,
                    //                     "ApIsolate":
                    //                         guest24Model!.data![3].apIsolate,
                    //                     "ShowPasswd":
                    //                         guest24Model!.data![3].showPasswd,
                    //                     "Is4Guest":
                    //                         guest24Model!.data![3].is4Guest,
                    //                     "PasswordLength": guest24Model!
                    //                         .data![3].passwordLength,
                    //                     "PasswordIndex": guest24Model!
                    //                         .data![3].passwordIndex,
                    //                     "MaxClient":
                    //                         guest24Model!.data![3].maxClient,
                    //                     "Ssid": guest24Model!.data![3].ssid,
                    //                     "Key": guest24Model!.data![3].key,
                    //                     "Password1":
                    //                         guest24Model!.data![3].password1,
                    //                     "Password2":
                    //                         guest24Model!.data![3].password2,
                    //                     "Password3":
                    //                         guest24Model!.data![3].password3,
                    //                     "Password4":
                    //                         guest24Model!.data![3].password4,
                    //                     "Encryption":
                    //                         guest24Model!.data![3].encryption,
                    //                     "SsidMac":
                    //                         guest24Model!.data![3].ssidMac,
                    //                     "AllowAccessIntranet": guest24Model!
                    //                         .data![3].allowAccessIntranet,
                    //                     "wifiRadiusServerIP": guest24Model!
                    //                         .data![3].wifiRadiusServerIP,
                    //                     "wifiRadiusServerPort": guest24Model!
                    //                         .data![3].wifiRadiusServerPort,
                    //                     "wifiRadiusSharedKey": guest24Model!
                    //                         .data![3].wifiRadiusSharedKey
                    //                   }
                    //                 ]
                    //               }
                    //             };
                    //             setData(parameterNames);

                    //             // setData([
                    //             //   '${prefix}1.SSIDProfile.4.Enable',
                    //             //   true,
                    //             //   'xsd:boolean'
                    //             // ]);
                    //             // handleSave(
                    //             //     '{"table":"WiFiSsidTable","value":[{"id":3,"Enable":"1"}]}');
                    //           }
                    //         });
                    //       },
                    //       icon: Icon(
                    //         data_2g.wiFiSsidTable![3].enable == '1'
                    //             ? Icons.check_box
                    //             : Icons.check_box_outline_blank,
                    //         color: Colors.blue,
                    //         size: 50.w,
                    //       ),
                    //     ),
                    //     callBack: () {
                    //       if (data_2g.wiFiSsidTable![3].enable == '1') {
                    //         Get.toNamed("/visitor_three");
                    //       } else {
                    //         ToastUtils.toast(S.of(context).notEnable);
                    //       }
                    //     }),
                    Padding(padding: EdgeInsets.only(top: 10.w)),
                    const TitleWidger(title: '5GHZ'),
                    //访客
                    InkWell(
                      onTap: () {
                        Get.toNamed("/visitor_four");
                      },
                      child: Container(
                        decoration: const BoxDecoration(color: Colors.white),
                        child: ListTile(
                          title: Text(
                            '${guest5gModel!.data![1].ssid}',
                            style: const TextStyle(fontSize: 14),
                            textScaler: TextScaler.noScaling,
                          ),
                          trailing: const Icon(Icons.chevron_right,
                              color: Colors.grey),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.toNamed("/visitor_five");
                      },
                      child: Container(
                        decoration: const BoxDecoration(color: Colors.white),
                        child: ListTile(
                          title: Text(
                            '${guest5gModel!.data![2].ssid}',
                            style: const TextStyle(fontSize: 14),
                            textScaler: TextScaler.noScaling,
                          ),
                          trailing: const Icon(Icons.chevron_right,
                              color: Colors.grey),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.toNamed("/visitor_six");
                      },
                      child: Container(
                        decoration: const BoxDecoration(color: Colors.white),
                        child: ListTile(
                          title: Text(
                            '${guest5gModel!.data![3].ssid}',
                            style: const TextStyle(fontSize: 14),
                            textScaler: TextScaler.noScaling,
                          ),
                          trailing: const Icon(Icons.chevron_right,
                              color: Colors.grey),
                        ),
                      ),
                    ),
                    // CommonWidget.simpleWidgetWithMine(
                    //     title: '${guest5gModel!.data![1].ssid}',
                    //     icon: IconButton(
                    //       onPressed: () {
                    //         setState(() {
                    //           if (data_5g.wiFi5GSsidTable![1].enable == '1') {
                    //             //5G guest1
                    //             guest5gModel!.data![1].enable = "0";
                    //             //guest1
                    //             var parameterNames = {
                    //               "method": "set",
                    //               "table": {
                    //                 "table": "WiFi5GSsidTable",
                    //                 "value": [
                    //                   {
                    //                     "id": guest5gModel!.data![1].id,
                    //                     "Enable": guest5gModel!.data![1].enable,
                    //                     "SsidHide":
                    //                         guest5gModel!.data![1].ssidHide,
                    //                     "ApIsolate":
                    //                         guest5gModel!.data![1].apIsolate,
                    //                     "ShowPasswd":
                    //                         guest5gModel!.data![1].showPasswd,
                    //                     "Is4Guest":
                    //                         guest5gModel!.data![1].is4Guest,
                    //                     "PasswordLength": guest5gModel!
                    //                         .data![1].passwordLength,
                    //                     "PasswordIndex": guest5gModel!
                    //                         .data![1].passwordIndex,
                    //                     "MaxClient":
                    //                         guest5gModel!.data![1].maxClient,
                    //                     "Ssid": guest5gModel!.data![1].ssid,
                    //                     "Key": guest5gModel!.data![1].key,
                    //                     "Password1":
                    //                         guest5gModel!.data![1].password1,
                    //                     "Password2":
                    //                         guest5gModel!.data![1].password2,
                    //                     "Password3":
                    //                         guest5gModel!.data![1].password3,
                    //                     "Password4":
                    //                         guest5gModel!.data![1].password4,
                    //                     "Encryption":
                    //                         guest5gModel!.data![1].encryption,
                    //                     "SsidMac":
                    //                         guest5gModel!.data![1].ssidMac,
                    //                     "AllowAccessIntranet": guest5gModel!
                    //                         .data![1].allowAccessIntranet,
                    //                     "wifiRadiusServerIP": guest5gModel!
                    //                         .data![1].wifiRadiusServerIP,
                    //                     "wifiRadiusServerPort": guest5gModel!
                    //                         .data![1].wifiRadiusServerPort,
                    //                     "wifiRadiusSharedKey": guest5gModel!
                    //                         .data![1].wifiRadiusSharedKey
                    //                   }
                    //                 ]
                    //               }
                    //             };
                    //             setData(parameterNames);

                    //             // setData([
                    //             //   '${prefix}2.SSIDProfile.2.Enable',
                    //             //   false,
                    //             //   'xsd:boolean'
                    //             // ]);
                    //             // handleSave(
                    //             //     '{"table":"WiFi5GSsidTable","value":[{"id":1,"Enable":"0"}]}');
                    //           } else {
                    //             //启用
                    //             data_5g.wiFi5GSsidTable![1].enable = '1';
                    //             guest5gModel!.data![1].enable = "1";
                    //             //guest1
                    //             var parameterNames = {
                    //               "method": "set",
                    //               "table": {
                    //                 "table": "WiFi5GSsidTable",
                    //                 "value": [
                    //                   {
                    //                     "id": guest5gModel!.data![1].id,
                    //                     "Enable": guest5gModel!.data![1].enable,
                    //                     "SsidHide":
                    //                         guest5gModel!.data![1].ssidHide,
                    //                     "ApIsolate":
                    //                         guest5gModel!.data![1].apIsolate,
                    //                     "ShowPasswd":
                    //                         guest5gModel!.data![1].showPasswd,
                    //                     "Is4Guest":
                    //                         guest5gModel!.data![1].is4Guest,
                    //                     "PasswordLength": guest5gModel!
                    //                         .data![1].passwordLength,
                    //                     "PasswordIndex": guest5gModel!
                    //                         .data![1].passwordIndex,
                    //                     "MaxClient":
                    //                         guest5gModel!.data![1].maxClient,
                    //                     "Ssid": guest5gModel!.data![1].ssid,
                    //                     "Key": guest5gModel!.data![1].key,
                    //                     "Password1":
                    //                         guest5gModel!.data![1].password1,
                    //                     "Password2":
                    //                         guest5gModel!.data![1].password2,
                    //                     "Password3":
                    //                         guest5gModel!.data![1].password3,
                    //                     "Password4":
                    //                         guest5gModel!.data![1].password4,
                    //                     "Encryption":
                    //                         guest5gModel!.data![1].encryption,
                    //                     "SsidMac":
                    //                         guest5gModel!.data![1].ssidMac,
                    //                     "AllowAccessIntranet": guest5gModel!
                    //                         .data![1].allowAccessIntranet,
                    //                     "wifiRadiusServerIP": guest5gModel!
                    //                         .data![1].wifiRadiusServerIP,
                    //                     "wifiRadiusServerPort": guest5gModel!
                    //                         .data![1].wifiRadiusServerPort,
                    //                     "wifiRadiusSharedKey": guest5gModel!
                    //                         .data![1].wifiRadiusSharedKey
                    //                   }
                    //                 ]
                    //               }
                    //             };
                    //             setData(parameterNames);
                    //             // setData([
                    //             //   '${prefix}2.SSIDProfile.2.Enable',
                    //             //   true,
                    //             //   'xsd:boolean'
                    //             // ]);
                    //             // handleSave(
                    //             //     '{"table":"WiFi5GSsidTable","value":[{"id":1,"Enable":"1"}]}');
                    //           }
                    //         });
                    //       },
                    //       icon: Icon(
                    //         data_5g.wiFi5GSsidTable![1].enable == '1'
                    //             ? Icons.check_box
                    //             : Icons.check_box_outline_blank,
                    //         color: Colors.blue,
                    //         size: 50.w,
                    //       ),
                    //     ),
                    //     callBack: () {
                    //       if (data_5g.wiFi5GSsidTable![1].enable == '1') {
                    //         Get.toNamed("/visitor_four");
                    //       } else {
                    //         ToastUtils.toast(S.of(context).notEnable);
                    //       }
                    //     }),
                    // CommonWidget.simpleWidgetWithMine(
                    //     title: '${guest5gModel!.data![2].ssid}',
                    //     icon: IconButton(
                    //       onPressed: () {
                    //         setState(() {
                    //           if (data_5g.wiFi5GSsidTable![2].enable == '1') {
                    //             //5G guest2
                    //             data_5g.wiFi5GSsidTable![2].enable = '0';
                    //             guest5gModel!.data![2].enable = "0";
                    //             //guest1
                    //             var parameterNames = {
                    //               "method": "set",
                    //               "table": {
                    //                 "table": "WiFi5GSsidTable",
                    //                 "value": [
                    //                   {
                    //                     "id": guest5gModel!.data![2].id,
                    //                     "Enable": guest5gModel!.data![2].enable,
                    //                     "SsidHide":
                    //                         guest5gModel!.data![2].ssidHide,
                    //                     "ApIsolate":
                    //                         guest5gModel!.data![2].apIsolate,
                    //                     "ShowPasswd":
                    //                         guest5gModel!.data![2].showPasswd,
                    //                     "Is4Guest":
                    //                         guest5gModel!.data![2].is4Guest,
                    //                     "PasswordLength": guest5gModel!
                    //                         .data![2].passwordLength,
                    //                     "PasswordIndex": guest5gModel!
                    //                         .data![2].passwordIndex,
                    //                     "MaxClient":
                    //                         guest5gModel!.data![2].maxClient,
                    //                     "Ssid": guest5gModel!.data![2].ssid,
                    //                     "Key": guest5gModel!.data![2].key,
                    //                     "Password1":
                    //                         guest5gModel!.data![2].password1,
                    //                     "Password2":
                    //                         guest5gModel!.data![2].password2,
                    //                     "Password3":
                    //                         guest5gModel!.data![2].password3,
                    //                     "Password4":
                    //                         guest5gModel!.data![2].password4,
                    //                     "Encryption":
                    //                         guest5gModel!.data![2].encryption,
                    //                     "SsidMac":
                    //                         guest5gModel!.data![2].ssidMac,
                    //                     "AllowAccessIntranet": guest5gModel!
                    //                         .data![2].allowAccessIntranet,
                    //                     "wifiRadiusServerIP": guest5gModel!
                    //                         .data![2].wifiRadiusServerIP,
                    //                     "wifiRadiusServerPort": guest5gModel!
                    //                         .data![2].wifiRadiusServerPort,
                    //                     "wifiRadiusSharedKey": guest5gModel!
                    //                         .data![2].wifiRadiusSharedKey
                    //                   }
                    //                 ]
                    //               }
                    //             };
                    //             setData(parameterNames);

                    //             // setData([
                    //             //   '${prefix}2.SSIDProfile.3.Enable',
                    //             //   false,
                    //             //   'xsd:boolean'
                    //             // ]);
                    //             // handleSave(
                    //             //     '{"table":"WiFi5GSsidTable","value":[{"id":2,"Enable":"0"}]}');
                    //           } else {
                    //             //启用
                    //             data_5g.wiFi5GSsidTable![2].enable = '1';
                    //             guest5gModel!.data![2].enable = "1";
                    //             //guest1
                    //             var parameterNames = {
                    //               "method": "set",
                    //               "table": {
                    //                 "table": "WiFi5GSsidTable",
                    //                 "value": [
                    //                   {
                    //                     "id": guest5gModel!.data![2].id,
                    //                     "Enable": guest5gModel!.data![2].enable,
                    //                     "SsidHide":
                    //                         guest5gModel!.data![2].ssidHide,
                    //                     "ApIsolate":
                    //                         guest5gModel!.data![2].apIsolate,
                    //                     "ShowPasswd":
                    //                         guest5gModel!.data![2].showPasswd,
                    //                     "Is4Guest":
                    //                         guest5gModel!.data![2].is4Guest,
                    //                     "PasswordLength": guest5gModel!
                    //                         .data![2].passwordLength,
                    //                     "PasswordIndex": guest5gModel!
                    //                         .data![2].passwordIndex,
                    //                     "MaxClient":
                    //                         guest5gModel!.data![2].maxClient,
                    //                     "Ssid": guest5gModel!.data![2].ssid,
                    //                     "Key": guest5gModel!.data![2].key,
                    //                     "Password1":
                    //                         guest5gModel!.data![2].password1,
                    //                     "Password2":
                    //                         guest5gModel!.data![2].password2,
                    //                     "Password3":
                    //                         guest5gModel!.data![2].password3,
                    //                     "Password4":
                    //                         guest5gModel!.data![2].password4,
                    //                     "Encryption":
                    //                         guest5gModel!.data![2].encryption,
                    //                     "SsidMac":
                    //                         guest5gModel!.data![2].ssidMac,
                    //                     "AllowAccessIntranet": guest5gModel!
                    //                         .data![2].allowAccessIntranet,
                    //                     "wifiRadiusServerIP": guest5gModel!
                    //                         .data![2].wifiRadiusServerIP,
                    //                     "wifiRadiusServerPort": guest5gModel!
                    //                         .data![2].wifiRadiusServerPort,
                    //                     "wifiRadiusSharedKey": guest5gModel!
                    //                         .data![2].wifiRadiusSharedKey
                    //                   }
                    //                 ]
                    //               }
                    //             };
                    //             setData(parameterNames);

                    //             // setData([
                    //             //   '${prefix}2.SSIDProfile.3.Enable',
                    //             //   true,
                    //             //   'xsd:boolean'
                    //             // ]);
                    //             // handleSave(
                    //             //     '{"table":"WiFi5GSsidTable","value":[{"id":2,"Enable":"1"}]}');
                    //           }
                    //         });
                    //       },
                    //       icon: Icon(
                    //         data_5g.wiFi5GSsidTable![2].enable == '1'
                    //             ? Icons.check_box
                    //             : Icons.check_box_outline_blank,
                    //         color: Colors.blue,
                    //         size: 50.w,
                    //       ),
                    //     ),
                    //     callBack: () {
                    //       if (data_5g.wiFi5GSsidTable![2].enable == '1') {
                    //         Get.toNamed("/visitor_five");
                    //       } else {
                    //         ToastUtils.toast(S.of(context).notEnable);
                    //       }
                    //     }),
                    // CommonWidget.simpleWidgetWithMine(
                    //     title: '${guest5gModel!.data![3].ssid}',
                    //     icon: IconButton(
                    //       onPressed: () {
                    //         setState(() {
                    //           if (data_5g.wiFi5GSsidTable![3].enable == '1') {
                    //             //5G guest3
                    //             data_5g.wiFi5GSsidTable![3].enable = '0';
                    //             guest5gModel!.data![3].enable = "0";
                    //             //guest1
                    //             var parameterNames = {
                    //               "method": "set",
                    //               "table": {
                    //                 "table": "WiFi5GSsidTable",
                    //                 "value": [
                    //                   {
                    //                     "id": guest5gModel!.data![3].id,
                    //                     "Enable": guest5gModel!.data![3].enable,
                    //                     "SsidHide":
                    //                         guest5gModel!.data![3].ssidHide,
                    //                     "ApIsolate":
                    //                         guest5gModel!.data![3].apIsolate,
                    //                     "ShowPasswd":
                    //                         guest5gModel!.data![3].showPasswd,
                    //                     "Is4Guest":
                    //                         guest5gModel!.data![3].is4Guest,
                    //                     "PasswordLength": guest5gModel!
                    //                         .data![3].passwordLength,
                    //                     "PasswordIndex": guest5gModel!
                    //                         .data![3].passwordIndex,
                    //                     "MaxClient":
                    //                         guest5gModel!.data![3].maxClient,
                    //                     "Ssid": guest5gModel!.data![3].ssid,
                    //                     "Key": guest5gModel!.data![3].key,
                    //                     "Password1":
                    //                         guest5gModel!.data![3].password1,
                    //                     "Password2":
                    //                         guest5gModel!.data![3].password2,
                    //                     "Password3":
                    //                         guest5gModel!.data![3].password3,
                    //                     "Password4":
                    //                         guest5gModel!.data![3].password4,
                    //                     "Encryption":
                    //                         guest5gModel!.data![3].encryption,
                    //                     "SsidMac":
                    //                         guest5gModel!.data![3].ssidMac,
                    //                     "AllowAccessIntranet": guest5gModel!
                    //                         .data![3].allowAccessIntranet,
                    //                     "wifiRadiusServerIP": guest5gModel!
                    //                         .data![3].wifiRadiusServerIP,
                    //                     "wifiRadiusServerPort": guest5gModel!
                    //                         .data![3].wifiRadiusServerPort,
                    //                     "wifiRadiusSharedKey": guest5gModel!
                    //                         .data![3].wifiRadiusSharedKey
                    //                   }
                    //                 ]
                    //               }
                    //             };
                    //             setData(parameterNames);

                    //             // setData([
                    //             //   '${prefix}2.SSIDProfile.4.Enable',
                    //             //   false,
                    //             //   'xsd:boolean'
                    //             // ]);
                    //             // handleSave(
                    //             //     '{"table":"WiFi5GSsidTable","value":[{"id":3,"Enable":"0"}]}');
                    //           } else {
                    //             //启用
                    //             data_5g.wiFi5GSsidTable![3].enable = '1';
                    //             guest5gModel!.data![3].enable = "1";
                    //             //guest1
                    //             var parameterNames = {
                    //               "method": "set",
                    //               "table": {
                    //                 "table": "WiFi5GSsidTable",
                    //                 "value": [
                    //                   {
                    //                     "id": guest5gModel!.data![3].id,
                    //                     "Enable": guest5gModel!.data![3].enable,
                    //                     "SsidHide":
                    //                         guest5gModel!.data![3].ssidHide,
                    //                     "ApIsolate":
                    //                         guest5gModel!.data![3].apIsolate,
                    //                     "ShowPasswd":
                    //                         guest5gModel!.data![3].showPasswd,
                    //                     "Is4Guest":
                    //                         guest5gModel!.data![3].is4Guest,
                    //                     "PasswordLength": guest5gModel!
                    //                         .data![3].passwordLength,
                    //                     "PasswordIndex": guest5gModel!
                    //                         .data![3].passwordIndex,
                    //                     "MaxClient":
                    //                         guest5gModel!.data![3].maxClient,
                    //                     "Ssid": guest5gModel!.data![3].ssid,
                    //                     "Key": guest5gModel!.data![3].key,
                    //                     "Password1":
                    //                         guest5gModel!.data![3].password1,
                    //                     "Password2":
                    //                         guest5gModel!.data![3].password2,
                    //                     "Password3":
                    //                         guest5gModel!.data![3].password3,
                    //                     "Password4":
                    //                         guest5gModel!.data![3].password4,
                    //                     "Encryption":
                    //                         guest5gModel!.data![3].encryption,
                    //                     "SsidMac":
                    //                         guest5gModel!.data![3].ssidMac,
                    //                     "AllowAccessIntranet": guest5gModel!
                    //                         .data![3].allowAccessIntranet,
                    //                     "wifiRadiusServerIP": guest5gModel!
                    //                         .data![3].wifiRadiusServerIP,
                    //                     "wifiRadiusServerPort": guest5gModel!
                    //                         .data![3].wifiRadiusServerPort,
                    //                     "wifiRadiusSharedKey": guest5gModel!
                    //                         .data![3].wifiRadiusSharedKey
                    //                   }
                    //                 ]
                    //               }
                    //             };
                    //             setData(parameterNames);
                    //             // setData([
                    //             //   '${prefix}2.SSIDProfile.4.Enable',
                    //             //   true,
                    //             //   'xsd:boolean'
                    //             // ]);
                    //             // handleSave(
                    //             //     '{"table":"WiFi5GSsidTable","value":[{"id":3,"Enable":"1"}]}');
                    //           }
                    //         });
                    //       },
                    //       icon: Icon(
                    //         data_5g.wiFi5GSsidTable![3].enable == '1'
                    //             ? Icons.check_box
                    //             : Icons.check_box_outline_blank,
                    //         color: Colors.blue,
                    //         size: 50.w,
                    //       ),
                    //     ),
                    //     callBack: () {
                    //       if (data_5g.wiFi5GSsidTable![3].enable == '1') {
                    //         Get.toNamed("/visitor_six");
                    //       } else {
                    //         ToastUtils.toast(S.of(context).notEnable);
                    //       }
                    //     }),
                  ],
                ),
              ),
            ),
    );
  }
}
