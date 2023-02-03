import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:flutter_template/core/widget/common_picker.dart';
import 'package:flutter_template/pages/wifi_set/wlan/wlan_datas.dart';
import 'package:flutter_template/pages/wifi_set/wlan/channel_list.dart';
import '../../../core/widget/custom_app_bar.dart';
import 'wifi5g_table.dart';
import 'wifi_table.dart';

/// WLAN设置
class WlanSet extends StatefulWidget {
  const WlanSet({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WlanSetState();
}

class _WlanSetState extends State<WlanSet> {
  wlanDatas wlanData = wlanDatas(
      wifiEnable: "1",
      wifiMode: "11axg",
      wifiHtmode: "--",
      wifiChannel: "auto",
      wifiTxpower: "20",
      wifi5gEnable: "1",
      wifi5gMode: "11axa",
      wifi5gHtmode: "80MHz",
      wifi5gChannel: "auto",
      wifi5gTxpower: "24");
  //频段 id 1 ,0 启用Enable 0,1
  String pdShowVal = '2.4GHz';
  channelList channelLists = channelList();
  wifiSsidTable wifiSsidTableLists = wifiSsidTable();
  wifi5GSsidTable wifi5GSsidTableLists = wifi5GSsidTable();
  int pdVal = 0;
  //模式

  List<String> wifi5gCountryChannelList = ['auto'];
  List<String> wifiCountryChannelList_HT20 = ['auto'];
  List<String> wifiCountryChannelList_HT40j = ['auto'];
  List<String> wifiCountryChannelList_HT40 = ['auto'];
  List<String> wifiModeV = ['11ng', '11axg', '11g', '11b'];
  List<String> wifi5gModeV = ['11ac', '11axa', '11na', '11a'];
  List<String> wifiMode = [
    '802.11n/g',
    '802.11axg',
    '802.11g Only',
    '802.11b Only'
  ];
  List<String> wifi5gMode = [
    '802.11ac',
    '802.11axa',
    '802.11n/a',
    '802.11a Only'
  ];
  int msVal = 0;
  int msVal5 = 0;
  //带宽

  int kdVal = 0;
  int kdVal5 = 0;
  List<String> wifiChannelBandwidth = ['20 MHz', '40+MHz', '40-MHz'];
  List<String> wifiChannelBandwidth5 = [
    '20 MHz',
    '20/40 MHz',
    '20/40/80 MHz',
  ];
  List<String> wifiChannelBandwidth5V = [
    '20MHz',
    '40MHz',
    '80MHz',
  ];
  List<String> wpaOptions = ['WPA2-PSK', 'WPA-PSK&WPA2-PSK', '空(不推荐)'];
  List<String> wpaOptionsV = ['psk2', 'psk-mixed', 'none'];
  List<String> wpajmOptions = [
    'AES(推荐)',
    'TKIP',
    'TKIP&AES',
  ];
  List<String> wpajmOptionsV = [
    'aes',
    'tkip',
    'tkip+aes',
  ];
  //信道
  String xtShowVal = 'Auto';
  int xtVal = 0;
  int xtVal5 = 0;
  //发射功率
  String fsShowVal = '100%';
  List<String> wifiTxpower = ['20', '17', '14'];
  List<String> wifi5gTxpower = ['24', '21', '18'];

  int fsVal = 0;
  int fsVal5 = 0;
  //安全
  String aqShowVal = 'WPA2-PSK';
  int aqVal = 0;
  int aqVal5 = 0;
  //WPA加密
  String wpaShowVal = 'AES(推荐)';
  int wpaVal = 0;
  int wpaVal5 = 0;
  //check
  bool isCheck = true;
  bool isCheck5 = true;
  bool apisCheck = true;
  bool apisCheck5 = true;
  bool ssidisCheck5 = true;
  bool ssidisCheck = true;
  final TextEditingController ssid = TextEditingController();
  final TextEditingController ssid5 = TextEditingController();
  final TextEditingController max = TextEditingController();
  final TextEditingController max5 = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController password5 = TextEditingController();
  @override
  void initState() {
    super.initState();

    getList();
    getWiFiSsidTable();
    getWiFi5GSsidTable();
  }

//提交
  void setData() async {
    if ((pdVal == 0 && isCheck)) {
      ssid.text == '';
      ToastUtils.waring('SSID 不能为空！');
    }
    if (pdVal == 1 && isCheck5) {
      ssid5.text == '';
      ToastUtils.waring('SSID 不能为空！');
    }
    var param;
    if (pdVal == 1) {
      if (isCheck5) {
        if (msVal5 < 3) {
          param =
              '{"wifi5gEnable":"1","wifi5gMode":"${wifi5gModeV[msVal5]}","wifi5gHtmode":"${wifiChannelBandwidth5V[kdVal5]}","wifi5gChannel":"${wifi5gCountryChannelList[xtVal5]}","wifi5gTxpower":"${wifi5gTxpower[fsVal5]}"}';
        } else {
          param =
              '{"wifi5gEnable":"1","wifi5gMode":"${wifi5gModeV[msVal5]}","wifi5gChannel":"${wifi5gCountryChannelList[xtVal5]}","wifi5gTxpower":"${wifi5gTxpower[fsVal5]}"}';
        }
      } else {
        param = '{"wifi5gEnable": "0"}';
      }
    } else {
      if (isCheck) {
        if (msVal < 2) {
          param =
              '{"wifiEnable":"1","wifiMode":"${wifiModeV[msVal]}","wifiHtmode":"${wifiChannelBandwidth[kdVal]}","wifiChannel":"${kdVal == 0 ? wifiCountryChannelList_HT20[xtVal] : kdVal == 1 ? wifiCountryChannelList_HT40j[xtVal] : wifiCountryChannelList_HT40}","wifiTxpower":"${wifiTxpower[fsVal]}"}';
        } else {
          param =
              '{"wifiEnable":"1","wifiMode":"${wifiModeV[msVal]}",,"wifiChannel":"${kdVal == 0 ? wifiCountryChannelList_HT20[xtVal] : kdVal == 1 ? wifiCountryChannelList_HT40j[xtVal] : wifiCountryChannelList_HT40}","wifiTxpower":"${wifiTxpower[fsVal]}"}';
        }
      } else {
        param = '{"wifiEnable": "0"}';
      }
    }
    Map<String, dynamic> data = {'method': 'obj_set', 'param': param};
    try {
      var response = await XHttp.get('/data.html', data);
      var d = json.decode(response.toString());
      if (d['success'] == true) {
        if ((pdVal == 0 && isCheck) || (pdVal == 1 && isCheck5)) {
          setTab();
        }
      } else {
        ToastUtils.error('提交失败！');
      }
    } catch (e) {
      ToastUtils.error('提交失败！');
    }
  }

  void setTab() async {
    var param;
    if (pdVal == 0) {
      param =
          '{"table":"WiFiSsidTable","value":[{"id":0,"Enable":"1","Ssid":"${ssid.text}","MaxClient":"${max.text}","SsidHide":"${ssidisCheck ? 1 : 0}","ApIsolate":"${apisCheck ? 1 : 0}","Encryption":"${wpaOptionsV[aqVal]}+${wpajmOptionsV[wpaVal]}","Key":"${password.text}"}]}';
    } else {
      param =
          '{"table":"WiFi5GSsidTable","value":[{"id":0,"Enable":"1","Ssid":"${ssid5.text}","MaxClient":"${max5.text}","SsidHide":"${ssidisCheck5 ? 1 : 0}","ApIsolate":"${apisCheck5 ? 1 : 0}","Encryption":"${wpaOptionsV[aqVal5]}+${wpajmOptionsV[wpaVal5]}","Key":"${password5.text}"}]}';
    }
    Map<String, dynamic> data = {'method': 'tab_set', 'param': param};
    try {
      var response = await XHttp.get('/data.html', data);
      var d = json.decode(response.toString());
      if (d['success'] == true) {
        ToastUtils.success('提交成功！');
      } else {
        ToastUtils.error('提交失败！');
      }
    } catch (e) {
      ToastUtils.error('提交失败！');
    }
  }

  //读取
  void getData() async {
    Map<String, dynamic> data = {
      'method': 'obj_get',
      'param':
          '["wifiBandGet","wifiEnable","wifiMode","wifiHtmode","wifiChannel","wifiTxpower","Ssid","MaxClient","SsidHide","ApIsolate","wlanencryption","wlanauthentication","Key","wifi5gEnable","wifi5gMode","wifi5gHtmode","wifi5gHtmode1","wifi5gChannel","wifi5gTxpower","Ssid5g","MaxClient5g","SsidHide5g","ApIsolate5g","wlanencryption5g","wlanauthentication5g","Key5g"]',
    };
    try {
      var response = await XHttp.get('/data.html', data);
      var d = json.decode(response.toString());
      setState(() {
        wlanData = wlanDatas.fromJson(d);
        //SSID

        // wifiModeV.indexOf(wlanData.wifiMode.toString());
        if (!wifiModeV.contains(wlanData.wifiMode.toString())) {
          return;
        }
        msVal = wifiModeV.indexOf(wlanData.wifiMode.toString());
        msVal5 = wifi5gModeV.indexOf(wlanData.wifi5gMode.toString());
        kdVal = wifiChannelBandwidth.indexOf(wlanData.wifiHtmode.toString());
        kdVal5 =
            wifiChannelBandwidth5V.indexOf(wlanData.wifi5gHtmode.toString());
        fsVal = wifiTxpower.indexOf(wlanData.wifiTxpower.toString());
        fsVal5 = wifi5gTxpower.indexOf(wlanData.wifi5gTxpower.toString());

        // wlanData.wifiMode.
        if (wlanData.wifiHtmode.toString() == '20MHz') {
          xtVal = wifiCountryChannelList_HT20
              .indexOf(wlanData.wifiChannel.toString());
        } else if (wlanData.wifiHtmode.toString() == '40+MHz') {
          xtVal = wifiCountryChannelList_HT40j
              .indexOf(wlanData.wifiChannel.toString());
        } else if (wlanData.wifiHtmode.toString() == '40-MHz') {
          xtVal = wifiCountryChannelList_HT40
              .indexOf(wlanData.wifiChannel.toString());
        }

        xtVal5 =
            wifi5gCountryChannelList.indexOf(wlanData.wifi5gChannel.toString());
        isCheck = wlanData.wifiEnable == '1';
        isCheck5 = wlanData.wifi5gEnable == '1';

        print(wlanData.toString());
      });
    } catch (e) {
      debugPrint('设置失败:$e.toString()');
    }
  }

//读取
  void getList() async {
    Map<String, dynamic> data = {
      'method': 'obj_get',
      'param':
          '["wifiCountryChannelList_HT20","wifiCountryChannelList_HT40+","wifiCountryChannelList_HT40-","wifiHtmode","wifi5gCountryChannelList"]',
    };
    try {
      var response = await XHttp.get('/data.html', data);
      var d = json.decode(response.toString());
      setState(() {
        channelLists = channelList.fromJson(d);
        print("+++++++++++++++$channelLists");

        wifi5gCountryChannelList
            .addAll(channelLists.wifi5gCountryChannelList!.split(';'));
        wifiCountryChannelList_HT20
            .addAll(channelLists.wifiCountryChannelListHT20!.split(';'));
        wifiCountryChannelList_HT40j
            .addAll(channelLists.wifiCountryChannelListHT40j!.split(';'));
        wifiCountryChannelList_HT40
            .addAll(channelLists.wifiCountryChannelListHT40!.split(';'));
      });
      getData();
    } catch (e) {
      debugPrint('获取wps设置失败:$e.toString()');
    }
  }

//读取WiFiSsidTable
  void getWiFiSsidTable() async {
    Map<String, dynamic> data = {
      'method': 'tab_dump',
      'param': '["WiFiSsidTable"]',
    };
    try {
      var response = await XHttp.get('/data.html', data);
      var d = json.decode(response.toString());
      setState(() {
        wifiSsidTableLists = wifiSsidTable.fromJson(d);
        ssid.text = wifiSsidTableLists.wiFiSsidTable![0].ssid.toString();
        max.text = wifiSsidTableLists.wiFiSsidTable![0].maxClient.toString();
        password.text = wifiSsidTableLists.wiFiSsidTable![0].key.toString();
        var encryption =
            wifiSsidTableLists.wiFiSsidTable![0].encryption.toString();
        print(encryption.toString());
        if (encryption != 'none') {
          encryption.split('+');
          wpaVal = wpajmOptionsV.indexOf(encryption.split('+')[1].toString());
          aqVal = wpaOptionsV.indexOf(encryption.split('+')[0].toString());
        }
        ssidisCheck =
            wifiSsidTableLists.wiFiSsidTable![0].ssidHide.toString() == '1';
        apisCheck =
            wifiSsidTableLists.wiFiSsidTable![0].apIsolate.toString() == '1';
        max.text = wlanData.wifiTxpower.toString();
      });
    } catch (e) {
      debugPrint('获取wps设置失败:$e.toString()');
    }
  }

//读取WiFi5GSsidTable
  void getWiFi5GSsidTable() async {
    Map<String, dynamic> data = {
      'method': 'tab_dump',
      'param': '["WiFi5GSsidTable"]',
    };
    try {
      var response = await XHttp.get('/data.html', data);
      var d = json.decode(response.toString());
      setState(() {
        wifi5GSsidTableLists = wifi5GSsidTable.fromJson(d);
        var encryption =
            wifi5GSsidTableLists.wiFi5GSsidTable![0].encryption.toString();
        if (encryption != 'none') {
          encryption.split('+');
          wpaVal5 = wpajmOptionsV.indexOf(encryption.split('+')[1].toString());
          aqVal5 = wpaOptionsV.indexOf(encryption.split('+')[0].toString());
        }
        ssid5.text = wifi5GSsidTableLists.wiFi5GSsidTable![0].ssid.toString();
        ssidisCheck5 =
            wifi5GSsidTableLists.wiFi5GSsidTable![0].ssidHide.toString() == '1';
        apisCheck5 =
            wifi5GSsidTableLists.wiFi5GSsidTable![0].apIsolate.toString() ==
                '1';

        max5.text =
            wifi5GSsidTableLists.wiFi5GSsidTable![0].maxClient.toString();
        password5.text =
            wifi5GSsidTableLists.wiFi5GSsidTable![0].key.toString();
      });
    } catch (e) {
      debugPrint('设置失败:$e.toString()');
    }
  }

  // 点击空白  关闭键盘 时传的一个对象
  FocusNode blankNode = FocusNode();

  /// 点击空白  关闭输入键盘
  void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(blankNode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(context: context, title: 'WLAN设置'),
        body: GestureDetector(
          onTap: () => closeKeyboard(context),
          behavior: HitTestBehavior.opaque,
          child: Container(
            decoration:
                const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
            height: 2000.w,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //一般设置
                  const TitleWidger(title: '一般设置'),
                  InfoBox(
                      boxCotainer: Column(
                    children: [
                      //频段
                      GestureDetector(
                        onTap: () {
                          closeKeyboard(context);
                          var result = CommonPicker.showPicker(
                            context: context,
                            options: ['2.4GHz', '5GHz'],
                            value: pdVal,
                          );
                          result?.then((selectedValue) => {
                                if (pdVal != selectedValue &&
                                    selectedValue != null)
                                  {
                                    setState(() => {
                                          pdVal = selectedValue,
                                        })
                                  }
                              });
                        },
                        child: BottomLine(
                          rowtem: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('频段',
                                  style: TextStyle(
                                      color: const Color.fromARGB(255, 5, 0, 0),
                                      fontSize: 28.sp)),
                              Row(
                                children: [
                                  Text(['2.4GHz', '5GHz'][pdVal],
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 5, 0, 0),
                                          fontSize: 28.sp)),
                                  Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    color:
                                        const Color.fromRGBO(144, 147, 153, 1),
                                    size: 30.w,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      //WLAN
                      BottomLine(
                        rowtem: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('WLAN',
                                style: TextStyle(
                                    color: const Color.fromARGB(255, 5, 0, 0),
                                    fontSize: 28.sp)),
                            Row(
                              children: [
                                Switch(
                                  value: pdVal == 0 ? isCheck : isCheck5,
                                  onChanged: (newVal) {
                                    setState(() {
                                      if (pdVal == 0) {
                                        isCheck = newVal;
                                      } else {
                                        isCheck5 = newVal;
                                      }
                                    });
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),

                      //模式
                      if (pdVal == 0 ? isCheck : isCheck5)
                        GestureDetector(
                          onTap: () {
                            closeKeyboard(context);
                            var result = CommonPicker.showPicker(
                              context: context,
                              options: pdVal == 0 ? wifiMode : wifi5gMode,
                              value: pdVal == 0 ? msVal : msVal5,
                            );
                            result?.then((selectedValue) => {
                                  if (msVal != selectedValue &&
                                      selectedValue != null)
                                    {
                                      setState(() => {
                                            if (pdVal == 0)
                                              {msVal = selectedValue, kdVal = 0}
                                            else
                                              {
                                                msVal5 = selectedValue,
                                                kdVal5 = 0
                                              }
                                          })
                                    }
                                });
                          },
                          child: BottomLine(
                            rowtem: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('模式',
                                    style: TextStyle(
                                        color:
                                            const Color.fromARGB(255, 5, 0, 0),
                                        fontSize: 28.sp)),
                                Row(
                                  children: [
                                    Text(
                                        pdVal == 0
                                            ? wifiMode[msVal]
                                            : wifi5gMode[msVal5],
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 5, 0, 0),
                                            fontSize: 28.sp)),
                                    Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      color: const Color.fromRGBO(
                                          144, 147, 153, 1),
                                      size: 30.w,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      //带宽
                      if (pdVal == 0
                          ? isCheck && (msVal < 2)
                          : isCheck5 && msVal5 != 3)
                        GestureDetector(
                          onTap: () {
                            closeKeyboard(context);
                            var result = CommonPicker.showPicker(
                              context: context,
                              options: pdVal == 0
                                  ? wifiChannelBandwidth
                                  : wifiChannelBandwidth5,
                              value: pdVal == 0 ? kdVal : kdVal5,
                            );
                            result?.then((selectedValue) => {
                                  if (kdVal != selectedValue &&
                                      selectedValue != null)
                                    {
                                      setState(() => {
                                            if (pdVal == 0)
                                              {kdVal = selectedValue, xtVal = 0}
                                            else
                                              {
                                                kdVal5 = selectedValue,
                                                xtVal5 = 0
                                              }
                                          })
                                    }
                                });
                          },
                          child: BottomLine(
                            rowtem: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('带宽',
                                    style: TextStyle(
                                        color:
                                            const Color.fromARGB(255, 5, 0, 0),
                                        fontSize: 28.sp)),
                                Row(
                                  children: [
                                    Text(
                                        pdVal == 0
                                            ? wifiChannelBandwidth[kdVal]
                                            : wifiChannelBandwidth5[kdVal5],
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 5, 0, 0),
                                            fontSize: 28.sp)),
                                    Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      color: const Color.fromRGBO(
                                          144, 147, 153, 1),
                                      size: 30.w,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      //信道
                      if (pdVal == 0 ? isCheck : isCheck5)
                        GestureDetector(
                          onTap: () {
                            closeKeyboard(context);
                            var result = CommonPicker.showPicker(
                              context: context,
                              options: pdVal == 1
                                  ? wifi5gCountryChannelList
                                  : kdVal == 0
                                      ? wifiCountryChannelList_HT20
                                      : kdVal == 1
                                          ? wifiCountryChannelList_HT40j
                                          : wifiCountryChannelList_HT40,
                              value: pdVal == 0 ? xtVal : xtVal5,
                            );
                            result?.then((selectedValue) => {
                                  if (xtVal != selectedValue &&
                                      selectedValue != null)
                                    {
                                      setState(() => {
                                            xtVal = selectedValue,
                                            if (pdVal == 1)
                                              {xtVal5 = selectedValue}
                                            else
                                              {xtVal = selectedValue}
                                          })
                                    }
                                });
                          },
                          child: BottomLine(
                            rowtem: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('信道',
                                    style: TextStyle(
                                        color:
                                            const Color.fromARGB(255, 5, 0, 0),
                                        fontSize: 28.sp)),
                                Row(
                                  children: [
                                    Text(
                                        pdVal == 1
                                            ? wifi5gCountryChannelList[xtVal5]
                                            : kdVal == 0
                                                ? wifiCountryChannelList_HT20[
                                                    xtVal]
                                                : kdVal == 1
                                                    ? wifiCountryChannelList_HT40j[
                                                        xtVal]
                                                    : wifiCountryChannelList_HT40[
                                                        xtVal],
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 5, 0, 0),
                                            fontSize: 28.sp)),
                                    Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      color: const Color.fromRGBO(
                                          144, 147, 153, 1),
                                      size: 30.w,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      //发射功率
                      if (pdVal == 0 ? isCheck : isCheck5)
                        GestureDetector(
                          onTap: () {
                            closeKeyboard(context);
                            var result = CommonPicker.showPicker(
                              context: context,
                              options: [
                                '100%',
                                '50%',
                                '20%',
                              ],
                              value: pdVal == 0 ? fsVal : fsVal5,
                            );
                            result?.then((selectedValue) => {
                                  if (fsVal != selectedValue &&
                                      selectedValue != null)
                                    {
                                      setState(() => {
                                            if (pdVal == 0)
                                              {
                                                fsVal = selectedValue,
                                              }
                                            else
                                              {
                                                fsVal5 = selectedValue,
                                              }
                                          })
                                    }
                                });
                          },
                          child: Container(
                            padding: EdgeInsets.only(top: 20.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('发射功率',
                                    style: TextStyle(
                                        color:
                                            const Color.fromARGB(255, 5, 0, 0),
                                        fontSize: 28.sp)),
                                Row(
                                  children: [
                                    Text(
                                        [
                                          '100%',
                                          '50%',
                                          '20%',
                                        ][pdVal == 0 ? fsVal : fsVal5],
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 5, 0, 0),
                                            fontSize: 28.sp)),
                                    Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      color: const Color.fromRGBO(
                                          144, 147, 153, 1),
                                      size: 30.w,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  )),
                  //配置
                  if (pdVal == 0 ? isCheck : isCheck5)
                    const TitleWidger(title: '配置'),
                  if (pdVal == 0 ? isCheck : isCheck5)
                    InfoBox(
                        boxCotainer: Column(
                      children: [
                        //SSID
                        BottomLine(
                          rowtem: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('SSID',
                                  style: TextStyle(
                                      color: const Color.fromARGB(255, 5, 0, 0),
                                      fontSize: 28.sp)),
                              SizedBox(
                                width: 250.w,
                                child: TextFormField(
                                  controller: pdVal == 0 ? ssid : ssid5,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 26.sp,
                                      color: const Color(0xff051220)),
                                  decoration: InputDecoration(
                                    hintText: "输入SSID",
                                    hintStyle: TextStyle(
                                        fontSize: 26.sp,
                                        color: const Color(0xff737A83)),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        //最大设备数
                        BottomLine(
                          rowtem: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('最大设备数',
                                  style: TextStyle(
                                      color: const Color.fromARGB(255, 5, 0, 0),
                                      fontSize: 28.sp)),
                              SizedBox(
                                width: 250.w,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^7[0]$|^[1-6]\d$|^[1-9]$'))
                                  ],
                                  textAlign: TextAlign.right,
                                  controller: pdVal == 0 ? max : max5,
                                  style: TextStyle(
                                      fontSize: 26.sp,
                                      color: const Color(0xff051220)),
                                  decoration: InputDecoration(
                                    hintText: "最大设备数",
                                    hintStyle: TextStyle(
                                        fontSize: 26.sp,
                                        color: const Color(0xff737A83)),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        //隐藏SSID网络
                        BottomLine(
                          rowtem: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('隐藏SSID网络',
                                  style: TextStyle(
                                      color: const Color.fromARGB(255, 5, 0, 0),
                                      fontSize: 28.sp)),
                              Row(
                                children: [
                                  Switch(
                                    value:
                                        pdVal == 0 ? ssidisCheck : ssidisCheck5,
                                    onChanged: (newVal) {
                                      setState(() {
                                        if (pdVal == 0) {
                                          ssidisCheck = newVal;
                                        }
                                        {
                                          ssidisCheck5 = newVal;
                                        }
                                      });
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        //AP隔离
                        BottomLine(
                          rowtem: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('AP隔离',
                                  style: TextStyle(
                                      color: const Color.fromARGB(255, 5, 0, 0),
                                      fontSize: 28.sp)),
                              Row(
                                children: [
                                  Switch(
                                    value: pdVal == 0 ? apisCheck : apisCheck5,
                                    onChanged: (newVal) {
                                      setState(() {
                                        if (pdVal == 0) {
                                          apisCheck = newVal;
                                        } else {
                                          apisCheck5 = newVal;
                                        }
                                      });
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        //安全
                        GestureDetector(
                          onTap: () {
                            closeKeyboard(context);
                            var result = CommonPicker.showPicker(
                              context: context,
                              options: wpaOptions,
                              value: pdVal == 0 ? aqVal : aqVal5,
                            );
                            result?.then((selectedValue) => {
                                  if (aqVal != selectedValue &&
                                      selectedValue != null)
                                    {
                                      setState(() => {
                                            if (pdVal == 0)
                                              {
                                                aqVal = selectedValue,
                                              }
                                            else
                                              {
                                                aqVal5 = selectedValue,
                                              }
                                          })
                                    }
                                });
                          },
                          child: BottomLine(
                            rowtem: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('安全',
                                    style: TextStyle(
                                        color:
                                            const Color.fromARGB(255, 5, 0, 0),
                                        fontSize: 28.sp)),
                                Row(
                                  children: [
                                    Text(
                                        pdVal == 0
                                            ? wpaOptions[aqVal]
                                            : wpaOptions[aqVal5],
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 5, 0, 0),
                                            fontSize: 28.sp)),
                                    Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      color: const Color.fromRGBO(
                                          144, 147, 153, 1),
                                      size: 30.w,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (aqVal != 2)
                          //WPA加密
                          GestureDetector(
                            onTap: () {
                              closeKeyboard(context);
                              var result = CommonPicker.showPicker(
                                context: context,
                                options: wpajmOptions,
                                value: pdVal == 0 ? wpaVal : wpaVal5,
                              );
                              result?.then((selectedValue) => {
                                    if (wpaVal != selectedValue &&
                                        selectedValue != null)
                                      {
                                        setState(() => {
                                              if (pdVal == 0)
                                                {
                                                  wpaVal = selectedValue,
                                                }
                                              else
                                                {
                                                  wpaVal5 = selectedValue,
                                                }
                                            })
                                      }
                                  });
                            },
                            child: BottomLine(
                              rowtem: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('WPA加密',
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 5, 0, 0),
                                          fontSize: 28.sp)),
                                  Row(
                                    children: [
                                      Text(
                                          pdVal == 0
                                              ? wpajmOptions[wpaVal]
                                              : wpajmOptions[wpaVal5],
                                          style: TextStyle(
                                              color: const Color.fromARGB(
                                                  255, 5, 0, 0),
                                              fontSize: 28.sp)),
                                      Icon(
                                        Icons.arrow_forward_ios_outlined,
                                        color: const Color.fromRGBO(
                                            144, 147, 153, 1),
                                        size: 30.w,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (aqVal != 2)

                          //密码
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "密码",
                                style: TextStyle(
                                    color: const Color.fromARGB(255, 5, 0, 0),
                                    fontSize: 28.sp),
                              ),
                              SizedBox(
                                width: 250.w,
                                child: TextFormField(
                                  autovalidateMode: AutovalidateMode.always,
                                  textAlign: TextAlign.right,
                                  controller: pdVal == 0 ? password : password5,
                                  style: TextStyle(
                                      fontSize: 26.sp,
                                      color: const Color(0xff051220)),
                                  decoration: InputDecoration(
                                    hintText: "输入新密码",
                                    hintStyle: TextStyle(
                                        fontSize: 26.sp,
                                        color: const Color(0xff737A83)),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    )),
                  Padding(
                      padding: EdgeInsets.only(top: 10.w),
                      child: Center(
                          child: SizedBox(
                        height: 70.sp,
                        width: 680.sp,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color.fromARGB(255, 48, 118, 250))),
                          onPressed: setData,
                          child: Text(
                            '提交',
                            style: TextStyle(fontSize: 36.sp),
                          ),
                        ),
                      )))
                  //提交
                ],
              ),
            ),
          ),
        ));
  }
}
