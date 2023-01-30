import 'dart:convert';

import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:flutter_template/core/widget/common_widget.dart';
import 'package:flutter_template/pages/wifi_set/visitor/2.4GHZ_visitor/2.4GHZ_datas.dart';
import 'package:flutter_template/pages/wifi_set/visitor/5G_visitor/5GHZ_datas.dart';
import 'package:get/get.dart';
import '../../../core/widget/custom_app_bar.dart';

/// 访客网络
class VisitorNet extends StatefulWidget {
  const VisitorNet({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _VisitorNetState();
}

class _VisitorNetState extends State<VisitorNet> {
  //2.4GHZ
  vis2gDatas data_2g = vis2gDatas(wiFiSsidTable: [
    WiFiSsidTable(
      enable: "1",
    ),
    WiFiSsidTable(
      enable: "1",
    ),
    WiFiSsidTable(
      enable: "1",
    ),
    WiFiSsidTable(
      enable: "1",
    )
  ]);
  //5GHZ
  vis5gDatas data_5g = vis5gDatas(wiFi5GSsidTable: [
    WiFiSsidTable(
      enable: "1",
    ),
    WiFiSsidTable(
      enable: "1",
    ),
    WiFiSsidTable(
      enable: "1",
    ),
    WiFiSsidTable(
      enable: "1",
    )
  ]);
  @override
  void initState() {
    super.initState();
    get2GData();
    get5GData();
  }

  //读取2.4GHZ
  void get2GData() async {
    Map<String, dynamic> data = {
      'method': 'tab_dump',
      'param': '["WiFiSsidTable"]',
    };
    try {
      var response = await XHttp.get('/data.html', data);
      var d = json.decode(response.toString());
      setState(() {
        data_2g = vis2gDatas.fromJson(d);
      });
    } catch (e) {
      debugPrint('获取2.4GHZ失败:$e.toString()');
    }
  }

  //读取5GHZ
  void get5GData() async {
    Map<String, dynamic> data = {
      'method': 'tab_dump',
      'param': '["WiFi5GSsidTable"]',
    };
    try {
      var response = await XHttp.get('/data.html', data);
      var d = json.decode(response.toString());
      setState(() {
        data_5g = vis5gDatas.fromJson(d);
      });
    } catch (e) {
      debugPrint('获取5GHZ失败:$e.toString()');
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
        ToastUtils.toast('修改成功');
      } on FormatException catch (e) {
        print(e);
      }
    }).catchError((onError) {
      debugPrint('失败：${onError.toString()}');
      ToastUtils.toast('修改失败');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(context: context, title: '访客网络'),
        body: Container(
          padding: EdgeInsets.all(20.0.w),
          decoration:
              const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
          height: 1000,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                        size: 50.w,
                      ),
                    ),
                    callBack: () {
                      if (data_2g.wiFiSsidTable![1].enable == '1') {
                        Get.toNamed("/visitor_one");
                      } else {
                        ToastUtils.toast('未启用');
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
                        size: 50.w,
                      ),
                    ),
                    callBack: () {
                      if (data_2g.wiFiSsidTable![2].enable == '1') {
                        Get.toNamed("/visitor_two");
                      } else {
                        ToastUtils.toast('未启用');
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
                        size: 50.w,
                      ),
                    ),
                    callBack: () {
                      if (data_2g.wiFiSsidTable![3].enable == '1') {
                        Get.toNamed("/visitor_three");
                      } else {
                        ToastUtils.toast('未启用');
                      }
                    }),
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
                        size: 50.w,
                      ),
                    ),
                    callBack: () {
                      if (data_5g.wiFi5GSsidTable![1].enable == '1') {
                        Get.toNamed("/visitor_four");
                      } else {
                        ToastUtils.toast('未启用');
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
                            data_5g.wiFi5GSsidTable![1].enable = '1';
                          }
                        });
                      },
                      icon: Icon(
                        data_5g.wiFi5GSsidTable![2].enable == '1'
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        size: 50.w,
                      ),
                    ),
                    callBack: () {
                      if (data_5g.wiFi5GSsidTable![2].enable == '1') {
                        Get.toNamed("/visitor_five");
                      } else {
                        ToastUtils.toast('未启用');
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
                        size: 50.w,
                      ),
                    ),
                    callBack: () {
                      if (data_5g.wiFi5GSsidTable![3].enable == '1') {
                        Get.toNamed("/visitor_six");
                      } else {
                        ToastUtils.toast('未启用');
                      }
                    }),
              ],
            ),
          ),
        ));
  }
}
