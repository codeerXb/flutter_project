// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:flutter_template/core/widget/common_picker.dart';
import 'package:flutter_template/core/widget/water_loading.dart';
import 'package:flutter_template/pages/wifi_set/wlan/wlan_datas.dart';
import 'package:flutter_template/pages/wifi_set/wlan/channel_list.dart';
import 'package:get/get.dart';
import '../../../core/http/http_app.dart';
import '../../../core/utils/shared_preferences_util.dart';
import '../../../core/widget/custom_app_bar.dart';
import '../../../generated/l10n.dart';
import '../../login/login_controller.dart';
import 'wifi5g_table.dart';
import 'wifi_table.dart';
import 'package:flutter_template/core/request/request.dart';
import '../visitor/guest_model.dart';
import '../wlan/wlanBeans.dart';
import '../wlan/wlan5gBeans.dart';

/// WLAN设置
class WlanSet extends StatefulWidget {
  const WlanSet({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WlanSetState();
}

class _WlanSetState extends State<WlanSet> {
  bool loading = false;

  wlanDatas wlanData = wlanDatas();
  //频段 id 1 ,0 启用Enable 0,1
  String bandShowVal = '2.4GHz';
  channelList channelLists = channelList();
  wifiSsidTable wifiSsidTableLists = wifiSsidTable();
  wifi5GSsidTable wifi5GSsidTableLists = wifi5GSsidTable();
  // 频段的索引值（0:2.4g,1:5g）
  int bandIndex = 0;

  // 模型数据
  guestModel? dataModel;
  // 模型数据
  guestModel? wlanModel;
  //模式
  // 2.4g
  // 传值
  List<String> modeVal = [
    '11b',
    '11g',
    '11n',
    '11bg',
    '11bgn',
    '11ax',
    // '11axg',
    // '11ng'
  ];
  // 2.4G  选项显示
  List<String> modeOpt = [
    '802.11b Only',
    '802.11g Only',
    '802.11n Only',
    '802.11b/g',
    '802.11b/g/n(Auto)',
    '802.11ax Only',
  ];

  // 2.4G  20选项显示
  List<String> modeH20Option = [
    '802.11b Only',
    '802.11g Only',
    '802.11b/g',
    '802.11b/g/n(Auto)'
  ];

  // 2.4G  20/40选项显示
  List<String> modeH40Option = [
    '802.11n Only',
    '802.11ax Only',
  ];

  List<String> bandWidthH20Option = ['20MHz'];

  // 5g
  // 传值
  List<String> modeVal5g = [
    '11a',
    '11n',
    '11a/n',
    '11an/ac',
    '11a/an/ac',
    '11ax',
    // '11axa',
    // '11na',
    // '11ac'
  ];
  // 5G 选项显示
  List<String> modeValOpt = [
    '802.11a Only',
    '802.11n Only',
    '802.11a/n',
    '802.11n/ac',
    '802.11a/n/ac(Auto)',
    '802.11ax Only',
  ];

  // 5G 20M选项显示
  List<String> modeVal20Option = ['802.11a Only'];

  // 5G 20/40选项显示
  List<String> modeVal40MOption = ['802.11n Only', '802.11a/n'];

  // 5G 20/40/80选项显示
  List<String> modeVal80MOption = ['802.11n/ac', '802.11a/n/ac(Auto)'];

  // 5G 160选项显示
  List<String> modeVal160MOption = ['802.11ax Only'];

  // 2.4g索引值
  int modeIndex = 0;
  // 5g索引值
  int modeIndex5g = 0;

  // 带宽
  int bandWidthIndex = 0;
  int bandWidthIndex5g = 0;
  // 2.4g 选项显示
  List<String> bandWidthOptVal = ['20MHz', '20/40MHz'];
  // 2.4g传值的内容
  List<String> bandWidthVal = ['HT20', 'HT40'];

  // 5g选项显示
  List<String> bandWidthOpt5g = [
    '20MHz',
    '20/40MHz',
    '20/40/80MHz',
    '20/40/80/160MHz',
  ];

  // 5g选项显示
  List<String> bandWidth20Option5g = ['20MHz'];

  List<String> bandWidth40Option5g = ['20MHz', '20/40MHz'];

  List<String> bandWidth80Option5g = ['20MHz', '20/40MHz', '20/40/80MHz'];

  // 5g传值的内容
  List<String> bandWidthVal5g = [
    'HT20',
    'HT40',
    'HT80',
    'HT160',
  ];

  List<String> bandWidth40Val5g = ['HT20', 'HT40'];

  List<String> bandWidth80Val5g = ['HT20', 'HT40', 'HT80'];

  // Channel 通道的选项和值
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

  // security
  // 显示的选项
  List<String> securityOpt = [
    'WPA2-PSK',
    'WPA-PSK&WPA2-PSK',
    "WPA3-PSK",
    'WPA2-PSK&WPA3-PSK',
    S.current.emptyNORecommend
  ];

  List<String> securityWpa2Option = ['WPA2-PSK', 'WPA-PSK&WPA2-PSK'];

  List<String> securityWpa3Option = ['WPA3-PSK', 'WPA2-PSK&WPA3-PSK'];

  // 对应的value
  List<String> securityVal = ['psk2', 'psk-mixed', 'wpa3', 'wpa2wpa3', 'none'];
  //安全 security
  String securityShowVal = 'WPA2-PSK';
  int securityIndex = 0;
  int securityIndex5g = 0;

  // wpa encryption
  // 显示的选项
  List<String> encryptionOpt = [
    S.current.aesRecommend,
    'TKIP',
    'TKIP&AES',
  ];
  List<String> encryptionWpa3Option = [S.current.aesRecommend];
  // 对应的value
  List<String> encryptionVal = [
    'aes',
    'tkip',
    'tkip+aes',
  ];
  //WPA加密 wpa encryption
  String encryptionShowVal = S.current.aesRecommend;
  int encryptionIndex = 0;
  int encryptionIndex5g = 0;

  // 信道
  String channelShowVal = 'Auto';
  int channelIndex = 0;
  int channelIndex5g = 0;

  // 密码
  bool passwordValHidden = true;

  // 发射功率
  String txPowerShowVal = '';
  String txPower5gShowVal = '';
  // 发射功率对应到节点数据
  // 2.4g发射功率对应关系
  List<String> wifiTxpower = [
    "100",
    '80',
    '40',
    '20',
  ];
  // 5g发射功率对应关系
  List<String> wifi5gTxpower = ['100', '80', '40', "20"];
  // 选择的索引值
  int txPowerIndex = 0;
  int txPowerIndex5g = 0;

  // check
  bool isCheck = false;
  bool isCheck5 = false;
  bool apisCheck = false;
  bool apisCheck5 = false;
  bool ssidisCheck5 = false;
  bool ssidisCheck = false;
  final TextEditingController ssid = TextEditingController();
  final TextEditingController ssid5 = TextEditingController();
  final TextEditingController max = TextEditingController();
  final TextEditingController max5 = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController password5 = TextEditingController();
  final LoginController loginController = Get.put(LoginController());

  String sn = '';
  bool _isLoading = false;
  List<String> bandOptions = [];
  List<String> band5GOptions = [];

  List<String> wpaEncryOptions = [];
  List<String> wpaEncryOptions5G = [];

  // 点击空白  关闭键盘 时传的一个对象
  FocusNode blankNode = FocusNode();

  /// 点击空白  关闭输入键盘
  void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(blankNode);
  }

  @override
  void initState() {
    super.initState();
    sharedGetData('deviceSn', String).then((value) {
      sn = value.toString();
      if (mounted) {
        // setState(() {
        //   _isLoading = true;
        // });
        get24gList();
        // if (loginController.login.state == 'cloud' && sn.isNotEmpty) {
        //   // 云端请求赋值

        //   // await getWifiCountryChannelList();
        // }
        // if (loginController.login.state == 'local') {
        //   // 本地请求赋值
        //   await getList();
        //   await getWiFiSsidTable();
        //   await getWiFi5GSsidTable();
        // }
        // setState(() {
        //   _isLoading = false;
        // });
      }
    });
  }

  // 获取WIFI信道列表(废弃)
  /*
  getWifiCountryChannelList() async {
    var data = {
      'sn': sn,
      'type': 'getWifiCountryChannelList',
    };
    var res = await App.post('/cpeMqtt/getWifiCountryChannelList', data: data);
    var d = json.decode(res.toString());
    if (d['code'] != 200) {
      ToastUtils.error(d['message']);
    } else {
      setState(() {
        // 20
        wifiCountryChannelListHT20 = [
          "auto",
          ...d['data']['wifiCountryChannelList_HT20'].split(';')
        ];
        // 40+
        wifiCountryChannelListHT40j = [
          "auto",
          ...d['data']['wifiCountryChannelList_HT40+'].split(';')
        ];
        // 40-
        wifiCountryChannelListHT40 = [
          "auto",
          ...d['data']['wifiCountryChannelList_HT40-'].split(';')
        ];
        // 5G
        wifi5gCountryChannelList = [
          "auto",
          ...d['data']['wifi5gCountryChannelList'].split(';')
        ];
      });
    }
  }
*/
  /// 云端获取接口
  // 2.4g
  Future get24gList() async {
    setState(() {
      loading = true;
      _isLoading = true;
    });

    Object? sn = await sharedGetData('deviceSn', String);
    // 获取SOD节点数据
    var parameterNames = {
      "method": "get",
      "nodes": [
        "wifiEnable",
        "wifiMode",
        "wifiHtmode",
        "wifiChannel",
        "wifiTxpower",
        "wifiCountryChannelList_HT20",
        "wifiCountryChannelList_HT40",
        "wifiCountryChannelList"
      ]
    };
    // 获取SOD节点数据
    var res = await Request().getACSNode(parameterNames, sn);
    var jsonObj = jsonDecode(res);
    var jsonModel = wlanBean.fromJson(jsonObj);
    debugPrint('wlan节点数据:----$jsonObj----}');
    // 获取SOD表数据
    var parameters = {"method": "get", "table": "WiFiSsidTable"};
    var result = await Request().getSODTable(parameters, sn);
    var jsonRes = jsonDecode(result);
    var model = guestModel.fromJson(jsonRes);
    dataModel = model;
    debugPrint('2.4G wlan表获取的数据:-----$jsonRes ----');

    try {
      // WLAN Enable
      bool enable = jsonModel.data!.wifiEnable == "0" ? false : true;
      // Mode
      String mode = jsonModel.data!.wifiMode ?? "";
      // Bandwidth
      String bandwidth = jsonModel.data!.wifiHtmode ?? "";
      // Channel
      String channel = jsonModel.data!.wifiChannel ?? "";
      // TX Power
      String txPower = jsonModel.data!.wifiTxpower ?? "";

      String channel_HT20 = jsonModel.data!.wifiCountryChannelListHT20 ?? "";

      String channelList = jsonModel.data!.wifiCountryChannelList ?? "";

      String channel_HT40 = jsonModel.data!.wifiCountryChannelListHT40 ?? "";
      debugPrint(
          'channel_HT20:${jsonModel.data!.wifiCountryChannelListHT20} -- channelList:${jsonModel.data!.wifiCountryChannelList}');
      // SSID
      String ssidText = model.data![0].ssid ?? "";
      // MAX
      String maxText = model.data![0].maxClient ?? "";
      // HIDE BROADCAST
      bool hideBroadcast = model.data![0].ssidHide == "0" ? false : true;
      // AP Isolation
      bool isolation = model.data![0].apIsolate == "0" ? false : true;
      // encryptionmode
      String encyptionmode = model.data![0].encryption ?? "";
      // SERCURITY
      String sercurity = encyptionmode.split('+')[0];
      // WPA ENCYPITON
      String wpaEncyption = "";
      if (encyptionmode == "psk2+tkip+aes" ||
          encyptionmode == "psk-mixed+tkip+aes") {
        wpaEncyption = encyptionmode.split('+').skip(1).join('+');
      } else {
        wpaEncyption = encyptionmode.split('+')[1];
      }
      // String wpaEncyption = encyptionmode.split('+').skip(1).join('+');
      // PASSWORD
      String wpaKey = model.data![0].key ?? "";
      setState(() {
        bandIndex = 0;
        isCheck = enable;
        modeIndex = modeVal.indexOf(mode);
        wifiCountryChannelListHT20 = ["auto", ...channelList.split(';')];
        wifiCountryChannelListHT40 = ["auto", ...channel_HT40.split(';')];
        bandWidthIndex = bandWidthVal.indexOf(bandwidth);
        if (channel.isNotEmpty) {
          channelIndex = wifiCountryChannelListHT20.indexOf(channel);
        }

        if (modeH20Option.contains(modeOpt[modeIndex])) {
          bandOptions = bandWidthH20Option;
        } else if (modeH40Option.contains(modeOpt[modeIndex])) {
          bandOptions = bandWidthOptVal;
        }

        for (var i = 0; i < wifiTxpower.length; i++) {
          if (txPower == wifiTxpower[i]) {
            txPowerIndex = i;
          }
        }
        ssid.text = ssidText;
        max.text = maxText.toString();
        ssidisCheck = hideBroadcast;
        apisCheck = isolation;
        securityIndex = securityVal.indexOf(sercurity);
        encryptionIndex = encryptionVal.indexOf(wpaEncyption);
        if (securityIndex < 0 || encryptionIndex < 0) {
          securityIndex = 0;
          encryptionIndex = 0;
        }
        if (securityWpa2Option.contains(securityOpt[securityIndex])) {
          wpaEncryOptions = encryptionOpt;
        } else if (securityWpa3Option.contains(securityOpt[securityIndex])) {
          wpaEncryOptions = encryptionWpa3Option;
        } else {}

        password.text = wpaKey;
      });
    } catch (err) {
      debugPrint('get2.4G ERROR: $err');
      ToastUtils.error('Request Failed');
      setState(() {
        loading = false;

        _isLoading = false;
      });
      // Get.back();
    } finally {
      setState(() {
        loading = false;

        _isLoading = false;
      });
    }
  }

  // 5g
  Future get5gList() async {
    setState(() {
      loading = true;

      _isLoading = true;
    });
    // 获取SOD节点数据
    var parameterNames = {
      "method": "get",
      "nodes": [
        "wifi5gEnable",
        "wifi5gMode",
        "wifi5gHtmode",
        "wifi5gChannel",
        "wifi5gTxpower",
        "wifi5gCountryChannelList"
      ]
    };

    try {
      Object? sn = await sharedGetData('deviceSn', String);
      var res = await Request().getACSNode(parameterNames, sn);
      var jsonObj = jsonDecode(res);
      var jsonModel = wlanAdvancedBean.fromJson(jsonObj);
      debugPrint('wlan_5g数据:$jsonObj');
      // 获取SOD表数据
      var parameters = {"method": "get", "table": "WiFi5GSsidTable"};
      var result = await Request().getSODTable(parameters, sn);
      var jsonRes = jsonDecode(result);
      var model = guestModel.fromJson(jsonRes);
      wlanModel = model;
      debugPrint('5G wlan获取的数据:$jsonRes');
      // WLAN Enable
      bool enable = jsonModel.data!.wifi5gEnable == "0" ? false : true;
      // Mode
      String mode = jsonModel.data!.wifi5gMode ?? "";
      // Bandwidth
      String bandwidth = jsonModel.data!.wifi5gHtmode ?? "";
      // Channel
      String channel = jsonModel.data!.wifi5gChannel ?? "";
      // TX Power
      String txPower = jsonModel.data!.wifi5gTxpower ?? "";

      String channel_5G_List = jsonModel.data!.wifi5gCountryChannelList ?? "";
      // SSID
      String ssidText = model.data![0].ssid ?? "";
      // MAX
      String maxText = model.data![0].maxClient ?? "";
      // HIDE BROADCAST
      bool hideBroadcast = model.data![0].ssidHide == "0" ? false : true;
      // AP Isolation
      bool isolation = model.data![0].apIsolate == "0" ? false : true;
      // encryptionmode
      var encyptionmode = model.data![0].encryption ?? "";
      // SERCURITY
      String sercurity = encyptionmode.split('+')[0];
      // WPA ENCYPITON
      // String wpaEncyption = encyptionmode.split('+').skip(1).join('+');
      String wpaEncyption = "";
      if (encyptionmode == "psk2+tkip+aes" ||
          encyptionmode == "psk-mixed+tkip+aes") {
        wpaEncyption = encyptionmode.split('+').skip(1).join('+');
      } else {
        wpaEncyption = encyptionmode.split('+')[1];
      }
      debugPrint("获取到的encyptionmode:$encyptionmode");
      debugPrint("获取到的wpaEncyption:$wpaEncyption");
      // PASSWORD
      String wpaKey = model.data![0].key ?? "";

      setState(() {
        bandIndex = 1;
        isCheck5 = enable;
        modeIndex5g = modeVal5g.indexOf(mode);
        wifi5gCountryChannelList = ["auto", ...channel_5G_List.split(';')];
        bandWidthIndex5g = bandWidthVal5g.indexOf(bandwidth);
        if (channel.isNotEmpty) {
          channelIndex5g = wifi5gCountryChannelList.indexOf(channel);
        }

        if (modeVal20Option.contains(modeValOpt[modeIndex5g])) {
          band5GOptions = bandWidth20Option5g;
        } else if (modeVal40MOption.contains(modeValOpt[modeIndex5g])) {
          band5GOptions = bandWidth40Option5g;
        } else if (modeVal80MOption.contains(modeValOpt[modeIndex5g])) {
          band5GOptions = bandWidth80Option5g;
        } else {
          band5GOptions = bandWidthOpt5g;
        }

        debugPrint("获取到的索引:$modeIndex5g - $bandWidthIndex5g - $channelIndex5g");
        // fsVal5 = txPower;
        // if (txPower == wifi5gTxpower[0]) {
        //   txPowerIndex5g = 0;
        // } else if (txPower == wifi5gTxpower[1]) {
        //   txPowerIndex5g = 1;
        // } else {
        //   txPowerIndex5g = 2;
        // }

        for (var i = 0; i < wifi5gTxpower.length; i++) {
          if (txPower == wifi5gTxpower[i]) {
            txPowerIndex5g = i;
          }
        }

        ssid5.text = ssidText;
        max5.text = maxText.toString();
        ssidisCheck5 = hideBroadcast;
        apisCheck5 = isolation;
        securityIndex5g = securityVal.indexOf(sercurity);
        encryptionIndex5g = encryptionVal.indexOf(wpaEncyption);
        debugPrint("获取到的索引2:$securityIndex5g - $encryptionIndex5g");
        if (securityWpa2Option.contains(securityOpt[securityIndex5g])) {
          wpaEncryOptions5G = encryptionOpt;
        } else if (securityWpa3Option
            .contains(securityOpt[securityIndex5g])) {
          wpaEncryOptions5G = encryptionWpa3Option;
        } else {}
        password5.text = wpaKey;
      });
    } catch (err) {
      debugPrint('get5G ERROR: $err');
      ToastUtils.error('Request Failed');
      // Get.back();
    } finally {
      setState(() {
        loading = false;
        _isLoading = false;
      });
    }
  }

  // 云2.4G设置数据
  setWlanData() async {
    Object? sn = await sharedGetData('deviceSn', String);
    debugPrint("当前获取的2.4G模型数据:$dataModel");
    var parameterNames = {
      "method": "set",
      "table": {
        "table": "WiFiSsidTable",
        "value": [
          {
            "id": dataModel!.data![0].id,
            "Enable": isCheck == false ? "0" : "1",
            "SsidHide": ssidisCheck == false ? "0" : "1",
            "ApIsolate": apisCheck == false ? "0" : "1",
            "ShowPasswd": dataModel!.data![0].showPasswd,
            "Is4Guest": dataModel!.data![0].is4Guest,
            "PasswordLength": dataModel!.data![0].passwordLength,
            "PasswordIndex": dataModel!.data![0].passwordIndex,
            "MaxClient": max.text,
            "Ssid": ssid.text,
            "Key": password.text,
            "Password1": dataModel!.data![0].password1,
            "Password2": dataModel!.data![0].password2,
            "Password3": dataModel!.data![0].password3,
            "Password4": dataModel!.data![0].password4,
            "Encryption":
                '${securityVal[securityIndex]}+${encryptionVal[encryptionIndex]}',
            "SsidMac": dataModel!.data![0].ssidMac,
            "AllowAccessIntranet": dataModel!.data![0].allowAccessIntranet,
            "wifiRadiusServerIP": dataModel!.data![0].wifiRadiusServerIP,
            "wifiRadiusServerPort": dataModel!.data![0].wifiRadiusServerPort,
            "wifiRadiusSharedKey": dataModel!.data![0].wifiRadiusSharedKey
          }
        ]
      }
    };

    var maxNum = int.parse(max.text);
    if (maxNum > 32) {
      ToastUtils.toast(
          "The maximum number of supported connected devices is 32");
      return;
    }
    if (password.text.length < 8 || password.text.length > 16) {
      ToastUtils.toast("Password cannot exceed 8 characters");
      return;
    }

    try {
      var res = await Request().setSODTable(parameterNames, sn);
      var jsonObj = jsonDecode(res);
      printInfo(info: '----$jsonObj');
      if (jsonObj['code'] == 200) {
        ToastUtils.toast('Save success');
      }
    } catch (e) {
      printError(info: e.toString());
    }

    var wifiHtModel = "";
    if (modeH20Option.contains(modeOpt[modeIndex])) {
      wifiHtModel = bandWidthVal[0];
    } else if (modeH40Option.contains(modeOpt[modeIndex])) {
      wifiHtModel = bandWidthVal[bandWidthIndex];
    } else {}

    var parameters = {
      "method": "set",
      "nodes": {
        "wifiEnable": isCheck == false ? "0" : "1",
        "wifiMode": modeVal[modeIndex],
        "wifiHtmode": wifiHtModel,
        "wifiChannel": wifiCountryChannelListHT20[channelIndex],
        "wifiTxpower": wifiTxpower[txPowerIndex]
      }
    };

    try {
      var res = await Request().setACSNode(parameters, sn);
      var jsonObj = jsonDecode(res);
      printInfo(info: 'wlanSet:$jsonObj');
      if (jsonObj['code'] == 200) {
        ToastUtils.toast(S.current.success);
      } else {
        ToastUtils.error('Request Failed');
      }
      setState(() {});
    } catch (e) {
      debugPrint('获取信息失败：${e.toString()}');
      ToastUtils.error('Request Failed');
      Get.back();
    }
  }

  // 云5G 设置数据
  setAdvancedWlanData() async {
    Object? sn = await sharedGetData('deviceSn', String);
    debugPrint("当前获取的5G模型数据:$wlanModel");
    var parameterNames = {
      "method": "set",
      "table": {
        "table": "WiFi5GSsidTable",
        "value": [
          {
            "id": wlanModel!.data![0].id,
            "Enable": isCheck5 == false ? "0" : "1",
            "SsidHide": ssidisCheck5 == false ? "0" : "1",
            "ApIsolate": apisCheck5 == false ? "0" : "1",
            "ShowPasswd": wlanModel!.data![0].showPasswd,
            "Is4Guest": wlanModel!.data![0].is4Guest,
            "PasswordLength": wlanModel!.data![0].passwordLength,
            "PasswordIndex": wlanModel!.data![0].passwordIndex,
            "MaxClient": max5.text,
            "Ssid": ssid5.text,
            "Key": password5.text,
            "Password1": wlanModel!.data![0].password1,
            "Password2": wlanModel!.data![0].password2,
            "Password3": wlanModel!.data![0].password3,
            "Password4": wlanModel!.data![0].password4,
            "Encryption":
                '${securityVal[securityIndex5g]}+${encryptionVal[encryptionIndex5g]}',
            "SsidMac": wlanModel!.data![0].ssidMac,
            "AllowAccessIntranet": wlanModel!.data![0].allowAccessIntranet,
            "wifiRadiusServerIP": wlanModel!.data![0].wifiRadiusServerIP,
            "wifiRadiusServerPort": wlanModel!.data![0].wifiRadiusServerPort,
            "wifiRadiusSharedKey": wlanModel!.data![0].wifiRadiusSharedKey
          }
        ]
      }
    };

    var maxNum = int.parse(max5.text);
    if (maxNum > 32) {
      ToastUtils.toast(
          "The maximum number of supported connected devices is 32");
      return;
    }
    if (password5.text.length < 8 || password5.text.length > 16) {
      ToastUtils.toast("Password cannot exceed 8 characters");
      return;
    }

    try {
      var res = await Request().setSODTable(parameterNames, sn);
      var jsonObj = jsonDecode(res);
      printInfo(info: '----$jsonObj');
      if (jsonObj['code'] == 200) {
        ToastUtils.toast('Save success');
      }
    } catch (e) {
      printError(info: e.toString());
      ToastUtils.error('Request Failed');
    }

    var wifi5GHtMode = "";
    if (modeVal20Option.contains(modeValOpt[modeIndex5g])) {
      wifi5GHtMode = bandWidthVal5g[0];
    } else if (modeVal40MOption.contains(modeValOpt[modeIndex5g])) {
      wifi5GHtMode = bandWidth40Val5g[bandWidthIndex5g];
    } else if (modeVal80MOption.contains(modeValOpt[modeIndex5g])) {
      wifi5GHtMode = bandWidth80Val5g[bandWidthIndex5g];
    } else {
      wifi5GHtMode = bandWidthVal5g[bandWidthIndex5g];
    }

    var parameters = {
      "method": "set",
      "nodes": {
        "wifi5gEnable": isCheck5 == false ? "0" : "1",
        "wifi5gMode": modeVal5g[modeIndex5g],
        "wifi5gHtmode": wifi5GHtMode,
        "wifi5gChannel": wifi5gCountryChannelList[channelIndex5g],
        "wifi5gTxpower": wifi5gTxpower[txPowerIndex5g]
      }
    };

    try {
      var res = await Request().setACSNode(parameters, sn);
      var jsonObj = jsonDecode(res);
      printInfo(info: 'wlanSet:$jsonObj');
      if (jsonObj['code'] == 200) {
        ToastUtils.toast(S.current.success);
      } else {
        ToastUtils.error('Request Failed');
      }
      setState(() {});
    } catch (e) {
      debugPrint('获取信息失败：${e.toString()}');
      ToastUtils.error('Request Failed');
      // Get.back();
    }
  }

  // 保存配置
  Future setList() async {
    // 定义前缀,2.4g pdVal为0 5g 为1
    if (bandIndex == 0) {
      // 2.4G设置
      setWlanData();
    } else {
      // 5G设置
      setAdvancedWlanData();
    }
  }

  // 提交
  // Future setData() async {
  //   if ((bandIndex == 0 && isCheck)) {
  //     ssid.text == '';
  //     ToastUtils.waring('SSID ${S.current.notEmpty}');
  //   }
  //   if (bandIndex == 1 && isCheck5) {
  //     ssid5.text == '';
  //     ToastUtils.waring('SSID ${S.current.notEmpty}');
  //   }
  //   String param;
  //   if (bandIndex == 1) {
  //     if (isCheck5) {
  //       if (modeIndex5g < 3) {
  //         param =
  //             '{"wifi5gEnable":"1","wifi5gMode":"${modeVal5g[modeIndex5g]}","wifi5gHtmode":"${bandWidthVal5g[bandWidthIndex5g]}","wifi5gChannel":"${wifi5gCountryChannelList[channelIndex5g]}","wifi5gTxpower":"${wifi5gTxpower[txPowerIndex5g]}"}';
  //       } else {
  //         param =
  //             '{"wifi5gEnable":"1","wifi5gMode":"${modeVal5g[modeIndex5g]}","wifi5gChannel":"${wifi5gCountryChannelList[channelIndex5g]}","wifi5gTxpower":"${wifi5gTxpower[txPowerIndex5g]}"}';
  //       }
  //     } else {
  //       param = '{"wifi5gEnable": "0"}';
  //     }
  //   } else {
  //     if (isCheck) {
  //       if (modeIndex < 2) {
  //         param =
  //             '{"wifiEnable":"1","wifiMode":"${modeVal[modeIndex]}","wifiHtmode":"${bandWidthVal[bandWidthIndex]}","wifiChannel":"${bandWidthIndex == 0 ? wifiCountryChannelListHT20[channelIndex] : bandWidthIndex == 1 ? wifiCountryChannelListHT40j[channelIndex] : wifiCountryChannelListHT40}","wifiTxpower":"${wifiTxpower[txPowerIndex]}"}';
  //       } else {
  //         param =
  //             '{"wifiEnable":"1","wifiMode":"${modeVal[modeIndex]}",,"wifiChannel":"${bandWidthIndex == 0 ? wifiCountryChannelListHT20[channelIndex] : bandWidthIndex == 1 ? wifiCountryChannelListHT40j[channelIndex] : wifiCountryChannelListHT40}","wifiTxpower":"${wifiTxpower[txPowerIndex]}"}';
  //       }
  //     } else {
  //       param = '{"wifiEnable": "0"}';
  //     }
  //   }
  //   Map<String, dynamic> data = {'method': 'obj_set', 'param': param};
  //   try {
  //     var response = await XHttp.get('/data.html', data);
  //     var d = json.decode(response.toString());
  //     if (d['success'] == true) {
  //       if ((bandIndex == 0 && isCheck) || (bandIndex == 1 && isCheck5)) {
  //         setTab();
  //       }
  //     } else {
  //       ToastUtils.error(S.current.error);
  //     }
  //   } catch (e) {
  //     ToastUtils.error(S.current.error);
  //   }
  // }

  // void setTab() async {
  //   String param;
  //   if (bandIndex == 0) {
  //     param =
  //         '{"table":"WiFiSsidTable","value":[{"id":0,"Enable":"1","Ssid":"${ssid.text}","MaxClient":"${max.text}","SsidHide":"${ssidisCheck ? 1 : 0}","ApIsolate":"${apisCheck ? 1 : 0}","Encryption":"${securityVal[securityIndex]}+${encryptionVal[encryptionIndex]}","Key":"${password.text}"}]}';
  //   } else {
  //     param =
  //         '{"table":"WiFi5GSsidTable","value":[{"id":0,"Enable":"1","Ssid":"${ssid5.text}","MaxClient":"${max5.text}","SsidHide":"${ssidisCheck5 ? 1 : 0}","ApIsolate":"${apisCheck5 ? 1 : 0}","Encryption":"${securityVal[securityIndex5g]}+${encryptionVal[encryptionIndex5g]}","Key":"${password5.text}"}]}';
  //   }
  //   Map<String, dynamic> data = {'method': 'tab_set', 'param': param};
  //   try {
  //     var response = await XHttp.get('/data.html', data);
  //     var d = json.decode(response.toString());
  //     if (d['success'] == true) {
  //       ToastUtils.success(S.current.success);
  //     } else {
  //       ToastUtils.error(S.current.error);
  //     }
  //   } catch (e) {
  //     ToastUtils.error(S.current.error);
  //   }
  // }

  //读取
  // void getData() async {
  //   // 请求的参数
  //   Map<String, dynamic> data = {
  //     'method': 'obj_get',
  //     'param':
  //         '["wifiBandGet","wifiEnable","wifiMode","wifiHtmode","wifiChannel","wifiTxpower","Ssid","MaxClient","SsidHide","ApIsolate","wlanencryption","wlanauthentication","Key","wifi5gEnable","wifi5gMode","wifi5gHtmode","wifi5gHtmode1","wifi5gChannel","wifi5gTxpower","Ssid5g","MaxClient5g","SsidHide5g","ApIsolate5g","wlanencryption5g","wlanauthentication5g","Key5g"]',
  //   };
  //   try {
  //     var response = await XHttp.get('/data.html', data);
  //     if (response == null || response.toString().isEmpty) {
  //       throw Exception('Response is empty.');
  //     }
  //     var d = json.decode(response.toString());
  //     setState(() {
  //       wlanData = wlanDatas.fromJson(d);
  //       updateState();
  //     });
  //   } catch (e) {
  //     ToastUtils.error('Request Failed');
  //     // 异步出错goback
  //     // Get.back();
  //   }
  // }
/*
  void updateState() {
    //SSID
    // wifiModeV.indexOf(wlanData.wifiMode.toString());
    if (!modeVal.contains(wlanData.wifiMode.toString())) {
      return;
    }
    modeIndex = modeVal.indexOf(wlanData.wifiMode.toString());
    modeIndex5g = modeVal5g.indexOf(wlanData.wifi5gMode.toString());
    bandWidthIndex = bandWidthVal.indexOf(wlanData.wifiHtmode.toString());
    bandWidthIndex5g = bandWidthVal5g.indexOf(wlanData.wifi5gHtmode.toString());
    txPowerIndex = wifiTxpower.indexOf(wlanData.wifiTxpower.toString());
    txPowerIndex5g = wifi5gTxpower.indexOf(wlanData.wifi5gTxpower.toString());

    // wlanData.wifiMode.
    // if (wlanData.wifiHtmode.toString() == 'HT20') {
    //   channelIndex =
    //       wifiCountryChannelListHT20.indexOf(wlanData.wifiChannel.toString());
    // } else if (wlanData.wifiHtmode.toString() == '40+MHz') {
    //   channelIndex =
    //       wifiCountryChannelListHT40j.indexOf(wlanData.wifiChannel.toString());
    // } else if (wlanData.wifiHtmode.toString() == '40-MHz') {
    //   channelIndex =
    //       wifiCountryChannelListHT40.indexOf(wlanData.wifiChannel.toString());
    // }

    channelIndex =
        wifiCountryChannelListHT20.indexOf(wlanData.wifiChannel.toString());

    channelIndex5g =
        wifi5gCountryChannelList.indexOf(wlanData.wifi5gChannel.toString());
    isCheck = wlanData.wifiEnable == '1';
    isCheck5 = wlanData.wifi5gEnable == '1';
  }
*/
// 读取Channel
  // void addChannelList(List<String> list, String? channelList) {
  //   if (channelList != null) {
  //     list.addAll(channelList.split(';'));
  //   }
  // }

  // Future getList() async {
  //   Map<String, dynamic> data = {
  //     'method': 'obj_get',
  //     'param':
  //         '["wifiCountryChannelList_HT20","wifiCountryChannelList_HT40+","wifiCountryChannelList_HT40-","wifiHtmode","wifi5gCountryChannelList"]',
  //   };
  //   var response = await XHttp.get('/data.html', data);
  //   Map<String, dynamic> d;
  //   try {
  //     d = json.decode(response.toString());
  //   } catch (e) {
  //     throw Exception('Failed to decode config data: $e');
  //   }
  //   setState(() {
  //     channelLists = channelList.fromJson(d);
  //     addChannelList(
  //         wifi5gCountryChannelList, channelLists.wifi5gCountryChannelList);
  //     addChannelList(
  //         wifiCountryChannelListHT20, channelLists.wifiCountryChannelListHT20);
  //     addChannelList(wifiCountryChannelListHT40j,
  //         channelLists.wifiCountryChannelListHT40j);
  //     addChannelList(
  //         wifiCountryChannelListHT40, channelLists.wifiCountryChannelListHT40);
  //   });
  //   getData();
  // }

//读取WiFiSsidTable
  // Future getWiFiSsidTable() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   Map<String, dynamic> data = {
  //     'method': 'tab_dump',
  //     'param': '["WiFiSsidTable"]',
  //   };
  //   try {
  //     var response = await XHttp.get('/data.html', data);
  //     var d = json.decode(response.toString());
  //     setState(() {
  //       wifiSsidTableLists = wifiSsidTable.fromJson(d);
  //       ssid.text = wifiSsidTableLists.wiFiSsidTable![0].ssid.toString();
  //       max.text = wifiSsidTableLists.wiFiSsidTable![0].maxClient.toString();
  //       password.text = wifiSsidTableLists.wiFiSsidTable![0].key.toString();
  //       var encryption =
  //           wifiSsidTableLists.wiFiSsidTable![0].encryption.toString();
  //       if (encryption != 'none') {
  //         encryption.split('+');
  //         encryptionIndex =
  //             encryptionVal.indexOf(encryption.split('+')[1].toString());
  //         securityIndex =
  //             securityVal.indexOf(encryption.split('+')[0].toString());
  //       }
  //       ssidisCheck =
  //           wifiSsidTableLists.wiFiSsidTable![0].ssidHide.toString() == '1';
  //       apisCheck =
  //           wifiSsidTableLists.wiFiSsidTable![0].apIsolate.toString() == '1';
  //       max.text = wlanData.wifiTxpower.toString();
  //     });
  //   } catch (e) {
  //     debugPrint('获取wps设置失败:$e.toString()');
  //   } finally {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

//读取WiFi5GSsidTable
  // Future getWiFi5GSsidTable() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   Map<String, dynamic> data = {
  //     'method': 'tab_dump',
  //     'param': '["WiFi5GSsidTable"]',
  //   };
  //   try {
  //     var response = await XHttp.get('/data.html', data);
  //     var d = json.decode(response.toString());
  //     setState(() {
  //       wifi5GSsidTableLists = wifi5GSsidTable.fromJson(d);
  //       var encryption =
  //           wifi5GSsidTableLists.wiFi5GSsidTable![0].encryption.toString();
  //       if (encryption != 'none') {
  //         encryption.split('+');
  //         encryptionIndex5g =
  //             encryptionVal.indexOf(encryption.split('+')[1].toString());
  //         securityIndex5g =
  //             securityVal.indexOf(encryption.split('+')[0].toString());
  //       }
  //       ssid5.text = wifi5GSsidTableLists.wiFi5GSsidTable![0].ssid.toString();
  //       ssidisCheck5 =
  //           wifi5GSsidTableLists.wiFi5GSsidTable![0].ssidHide.toString() == '1';
  //       apisCheck5 =
  //           wifi5GSsidTableLists.wiFi5GSsidTable![0].apIsolate.toString() ==
  //               '1';

  //       max5.text =
  //           wifi5GSsidTableLists.wiFi5GSsidTable![0].maxClient.toString();
  //       password5.text =
  //           wifi5GSsidTableLists.wiFi5GSsidTable![0].key.toString();
  //     });
  //   } catch (e) {
  //     debugPrint('设置失败:$e.toString()');
  //   } finally {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

  /// 保存
  Future<void> _saveData() async {
    setState(() {
      _isLoading = true;
    });
    closeKeyboard(context);
    if (loginController.login.state == 'cloud' && sn.isNotEmpty) {
      // 云端请求赋值
      try {
        await setList();
      } catch (e) {
        debugPrint('云端请求出错：${e.toString()}');
        ToastUtils.error('Request Failed');
        // Get.back();
      }
    }
    // if (loginController.login.state == 'local') {
    //   // 本地请求赋值
    //   await setData();
    // }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(
            context: context,
            title: S.of(context).wlanSet,
            actions: <Widget>[
              Container(
                margin: EdgeInsets.all(20.w),
                child: OutlinedButton(
                  onPressed: _isLoading ? null : _saveData,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(width: 1.5, color: Colors.blue),
                  ),
                  child: Row(
                    children: [
                      if (_isLoading)
                        const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      if (!_isLoading)
                        Text(
                          S.current.save,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: _isLoading ? Colors.grey : Colors.blue,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ]),
        body: loading
            ? const Center(
                child: SizedBox(
                  height: 80,
                  width: 80,
                  child: WaterLoading(
                    color: Color.fromARGB(255, 65, 167, 251),
                  ),
                ),
              )
            : GestureDetector(
                onTap: () => closeKeyboard(context),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(240, 240, 240, 1)),
                  height: double.infinity,
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
                                    value: bandIndex,
                                  );
                                  result?.then((selectedValue) {
                                    if (bandIndex != selectedValue &&
                                        selectedValue != null) {
                                      setState(() {
                                        bandIndex = selectedValue;
                                        if (loginController.login.state ==
                                                'cloud' &&
                                            sn.isNotEmpty) {
                                          // 云端请求赋值
                                          if (selectedValue == 0) {
                                            get24gList();
                                          } else if (selectedValue == 1) {
                                            get5gList();
                                          }
                                        }
                                      });
                                    }
                                  });
                                },
                                child: BottomLine(
                                  rowtem: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        S.of(context).Band,
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 5, 0, 0),
                                            fontSize: 28.sp),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            ['2.4GHz', '5GHz'][bandIndex],
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'WLAN',
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 5, 0, 0),
                                          fontSize: 28.sp),
                                    ),
                                    Row(
                                      children: [
                                        Switch(
                                          value: bandIndex == 0
                                              ? isCheck
                                              : isCheck5,
                                          onChanged: (newVal) {
                                            setState(() {
                                              if (bandIndex == 0) {
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
                              if (bandIndex == 0 ? isCheck : isCheck5)
                                GestureDetector(
                                  onTap: () {
                                    closeKeyboard(context);
                                    var result = CommonPicker.showPicker(
                                      context: context,
                                      options:
                                          bandIndex == 0 ? modeOpt : modeValOpt,
                                      value: bandIndex == 0
                                          ? modeIndex
                                          : modeIndex5g,
                                    );
                                    result?.then((selectedValue) => {
                                          if (modeIndex != selectedValue &&
                                              selectedValue != null)
                                            {
                                              setState(() {
                                                if (bandIndex == 0) {
                                                  modeIndex = selectedValue;
                                                  bandWidthIndex = 0;
                                                } else {
                                                  modeIndex5g = selectedValue;
                                                  bandWidthIndex5g = 0;
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
                                                bandIndex == 0
                                                    ? modeIndex > 0
                                                        ? modeOpt[modeIndex]
                                                        : ''
                                                    : modeIndex5g > 0
                                                        ? modeValOpt[
                                                            modeIndex5g]
                                                        : '',
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
                              if (bandIndex == 0
                                  ? isCheck
                                  : isCheck5 && modeIndex5g != 3)
                                GestureDetector(
                                  onTap: () {
                                    if (modeH20Option
                                        .contains(modeOpt[modeIndex])) {
                                      bandOptions = bandWidthH20Option;
                                    } else if (modeH40Option
                                        .contains(modeOpt[modeIndex])) {
                                      bandOptions = bandWidthOptVal;
                                    } else {}

                                    if (modeVal20Option
                                        .contains(modeValOpt[modeIndex5g])) {
                                      band5GOptions = bandWidth20Option5g;
                                    } else if (modeVal40MOption
                                        .contains(modeValOpt[modeIndex5g])) {
                                      band5GOptions = bandWidth40Option5g;
                                    } else if (modeVal80MOption
                                        .contains(modeValOpt[modeIndex5g])) {
                                      band5GOptions = bandWidth80Option5g;
                                    } else {
                                      band5GOptions = bandWidthOpt5g;
                                    }
                                    closeKeyboard(context);
                                    var result = CommonPicker.showPicker(
                                      context: context,
                                      options: bandIndex == 0
                                          ? bandOptions
                                          : band5GOptions,
                                      value: bandIndex == 0
                                          ? bandWidthIndex
                                          : bandWidthIndex5g,
                                    );
                                    result?.then((selectedValue) {
                                      if (selectedValue != null) {
                                        setState(() {
                                          if (bandIndex == 0) {
                                            bandWidthIndex = selectedValue;
                                            channelIndex = 0;
                                          } else {
                                            bandWidthIndex5g = selectedValue;
                                            channelIndex5g = 0;
                                          }
                                        });
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
                                                bandIndex == 0
                                                    ? bandOptions[
                                                        bandWidthIndex]
                                                    : band5GOptions[
                                                        bandWidthIndex5g],
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
                              if (bandIndex == 0 ? isCheck : isCheck5)
                                GestureDetector(
                                  onTap: () {
                                    closeKeyboard(context);
                                    var result = CommonPicker.showPicker(
                                      context: context,
                                      options: bandIndex == 1
                                          ? wifi5gCountryChannelList
                                          : wifiCountryChannelListHT20,
                                      value: bandIndex == 0
                                          ? channelIndex
                                          : channelIndex5g,
                                    );
                                    result?.then((selectedValue) => {
                                          if (channelIndex != selectedValue &&
                                              selectedValue != null)
                                            {
                                              setState(() {
                                                channelIndex = selectedValue;
                                                if (bandIndex == 1) {
                                                  channelIndex5g =
                                                      selectedValue;
                                                } else {
                                                  channelIndex = selectedValue;
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
                                        Text(S.of(context).Channel,
                                            style: TextStyle(
                                                color: const Color.fromARGB(
                                                    255, 5, 0, 0),
                                                fontSize: 28.sp)),
                                        Row(
                                          children: [
                                            Text(
                                                bandIndex == 1
                                                    ? wifi5gCountryChannelList[
                                                        channelIndex5g]
                                                    : wifiCountryChannelListHT20[
                                                        channelIndex],
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
                              if (bandIndex == 0 ? isCheck : isCheck5)
                                GestureDetector(
                                  onTap: () {
                                    closeKeyboard(context);
                                    var result = CommonPicker.showPicker(
                                      context: context,
                                      options: [
                                        '100%',
                                        '80%',
                                        '40%',
                                        '20%',
                                      ],
                                      value: bandIndex == 0
                                          ? txPowerIndex
                                          : txPowerIndex5g,
                                    );
                                    result?.then((selectedValue) => {
                                          if (selectedValue != null)
                                            {
                                              setState(() {
                                                if (bandIndex == 0) {
                                                  txPowerIndex = selectedValue;
                                                  txPowerShowVal = wifiTxpower[
                                                      selectedValue];
                                                  // if (selectedValue == 0)
                                                  //   {
                                                  //     txPowerShowVal =
                                                  //         wifiTxpower[0],
                                                  //   }
                                                  // else if (selectedValue ==
                                                  //     1)
                                                  //   {
                                                  //     txPowerShowVal =
                                                  //         wifiTxpower[1],
                                                  //   }
                                                  // else
                                                  //   {
                                                  //     txPowerShowVal =
                                                  //         wifiTxpower[2],
                                                  //   }
                                                } else {
                                                  txPowerIndex5g =
                                                      selectedValue;
                                                  txPower5gShowVal =
                                                      wifi5gTxpower[
                                                          selectedValue];
                                                  // if (selectedValue == 0)
                                                  //   {
                                                  //     txPower5gShowVal =
                                                  //         wifiTxpower[0],
                                                  //   }
                                                  // else if (selectedValue ==
                                                  //     1)
                                                  //   {
                                                  //     txPower5gShowVal =
                                                  //         wifiTxpower[1],
                                                  //   }
                                                  // else
                                                  //   {
                                                  //     txPower5gShowVal =
                                                  //         wifiTxpower[2],
                                                  //   }
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
                                                ['100%', '80%', '40%', '20%'][
                                                    bandIndex == 0
                                                        ? txPowerIndex
                                                        : txPowerIndex5g],
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
                        if (bandIndex == 0 ? isCheck : isCheck5)
                          TitleWidger(title: S.of(context).Configuration),
                        if (bandIndex == 0 ? isCheck : isCheck5)
                          InfoBox(
                              boxCotainer: Column(
                            children: [
                              //SSID
                              BottomLine(
                                rowtem: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('SSID',
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 5, 0, 0),
                                            fontSize: 28.sp)),
                                    Expanded(
                                        child: SizedBox(
                                      width: 250.w,
                                      child: TextFormField(
                                        controller:
                                            bandIndex == 0 ? ssid : ssid5,
                                        keyboardType:
                                            TextInputType.emailAddress,
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
                                    )),
                                  ],
                                ),
                              ),
                              //最大设备数
                              BottomLine(
                                rowtem: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(S.of(context).Maximum,
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 5, 0, 0),
                                            fontSize: 28.sp)),
                                    Expanded(
                                        child: SizedBox(
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
                                        controller: bandIndex == 0 ? max : max5,
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
                                    )),
                                  ],
                                ),
                              ),
                              //隐藏SSID网络
                              BottomLine(
                                rowtem: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(S.of(context).HideSSIDBroadcast,
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 5, 0, 0),
                                            fontSize: 28.sp)),
                                    Row(
                                      children: [
                                        Switch(
                                          value: bandIndex == 0
                                              ? ssidisCheck
                                              : ssidisCheck5,
                                          onChanged: (newVal) {
                                            setState(() {
                                              if (bandIndex == 0) {
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(S.of(context).APIsolation,
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 5, 0, 0),
                                            fontSize: 28.sp)),
                                    Row(
                                      children: [
                                        Switch(
                                          value: bandIndex == 0
                                              ? apisCheck
                                              : apisCheck5,
                                          onChanged: (newVal) {
                                            setState(() {
                                              if (bandIndex == 0) {
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
                                    options: securityOpt,
                                    value: bandIndex == 0
                                        ? securityIndex
                                        : securityIndex5g,
                                  );
                                  result?.then((selectedValue) => {
                                        if (securityIndex != selectedValue &&
                                            selectedValue != null)
                                          {
                                            setState(() {
                                              if (bandIndex == 0) {
                                                securityIndex = selectedValue;
                                              } else {
                                                securityIndex5g = selectedValue;
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
                                      Text(S.of(context).Security,
                                          style: TextStyle(
                                              color: const Color.fromARGB(
                                                  255, 5, 0, 0),
                                              fontSize: 28.sp)),
                                      Row(
                                        children: [
                                          Text(
                                              bandIndex == 0
                                                  ? securityOpt[securityIndex]
                                                  : securityOpt[
                                                      securityIndex5g],
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
                              if ((bandIndex == 0 && securityIndex != 4) ||
                                  (bandIndex == 1 && securityIndex5g != 4))
                                // WPA加密
                                GestureDetector(
                                  onTap: () {
                                    if (securityWpa2Option
                                        .contains(securityOpt[securityIndex])) {
                                      wpaEncryOptions = encryptionOpt;
                                    } else if (securityWpa3Option
                                        .contains(securityOpt[securityIndex])) {
                                      wpaEncryOptions = encryptionWpa3Option;
                                    } else {}

                                    if (securityWpa2Option.contains(
                                        securityOpt[securityIndex5g])) {
                                      wpaEncryOptions5G = encryptionOpt;
                                    } else if (securityWpa3Option.contains(
                                        securityOpt[securityIndex5g])) {
                                      wpaEncryOptions5G = encryptionWpa3Option;
                                    } else {}

                                    closeKeyboard(context);
                                    var result = CommonPicker.showPicker(
                                      context: context,
                                      options: bandIndex == 0
                                          ? wpaEncryOptions
                                          : wpaEncryOptions5G,
                                      value: bandIndex == 0
                                          ? encryptionIndex
                                          : encryptionIndex5g,
                                    );
                                    result?.then((selectedValue) => {
                                          if (encryptionIndex !=
                                                  selectedValue &&
                                              selectedValue != null)
                                            {
                                              setState(() {
                                                if (bandIndex == 0) {
                                                  encryptionIndex =
                                                      selectedValue;
                                                } else {
                                                  encryptionIndex5g =
                                                      selectedValue;
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
                                                bandIndex == 0
                                                    ? wpaEncryOptions[
                                                        encryptionIndex]
                                                    : wpaEncryOptions5G[
                                                        encryptionIndex5g],
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
                              if ((bandIndex == 0 && securityIndex != 4) ||
                                  (bandIndex == 1 && securityIndex5g != 4))
                                //密码
                                BottomLine(
                                  rowtem: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        S.of(context).Password,
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 5, 0, 0),
                                            fontSize: 28.sp),
                                      ),
                                      SizedBox(
                                        width:
                                            (MediaQuery.of(context).size.width -
                                                    40)
                                                .w,
                                        child: TextFormField(
                                          autovalidateMode:
                                              AutovalidateMode.always,
                                          obscureText: passwordValHidden,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          textAlign: TextAlign.right,
                                          controller: bandIndex == 0
                                              ? password
                                              : password5,
                                          style: TextStyle(
                                              fontSize: 26.sp,
                                              color: const Color(0xff051220)),
                                          decoration: InputDecoration(
                                            suffixIcon: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    passwordValHidden =
                                                        !passwordValHidden;
                                                  });
                                                },
                                                icon: Icon(!passwordValHidden
                                                    ? Icons.visibility
                                                    : Icons.visibility_off)),
                                            hintText: S.current.enter +
                                                S.current.newPassowld,
                                            hintStyle: TextStyle(
                                                fontSize: 26.sp,
                                                color: const Color(0xff737A83)),
                                            border: InputBorder.none,
                                          ),
                                          validator: (value) {
                                            return value!.trim().length >= 8
                                                ? null
                                                : 'Password is set to 8 characters';
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          )),
                      ],
                    ),
                  ),
                ),
              ));
  }
}
