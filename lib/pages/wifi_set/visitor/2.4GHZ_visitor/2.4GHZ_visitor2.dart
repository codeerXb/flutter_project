import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:flutter_template/core/widget/custom_app_bar.dart';
import 'package:flutter_template/pages/wifi_set/visitor/2.4GHZ_visitor/2.4GHZ_datas.dart';

/// 4G访客2
class Visitor2 extends StatefulWidget {
  const Visitor2({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Visitor2State();
}

class _Visitor2State extends State<Visitor2> {
  vis2gDatas data_2g = vis2gDatas();
  WiFiSsidTable currentData = WiFiSsidTable(
    ssid:'',
  );
  @override
  void initState() {
    super.initState();
    get2GData();
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
        data_2g = vis2gDatas.fromJson(d);
        currentData = data_2g.wiFiSsidTable![2];
      });
    } catch (e) {
      debugPrint('获取2.4GHZ失败:$e.toString()');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(context: context, title: 'guest2'),
        body: Container(
          padding: EdgeInsets.all(20.0.w),
          decoration:
              const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
          height: 1000,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InfoBox(
                    boxCotainer: Column(
                  children: [
                    //访客网络索引
                    BottomLine(
                        rowtem: RowContainer(
                      leftText: '访客网络索引',
                      righText: currentData.ssid.toString(),
                    )),
                   //是否允许访问内网 allowAccessIntranet=='0'不启用
                    BottomLine(
                        rowtem: RowContainer(
                      leftText: '是否允许访问内网',
                      righText: currentData.allowAccessIntranet.toString()=='0'?'不启用':'启用',
                    )),
                    //SSID
                    BottomLine(
                        rowtem: RowContainer(
                      leftText: 'SSID',
                      righText: currentData.ssid.toString(),
                    )),
                    //最大设备数
                    BottomLine(
                        rowtem: RowContainer(
                      leftText: '最大设备数',
                      righText: currentData.maxClient.toString(),
                    )),
                    //隐藏SSID网络
                    BottomLine(
                        rowtem: RowContainer(
                      leftText: '隐藏SSID网络',
                      righText: '不启用',
                    )),
                     //AP隔离 ApIsolate=='0' 不启用
                    BottomLine(
                        rowtem: RowContainer(
                      leftText: 'AP隔离',
                      righText: currentData.apIsolate.toString()=='0'?'不启用':'启用',
                    )),
                    //安全
                    BottomLine(
                        rowtem: RowContainer(
                      leftText: '安全',
                      righText: 'WPA-psk&WPA2-PS',
                    )),
                    //WPA加密
                    BottomLine(
                        rowtem: RowContainer(
                      leftText: 'WPA加密',
                      righText: 'AES(推荐使用)',
                    )),
                    //密码
                    BottomLine(
                        rowtem: RowContainer(
                      leftText: '密码',
                      righText: currentData.key.toString(),
                    )),
                  ],
                )),
              ],
            ),
          ),
        ));
  }
}
