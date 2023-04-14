import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/request/request.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:flutter_template/pages/equInfo/equinfo_datas.dart';
import 'package:flutter_template/pages/login/login_controller.dart';
import 'package:get/get.dart';
import '../../core/widget/custom_app_bar.dart';
import '../../generated/l10n.dart';

/// 设备信息
class EquInfo extends StatefulWidget {
  const EquInfo({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EquInfoState();
}

class _EquInfoState extends State<EquInfo> {
  final LoginController loginController = Get.put(LoginController());

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
  int day = 0;
  int hour = 0;
  int min = 0;
  String sn = '';
  String state = '';
  String ipAddressValue = '';
  String macAddressValue = '';
  String subnetMaskValue = '';
  String imeiValue = '';
  String runtimeValue = '';
  String hardVersionValue = '';
  String productModelValue = '';
  String serialNumberValue = '';
  String softwareVersionValue = '';
  String ubootVersionValue = '';

  @override
  void initState() {
    super.initState();
    sharedGetData('deviceSn', String).then(((res) {
      printInfo(info: 'deviceSn$res');
      setState(() {
        sn = res.toString();
        //状态为local 请求本地  状态为cloud  请求云端
        if (loginController.login.state == 'cloud' && sn.isNotEmpty) {
          getTREquinfoDatas();
        }
        if (loginController.login.state == 'local') {
          getEquinfoDatas();
        }
      });
    }));
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
        var time = int.parse(equinfoData.systemRunningTime.toString());
        day = time ~/ (24 * 3600);
        hour = (time - day * 24 * 3600) ~/ 3600;
        min = (time - day * 24 * 3600 - hour * 3600) ~/ 60;
      });
    } catch (e) {
      debugPrint('获取设备信息失败：$e.toString()');
    }
  }

// 云端
  getTREquinfoDatas() async {
    printInfo(info: 'sn在这里有值吗-------$sn');
    var parameterNames = [
      "InternetGatewayDevice.WEB_GUI.Overview.VersionInfo.ProductModel",
      "InternetGatewayDevice.WEB_GUI.Overview.VersionInfo.HardVersion",
      "InternetGatewayDevice.WEB_GUI.Overview.VersionInfo.SoftwareVersion",
      "InternetGatewayDevice.WEB_GUI.Overview.VersionInfo.UBOOTVersion",
      "InternetGatewayDevice.WEB_GUI.Overview.VersionInfo.SerialNumber",
      "InternetGatewayDevice.WEB_GUI.Overview.ModuleInfo.IMEI",
      "InternetGatewayDevice.WEB_GUI.Overview.ModuleInfo.IMSI",
      "InternetGatewayDevice.WEB_GUI.Overview.LANStatus.MACAddress",
      "InternetGatewayDevice.WEB_GUI.Overview.LANStatus.IPAddress",
      "InternetGatewayDevice.WEB_GUI.Overview.LANStatus.SubnetMask",
      "InternetGatewayDevice.WEB_GUI.Overview.SystemInfo.RunTime"
    ];
    var res = await Request().setTRUsedFlow(parameterNames, sn);
    try {
      Map<String, dynamic> d = jsonDecode(res);
      setState(() {
        ipAddressValue = d['data']['InternetGatewayDevice']['WEB_GUI']
            ['Overview']['LANStatus']['IPAddress']['_value'];
        macAddressValue = d["data"]["InternetGatewayDevice"]["WEB_GUI"]
            ["Overview"]["LANStatus"]["MACAddress"]["_value"];
        subnetMaskValue = d["data"]["InternetGatewayDevice"]["WEB_GUI"]
            ["Overview"]["LANStatus"]["SubnetMask"]["_value"];
        imeiValue = d["data"]["InternetGatewayDevice"]["WEB_GUI"]["Overview"]
            ["ModuleInfo"]["IMEI"]["_value"];
        runtimeValue = d["data"]["InternetGatewayDevice"]["WEB_GUI"]["Overview"]
            ["SystemInfo"]["RunTime"]["_value"];
        var time = int.parse(runtimeValue.toString());
        day = time ~/ (24 * 3600);
        hour = (time - day * 24 * 3600) ~/ 3600;
        min = (time - day * 24 * 3600 - hour * 3600) ~/ 60;
        hardVersionValue = d["data"]["InternetGatewayDevice"]["WEB_GUI"]
            ["Overview"]["VersionInfo"]["HardVersion"]["_value"];
        productModelValue = d["data"]["InternetGatewayDevice"]["WEB_GUI"]
            ["Overview"]["VersionInfo"]["ProductModel"]["_value"];
        serialNumberValue = d["data"]["InternetGatewayDevice"]["WEB_GUI"]
            ["Overview"]["VersionInfo"]["SerialNumber"]["_value"];
        softwareVersionValue = d["data"]["InternetGatewayDevice"]["WEB_GUI"]
            ["Overview"]["VersionInfo"]["SoftwareVersion"]["_value"];
        ubootVersionValue = d["data"]["InternetGatewayDevice"]["WEB_GUI"]
            ["Overview"]["VersionInfo"]["UBOOTVersion"]["_value"];
      });
    } catch (e) {
      debugPrint('获取设备信息失败：${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(context: context, title: S.of(context).deviceInfo),
        body: Container(
          decoration:
              const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
          height: 1400.w,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //1系统信息
                TitleWidger(title: S.of(context).systemInfo),
                InfoBox(
                  boxCotainer: RowContainer(
                    leftText: S.of(context).RunningTime,
                    righText: day.toString() +
                        S.of(context).date +
                        hour.toString() +
                        S.of(context).hour +
                        min.toString() +
                        S.of(context).minute,
                  ),
                ),
                //2版本信息
                TitleWidger(title: S.of(context).versionInfo),
                InfoBox(
                  boxCotainer: Column(
                    children: [
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: S.of(context).ProductModel,
                        righText: productModelValue.isNotEmpty
                            ? productModelValue
                            : equinfoData.systemProductModel.toString(),
                      )),
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: S.of(context).HardwareVersion,
                        righText: hardVersionValue.isNotEmpty
                            ? hardVersionValue
                            : equinfoData.systemVersionHw.toString(),
                      )),
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: S.of(context).SoftwareVersion,
                        righText: softwareVersionValue.isNotEmpty
                            ? softwareVersionValue
                            : equinfoData.systemVersionRunning.toString(),
                      )),
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: S.of(context).UBOOTVersion,
                        righText: ubootVersionValue.isNotEmpty
                            ? ubootVersionValue
                            : equinfoData.systemVersionUboot.toString(),
                      )),
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: S.of(context).SerialNumber,
                        righText: serialNumberValue.isNotEmpty
                            ? serialNumberValue
                            : equinfoData.systemVersionSn.toString(),
                      )),
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: 'IMEI',
                        righText: imeiValue.isNotEmpty
                            ? imeiValue
                            : equinfoData.lteImei.toString(),
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
                TitleWidger(title: S.of(context).lanStatus),
                InfoBox(
                  boxCotainer: Column(
                    children: [
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: S.of(context).MACAddress,
                        righText: macAddressValue.isNotEmpty
                            ? macAddressValue
                            : equinfoData.networkLanSettingsMac.toString(),
                      )),
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: S.of(context).IPAddress,
                        righText: ipAddressValue.isNotEmpty
                            ? ipAddressValue
                            : equinfoData.networkLanSettingIp.toString(),
                      )),
                      Container(
                        padding: EdgeInsets.only(top: 20.w),
                        child: RowContainer(
                          leftText: S.of(context).SubnetMask,
                          righText: subnetMaskValue.isNotEmpty
                              ? subnetMaskValue
                              : equinfoData.networkLanSettingMask.toString(),
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
