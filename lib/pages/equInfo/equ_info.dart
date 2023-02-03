import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:flutter_template/pages/equInfo/equinfo_datas.dart';
import 'package:intl/intl.dart';
import '../../core/widget/custom_app_bar.dart';

/// 设备信息
class EquInfo extends StatefulWidget {
  const EquInfo({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EquInfoState();
}

class _EquInfoState extends State<EquInfo> {
  EquinfoDatas equinfoData = EquinfoDatas(
    systemProductModel: '',
    systemVersionHw: '',
    systemVersionRunning: '',
    systemVersionUboot: '',
    systemVersionSn: '',
    lteImei: '',
    lteImsi: '',
    networkLanSettingsMac: '',
    networkLanSettingIp: '',
    networkLanSettingMask: '',
    systemRunningTime: '',
  );
  @override
  void initState() {
    super.initState();
    getEquinfoDatas();
  }

  void getEquinfoDatas() async {
    Map<String, dynamic> data = {
      'method': 'obj_get',
      'param':
          '["systemProductModel","systemVersionHw","systemVersionRunning","systemVersionUboot","systemVersionSn","lteImei","lteImsi","networkLanSettingsMac","networkLanSettingIp","networkLanSettingMask","systemRunningTime"]',
    };
    try {
      var response = await XHttp.get('/data.html', data);
      var d = json.decode(response.toString());
      setState(() {
        equinfoData = EquinfoDatas.fromJson(d);
      });
    } catch (e) {
      debugPrint('获取设备信息失败：$e.toString()');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(context: context, title: '设备信息'),
        body: Container(
          decoration:
              const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
          height: 2000.w,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //1系统信息
                const TitleWidger(title: '系统信息'),
                InfoBox(
                  boxCotainer: RowContainer(
                    leftText: '运行时长',
                    righText: DateFormat("dd天HH小时mm分钟").format(
                        DateTime.fromMillisecondsSinceEpoch(int.parse(
                                equinfoData.systemRunningTime.toString() +
                                    '000') -
                            86400000)),
                  ),
                ),
                //2版本信息
                const TitleWidger(title: '版本信息'),
                InfoBox(
                  boxCotainer: Column(
                    children: [
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: '产品型号',
                        righText: equinfoData.systemProductModel.toString(),
                      )),
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: '硬件版本',
                        righText: equinfoData.systemVersionHw.toString(),
                      )),
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: '软件版本',
                        righText: equinfoData.systemVersionRunning.toString(),
                      )),
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: 'UBOOT版本',
                        righText: equinfoData.systemVersionUboot.toString(),
                      )),
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: '产品序列号',
                        righText: equinfoData.systemVersionSn.toString(),
                      )),
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: 'IMEI',
                        righText: equinfoData.lteImei.toString(),
                      )),
                      Container(
                        padding: EdgeInsets.only(top: 20.w),
                        child: RowContainer(
                          leftText: 'IMSI',
                          righText: equinfoData.lteImsi == null
                              ? equinfoData.lteImsi.toString()
                              : '- -',
                        ),
                      )
                    ],
                  ),
                ),

                //3.0LAN口状态
                const TitleWidger(title: 'LAN口状态'),
                InfoBox(
                  boxCotainer: Column(
                    children: [
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: 'MAC地址',
                        righText: equinfoData.networkLanSettingsMac.toString(),
                      )),
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: 'IP地址',
                        righText: equinfoData.networkLanSettingIp.toString(),
                      )),
                      Container(
                        padding: EdgeInsets.only(top: 20.w),
                        child: RowContainer(
                          leftText: '子网掩码',
                          righText:
                              equinfoData.networkLanSettingMask.toString(),
                        ),
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
