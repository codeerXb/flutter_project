import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/request/request.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:flutter_template/core/widget/common_widget.dart';
import 'package:flutter_template/pages/wifi_set/visitor/2.4GHZ_visitor/2.4GHZ_datas.dart';
import 'package:flutter_template/pages/wifi_set/visitor/5G_visitor/5GHZ_datas.dart';
import 'package:get/get.dart';
import '../../../core/widget/custom_app_bar.dart';
import '../../../generated/l10n.dart';
import '../../login/login_controller.dart';

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

  // 云端获取数据
  Future getCloudData() async {
    if (sn == '') {
      var value = await sharedGetData('deviceSn', String);
      sn = value.toString();
    }
    try {
      List<String> parameterNames = [
        'InternetGatewayDevice.WEB_GUI.WiFi.WLANSettings',
      ];
      var res = await Request().getACSNode(parameterNames, sn);
      var prefix24g = jsonDecode(res)['data']['InternetGatewayDevice']
          ['WEB_GUI']['WiFi']['WLANSettings']['1']['SSIDProfile'];
      var prefix5g = jsonDecode(res)['data']['InternetGatewayDevice']['WEB_GUI']
          ['WiFi']['WLANSettings']['2']['SSIDProfile'];
      setState(() {
        data_2g.wiFiSsidTable![0].enable =
            prefix24g['1']['Enable']['_value'] ? '1' : '0';
        data_2g.wiFiSsidTable![1].enable =
            prefix24g['2']['Enable']['_value'] ? '1' : '0';
        data_2g.wiFiSsidTable![2].enable =
            prefix24g['3']['Enable']['_value'] ? '1' : '0';
        data_2g.wiFiSsidTable![3].enable =
            prefix24g['4']['Enable']['_value'] ? '1' : '0';

        data_5g.wiFi5GSsidTable![0].enable =
            prefix5g['1']['Enable']['_value'] ? '1' : '0';
        data_5g.wiFi5GSsidTable![1].enable =
            prefix5g['2']['Enable']['_value'] ? '1' : '0';
        data_5g.wiFi5GSsidTable![2].enable =
            prefix5g['3']['Enable']['_value'] ? '1' : '0';
        data_5g.wiFi5GSsidTable![3].enable =
            prefix5g['4']['Enable']['_value'] ? '1' : '0';
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
          ? const Center(child: CircularProgressIndicator())
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
                    CommonWidget.simpleWidgetWithMine(
                        title: 'guest1',
                        icon: IconButton(
                          onPressed: () {
                            setState(() {
                              if (data_2g.wiFiSsidTable![1].enable == '1') {
                                data_2g.wiFiSsidTable![1].enable = '0';
                                //移除
                                handleSave(
                                    '{"table":"WiFiSsidTable","value":[{"id":1,"Enable":"0"}]}');
                              } else {
                                data_2g.wiFiSsidTable![1].enable = '1';
                                //启用
                                handleSave(
                                    '{"table":"WiFiSsidTable","value":[{"id":1,"Enable":"1"}]}');
                              }
                            });
                          },
                          icon: Icon(
                            data_2g.wiFiSsidTable![1].enable == '1'
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: Colors.blue,
                            size: 50.w,
                          ),
                        ),
                        callBack: () {
                          if (data_2g.wiFiSsidTable![1].enable == '1') {
                            Get.toNamed("/visitor_one");
                          } else {
                            ToastUtils.toast(S.of(context).notEnable);
                          }
                        }),
                    CommonWidget.simpleWidgetWithMine(
                        title: 'guest2',
                        icon: IconButton(
                          onPressed: () {
                            setState(() {
                              if (data_2g.wiFiSsidTable![2].enable == '1') {
                                //移除
                                handleSave(
                                    '{"table":"WiFiSsidTable","value":[{"id":2,"Enable":"0"}]}');
                                data_2g.wiFiSsidTable![2].enable = '0';
                              } else {
                                //启用
                                handleSave(
                                    '{"table":"WiFiSsidTable","value":[{"id":2,"Enable":"1"}]}');
                                data_2g.wiFiSsidTable![2].enable = '1';
                              }
                            });
                          },
                          icon: Icon(
                            data_2g.wiFiSsidTable![2].enable == '1'
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: Colors.blue,
                            size: 50.w,
                          ),
                        ),
                        callBack: () {
                          if (data_2g.wiFiSsidTable![2].enable == '1') {
                            Get.toNamed("/visitor_two");
                          } else {
                            ToastUtils.toast(S.of(context).notEnable);
                          }
                        }),
                    CommonWidget.simpleWidgetWithMine(
                        title: 'guest3',
                        icon: IconButton(
                          onPressed: () {
                            setState(() {
                              if (data_2g.wiFiSsidTable![3].enable == '1') {
                                //移除
                                handleSave(
                                    '{"table":"WiFiSsidTable","value":[{"id":3,"Enable":"0"}]}');
                                data_2g.wiFiSsidTable![3].enable = '0';
                              } else {
                                //启用
                                handleSave(
                                    '{"table":"WiFiSsidTable","value":[{"id":3,"Enable":"1"}]}');
                                data_2g.wiFiSsidTable![3].enable = '1';
                              }
                            });
                          },
                          icon: Icon(
                            data_2g.wiFiSsidTable![3].enable == '1'
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: Colors.blue,
                            size: 50.w,
                          ),
                        ),
                        callBack: () {
                          if (data_2g.wiFiSsidTable![3].enable == '1') {
                            Get.toNamed("/visitor_three");
                          } else {
                            ToastUtils.toast(S.of(context).notEnable);
                          }
                        }),
                    Padding(padding: EdgeInsets.only(top: 10.w)),
                    const TitleWidger(title: '5GHZ'),
                    //访客
                    CommonWidget.simpleWidgetWithMine(
                        title: 'guest4',
                        icon: IconButton(
                          onPressed: () {
                            setState(() {
                              if (data_5g.wiFi5GSsidTable![1].enable == '1') {
                                //移除
                                handleSave(
                                    '{"table":"WiFi5GSsidTable","value":[{"id":1,"Enable":"0"}]}');
                                data_5g.wiFi5GSsidTable![1].enable = '0';
                              } else {
                                //启用
                                handleSave(
                                    '{"table":"WiFi5GSsidTable","value":[{"id":1,"Enable":"1"}]}');
                                data_5g.wiFi5GSsidTable![1].enable = '1';
                              }
                            });
                          },
                          icon: Icon(
                            data_5g.wiFi5GSsidTable![1].enable == '1'
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: Colors.blue,
                            size: 50.w,
                          ),
                        ),
                        callBack: () {
                          if (data_5g.wiFi5GSsidTable![1].enable == '1') {
                            Get.toNamed("/visitor_four");
                          } else {
                            ToastUtils.toast(S.of(context).notEnable);
                          }
                        }),
                    CommonWidget.simpleWidgetWithMine(
                        title: 'guest5',
                        icon: IconButton(
                          onPressed: () {
                            setState(() {
                              if (data_5g.wiFi5GSsidTable![2].enable == '1') {
                                //移除
                                handleSave(
                                    '{"table":"WiFi5GSsidTable","value":[{"id":2,"Enable":"0"}]}');
                                data_5g.wiFi5GSsidTable![2].enable = '0';
                              } else {
                                //启用
                                handleSave(
                                    '{"table":"WiFi5GSsidTable","value":[{"id":2,"Enable":"1"}]}');
                                data_5g.wiFi5GSsidTable![2].enable = '1';
                              }
                            });
                          },
                          icon: Icon(
                            data_5g.wiFi5GSsidTable![2].enable == '1'
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: Colors.blue,
                            size: 50.w,
                          ),
                        ),
                        callBack: () {
                          if (data_5g.wiFi5GSsidTable![2].enable == '1') {
                            Get.toNamed("/visitor_five");
                          } else {
                            ToastUtils.toast(S.of(context).notEnable);
                          }
                        }),
                    CommonWidget.simpleWidgetWithMine(
                        title: 'guest6',
                        icon: IconButton(
                          onPressed: () {
                            setState(() {
                              if (data_5g.wiFi5GSsidTable![3].enable == '1') {
                                //移除
                                handleSave(
                                    '{"table":"WiFi5GSsidTable","value":[{"id":3,"Enable":"0"}]}');
                                data_5g.wiFi5GSsidTable![3].enable = '0';
                              } else {
                                //启用
                                handleSave(
                                    '{"table":"WiFi5GSsidTable","value":[{"id":3,"Enable":"1"}]}');
                                data_5g.wiFi5GSsidTable![3].enable = '1';
                              }
                            });
                          },
                          icon: Icon(
                            data_5g.wiFi5GSsidTable![3].enable == '1'
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: Colors.blue,
                            size: 50.w,
                          ),
                        ),
                        callBack: () {
                          if (data_5g.wiFi5GSsidTable![3].enable == '1') {
                            Get.toNamed("/visitor_six");
                          } else {
                            ToastUtils.toast(S.of(context).notEnable);
                          }
                        }),
                  ],
                ),
              ),
            ),
    );
  }
}
