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
import 'package:get/get.dart';
import '../../../core/utils/shared_preferences_util.dart';
import '../../../core/widget/custom_app_bar.dart';
import '../../../generated/l10n.dart';
import '../../login/login_controller.dart';
import 'wifi5g_table.dart';
import 'wifi_table.dart';
import 'package:flutter_template/core/request/request.dart';

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
  // 0:2.4g,1:5g
  int pdVal = 0;
  //模式
  List<String> wifi5gCountryChannelList = [
    'auto',
    "36",
    "40",
    "44",
    "48",
    "52",
    "56",
    "60",
    "64",
    "100",
    "104",
    "108",
    "112",
    "116",
    "120",
    "124",
    "128",
    "132",
    "136",
    "140"
  ];
  List<String> wifiCountryChannelListHT20 = [
    'auto',
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11",
    "12",
    "13"
  ];
  List<String> wifiCountryChannelListHT40j = [
    'auto',
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9"
  ];
  List<String> wifiCountryChannelListHT40 = [
    'auto',
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11",
    "12",
    "13"
  ];
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
  List<String> wifiChannelBandwidth = ['20MHz', '40+MHz', '40-MHz'];
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
  List<String> wpaOptions = [
    'WPA2-PSK',
    'WPA-PSK&WPA2-PSK',
    S.current.emptyNORecommend
  ];
  List<String> wpaOptionsV = ['psk2', 'psk-mixed', 'none'];
  List<String> wpajmOptions = [
    S.current.aesRecommend,
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
  //密码
  bool passwordValShow = true;
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
  String wpaShowVal = S.current.aesRecommend;
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
  String sn = '';
  final LoginController loginController = Get.put(LoginController());
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
            // 云端请求赋值
            get24gList();
          }
          if (loginController.login.state == 'local') {
            // 本地请求赋值
            getList();
            getWiFiSsidTable();
            getWiFi5GSsidTable();
          }
        }
      });
    }));
  }

  // 云端获取接口
  // 2.4g
  Future get24gList() async {
    Object? sn = await sharedGetData('deviceSn', String);
    List<String> parameterNames = [
      'InternetGatewayDevice.WEB_GUI.WiFi.WLANSettings.1'
    ];
    var res = await Request().getACSNode(parameterNames, sn.toString());
    var list = json.decode(res)['data']['InternetGatewayDevice']['WEB_GUI']
        ['WiFi']['WLANSettings']['1'];
    // WLAN Enable
    bool enable = list['Enable']['_value'];
    // Mode
    String mode = list['Mode']['_value'];
    // Bandwidth
    String bandwidth = list['ChannelBandwidth']['_value'];
    // Channel
    String channel = list['Channel']['_value'];
    // TX Power
    String txPower = list['TxPower']['_value'];
    // SSID
    String ssidText = list['SSIDProfile']['1']['SSID']['_value'];
    // MAX
    int maxText = list['SSIDProfile']['1']['MaxNoOfDev']['_value'];
    // HIDE BROADCAST
    bool hideBroadcast =
        list['SSIDProfile']['1']['HideSSIDBroadcast']['_value'];
    // AP Isolation
    bool isolation = list['SSIDProfile']['1']['APIsolation']['_value'];
    // encryptionmode
    var encyptionmode = list['SSIDProfile']['1']['EncryptionMode']['_value'];
    // SERCURITY
    String sercurity = encyptionmode.split('+')[0];
    // WPA ENCYPITON
    String wpaEncyption = encyptionmode.split('+').skip(1).join('+');
    // PASSWORD
    // 暂无PASSWORD
    setState(() {
      pdVal = 0;
      isCheck = enable;
      msVal = wifiModeV.indexOf(mode);
      kdVal = wifiChannelBandwidth.indexOf(bandwidth);
      xtVal = kdVal == 0
          ? wifiCountryChannelListHT20.indexOf(channel)
          : kdVal == 1
              ? wifiCountryChannelListHT40j.indexOf(channel)
              : wifiCountryChannelListHT40.indexOf(channel);
      // fsVal = txPower;

      ssid.text = ssidText;
      max.text = maxText.toString();
      ssidisCheck = hideBroadcast;
      apisCheck = isolation;
      aqVal = wpaOptionsV.indexOf(sercurity);
      wpaVal = wpajmOptionsV.indexOf(wpaEncyption);
    });
  }

  // 5g
  Future get5gList() async {
    Object? sn = await sharedGetData('deviceSn', String);
    List<String> parameterNames = [
      'InternetGatewayDevice.WEB_GUI.WiFi.WLANSettings.2'
    ];
    var res = await Request().getACSNode(parameterNames, sn.toString());
    var list = json.decode(res)['data']['InternetGatewayDevice']['WEB_GUI']
        ['WiFi']['WLANSettings']['2'];
    // WLAN Enable
    bool enable = list['Enable']['_value'];
    // Mode
    String mode = list['Mode']['_value'];
    // Bandwidth
    String bandwidth = list['ChannelBandwidth']['_value'];
    // Channel
    String channel = list['Channel']['_value'];
    // TX Power
    String txPower = list['TxPower']['_value'];
    // SSID
    String ssidText = list['SSIDProfile']['1']['SSID']['_value'];
    // MAX
    int maxText = list['SSIDProfile']['1']['MaxNoOfDev']['_value'];
    // HIDE BROADCAST
    bool hideBroadcast =
        list['SSIDProfile']['1']['HideSSIDBroadcast']['_value'];
    // AP Isolation
    bool isolation = list['SSIDProfile']['1']['APIsolation']['_value'];
    // encryptionmode
    var encyptionmode = list['SSIDProfile']['1']['EncryptionMode']['_value'];
    // SERCURITY
    String sercurity = encyptionmode.split('+')[0];
    // WPA ENCYPITON
    String wpaEncyption = encyptionmode.split('+').skip(1).join('+');
    // PASSWORD
    // 暂无PASSWORD
    setState(() {
      pdVal = 1;
      isCheck5 = enable;
      msVal5 = wifi5gModeV.indexOf(mode);
      kdVal5 = wifiChannelBandwidth5V.indexOf(bandwidth);
      xtVal5 = wifi5gCountryChannelList.indexOf(channel);
      // fsVal = txPower;

      ssid5.text = ssidText;
      max5.text = maxText.toString();
      ssidisCheck5 = hideBroadcast;
      apisCheck5 = isolation;
      aqVal5 = wpaOptionsV.indexOf(sercurity);
      wpaVal5 = wpajmOptionsV.indexOf(wpaEncyption);
    });
  }

  //提交
  void setData() async {
    if ((pdVal == 0 && isCheck)) {
      ssid.text == '';
      ToastUtils.waring('SSID ${S.current.notEmpty}');
    }
    if (pdVal == 1 && isCheck5) {
      ssid5.text == '';
      ToastUtils.waring('SSID ${S.current.notEmpty}');
    }
    String param;
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
              '{"wifiEnable":"1","wifiMode":"${wifiModeV[msVal]}","wifiHtmode":"${wifiChannelBandwidth[kdVal]}","wifiChannel":"${kdVal == 0 ? wifiCountryChannelListHT20[xtVal] : kdVal == 1 ? wifiCountryChannelListHT40j[xtVal] : wifiCountryChannelListHT40}","wifiTxpower":"${wifiTxpower[fsVal]}"}';
        } else {
          param =
              '{"wifiEnable":"1","wifiMode":"${wifiModeV[msVal]}",,"wifiChannel":"${kdVal == 0 ? wifiCountryChannelListHT20[xtVal] : kdVal == 1 ? wifiCountryChannelListHT40j[xtVal] : wifiCountryChannelListHT40}","wifiTxpower":"${wifiTxpower[fsVal]}"}';
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
        ToastUtils.error(S.current.error);
      }
    } catch (e) {
      ToastUtils.error(S.current.error);
    }
  }

  void setTab() async {
    String param;
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
        ToastUtils.success(S.current.success);
      } else {
        ToastUtils.error(S.current.error);
      }
    } catch (e) {
      ToastUtils.error(S.current.error);
    }
  }

  //读取
  void getData() async {
    // 请求的参数
    Map<String, dynamic> data = {
      'method': 'obj_get',
      'param':
          '["wifiBandGet","wifiEnable","wifiMode","wifiHtmode","wifiChannel","wifiTxpower","Ssid","MaxClient","SsidHide","ApIsolate","wlanencryption","wlanauthentication","Key","wifi5gEnable","wifi5gMode","wifi5gHtmode","wifi5gHtmode1","wifi5gChannel","wifi5gTxpower","Ssid5g","MaxClient5g","SsidHide5g","ApIsolate5g","wlanencryption5g","wlanauthentication5g","Key5g"]',
    };
    try {
      var response = await XHttp.get('/data.html', data);
      if (response == null || response.toString().isEmpty) {
        throw Exception('Response is empty.');
      }
      var d = json.decode(response.toString());
      setState(() {
        wlanData = wlanDatas.fromJson(d);
        updateState();
      });
    } catch (e) {
      // 异步出错goback
      Get.back();
    }
  }

  void updateState() {
    //SSID
    // wifiModeV.indexOf(wlanData.wifiMode.toString());
    if (!wifiModeV.contains(wlanData.wifiMode.toString())) {
      return;
    }
    msVal = wifiModeV.indexOf(wlanData.wifiMode.toString());
    msVal5 = wifi5gModeV.indexOf(wlanData.wifi5gMode.toString());
    kdVal = wifiChannelBandwidth.indexOf(wlanData.wifiHtmode.toString());
    kdVal5 = wifiChannelBandwidth5V.indexOf(wlanData.wifi5gHtmode.toString());
    fsVal = wifiTxpower.indexOf(wlanData.wifiTxpower.toString());
    fsVal5 = wifi5gTxpower.indexOf(wlanData.wifi5gTxpower.toString());

    // wlanData.wifiMode.
    if (wlanData.wifiHtmode.toString() == '20MHz') {
      xtVal =
          wifiCountryChannelListHT20.indexOf(wlanData.wifiChannel.toString());
    } else if (wlanData.wifiHtmode.toString() == '40+MHz') {
      xtVal =
          wifiCountryChannelListHT40j.indexOf(wlanData.wifiChannel.toString());
    } else if (wlanData.wifiHtmode.toString() == '40-MHz') {
      xtVal =
          wifiCountryChannelListHT40.indexOf(wlanData.wifiChannel.toString());
    }

    xtVal5 =
        wifi5gCountryChannelList.indexOf(wlanData.wifi5gChannel.toString());
    isCheck = wlanData.wifiEnable == '1';
    isCheck5 = wlanData.wifi5gEnable == '1';

    printInfo(info: 'wlanData$wlanData');
  }

// 读取Channel
  void addChannelList(List<String> list, String? channelList) {
    if (channelList != null) {
      list.addAll(channelList.split(';'));
    }
  }

  void getList() async {
    Map<String, dynamic> data = {
      'method': 'obj_get',
      'param':
          '["wifiCountryChannelList_HT20","wifiCountryChannelList_HT40+","wifiCountryChannelList_HT40-","wifiHtmode","wifi5gCountryChannelList"]',
    };
    var response = await XHttp.get('/data.html', data);
    Map<String, dynamic> d;
    try {
      d = json.decode(response.toString());
    } catch (e) {
      throw Exception('Failed to decode config data: $e');
    }
    setState(() {
      channelLists = channelList.fromJson(d);
      debugPrint("+++++++++++++++$channelLists");

      addChannelList(
          wifi5gCountryChannelList, channelLists.wifi5gCountryChannelList);
      addChannelList(
          wifiCountryChannelListHT20, channelLists.wifiCountryChannelListHT20);
      addChannelList(wifiCountryChannelListHT40j,
          channelLists.wifiCountryChannelListHT40j);
      addChannelList(
          wifiCountryChannelListHT40, channelLists.wifiCountryChannelListHT40);
    });
    getData();
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
        appBar: customAppbar(context: context, title: S.of(context).wlanSet),
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
                  TitleWidger(title: S.of(context).General),
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
                            result?.then((selectedValue) {
                              if (pdVal != selectedValue &&
                                  selectedValue != null) {
                                setState(() {
                                  pdVal = selectedValue;
                                  if (selectedValue == 0) {
                                    get24gList();
                                  } else if (selectedValue == 1) {
                                    get5gList();
                                  }
                                });
                              }
                            });
                          },
                          child: BottomLine(
                            rowtem: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  S.of(context).Band,
                                  style: TextStyle(
                                      color: const Color.fromARGB(255, 5, 0, 0),
                                      fontSize: 28.sp),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      ['2.4GHz', '5GHz'][pdVal],
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 5, 0, 0),
                                          fontSize: 28.sp),
                                    ),
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
                        //WLAN
                        BottomLine(
                          rowtem: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'WLAN',
                                style: TextStyle(
                                    color: const Color.fromARGB(255, 5, 0, 0),
                                    fontSize: 28.sp),
                              ),
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
                                                {
                                                  msVal = selectedValue,
                                                  kdVal = 0
                                                }
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(S.of(context).Mode,
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 5, 0, 0),
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
                                                {
                                                  kdVal = selectedValue,
                                                  xtVal = 0
                                                }
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(S.of(context).Bandwidth,
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 5, 0, 0),
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
                                        ? wifiCountryChannelListHT20
                                        : kdVal == 1
                                            ? wifiCountryChannelListHT40j
                                            : wifiCountryChannelListHT40,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(S.of(context).Channel,
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 5, 0, 0),
                                          fontSize: 28.sp)),
                                  Row(
                                    children: [
                                      Text(
                                          pdVal == 1
                                              ? wifi5gCountryChannelList[xtVal5]
                                              : kdVal == 0
                                                  ? wifiCountryChannelListHT20[
                                                      xtVal]
                                                  : kdVal == 1
                                                      ? wifiCountryChannelListHT40j[
                                                          xtVal]
                                                      : wifiCountryChannelListHT40[
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
                            child: BottomLine(
                              rowtem: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(S.of(context).TxPower,
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 5, 0, 0),
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
                    ),
                  ),
                  //配置
                  if (pdVal == 0 ? isCheck : isCheck5)
                    TitleWidger(title: S.of(context).Configuration),
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
                                    color: const Color(0xff051220),
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "${S.current.enter}SSID",
                                    hintStyle: TextStyle(
                                      fontSize: 26.sp,
                                      color: const Color(0xff737A83),
                                    ),
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
                              Text(S.of(context).Maximum,
                                  style: TextStyle(
                                      color: const Color.fromARGB(255, 5, 0, 0),
                                      fontSize: 28.sp)),
                              SizedBox(
                                width: 250.w,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(
                                          r'^[1-6][0-4]$|^[1-9]$|^[1-5][0-9]$'),
                                    )
                                  ],
                                  textAlign: TextAlign.right,
                                  controller: pdVal == 0 ? max : max5,
                                  style: TextStyle(
                                      fontSize: 26.sp,
                                      color: const Color(0xff051220)),
                                  decoration: InputDecoration(
                                    hintText: S.of(context).MaximumRange,
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
                              Text(S.of(context).HideSSIDBroadcast,
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
                                        } else {
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
                              Text(S.of(context).APIsolation,
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
                                Text(S.of(context).Security,
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
                                  Text(S.of(context).WPAEncry,
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
                          BottomLine(
                            rowtem: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  S.of(context).Password,
                                  style: TextStyle(
                                      color: const Color.fromARGB(255, 5, 0, 0),
                                      fontSize: 28.sp),
                                ),
                                SizedBox(
                                  width: 250.w,
                                  child: TextFormField(
                                    autovalidateMode: AutovalidateMode.always,
                                    obscureText: passwordValShow,
                                    textAlign: TextAlign.right,
                                    controller:
                                        pdVal == 0 ? password : password5,
                                    style: TextStyle(
                                        fontSize: 26.sp,
                                        color: const Color(0xff051220)),
                                    decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              passwordValShow =
                                                  !passwordValShow;
                                            });
                                          },
                                          icon: Icon(!passwordValShow
                                              ? Icons.visibility
                                              : Icons.visibility_off)),
                                      hintText: S.current.enter +
                                          S.current.newPassowld,
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
                      ],
                    )),
                  Padding(
                      padding: EdgeInsets.only(top: 10.w, bottom: 50.w),
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
                            S.current.save,
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
