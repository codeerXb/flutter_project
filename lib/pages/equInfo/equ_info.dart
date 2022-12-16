import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:flutter_template/pages/equInfo/equinfo_datas.dart';
import '../../core/widget/custom_app_bar.dart';

/// 设备信息
class EquInfo extends StatefulWidget {
  const EquInfo({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EquInfoState();
}

class _EquInfoState extends State<EquInfo> {
  EquinfoDatas equinfoData = EquinfoDatas();
  @override
  void initState() {
    super.initState();
    getEquinfoDatas();
  }

  void getEquinfoDatas() {
    Map<String, dynamic> data = {
      'method': 'obj_get',
      'param':
          '["systemProductModel","systemVersionHw","systemVersionRunning","systemVersionUboot","systemVersionSn","lteImei","lteImsi","networkLanSettingsMac","networkLanSettingIp","networkLanSettingMask","systemRunningTime"]',
    };
    XHttp.get('', data).then((res) {
      try {
        var d = json.decode(res.toString());
        setState(() {
          equinfoData = EquinfoDatas.fromJson(d);
          print(equinfoData.lteImei);
        });
      } on FormatException catch (e) {
        print(e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(context: context, title: '设备信息'),
        body: Container(
          padding: const EdgeInsets.all(10.0),
          decoration:
              const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
          height: 1000,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //1系统信息
                const TitleWidger(title: '系统信息'),
                const InfoBox(
                  boxCotainer: RowContainer(
                    leftText: '运行时长',
                    righText: '05d 20h 01m',
                  ),
                ),

                //2版本信息
                const TitleWidger(title: '版本信息'),
                InfoBox(
                  boxCotainer: Column(
                    children: const [
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: '产品型号',
                        righText: 'SRS621-a',
                      )),
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: '硬件版本',
                        righText: 'V1.0',
                      )),
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: '软件版本',
                        righText: 'SQXR60_V1.0.2',
                      )),
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: 'UBOOT版本',
                        righText: 'V1.1.0',
                      )),
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: '产品序列号',
                        righText: 'RS621A00211700113',
                      )),
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: 'IMEI',
                        righText: '862165040976175',
                      )),
                      RowContainer(
                        leftText: 'IMSI',
                        righText: '— —',
                      )
                    ],
                  ),
                ),

                //3.0LAN口状态
                TitleWidger(title: 'LAN口状态'),
                InfoBox(
                  boxCotainer: Column(
                    children: const [
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: 'MAC地址',
                        righText: '88:12:3D:03:6F:66',
                      )),
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: 'IP地址',
                        righText: '192.168.1.1',
                      )),
                      RowContainer(
                        leftText: '子网掩码',
                        righText: '255.255.255.06',
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
