import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/request/request.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:flutter_template/pages/login/login_controller.dart';
import 'package:get/get.dart';
import '../../../core/widget/custom_app_bar.dart';
import '../../core/http/http.dart';
import '../../core/utils/toast.dart';
import '../../core/widget/common_box.dart';
import '../../core/widget/common_picker.dart';
import '../../generated/l10n.dart';
import 'model/radio_data.dart';

/// Radio设置
class RadioSettings extends StatefulWidget {
  const RadioSettings({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RadioSettingsState();
}

class _RadioSettingsState extends State<RadioSettings> {
  String showVal = '';
  String radioShowVal = '';
  int val = 0;
  String radioGTitle = '';

  RadioConcatenateData radioConcatenate = RadioConcatenateData();
  final LoginController loginController = Get.put(LoginController());
  RadioGData radioGState = RadioGData();
  String sn = '';
  // 定义页面转换变量
  String state = '';
  String gsc = '';
  String dlfre = '';
  String ulfre = '';
  String band = '';
  String bandwidth = '';
  String rsrp = '';
  String rssi = '';
  String rsrq = '';
  String sinr = '';
  String txP = '';
  String pci = '';
  String cellId = '';
  String mcc = '';
  String mnc = '';
  @override
  void initState() {
    super.initState();
    sharedGetData('deviceSn', String).then(((res) {
      printInfo(info: 'deviceSn$res');
      setState(() {
        sn = res.toString();
        //状态为local 请求本地  状态为cloud  请求云端
        printInfo(info: 'state--${loginController.login.state}');
        if (mounted) {
          if (loginController.login.state == 'cloud' && sn.isNotEmpty) {
            getTRRadioGData();
          }
          if (loginController.login.state == 'local') {
            getRadioGData();
          }
        }
      });
    }));
  }

  // 获取 云端
  getTRRadioGData() async {
    printInfo(info: 'sn在这里有值吗-------$sn');
    var parameterNames = [
      "InternetGatewayDevice.WEB_GUI.Network.NR-LTE.ConnectMethod",
      "InternetGatewayDevice.WEB_GUI.Network.NR-LTE.ConnectStatus",
      // 4G
      "InternetGatewayDevice.WEB_GUI.Network.NR-LTE.Status.LTE.EARFCN",
      "InternetGatewayDevice.WEB_GUI.Network.NR-LTE.Status.LTE.Bandwidth",
      "InternetGatewayDevice.WEB_GUI.Network.NR-LTE.Status.LTE.Band",
      "InternetGatewayDevice.WEB_GUI.Network.NR-LTE.Status.LTE.RSRP0",
      "InternetGatewayDevice.WEB_GUI.Network.NR-LTE.Status.LTE.RSRP1",
      "InternetGatewayDevice.WEB_GUI.Network.NR-LTE.Status.LTE.RSRQ",
      "InternetGatewayDevice.WEB_GUI.Network.NR-LTE.Status.LTE.SINR",
      "InternetGatewayDevice.WEB_GUI.Network.NR-LTE.Status.LTE.RSSI",
      "InternetGatewayDevice.WEB_GUI.Network.NR-LTE.Status.LTE.PCI",
      "InternetGatewayDevice.WEB_GUI.Network.NR-LTE.Status.LTE.CellID",
      "InternetGatewayDevice.WEB_GUI.Network.NR-LTE.Status.LTE.MCC",
      "InternetGatewayDevice.WEB_GUI.Network.NR-LTE.Status.LTE.MNC",
      "InternetGatewayDevice.WEB_GUI.Network.NR-LTE.Status.LTE.TXPower",
      "InternetGatewayDevice.WEB_GUI.Network.NR-LTE.Status.LTE.Frequency",
      // 5G
      "InternetGatewayDevice.WEB_GUI.Network.NR-LTE.Status.NR.NR_Bandwidth",
      "InternetGatewayDevice.WEB_GUI.Network.NR-LTE.Status.NR.NR_Band",
      "InternetGatewayDevice.WEB_GUI.Network.NR-LTE.Status.NR.SSB_RSRP0",
      "InternetGatewayDevice.WEB_GUI.Network.NR-LTE.Status.NR.SSB_RSRP1",
      "InternetGatewayDevice.WEB_GUI.Network.NR-LTE.Status.NR.SSB_RSRQ",
      "InternetGatewayDevice.WEB_GUI.Network.NR-LTE.Status.NR.SSB_SINR",
      "InternetGatewayDevice.WEB_GUI.Network.NR-LTE.Status.NR.SSB_RSSI",
      "InternetGatewayDevice.WEB_GUI.Network.NR-LTE.Status.NR.NR_PCI",
      "InternetGatewayDevice.WEB_GUI.Network.NR-LTE.Status.NR.NR_CellID",
      "InternetGatewayDevice.WEB_GUI.Network.NR-LTE.Status.NR.NR_MCC",
      "InternetGatewayDevice.WEB_GUI.Network.NR-LTE.Status.NR.NR_MNC",
      "InternetGatewayDevice.WEB_GUI.Network.NR-LTE.Status.NR.NR_TXPower",
      "InternetGatewayDevice.WEB_GUI.Network.NR-LTE.Status.NR.NR-ARFCN",
      "InternetGatewayDevice.WEB_GUI.Network.NR-LTE.Status.NR.NR_Frequency",
    ];
    var res = await Request().setTRUsedFlow(parameterNames, sn);
    try {
      var jsonObj = jsonDecode(res);
      setState(() {
        var radioState = jsonObj["data"]["InternetGatewayDevice"]["WEB_GUI"]
            ["Network"]["NR-LTE"];
        state = radioState["ConnectStatus"]["_value"];
        var radioState4 = radioState["Status"]["LTE"];
        var radioState5 = radioState["Status"]["NR"];
        gsc = radioState5["NR-ARFCN"]["_value"] == '--' ||
                radioState5["NR-ARFCN"]["_value"] == ''
            ? radioState4["EARFCN"]["_value"]
            : radioState5["NR-ARFCN"]["_value"];
        printInfo(info: '222224$gsc');
        dlfre = radioState5["NR_Frequency"]["_value"] == '--' ||
                radioState5["NR_Frequency"]["_value"] == ''
            ? radioState4["Frequency"]["_value"]
            : radioState5["NR_Frequency"]["_value"];
        band = radioState5["NR_Band"]["_value"] == '--' ||
                radioState5["NR_Band"]["_value"] == ''
            ? radioState4["Band"]["_value"]
            : radioState5["NR_Band"]["_value"];
        bandwidth = radioState5["NR_Bandwidth"]["_value"] == '--' ||
                radioState5["NR_Bandwidth"]["_value"] == ''
            ? radioState4["Bandwidth"]["_value"]
            : radioState5["NR_Bandwidth"]["_value"];
        rsrp = radioState5["SSB_RSRP0"]["_value"] == '--' ||
                radioState5["SSB_RSRP0"]["_value"] == ''
            ? radioState4["RSRP0"]["_value"]
            : radioState5["SSB_RSRP0"]["_value"];
        rssi = radioState5["SSB_RSSI"]["_value"] == '--' ||
                radioState5["SSB_RSSI"]["_value"] == ''
            ? radioState4["RSSI"]["_value"]
            : radioState5["SSB_RSSI"]["_value"];
        rsrq = radioState5["SSB_RSRQ"]["_value"] == '--' ||
                radioState5["SSB_RSRQ"]["_value"] == ''
            ? radioState4["RSRQ"]["_value"]
            : radioState5["SSB_RSRQ"]["_value"];
        sinr = radioState5["SSB_SINR"]["_value"] == '--' ||
                radioState5["SSB_SINR"]["_value"] == ''
            ? radioState4["SINR"]["_value"]
            : radioState5["SSB_SINR"]["_value"];
        txP = radioState5["NR_TXPower"]["_value"] == '--' ||
                radioState5["NR_TXPower"]["_value"] == ''
            ? radioState4["TXPower"]["_value"]
            : radioState5["NR_TXPower"]["_value"];
        pci = radioState5["NR_PCI"]["_value"] == '--' ||
                radioState5["NR_PCI"]["_value"] == ''
            ? radioState4["PCI"]["_value"]
            : radioState5["NR_PCI"]["_value"];
        cellId = radioState5["NR_CellID"]["_value"] == '--' ||
                radioState5["NR_CellID"]["_value"] == ''
            ? radioState4["CellID"]["_value"]
            : radioState5["NR_CellID"]["_value"];
        mcc = radioState5["NR_MCC"]["_value"] == '--' ||
                radioState5["NR_MCC"]["_value"] == ''
            ? radioState4["MCC"]["_value"]
            : radioState5["NR_MCC"]["_value"];
        mnc = radioState5["NR_MNC"]["_value"] == '--' ||
                radioState5["NR_MNC"]["_value"] == ''
            ? radioState4["MNC"]["_value"]
            : radioState5["NR_MNC"]["_value"];
        if (radioState["ConnectMethod"]["_value"] == 'auto_select') {
          showVal = S.current.Auto;
          val = 0;
        } else {
          showVal = S.current.Manual;
          val = 1;
        }
        if (radioState5["NR_Band"]["_value"] == '--' ||
            radioState5["NR_Band"]["_value"] == '') {
          radioGTitle = '4G ${S.of(context).status}';
        } else {
          radioGTitle = '5G ${S.of(context).status}';
        }
      });
    } catch (e) {
      debugPrint('获取信息失败：${e.toString()}');
    }
  }

// 设置 云端
  setTRRadioSettingData() async {
    var parameterNames = [
      [
        "InternetGatewayDevice.WEB_GUI.Network.NR-LTE.ConnectMethod",
        radioShowVal,
        "xsd:string"
      ]
    ];
    var res = await Request().getTRUsedFlow(parameterNames, sn);
    printInfo(info: '----$res');
    try {
      var jsonObj = jsonDecode(res);
      setState(() {});
      return res;
    } catch (e) {
      debugPrint('获取信息失败：${e.toString()}');
    }
  }

// 获取Radio设置  本地
  void getRadioSettingData() async {
    Map<String, dynamic> data = {
      'method': 'obj_set',
      'param': '{"lteNetSelectMode":"$radioShowVal"}',
    };
    XHttp.get('/data.html', data).then((res) {
      try {
        var d = json.decode(res.toString());
        setState(() {
          radioConcatenate = RadioConcatenateData.fromJson(d);
          if (radioConcatenate.success == true) {
            ToastUtils.toast(S.current.success);
          } else {
            ToastUtils.toast(S.current.error);
          }
        });
      } on FormatException catch (e) {
        print(e);
        ToastUtils.toast(S.current.error);
      }
    }).catchError((e) {
      debugPrint('获取Radio设置失败：$e.toString()');
      ToastUtils.toast(S.current.error);
    });
  }

// 获取Radio 状态 本地
  void getRadioGData() async {
    Map<String, dynamic> data = {
      'method': 'obj_get',
      'param':
          '["lteNetSelectMode","lteModeGet","lteOnOff","systemCurrentPlatform","lteMainStatusGet","lteDlmcs","lteUlmcs","lteDlEarfcnGet","lteDlFrequency","lteUlFrequency","lteBandGet","lteBandwidthGet","lteRsrp0","lteRsrp1","lteRssi","lteRsrq","lteSinr","lteCinr0","lteCinr1","lteTxpower","ltePci","lteCellidGet","lteMccGet","lteMncGet","lteDlEarfcnGet_5g","lteDlFrequency_5g","lteUlFrequency_5g","lteBandGet_5g","lteBandwidthGet_5g","lteRsrp0_5g","lteRsrp1_5g","lteRsrq_5g","lteSinr_5g","ltePci_5g","lteCellidGet_5g","lteMccGet_5g","lteMncGet_5g","lteRssi_5g"]',
    };
    try {
      var response = await XHttp.get('/data.html', data);
      var d = json.decode(response.toString());
      setState(() {
        radioGState = RadioGData.fromJson(d);
        state = radioGState.lteMainStatusGet.toString();
        gsc = (radioGState.lteDlEarfcnGet5g.toString() == '--' ||
                radioGState.lteDlEarfcnGet5g.toString() == '')
            ? radioGState.lteDlEarfcnGet.toString()
            : radioGState.lteDlEarfcnGet5g.toString();
        dlfre = (radioGState.lteDlFrequency5g.toString() == '--' ||
                radioGState.lteDlFrequency5g.toString() == '')
            ? radioGState.lteDlFrequency.toString()
            : radioGState.lteDlFrequency5g.toString();
        band = (radioGState.lteBandGet5g.toString() == '--' ||
                radioGState.lteBandGet5g.toString() == '')
            ? radioGState.lteBandGet.toString()
            : radioGState.lteBandGet5g.toString();
        bandwidth = (radioGState.lteBandwidthGet5g.toString() == '--' ||
                radioGState.lteBandwidthGet5g.toString() == '')
            ? radioGState.lteBandwidthGet.toString()
            : radioGState.lteBandwidthGet5g.toString();
        rsrp = (radioGState.lteRsrp05g.toString() == '--' ||
                radioGState.lteRsrp05g.toString() == '')
            ? radioGState.lteRsrp0.toString()
            : radioGState.lteRsrp05g.toString();
        rssi = (radioGState.lteRssi5g.toString() == '--' ||
                radioGState.lteRssi5g.toString() == '')
            ? radioGState.lteRssi.toString()
            : radioGState.lteRssi5g.toString();
        rsrq = (radioGState.lteRsrq5g.toString() == '--' ||
                radioGState.lteRsrq5g.toString() == '')
            ? radioGState.lteRsrq.toString()
            : radioGState.lteRsrq5g.toString();
        sinr = (radioGState.lteSinr5g.toString() == '--' ||
                radioGState.lteSinr5g.toString() == '')
            ? radioGState.lteSinr.toString()
            : radioGState.lteSinr5g.toString();
        txP = radioGState.lteTxpower.toString();
        pci = (radioGState.ltePci5g.toString() == '--' ||
                radioGState.ltePci5g.toString() == '')
            ? radioGState.ltePci.toString()
            : radioGState.ltePci5g.toString();
        cellId = (radioGState.lteCellidGet5g.toString() == '--' ||
                radioGState.lteCellidGet5g.toString() == '')
            ? radioGState.lteCellidGet.toString()
            : radioGState.lteCellidGet5g.toString();
        mcc = (radioGState.lteMccGet5g.toString() == '--' ||
                radioGState.lteMccGet5g.toString() == '')
            ? radioGState.lteMccGet.toString()
            : radioGState.lteMccGet5g.toString();
        mnc = (radioGState.lteMncGet5g.toString() == '--' ||
                radioGState.lteMncGet5g.toString() == '')
            ? radioGState.lteMncGet.toString()
            : radioGState.lteMncGet5g.toString();
        if (radioGState.lteNetSelectMode.toString() == 'auto_select') {
          showVal = S.current.Auto;
          val = 0;
        } else {
          showVal = S.current.Manual;
          val = 1;
        }
        if (radioGState.lteBandGet5g.toString() == '--' ||
            radioGState.lteBandGet5g.toString() == '') {
          radioGTitle = '4G ${S.of(context).status}';
        } else {
          radioGTitle = '5G ${S.of(context).status}';
        }
      });
    } catch (e) {
      debugPrint('获取Radio 状态失败：$e.toString()');
      ToastUtils.toast(S.current.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          customAppbar(context: context, title: S.of(context).radioSettings),
      body: SingleChildScrollView(
        child: Container(
            decoration:
                const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TitleWidger(title: S.of(context).status),
                  InfoBox(
                      boxCotainer: Column(children: [
                    BottomLine(
                      rowtem: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(S.of(context).status,
                              style: TextStyle(fontSize: 30.sp)),
                          Text(state, style: TextStyle(fontSize: 30.sp)),
                        ],
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        var result = CommonPicker.showPicker(
                          context: context,
                          options: [S.current.Auto, S.current.Manual],
                          value: val,
                        );
                        result?.then((selectedValue) => {
                              if (val != selectedValue && selectedValue != null)
                                {
                                  setState(() => {
                                        val = selectedValue,
                                        showVal = [
                                          S.current.Auto,
                                          S.current.Manual
                                        ][val],
                                        if (val == 0)
                                          {
                                            radioShowVal = 'auto_select',
                                            if (mounted)
                                              {
                                                if (loginController
                                                            .login.state ==
                                                        'cloud' &&
                                                    sn.isNotEmpty)
                                                  {setTRRadioSettingData()}
                                                else if (loginController
                                                        .login.state ==
                                                    'local')
                                                  {getRadioSettingData()}
                                              }
                                          },
                                        if (val == 1)
                                          {
                                            radioShowVal = 'manual_select',
                                            if (mounted)
                                              {
                                                if (loginController
                                                            .login.state ==
                                                        'cloud' &&
                                                    sn.isNotEmpty)
                                                  {setTRRadioSettingData()}
                                                else if (loginController
                                                        .login.state ==
                                                    'local')
                                                  {getRadioSettingData()}
                                              }
                                          },
                                      })
                                }
                            });
                      },
                      child: BottomLine(
                        rowtem: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(S.of(context).connectMethod,
                                  style: TextStyle(fontSize: 30.sp)),
                              Row(
                                children: [
                                  Text(showVal,
                                      style: TextStyle(fontSize: 30.sp)),
                                  Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    color:
                                        const Color.fromRGBO(144, 147, 153, 1),
                                    size: 30.w,
                                  )
                                ],
                              ),
                            ]),
                      ),
                    ),
                  ])),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TitleWidger(title: radioGTitle),
                        InfoBox(
                          boxCotainer: Column(
                            children: [
                              BottomLine(
                                  rowtem: RowContainer(
                                leftText: S.of(context).GSCNARFCN,
                                righText: gsc,
                              )),
                              BottomLine(
                                  rowtem: RowContainer(
                                leftText: S.of(context).DLFrequency,
                                righText: '${dlfre}MHz',
                              )),
                              BottomLine(
                                  rowtem: RowContainer(
                                leftText: S.of(context).ULFrequency,
                                righText: '${ulfre}MHz',
                              )),
                              BottomLine(
                                  rowtem: RowContainer(
                                leftText: S.of(context).Band,
                                righText: band,
                              )),
                              BottomLine(
                                  rowtem: RowContainer(
                                leftText: S.of(context).Bandwidth,
                                righText: '${bandwidth}MHz',
                              )),
                              BottomLine(
                                  rowtem: RowContainer(
                                leftText: 'RSRP',
                                righText: '${rsrp}dBm',
                              )),
                              BottomLine(
                                  rowtem: RowContainer(
                                leftText: 'RSSI',
                                righText: '${rssi}dBm',
                              )),
                              BottomLine(
                                  rowtem: RowContainer(
                                leftText: 'RSRQ',
                                righText: '${rsrq}dB',
                              )),
                              BottomLine(
                                  rowtem: RowContainer(
                                leftText: 'SINR',
                                righText: '${sinr}dB',
                              )),
                              BottomLine(
                                  rowtem: RowContainer(
                                leftText: S.of(context).TxPower,
                                righText: '${txP}dBm',
                              )),
                              BottomLine(
                                  rowtem: RowContainer(
                                leftText: 'PCI',
                                righText: pci,
                              )),
                              BottomLine(
                                  rowtem: RowContainer(
                                leftText: 'Cell ID',
                                righText: cellId,
                              )),
                              BottomLine(
                                  rowtem: RowContainer(
                                leftText: 'MCC',
                                righText: mcc,
                              )),
                              BottomLine(
                                  rowtem: RowContainer(
                                leftText: 'MNC',
                                righText: mnc,
                              )),
                            ],
                          ),
                        ),
                      ])
                ])),
      ),
    );
  }
}
