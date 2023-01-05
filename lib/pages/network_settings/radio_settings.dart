import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/widget/custom_app_bar.dart';
import '../../core/http/http.dart';
import '../../core/utils/toast.dart';
import '../../core/widget/common_box.dart';
import '../../core/widget/common_picker.dart';
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
        ToastUtils.toast('修改成功');
      } on FormatException catch (e) {
        print(e);
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
        if (radioGState.lteDlEarfcnGet5g.toString() == '') {
          radioGTitle = '4G状态';
        } else {
          radioGTitle = '5G状态';
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
      appBar: customAppbar(context: context, title: 'Radio设置'),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(20.sp),
            decoration:
                const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
            child: Column(children: [
              SizedBox(
                height: 10.sp,
              ),
              InfoBox(
                  boxCotainer: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('状态', style: TextStyle(fontSize: 30.sp)),
                    Text(radioStateVal, style: TextStyle(fontSize: 30.sp)),
                  ],
                ),
                SizedBox(
                  height: 20.sp,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('连接方式',
                          style: TextStyle(
                              color: const Color.fromARGB(255, 5, 0, 0),
                              fontSize: 32.sp)),
                      GestureDetector(
                        onTap: () {
                          var result = CommonPicker.showPicker(
                            context: context,
                            options: ['自动', '手动'],
                            value: val,
                          );
                          result?.then((selectedValue) => {
                                if (val != selectedValue &&
                                    selectedValue != null)
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
                        child: Row(
                          children: [
                            Text(showVal,
                                style: TextStyle(
                                    color: const Color.fromARGB(255, 5, 0, 0),
                                    fontSize: 32.sp)),
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: const Color.fromRGBO(144, 147, 153, 1),
                              size: 30.w,
                            )
                          ],
                        ),
                      ),
                    ]),
              ])),
              Column(children: [
                SizedBox(
                  height: 40.sp,
                ),
                Row(children: [
                  TitleWidger(title: radioGTitle),
                ]),
                InfoBox(
                  boxCotainer: Column(
                    children: [
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: '频点',
                        righText: radioGState.lteDlEarfcnGet5g.toString() == ''
                            ? radioGState.lteDlEarfcnGet.toString()
                            : radioGState.lteDlEarfcnGet5g.toString(),
                      )),
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: '下行频率',
                        righText:
                            '${radioGState.lteDlFrequency5g.toString() == '' ? radioGState.lteDlFrequency.toString() : radioGState.lteDlFrequency5g.toString()}MHz',
                      )),
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: '上行频率',
                        righText:
                            '${radioGState.lteUlFrequency5g.toString() == '' ? radioGState.lteUlFrequency.toString() : radioGState.lteUlFrequency5g.toString()}MHz',
                      )),
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: '频段',
                        righText: radioGState.lteBandGet5g.toString() == ''
                            ? radioGState.lteBandGet.toString()
                            : radioGState.lteBandGet5g.toString(),
                      )),
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: '宽带',
                        righText:
                            '${radioGState.lteBandwidthGet5g.toString() == '' ? radioGState.lteBandwidthGet.toString() : radioGState.lteBandwidthGet5g.toString()}MHz',
                      )),
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: 'RSRP',
                        righText:
                            '${radioGState.lteRsrp05g.toString() == '' ? radioGState.lteRsrp0.toString() : radioGState.lteRsrp05g.toString()}dBm',
                      )),
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: 'RSSI',
                        righText:
                            '${radioGState.lteRssi5g.toString() == '' ? radioGState.lteRssi.toString() : radioGState.lteRssi5g.toString()}dBm',
                      )),
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: 'RSRQ',
                        righText:
                            '${radioGState.lteRsrq5g.toString() == '' ? radioGState.lteRsrq.toString() : radioGState.lteRsrq5g.toString()}dB',
                      )),
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: 'SINR',
                        righText:
                            '${radioGState.lteSinr5g.toString() == '' ? radioGState.lteSinr.toString() : radioGState.lteSinr5g.toString()}dB',
                      )),
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: '发射功率',
                        righText: '${radioGState.lteTxpower}dBm',
                      )),
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: 'PCI',
                        righText: radioGState.ltePci5g.toString() == ''
                            ? radioGState.ltePci.toString()
                            : radioGState.ltePci5g.toString(),
                      )),
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: 'Cell ID',
                        righText: radioGState.lteCellidGet5g.toString() == ''
                            ? radioGState.lteCellidGet.toString()
                            : radioGState.lteCellidGet5g.toString(),
                      )),
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: 'MCC',
                        righText: radioGState.lteMccGet5g.toString() == ''
                            ? radioGState.lteMccGet.toString()
                            : radioGState.lteMccGet5g.toString(),
                      )),
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: 'MNC',
                        righText: radioGState.lteMncGet5g.toString() == ''
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

class TitleWidger extends StatelessWidget {
  final String title;

  const TitleWidger({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        title,
        style: TextStyle(color: Colors.blueAccent, fontSize: 32.sp),
      ),
    );
  }
}

class InfoBox extends StatelessWidget {
  final Widget boxCotainer;

  const InfoBox({super.key, required this.boxCotainer});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20.0.w),
        margin: EdgeInsets.only(bottom: 3.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.w),
        ),
        child: boxCotainer);
  }
}
