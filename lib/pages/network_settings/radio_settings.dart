import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  String radioStateVal = '';
  String radioGTitle = '';

  RadioConcatenateData radioConcatenate = RadioConcatenateData();

  RadioGData radioGState = RadioGData();

  @override
  void initState() {
    super.initState();
    getRadioGData();
  }

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
            ToastUtils.toast('修改成功');
          } else {
            ToastUtils.toast('修改失败');
          }
        });
      } on FormatException catch (e) {
        print(e);
        ToastUtils.toast('修改失败');
      }
    }).catchError((e) {
      debugPrint('获取Radio设置失败：$e.toString()');
      ToastUtils.toast('获取Radio设置失败');
    });
  }

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
        radioStateVal = radioGState.lteMainStatusGet.toString();
        if (radioGState.lteNetSelectMode.toString() == 'auto_select') {
          showVal = '自动';
          val = 0;
        } else {
          showVal = '手动';
          val = 1;
        }
        if (radioGState.lteBandGet5g.toString() == '--' ||
            radioGState.lteBandGet5g.toString() == '') {
          radioGTitle = '4G ' + S.of(context).status;
        } else {
          radioGTitle = '5G ' + S.of(context).status;
        }
      });
    } catch (e) {
      debugPrint('获取Radio 状态失败：$e.toString()');
      ToastUtils.toast('获取Radio 状态失败');
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
                          Text(radioStateVal,
                              style: TextStyle(fontSize: 30.sp)),
                        ],
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        var result = CommonPicker.showPicker(
                          context: context,
                          options: ['自动', '手动'],
                          value: val,
                        );
                        result?.then((selectedValue) => {
                              if (val != selectedValue && selectedValue != null)
                                {
                                  setState(() => {
                                        val = selectedValue,
                                        showVal = ['自动', '手动'][val],
                                        if (val == 0)
                                          {
                                            radioShowVal = 'auto_select',
                                            getRadioSettingData()
                                          },
                                        if (val == 1)
                                          {
                                            radioShowVal = 'manual_select',
                                            getRadioSettingData()
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
                                leftText:  S.of(context).GSCNARFCN,
                                righText: (radioGState.lteDlEarfcnGet5g
                                                .toString() ==
                                            '--' ||
                                        radioGState.lteDlEarfcnGet5g
                                                .toString() ==
                                            '')
                                    ? radioGState.lteDlEarfcnGet.toString()
                                    : radioGState.lteDlEarfcnGet5g.toString(),
                              )),
                              BottomLine(
                                  rowtem: RowContainer(
                                leftText:  S.of(context).DLFrequency,
                                righText:
                                    '${(radioGState.lteDlFrequency5g.toString() == '--' || radioGState.lteDlFrequency5g.toString() == '') ? radioGState.lteDlFrequency.toString() : radioGState.lteDlFrequency5g.toString()}MHz',
                              )),
                              BottomLine(
                                  rowtem: RowContainer(
                                leftText: S.of(context).ULFrequency,
                                righText:
                                    '${(radioGState.lteUlFrequency5g.toString() == '--' || radioGState.lteUlFrequency5g.toString() == '') ? radioGState.lteUlFrequency.toString() : radioGState.lteUlFrequency5g.toString()}MHz',
                              )),
                              BottomLine(
                                  rowtem: RowContainer(
                                leftText: S.of(context).Band,
                                righText: (radioGState.lteBandGet5g
                                                .toString() ==
                                            '--' ||
                                        radioGState.lteBandGet5g.toString() ==
                                            '')
                                    ? radioGState.lteBandGet.toString()
                                    : radioGState.lteBandGet5g.toString(),
                              )),
                              BottomLine(
                                  rowtem: RowContainer(
                                leftText: S.of(context).Bandwidth,
                                righText:
                                    '${(radioGState.lteBandwidthGet5g.toString() == '--' || radioGState.lteBandwidthGet5g.toString() == '') ? radioGState.lteBandwidthGet.toString() : radioGState.lteBandwidthGet5g.toString()}MHz',
                              )),
                              BottomLine(
                                  rowtem: RowContainer(
                                leftText: 'RSRP',
                                righText:
                                    '${(radioGState.lteRsrp05g.toString() == '--' || radioGState.lteRsrp05g.toString() == '') ? radioGState.lteRsrp0.toString() : radioGState.lteRsrp05g.toString()}dBm',
                              )),
                              BottomLine(
                                  rowtem: RowContainer(
                                leftText: 'RSSI',
                                righText:
                                    '${(radioGState.lteRssi5g.toString() == '--' || radioGState.lteRssi5g.toString() == '') ? radioGState.lteRssi.toString() : radioGState.lteRssi5g.toString()}dBm',
                              )),
                              BottomLine(
                                  rowtem: RowContainer(
                                leftText: 'RSRQ',
                                righText:
                                    '${(radioGState.lteRsrq5g.toString() == '--' || radioGState.lteRsrq5g.toString() == '') ? radioGState.lteRsrq.toString() : radioGState.lteRsrq5g.toString()}dB',
                              )),
                              BottomLine(
                                  rowtem: RowContainer(
                                leftText: 'SINR',
                                righText:
                                    '${(radioGState.lteSinr5g.toString() == '--' || radioGState.lteSinr5g.toString() == '') ? radioGState.lteSinr.toString() : radioGState.lteSinr5g.toString()}dB',
                              )),
                              BottomLine(
                                  rowtem: RowContainer(
                                leftText:  S.of(context).TxPower,
                                righText: '${radioGState.lteTxpower}dBm',
                              )),
                              BottomLine(
                                  rowtem: RowContainer(
                                leftText: 'PCI',
                                righText: (radioGState.ltePci5g.toString() ==
                                            '--' ||
                                        radioGState.ltePci5g.toString() == '')
                                    ? radioGState.ltePci.toString()
                                    : radioGState.ltePci5g.toString(),
                              )),
                              BottomLine(
                                  rowtem: RowContainer(
                                leftText: 'Cell ID',
                                righText: (radioGState.lteCellidGet5g
                                                .toString() ==
                                            '--' ||
                                        radioGState.lteCellidGet5g.toString() ==
                                            '')
                                    ? radioGState.lteCellidGet.toString()
                                    : radioGState.lteCellidGet5g.toString(),
                              )),
                              BottomLine(
                                  rowtem: RowContainer(
                                leftText: 'MCC',
                                righText: (radioGState.lteMccGet5g.toString() ==
                                            '--' ||
                                        radioGState.lteMccGet5g.toString() ==
                                            '')
                                    ? radioGState.lteMccGet.toString()
                                    : radioGState.lteMccGet5g.toString(),
                              )),
                              BottomLine(
                                  rowtem: RowContainer(
                                leftText: 'MNC',
                                righText: (radioGState.lteMncGet5g.toString() ==
                                            '--' ||
                                        radioGState.lteMncGet5g.toString() ==
                                            '')
                                    ? radioGState.lteMncGet.toString()
                                    : radioGState.lteMncGet5g.toString(),
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
